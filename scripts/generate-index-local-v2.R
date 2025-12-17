#!/usr/bin/env Rscript
# Script mejorado para generar index.html completo con contenido incluido

cat("=== Generando index.html completo para uso local ===\n")

# Leer archivos de contenido
destacados_path <- "content/destacados-generated.html"
noticias_path <- "content/noticias/recientes-generated.html"

destacados_html <- ""
if (file.exists(destacados_path)) {
  destacados_html <- paste(readLines(destacados_path, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  cat("✓ Destacados cargados\n")
} else {
  cat("⚠️  No se encontró content/destacados-generated.html\n")
}

noticias_html <- ""
if (file.exists(noticias_path)) {
  noticias_html <- paste(readLines(noticias_path, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  cat("✓ Noticias recientes cargadas\n")
} else {
  cat("⚠️  No se encontró content/noticias/recientes-generated.html\n")
}

# Leer template
template <- readLines("index.html", warn = FALSE, encoding = "UTF-8")

# Encontrar índices
destacados_idx <- which(grepl('id="destacados-container"', template))
noticias_idx <- which(grepl('id="noticias-recientes-container"', template))

cat("Destacados encontrados en línea:", destacados_idx, "\n")
cat("Noticias encontradas en línea:", noticias_idx, "\n")

# Construir nuevo archivo
output <- character()

for (i in seq_along(template)) {
  # Insertar destacados después del contenedor
  if (i == destacados_idx) {
    output <- c(output, template[i])
    # Saltar comentario siguiente
    if (i < length(template) && grepl("<!--.*dinámicamente", template[i+1])) {
      i <- i + 1
    }
    # Insertar contenido
    if (nchar(destacados_html) > 0) {
      output <- c(output, destacados_html)
    }
    # Incluir cierre de div
    if (i < length(template) && grepl("</div>", template[i+1])) {
      output <- c(output, template[i+1])
      i <- i + 1
    }
    next
  }
  
  # Insertar noticias después del contenedor
  if (i == noticias_idx) {
    output <- c(output, template[i])
    # Saltar comentario siguiente
    if (i < length(template) && grepl("<!--.*dinámicamente", template[i+1])) {
      i <- i + 1
    }
    # Insertar contenido
    if (nchar(noticias_html) > 0) {
      output <- c(output, noticias_html)
    }
    # Incluir cierre de div
    if (i < length(template) && grepl("</div>", template[i+1])) {
      output <- c(output, template[i+1])
      i <- i + 1
    }
    next
  }
  
  # Saltar comentarios sobre carga dinámica
  if (grepl("<!--.*dinámicamente|<!--.*cargarán", template[i])) {
    next
  }
  
  # Saltar funciones async y sus llamadas
  if (grepl("async function loadDestacados|async function loadRecentNews|async function loadPublications", template[i])) {
    # Saltar hasta el cierre de la función
    i <- i + 1
    while (i <= length(template) && !grepl("^\\s*\\}\\s*$", template[i])) {
      i <- i + 1
    }
    next
  }
  
  if (grepl("loadDestacados\\(\\)|loadRecentNews\\(\\)|loadPublications\\(\\)", template[i])) {
    next
  }
  
  # Incluir todas las demás líneas
  output <- c(output, template[i])
}

# Escribir archivo
writeLines(output, "index.html")
cat("\n✓ Generado: index.html con contenido incluido\n")
cat("✓ Total de líneas:", length(output), "\n")
cat("✓ El archivo ahora funciona con file:// sin problemas de CORS\n")

