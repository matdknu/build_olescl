# Script CORRECTO para desplegar la aplicación Shiny
# IMPORTANTE: Ejecutar desde la carpeta shiny-app/

# Cambiar al directorio correcto si es necesario
if (basename(getwd()) != "shiny-app") {
  if (file.exists("shiny-app/app.R")) {
    setwd("shiny-app")
    cat("Cambiando al directorio shiny-app/\n")
  } else {
    stop("Por favor, ejecuta este script desde la carpeta shiny-app/ o desde la raíz del proyecto")
  }
}

# Verificar que app.R existe
if (!file.exists("app.R")) {
  stop("app.R no encontrado. Asegúrate de estar en la carpeta shiny-app/")
}

# Cargar librería
library(rsconnect)

# Configurar opciones SSL para evitar errores de certificado
options(rsconnect.check.certificate = FALSE)
options(RCurlOptions = list(
  ssl.verifypeer = TRUE,
  ssl.verifyhost = TRUE,
  verbose = FALSE
))
options(timeout = 300)

cat("=== Configuración de Despliegue ===\n")
cat("Directorio:", getwd(), "\n")
cat("Opciones SSL configuradas\n")
cat("Timeout: 300 segundos\n\n")

# Verificar cuenta
cat("Verificando cuenta de shinyapps.io...\n")
accounts <- rsconnect::accounts()
print(accounts)

if (nrow(accounts) == 0) {
  cat("\n⚠️  No hay cuentas configuradas.\n")
  stop("Cuenta no configurada")
}

# Nombre de la aplicación
app_name <- "analisis-prensa-carabineros"

# Usar la cuenta matdknu (segunda cuenta)
account_name <- "matdknu"
if (!account_name %in% accounts$name) {
  account_name <- accounts$name[1]
  cat("⚠️  Usando cuenta:", account_name, "\n")
}

cat("\n=== Desplegando aplicación ===\n")
cat("Nombre de la app:", app_name, "\n")
cat("Cuenta:", account_name, "\n")
cat("Directorio:", getwd(), "\n\n")

# Listar archivos que se van a incluir
cat("Archivos en el directorio:\n")
files <- list.files(".", all.files = FALSE)
cat(paste(files, collapse = ", "), "\n\n")

# Intentar desplegar
tryCatch({
  rsconnect::deployApp(
    appDir = ".",
    appName = app_name,
    account = account_name,
    forceUpdate = TRUE,
    launch.browser = FALSE
  )
  cat("\n✅ ¡Despliegue exitoso!\n")
  cat("La aplicación está disponible en:\n")
  cat(paste0("https://", account_name, ".shinyapps.io/", app_name, "/\n"))
}, error = function(e) {
  cat("\n❌ Error durante el despliegue:\n")
  cat(conditionMessage(e), "\n\n")
  stop(conditionMessage(e))
})


