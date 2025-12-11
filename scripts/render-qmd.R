#!/usr/bin/env Rscript
# Script para renderizar archivos QMD y generar HTML

library(quarto)

# Función para renderizar todos los QMD en una carpeta
render_folder <- function(folder, output_format = "html") {
  qmd_files <- list.files(
    path = folder,
    pattern = "\\.qmd$",
    full.names = TRUE,
    recursive = TRUE
  )
  
  for (qmd_file in qmd_files) {
    cat("Renderizando:", qmd_file, "\n")
    tryCatch({
      quarto_render(qmd_file, output_format = output_format)
      cat("✓ Completado:", qmd_file, "\n")
    }, error = function(e) {
      cat("✗ Error en:", qmd_file, "\n")
      cat("  ", e$message, "\n")
    })
  }
}

# Renderizar todas las carpetas
cat("=== Renderizando Noticias ===\n")
render_folder("content/noticias")

cat("\n=== Renderizando Eventos ===\n")
render_folder("content/eventos")

cat("\n=== Renderizando Proyectos ===\n")
render_folder("content/proyectos")

# Generar HTMLs simples para noticias
cat("\n=== Generando HTMLs simples de noticias ===\n")
source("scripts/generate-news-html.R")

cat("\n✓ Proceso completado!\n")

