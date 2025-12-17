#!/usr/bin/env Rscript
# Script para limpiar archivos innecesarios del proyecto
# Elimina carpetas *_files que contienen librerías de Quarto no necesarias para el sitio final

cat("=== Limpiando archivos innecesarios ===\n\n")

# Directorios a limpiar
directorios_limpiar <- c(
  "content",
  "equipo",
  "GUIA-QMD-PASO-A-PASO_files",
  "MANUAL-NOTICIAS_files",
  "MANUAL-QMD_files",
  "MANUAL-USO_files",
  "wordpress-install_files",
  "shiny-app/DEPLOY_files",
  "shiny-app/INSTRUCCION-DEPLOY_files",
  "shiny-app/INSTRUCCIONES_files",
  "shiny-app/SOLUCION-SSL_files"
)

total_eliminado <- 0
total_tamaño <- 0

for (dir_base in directorios_limpiar) {
  if (!dir.exists(dir_base)) {
    next
  }
  
  # Buscar todas las carpetas *_files
  files_dirs <- list.dirs(dir_base, recursive = TRUE, full.names = TRUE)
  files_dirs <- files_dirs[grepl("_files$", basename(files_dirs))]
  
  for (files_dir in files_dirs) {
    # Calcular tamaño antes de eliminar
    tamaño <- sum(file.info(list.files(files_dir, recursive = TRUE, full.names = TRUE, all.files = TRUE))$size, na.rm = TRUE)
    
    # Eliminar carpeta
    unlink(files_dir, recursive = TRUE)
    
    if (!dir.exists(files_dir)) {
      cat("✓ Eliminado:", files_dir, sprintf("(%.2f MB)\n", tamaño / 1024 / 1024))
      total_eliminado <- total_eliminado + 1
      total_tamaño <- total_tamaño + tamaño
    }
  }
}

cat("\n=== Resumen ===\n")
cat("✓ Carpetas eliminadas:", total_eliminado, "\n")
cat("✓ Espacio liberado:", sprintf("%.2f MB\n", total_tamaño / 1024 / 1024))
cat("\n✓ Limpieza completada\n")
