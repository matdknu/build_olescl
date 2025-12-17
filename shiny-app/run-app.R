# Script para ejecutar la aplicación Shiny
# Observatorio de Legitimidad - Análisis de Prensa

# Verificar que los paquetes necesarios estén instalados
required_packages <- c("shiny", "dplyr", "ggplot2", "lubridate", "DT", "plotly", "shinythemes", "tidyr")

missing_packages <- required_packages[!required_packages %in% installed.packages()[,"Package"]]

if (length(missing_packages) > 0) {
  cat("Instalando paquetes faltantes:", paste(missing_packages, collapse = ", "), "\n")
  install.packages(missing_packages, dependencies = TRUE)
}

# Verificar que el archivo de datos existe
data_path <- file.path("..", "data", "noticias_carabineros.rds")
if (!file.exists(data_path)) {
  data_path <- file.path("data", "noticias_carabineros.rds")
  if (!file.exists(data_path)) {
    stop("No se encontró el archivo de datos: noticias_carabineros.rds")
  }
}

cat("Iniciando aplicación Shiny...\n")
cat("La aplicación estará disponible en: http://localhost:3838\n")
cat("Presiona Ctrl+C para detener la aplicación\n\n")

# Ejecutar la aplicación
shiny::runApp(
  appDir = getwd(),
  port = 3838,
  host = "0.0.0.0",
  launch.browser = FALSE
)

