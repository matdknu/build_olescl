#!/usr/bin/env Rscript
# Script para generar noticias/index.html completo con el contenido incluido
# Esto evita problemas de CORS cuando se abre con file://

library(yaml)

# Leer el template base
template_path <- "noticias/index.html"
if (!file.exists(template_path)) {
  stop("No se encontró noticias/index.html")
}

template <- readLines(template_path, warn = FALSE, encoding = "UTF-8")

# Leer el contenido generado
content_path <- "content/noticias/index-generated.html"
if (!file.exists(content_path)) {
  cat("⚠️  No se encontró content/noticias/index-generated.html\n")
  cat("Ejecutando generate-news-html.R primero...\n")
  source("scripts/generate-news-html.R")
}

if (!file.exists(content_path)) {
  stop("No se pudo generar content/noticias/index-generated.html")
}

content <- readLines(content_path, warn = FALSE, encoding = "UTF-8")
content_html <- paste(content, collapse = "\n")

# Reemplazar el contenedor dinámico con el contenido estático
output_lines <- character()
in_script_section <- FALSE
skip_until_end_script <- FALSE

for (i in seq_along(template)) {
  line <- template[i]
  
  # Detectar el inicio del script que carga dinámicamente
  if (grepl("async function loadAllNews|Load all news", line)) {
    in_script_section <- TRUE
    skip_until_end_script <- TRUE
    # No agregar esta línea, saltarla
    next
  }
  
  # Detectar comentarios dentro del script
  if (skip_until_end_script && grepl("<!--", line)) {
    next
  }
  
  # Detectar el contenedor vacío
  if (grepl('id="noticias-container"', line) && !skip_until_end_script) {
    output_lines <- c(output_lines, line)
    # Insertar el contenido después de la línea del contenedor
    output_lines <- c(output_lines, content_html)
    next
  }
  
  # Detectar el final del script
  if (skip_until_end_script && grepl("</script>", line)) {
    skip_until_end_script <- FALSE
    in_script_section <- FALSE
    # No incluir este </script> ya que eliminamos el script
    next
  }
  
  # Saltar líneas del script que carga dinámicamente
  if (skip_until_end_script) {
    next
  }
  
  # Incluir todas las demás líneas
  output_lines <- c(output_lines, line)
}

# Escribir el archivo completo
writeLines(output_lines, template_path)
cat("✓ Generado:", template_path, "con contenido incluido\n")
cat("✓ Total de noticias incluidas\n")

