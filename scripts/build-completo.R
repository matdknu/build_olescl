#!/usr/bin/env Rscript
# Script completo para hacer el build del sitio
# Ejecuta todos los pasos necesarios en el orden correcto

cat("=== Build Completo del Sitio ===\n\n")

# Paso 1: Generar HTMLs de noticias desde QMD
cat("[1/3] Generando HTMLs de noticias desde QMD...\n")
source("scripts/generate-news-html.R")
cat("✓ HTMLs de noticias generados\n\n")

# Paso 2: Renderizar con Quarto
cat("[2/3] Renderizando sitio con Quarto...\n")
quarto::quarto_render()
cat("✓ Quarto render completado\n\n")

# Paso 3: Generar index.html completo para uso local
cat("[3/4] Generando index.html completo para uso local...\n")
source("scripts/generate-index-local.R")
cat("✓ index.html generado con contenido incluido\n\n")

# Paso 4: Generar índice de noticias completo en _site/
cat("[4/4] Generando índice de noticias completo en _site/...\n")
source("scripts/post-render-news-index.R")
cat("✓ Índice de noticias generado en _site/\n\n")

cat("=== Build completado exitosamente ===\n")
cat("El sitio está disponible en: _site/\n")

