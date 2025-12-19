#!/usr/bin/env Rscript
# Script para generar index.html completo con contenido incluido
# Esto permite que funcione con file:// sin problemas de CORS
# Solo incluye 3 noticias recientes y destacados (sin duplicados)

cat("=== Generando index.html completo para uso local ===\n")

# Leer el template base (usar index.html.backup si existe, sino index.html)
template_path <- if (file.exists("index.html.backup")) "index.html.backup" else "index.html"
if (!file.exists(template_path)) {
  stop("No se encontró index.html ni index.html.backup")
}

cat("Usando template:", template_path, "\n")
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

# Leer contenido de noticias recientes
recientes_path <- "content/noticias/recientes-generated.html"
recientes_html <- ""
if (file.exists(recientes_path)) {
  recientes <- readLines(recientes_path, warn = FALSE, encoding = "UTF-8")
  recientes_html <- paste(recientes, collapse = "\n")
  n_recientes <- length(grep("noticia-card", recientes))
  cat("✓ Noticias recientes cargadas (", n_recientes, " items)\n", sep = "")
} else {
  cat("⚠️  No se encontró content/noticias/recientes-generated.html\n")
  cat("Ejecutando generate-recientes.R primero...\n")
  source("scripts/generate-recientes.R")
  if (file.exists(recientes_path)) {
    recientes <- readLines(recientes_path, warn = FALSE, encoding = "UTF-8")
    recientes_html <- paste(recientes, collapse = "\n")
  }
}

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
noticias_inserted <- FALSE
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
    
    # Saltar TODO el contenido existente dentro del contenedor hasta encontrar el cierre
    depth <- 1
    closing_line <- i
    while (closing_line <= length(template) && depth > 0) {
      if (grepl("<div", template[closing_line])) {
        depth <- depth + 1
      }
      if (grepl("</div>", template[closing_line])) {
        depth <- depth - 1
        if (depth == 0) {
          # Encontramos el cierre
          break
        }
      }
      closing_line <- closing_line + 1
    }
    
    # Insertar contenido de destacados ANTES del cierre
    if (nchar(destacados_html) > 0) {
      output_lines <- c(output_lines, destacados_html)
      destacados_inserted <- TRUE
    }
    
    # Saltar todas las líneas hasta el cierre
    i <- closing_line
    
    # Incluir línea de cierre del div
    if (i <= length(template) && grepl("</div>", template[i])) {
      output_lines <- c(output_lines, template[i])
      i <- i + 1
    }
    next
  }
  
  # Saltar cualquier contenido de destacados que quede (evitar duplicados)
  if (grepl("destacado-card|destacados-grid", line) && destacados_inserted) {
    # Saltar hasta encontrar el cierre
    while (i <= length(template) && !grepl("</div>|</article>", template[i])) {
      i <- i + 1
    }
    if (i <= length(template)) {
      i <- i + 1
    }
    next
  }
  
  # Insertar noticias recientes
  if (grepl('id="noticias-recientes-container"', line) && !noticias_inserted) {
    output_lines <- c(output_lines, line)
    i <- i + 1
    
    # Saltar comentario si existe
    if (i <= length(template) && grepl("<!--.*dinámicamente|<!--.*cargarán", template[i])) {
      i <- i + 1
    }
    
    # Saltar TODO el contenido existente dentro del contenedor hasta encontrar el cierre
    # Buscar el siguiente </div> que cierra el contenedor
    depth <- 1
    closing_line <- i
    while (closing_line <= length(template) && depth > 0) {
      if (grepl("<div", template[closing_line])) {
        depth <- depth + 1
      }
      if (grepl("</div>", template[closing_line])) {
        depth <- depth - 1
        if (depth == 0) {
          # Encontramos el cierre
          break
        }
      }
      closing_line <- closing_line + 1
    }
    
    # Insertar contenido de noticias recientes (solo 4) ANTES del cierre
    if (nchar(recientes_html) > 0) {
      output_lines <- c(output_lines, recientes_html)
      noticias_inserted <- TRUE
    }
    
    # Saltar todas las líneas hasta el cierre
    i <- closing_line
    
    # Incluir línea de cierre del div
    if (i <= length(template) && grepl("</div>", template[i])) {
      output_lines <- c(output_lines, template[i])
      i <- i + 1
    }
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

# Escribir el archivo completo (siempre a index.html, no a _site/index.html)
output_path <- "index.html"
writeLines(output_lines, output_path)
cat("\n✓ Generado:", output_path, "con contenido incluido\n")
cat("✓ El archivo ahora funciona con file:// sin problemas de CORS\n")

