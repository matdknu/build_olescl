#!/usr/bin/env Rscript
# Script para limpiar archivos innecesarios antes de subir a WordPress
# Elimina archivos temporales, backups, y contenido no esencial

cat("=== Limpiando archivos innecesarios para WordPress ===\n\n")

# Archivos temporales y de sistema
archivos_temporales <- c(
  ".RData",
  ".Rhistory",
  ".DS_Store",
  "index.html.backup",
  "equipo/tesistas-pasantes-data.md.bak"
)

# Carpetas completas a eliminar (no necesarias para WordPress)
carpetas_eliminar <- c(
  "_site",           # Generado por Quarto, no necesario
  "shiny-app",       # Aplicación separada, no para WordPress
  ".Rproj.user",     # Configuración de RStudio
  ".quarto",         # Cache de Quarto
  "rsconnect",       # Configuración de RStudio Connect
  "content/noticias/2020",
  "content/noticias/2021",
  "content/noticias/2022",
  "content/noticias/2023",
  "content/noticias/2024",
  "content/noticias/2025",
  "content/noticias/2026"
)

# Archivos de documentación excesiva (mantener solo README.md)
docs_eliminar <- c(
  "GUIA-QMD-PASO-A-PASO.md",
  "INSTRUCCIONES-BUILD.md",
  "INSTRUCCIONES-LOCAL.md",
  "MANUAL-NOTICIAS.md",
  "MANUAL-QMD.md",
  "MANUAL-USO.md",
  "wordpress-install.md"
)

# Scripts innecesarios para WordPress (mantener solo los esenciales)
scripts_eliminar <- c(
  "scripts/add-logo-to-headers.sh",
  "scripts/add-logos-to-pages.sh",
  "scripts/add-theme-color.sh",
  "scripts/generate-index-local-v2.R",
  "scripts/generate-index-local-v3.R",
  "scripts/generate-index.R",
  "scripts/generate-profiles.sh",
  "scripts/limpiar-archivos-innecesarios.R",
  "scripts/reorganizar-equipo-en-carpetas.R",
  "scripts/reorganizar-noticias-en-carpetas.R",
  "scripts/reorganizar-noticias-por-fecha.R",
  "scripts/update-color-453958.sh",
  "scripts/update-header-color.sh",
  "scripts/update-logo-only.sh",
  "scripts/update-logo-spacing.sh",
  "scripts/update-theme-color-white.sh",
  "scripts/render-qmd.R"
)

# Archivos grandes de datos no necesarios
datos_eliminar <- c(
  "data/noticias_carabineros.rds"  # 144MB, solo para shiny-app
)

# Función para eliminar archivo
eliminar_archivo <- function(archivo) {
  if (file.exists(archivo)) {
    file.remove(archivo)
    cat("✓ Eliminado:", archivo, "\n")
    return(TRUE)
  }
  return(FALSE)
}

# Función para eliminar carpeta
eliminar_carpeta <- function(carpeta) {
  if (dir.exists(carpeta)) {
    unlink(carpeta, recursive = TRUE)
    cat("✓ Eliminada carpeta:", carpeta, "\n")
    return(TRUE)
  }
  return(FALSE)
}

# Eliminar archivos temporales
cat("\n[1/5] Eliminando archivos temporales...\n")
contador <- 0
for (archivo in archivos_temporales) {
  if (eliminar_archivo(archivo)) contador <- contador + 1
}
cat("✓ Eliminados", contador, "archivos temporales\n")

# Eliminar .DS_Store recursivamente
cat("\n[2/5] Eliminando archivos .DS_Store...\n")
ds_files <- list.files(".", pattern = "\\.DS_Store$", recursive = TRUE, full.names = TRUE)
contador <- 0
for (archivo in ds_files) {
  if (eliminar_archivo(archivo)) contador <- contador + 1
}
cat("✓ Eliminados", contador, "archivos .DS_Store\n")

# Eliminar carpetas completas
cat("\n[3/5] Eliminando carpetas innecesarias...\n")
contador <- 0
for (carpeta in carpetas_eliminar) {
  if (eliminar_carpeta(carpeta)) contador <- contador + 1
}
cat("✓ Eliminadas", contador, "carpetas\n")

# Eliminar documentación excesiva
cat("\n[4/5] Eliminando documentación excesiva...\n")
contador <- 0
for (doc in docs_eliminar) {
  if (eliminar_archivo(doc)) contador <- contador + 1
}
cat("✓ Eliminados", contador, "archivos de documentación\n")

# Eliminar scripts innecesarios
cat("\n[5/5] Eliminando scripts innecesarios...\n")
contador <- 0
for (script in scripts_eliminar) {
  if (eliminar_archivo(script)) contador <- contador + 1
}
cat("✓ Eliminados", contador, "scripts innecesarios\n")

# Eliminar archivos de datos grandes
cat("\n[6/6] Eliminando archivos de datos grandes...\n")
contador <- 0
for (dato in datos_eliminar) {
  if (eliminar_archivo(dato)) contador <- contador + 1
}
cat("✓ Eliminados", contador, "archivos de datos grandes\n")

# Calcular tamaño final
cat("\n=== Limpieza completada ===\n")
cat("Ejecuta 'du -sh .' para ver el tamaño final del repositorio\n")
cat("\nArchivos esenciales mantenidos:\n")
cat("  - index.html, style.css, script.js\n")
cat("  - logos/\n")
cat("  - content/ (fuente de noticias)\n")
cat("  - noticias/*.html (generados)\n")
cat("  - equipo/*.html\n")
cat("  - proyectos/*.html\n")
cat("  - publicaciones/\n")
cat("  - scripts/ esenciales para generar contenido\n")

