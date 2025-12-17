# Instrucciones Rápidas - Aplicación Shiny de Análisis de Prensa

## 🚀 Inicio Rápido

### Ejecutar localmente

1. **Abre una terminal** en la carpeta del proyecto
2. **Ejecuta:**
   ```bash
   cd shiny-app
   Rscript run-app.R
   ```
   
   O desde RStudio:
   - Abre `app.R`
   - Haz clic en "Run App"

3. **Abre tu navegador** en: `http://localhost:3838`

4. **Actualiza la página HTML** (`proyectos/prensa-redes.html`) para usar:
   ```html
   <iframe src="http://localhost:3838" ...></iframe>
   ```

## 📊 Características de la Aplicación

### Pestañas disponibles:

1. **Resumen**
   - Tendencias temporales de noticias
   - Distribución por medio de comunicación
   - Distribución de delitos

2. **Análisis de Delitos**
   - Evolución de delitos en el tiempo
   - Comparación entre tipos de delitos

3. **Análisis por Medio**
   - Cobertura temporal por medio
   - Top 10 medios por número de noticias

4. **Búsqueda de Noticias**
   - Buscar en títulos y contenido
   - Resultados con enlaces a noticias originales

5. **Datos**
   - Tabla completa con opciones de descarga
   - Filtros aplicados

### Filtros disponibles:

- ✅ **Rango de fechas**: Selecciona el período a analizar
- ✅ **Medio de comunicación**: Filtra por medio específico
- ✅ **Tipo de delito**: Filtra noticias que mencionan delitos específicos

## 🔧 Solución de Problemas

### La aplicación no carga

1. Verifica que R esté instalado: `R --version`
2. Verifica que los paquetes estén instalados:
   ```r
   install.packages(c("shiny", "dplyr", "ggplot2", "lubridate", "DT", "plotly", "shinythemes", "tidyr"))
   ```
3. Verifica que el archivo de datos exista: `data/noticias_carabineros.rds`

### El iframe no muestra la app

1. Verifica que la aplicación esté ejecutándose (puerto 3838)
2. Verifica la URL en el iframe
3. Si usas shinyapps.io, asegúrate de que la URL sea correcta

### Error al cargar datos

1. Verifica que `data/noticias_carabineros.rds` exista
2. Verifica los permisos del archivo
3. Revisa la consola de R para mensajes de error

## 📤 Desplegar en Producción

Ver `DEPLOY.md` para instrucciones detalladas sobre cómo desplegar en:
- shinyapps.io (recomendado)
- Servidor Shiny propio
- RStudio Connect

## 📝 Notas

- La aplicación está optimizada para datasets grandes (92,745 noticias)
- Los gráficos son interactivos usando Plotly
- Las tablas permiten ordenar, filtrar y descargar datos
- La búsqueda es case-insensitive y busca en títulos y contenido

## 🆘 Soporte

Para problemas o preguntas, consulta:
- `README.md` - Documentación completa
- `DEPLOY.md` - Guía de despliegue
- Logs de la aplicación en la consola de R

