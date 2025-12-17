#!/usr/bin/env Rscript
# Script mejorado para generar index.html completo con contenido incluido
# Solo incluye 3 noticias recientes y destacados

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
  cat("✓ Noticias recientes cargadas (solo 3)\n")
} else {
  cat("⚠️  No se encontró content/noticias/recientes-generated.html\n")
}

# Leer template
template <- readLines("index.html", warn = FALSE, encoding = "UTF-8")

# Encontrar índices
destacados_idx <- which(grepl('id="destacados-container"', template))[1]
noticias_idx <- which(grepl('id="noticias-recientes-container"', template))[1]

cat("Destacados encontrados en línea:", destacados_idx, "\n")
cat("Noticias encontradas en línea:", noticias_idx, "\n")

# Construir nuevo archivo
output <- character()
destacados_inserted <- FALSE
noticias_inserted <- FALSE

for (i in seq_along(template)) {
  line <- template[i]
  
  # Insertar destacados después del contenedor (solo una vez)
  if (i == destacados_idx && !destacados_inserted) {
    output <- c(output, line)
    # Saltar comentario siguiente si existe
    if (i < length(template) && grepl("<!--.*dinámicamente|<!--.*cargarán", template[i+1])) {
      i <- i + 1
    }
    # Insertar contenido de destacados
    if (nchar(destacados_html) > 0) {
      output <- c(output, destacados_html)
    }
    destacados_inserted <- TRUE
    # Incluir cierre de div si viene después
    if (i < length(template) && grepl("</div>", template[i+1])) {
      output <- c(output, template[i+1])
      i <- i + 1
    }
    next
  }
  
  # Insertar noticias después del contenedor (solo una vez)
  if (i == noticias_idx && !noticias_inserted) {
    output <- c(output, line)
    # Saltar comentario siguiente si existe
    if (i < length(template) && grepl("<!--.*dinámicamente|<!--.*cargarán", template[i+1])) {
      i <- i + 1
    }
    # Insertar contenido de noticias (solo 3)
    if (nchar(noticias_html) > 0) {
      output <- c(output, noticias_html)
    }
    noticias_inserted <- TRUE
    # Incluir cierre de div si viene después
    if (i < length(template) && grepl("</div>", template[i+1])) {
      output <- c(output, template[i+1])
      i <- i + 1
    }
    next
  }
  
  # Saltar comentarios sobre carga dinámica
  if (grepl("<!--.*dinámicamente|<!--.*cargarán", line)) {
    next
  }
  
  # Saltar funciones async y sus llamadas
  if (grepl("async function loadDestacados|async function loadRecentNews|async function loadPublications", line)) {
    # Saltar hasta el cierre de la función
    i <- i + 1
    depth <- 1
    while (i <= length(template) && depth > 0) {
      if (grepl("\\{", template[i])) depth <- depth + 1
      if (grepl("\\}", template[i])) depth <- depth - 1
      if (depth > 0) i <- i + 1
    }
    next
  }
  
  if (grepl("loadDestacados\\(\\)|loadRecentNews\\(\\)|loadPublications\\(\\)", line)) {
    next
  }
  
  # Incluir todas las demás líneas
  output <- c(output, line)
}

# Escribir archivo
writeLines(output, "index.html")
cat("\n✓ Generado: index.html con contenido incluido\n")
cat("✓ Total de líneas:", length(output), "\n")
cat("✓ Destacados insertados:", destacados_inserted, "\n")
cat("✓ Noticias recientes insertadas:", noticias_inserted, "\n")
cat("✓ El archivo ahora funciona con file:// sin problemas de CORS\n")

