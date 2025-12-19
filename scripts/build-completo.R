#!/usr/bin/env Rscript
# Script completo para hacer el build del sitio
# Ejecuta todos los pasos necesarios en el orden correcto

cat("=== Build Completo del Sitio ===\n\n")

# Paso 1: Generar HTMLs de noticias desde QMD
cat("[1/5] Generando HTMLs de noticias desde QMD...\n")
source("scripts/generate-news-html.R")
cat("✓ HTMLs de noticias generados\n\n")

# Paso 1.5: Generar destacados (solo 1)
cat("[1.5/5] Generando destacados (solo 1)...\n")
source("scripts/generate-destacados.R")
cat("✓ Destacados generados\n\n")

# Paso 1.6: Generar noticias recientes (no destacadas)
cat("[1.6/5] Generando noticias recientes...\n")
source("scripts/generate-recientes.R")
cat("✓ Noticias recientes generadas\n\n")

# Paso 2: Renderizar con Quarto
cat("[2/5] Renderizando sitio con Quarto...\n")
quarto::quarto_render()
cat("✓ Quarto render completado\n\n")

# Paso 3: Generar index.html completo para uso local
cat("[3/5] Generando index.html completo para uso local...\n")
source("scripts/generate-index-local.R")
cat("✓ index.html generado con contenido incluido\n\n")

# Paso 4: Generar índice de noticias completo en _site/
cat("[4/5] Generando índice de noticias completo en _site/...\n")
source("scripts/post-render-news-index.R")
cat("✓ Índice de noticias generado en _site/\n\n")

cat("=== Build completado exitosamente ===\n")
cat("El sitio está disponible en: _site/\n")

