#!/usr/bin/env Rscript
# Script post-render para Quarto
# Genera noticias/index.html completo después del build

# Este script se ejecuta después de que Quarto renderiza el sitio
# Asegura que noticias/index.html tenga el contenido incluido

library(yaml)

cat("=== Generando índice de noticias completo ===\n")

# Rutas
template_path <- "noticias/index.html"
content_path <- "content/noticias/index-generated.html"
output_path <- "_site/noticias/index.html"

# Verificar que existe el template
if (!file.exists(template_path)) {
  cat("⚠️  No se encontró noticias/index.html\n")
  quit(status = 1)
}

# Leer el contenido generado
if (!file.exists(content_path)) {
  cat("⚠️  No se encontró content/noticias/index-generated.html\n")
  cat("Ejecutando generate-news-html.R primero...\n")
  source("scripts/generate-news-html.R")
}

if (!file.exists(content_path)) {
  cat("❌ Error: No se pudo generar content/noticias/index-generated.html\n")
  quit(status = 1)
}

# Leer archivos
template <- readLines(template_path, warn = FALSE, encoding = "UTF-8")
content <- readLines(content_path, warn = FALSE, encoding = "UTF-8")
content_html <- paste(content, collapse = "\n")

# Procesar template
output_lines <- character()
skip_until_end_script <- FALSE

for (i in seq_along(template)) {
  line <- template[i]
  
  # Detectar el contenedor de noticias
  if (grepl('id="noticias-container"', line)) {
    output_lines <- c(output_lines, line)
    # Insertar el contenido después del contenedor
    output_lines <- c(output_lines, content_html)
    next
  }
  
  # Detectar y eliminar el script de carga dinámica
  if (grepl("async function loadAllNews|Load all news", line)) {
    skip_until_end_script <- TRUE
    next
  }
  
  if (skip_until_end_script) {
    if (grepl("</script>", line)) {
      skip_until_end_script <- FALSE
      # No incluir este </script>
      next
    }
    # Saltar todas las líneas del script
    next
  }
  
  # Incluir todas las demás líneas
  output_lines <- c(output_lines, line)
}

# Crear directorio de salida si no existe
dir.create(dirname(output_path), showWarnings = FALSE, recursive = TRUE)

# Escribir el archivo completo
writeLines(output_lines, output_path)
cat("✓ Generado:", output_path, "con contenido incluido\n")
cat("✓ Total de noticias incluidas\n")

