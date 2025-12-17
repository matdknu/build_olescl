# Instrucciones para Usar el Proyecto en Local

## Problema

Cuando abres archivos HTML directamente con `file://`, el navegador bloquea las peticiones `fetch()` por políticas de seguridad CORS. Esto hace que el contenido cargado dinámicamente no se muestre.

## Solución

Se han creado scripts que generan los archivos HTML con el contenido incluido directamente, eliminando la necesidad de usar `fetch()`.

## Archivos Generados

### 1. `index.html`
- Incluye destacados directamente
- Incluye noticias recientes directamente
- Funciona con `file://` sin problemas

### 2. `noticias/index.html`
- Incluye todas las noticias directamente
- Funciona con `file://` sin problemas

## Cómo Generar los Archivos para Local

### Opción 1: Script Completo

```r
source("scripts/build-completo.R")
```

Este script:
1. Genera HTMLs de noticias desde QMD
2. Renderiza con Quarto
3. Genera `index.html` completo para local
4. Genera `noticias/index.html` completo en `_site/`

### Opción 2: Solo para Local (sin Quarto)

```r
# Generar HTMLs de noticias
source("scripts/generate-news-html.R")

# Generar index.html completo
source("scripts/generate-index-local.R")

# Generar noticias/index.html completo
source("scripts/generate-news-index.R")
```

### Opción 3: Desde Terminal

```bash
# Generar HTMLs de noticias
Rscript scripts/generate-news-html.R

# Generar index.html completo
Rscript scripts/generate-index-local.R

# Generar noticias/index.html completo
Rscript scripts/generate-news-index.R
```

## Verificación

Después de ejecutar los scripts, puedes abrir directamente:

```bash
# Abrir index.html
open index.html

# O abrir noticias/index.html
open noticias/index.html
```

Todo debería funcionar correctamente sin necesidad de un servidor web.

## Nota sobre Publicaciones

Las publicaciones se cargan desde `data/publicaciones.json` usando `fetch()`. Este archivo JSON funciona con `file://` porque es un archivo de datos, no HTML. Si tienes problemas, puedes incluir las publicaciones directamente en el HTML también.

## Aplicación Shiny

La aplicación Shiny en `proyectos/analisis-prensa.html` está configurada para usar `http://localhost:3838`. Asegúrate de tener la aplicación ejecutándose:

```bash
cd shiny-app
Rscript run-app.R
```

