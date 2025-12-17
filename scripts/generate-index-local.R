#!/usr/bin/env Rscript
# Script para generar index.html completo con contenido incluido
# Esto permite que funcione con file:// sin problemas de CORS
# Solo incluye 3 noticias recientes y destacados (sin duplicados)

cat("=== Generando index.html completo para uso local ===\n")

# Leer el template base
template_path <- "index.html"
if (!file.exists(template_path)) {
  stop("No se encontró index.html")
}

template <- readLines(template_path, warn = FALSE, encoding = "UTF-8")

# Leer contenido de destacados
destacados_path <- "content/destacados-generated.html"
destacados_html <- ""
if (file.exists(destacados_path)) {
  destacados <- readLines(destacados_path, warn = FALSE, encoding = "UTF-8")
  destacados_html <- paste(destacados, collapse = "\n")
  # Verificar que no haya duplicados (contar destacado-card)
  n_destacados <- length(grep("destacado-card", destacados))
  cat("✓ Destacados cargados (", n_destacados, " items)\n", sep = "")
} else {
  cat("⚠️  No se encontró content/destacados-generated.html\n")
}

# No cargar noticias recientes - solo destacados
cat("ℹ️  Noticias recientes omitidas - solo se muestran destacados\n")

# Leer publicaciones JSON
publicaciones_path <- "data/publicaciones.json"
publicaciones_json <- ""
if (file.exists(publicaciones_path)) {
  publicaciones_json <- readLines(publicaciones_path, warn = FALSE, encoding = "UTF-8")
  publicaciones_json <- paste(publicaciones_json, collapse = "\n")
  cat("✓ Publicaciones JSON cargado\n")
} else {
  cat("⚠️  No se encontró data/publicaciones.json\n")
}

# Procesar template
output_lines <- character()
skip_script_section <- FALSE
in_script_tag <- FALSE
destacados_inserted <- FALSE
i <- 1

while (i <= length(template)) {
  line <- template[i]
  
  # Detectar inicio de script tag
  if (grepl("<script", line) && grepl("script.js", line)) {
    in_script_tag <- TRUE
    output_lines <- c(output_lines, line)
    i <- i + 1
    next
  }
  
  # Detectar fin de script tag
  if (in_script_tag && grepl("</script>", line)) {
    in_script_tag <- FALSE
    output_lines <- c(output_lines, line)
    i <- i + 1
    next
  }
  
  # Si estamos dentro de un script tag, incluir la línea
  if (in_script_tag) {
    output_lines <- c(output_lines, line)
    i <- i + 1
    next
  }
  
  # Reemplazar contenedor de destacados (solo una vez)
  if (grepl('id="destacados-container"', line) && !destacados_inserted) {
    output_lines <- c(output_lines, line)
    i <- i + 1
    
    # Saltar comentario si existe
    if (i <= length(template) && grepl("<!--.*dinámicamente|<!--.*cargarán", template[i])) {
      i <- i + 1
    }
    
    # Insertar contenido de destacados (solo si no se ha insertado ya)
    if (nchar(destacados_html) > 0) {
      output_lines <- c(output_lines, destacados_html)
      destacados_inserted <- TRUE
    }
    
    # Incluir línea de cierre del div
    if (i <= length(template) && grepl("</div>", template[i])) {
      output_lines <- c(output_lines, template[i])
      i <- i + 1
    }
    next
  }
  
  # Saltar el contenedor de noticias recientes (ya no se usa)
  if (grepl('id="noticias-recientes-container"', line)) {
    # Saltar esta línea y el comentario siguiente
    i <- i + 1
    if (i <= length(template) && grepl("<!--.*dinámicamente|<!--.*cargarán", template[i])) {
      i <- i + 1
    }
    # Saltar el cierre del div también
    if (i <= length(template) && grepl("</div>", template[i])) {
      i <- i + 1
    }
    next
  }
  
  # Saltar líneas que ya contienen contenido insertado (evitar duplicados)
  if (grepl("destacados-grid", line) && destacados_inserted) {
    i <- i + 1
    next
  }
  
  # Saltar comentarios sobre carga dinámica
  if (grepl("<!--.*dinámicamente|<!--.*cargarán", line)) {
    i <- i + 1
    next
  }
  
  # Detectar y eliminar funciones async de carga dinámica
  if (grepl("async function loadDestacados|async function loadRecentNews|async function loadPublications", line)) {
    skip_script_section <- TRUE
    i <- i + 1
    next
  }
  
  if (skip_script_section) {
    # Detectar fin de función
    if (grepl("^\\s*\\}\\s*$", line)) {
      # Verificar si la siguiente línea es otra función o el final
      if (i < length(template)) {
        next_line <- template[i+1]
        if (!grepl("async function|if.*getElementById", next_line)) {
          skip_script_section <- FALSE
        }
      } else {
        skip_script_section <- FALSE
      }
    }
    i <- i + 1
    next
  }
  
  # Eliminar llamadas a funciones de carga (excepto loadPublications si se necesita)
  if (grepl("loadDestacados\\(\\)|loadRecentNews\\(\\)", line)) {
    i <- i + 1
    next
  }
  
  # Incluir todas las demás líneas
  output_lines <- c(output_lines, line)
  i <- i + 1
}

# Escribir el archivo completo
writeLines(output_lines, template_path)
cat("\n✓ Generado:", template_path, "con contenido incluido\n")
cat("✓ El archivo ahora funciona con file:// sin problemas de CORS\n")

