# Instrucciones para Build Completo del Sitio

## Problema

Cuando haces el build desde R/Quarto, las noticias no se ven porque:
1. Quarto renderiza el sitio en `_site/`
2. El archivo `noticias/index.html` necesita tener el contenido incluido directamente (no con fetch)
3. El script que genera el índice completo debe ejecutarse **después** del render de Quarto

## Solución

### Opción 1: Script Completo (Recomendado)

Ejecuta el script que hace todo el proceso:

```r
source("scripts/build-completo.R")
```

Este script:
1. Genera los HTMLs de noticias desde QMD
2. Renderiza el sitio con Quarto
3. Genera el índice completo de noticias en `_site/noticias/index.html`

### Opción 2: Pasos Manuales

Si prefieres hacerlo paso a paso:

```r
# Paso 1: Generar HTMLs de noticias
source("scripts/generate-news-html.R")

# Paso 2: Renderizar con Quarto
quarto::quarto_render()

# Paso 3: Generar índice completo en _site/
source("scripts/post-render-news-index.R")
```

### Opción 3: Desde Terminal

```bash
# Generar HTMLs de noticias
Rscript scripts/generate-news-html.R

# Renderizar con Quarto
quarto render

# Generar índice completo
Rscript scripts/post-render-news-index.R
```

## Verificación

Después del build, verifica que el archivo existe:

```bash
ls -lh _site/noticias/index.html
```

Debería tener aproximadamente 100KB y contener todas las noticias.

## Nota Importante

**Siempre ejecuta `post-render-news-index.R` después de `quarto render`** para que las noticias se vean correctamente en `_site/noticias/index.html`.

