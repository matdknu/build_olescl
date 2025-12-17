# Aplicación Shiny - Análisis de Prensa: Cobertura de Legitimidad Institucional

Aplicación interactiva para el análisis de cobertura mediática sobre Carabineros de Chile.

## Características

- 📊 **Visualizaciones interactivas** con Plotly
- 🔍 **Búsqueda de noticias** en títulos y contenido
- 📅 **Filtros temporales** por rango de fechas
- 📰 **Análisis por medio** de comunicación
- 🚨 **Análisis de delitos** mencionados en las noticias
- 📋 **Tablas interactivas** con opciones de descarga

## Requisitos

```r
install.packages(c("shiny", "dplyr", "ggplot2", "lubridate", "DT", "plotly", "shinythemes", "tidyr"))
```

## Ejecución Local

1. Asegúrate de que el archivo `data/noticias_carabineros.rds` existe en la carpeta padre
2. Ejecuta:
```r
shiny::runApp("shiny-app")
```

O desde la terminal:
```bash
Rscript -e "shiny::runApp('shiny-app', port=3838, host='0.0.0.0')"
```

## Despliegue

### Opción 1: shinyapps.io (Recomendado)

1. Instala `rsconnect`:
```r
install.packages("rsconnect")
```

2. Configura tu cuenta:
```r
library(rsconnect)
rsconnect::setAccountInfo(
  name = "tu-cuenta",
  token = "tu-token",
  secret = "tu-secret"
)
```

3. Despliega:
```r
rsconnect::deployApp("shiny-app", appName = "analisis-prensa-carabineros")
```

### Opción 2: Servidor propio

Usa Shiny Server o RStudio Connect para alojar la aplicación.

## Estructura de Datos

La aplicación espera un archivo RDS con las siguientes columnas:
- `fecha`: Fecha de la noticia (Date)
- `medio`: Nombre del medio (character)
- `titular`: Título de la noticia (character)
- `cuerpo`: Contenido completo (character)
- `texto_clean`: Texto limpio (character)
- `url`: URL de la noticia (character)
- Variables binarias de delitos (0/1)
- `delitos_comunes`: Suma de delitos comunes
- `largo`: Longitud del texto

## Integración en HTML

Para integrar la app en `proyectos/prensa-redes.html`, usa un iframe:

```html
<iframe 
  src="URL_DE_TU_SHINY_APP" 
  width="100%" 
  height="800px" 
  frameborder="0"
  style="border: 1px solid #ddd; border-radius: 0.5rem;">
</iframe>
```


