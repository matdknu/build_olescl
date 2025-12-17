# Script para desplegar la aplicación Shiny en shinyapps.io
# Soluciona problemas de SSL/TLS
# IMPORTANTE: Ejecutar desde la carpeta shiny-app/

# Cambiar al directorio correcto si es necesario
original_dir <- getwd()
if (basename(getwd()) != "shiny-app") {
  if (file.exists("shiny-app/app.R")) {
    setwd("shiny-app")
    cat("⚠️  Cambiando al directorio shiny-app/\n")
  } else {
    stop("ERROR: Por favor, ejecuta este script desde la carpeta shiny-app/\nDirectorio actual: ", getwd())
  }
}

# Cargar librería
library(rsconnect)

# Configurar opciones SSL para evitar errores de certificado
# Solución para error "cert already in hash table" en macOS
options(rsconnect.check.certificate = FALSE)

# Configurar curl para macOS
if (Sys.info()["sysname"] == "Darwin") {
  # macOS - usar certificados del sistema
  Sys.setenv(CURL_CA_BUNDLE = "")
  options(RCurlOptions = list(
    ssl.verifypeer = TRUE,
    ssl.verifyhost = TRUE,
    verbose = FALSE,
    cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")
  ))
} else {
  options(RCurlOptions = list(
    ssl.verifypeer = TRUE,
    ssl.verifyhost = TRUE,
    verbose = FALSE
  ))
}

# Configurar timeout más largo
options(timeout = 300)

cat("=== Configuración de Despliegue ===\n")
cat("Opciones SSL configuradas\n")
cat("Timeout: 300 segundos\n\n")

# Verificar cuenta
cat("Verificando cuenta de shinyapps.io...\n")
accounts <- rsconnect::accounts()
print(accounts)

if (nrow(accounts) == 0) {
  cat("\n⚠️  No hay cuentas configuradas.\n")
  cat("Por favor, configura tu cuenta primero:\n")
  cat("rsconnect::setAccountInfo(\n")
  cat("  name = 'tu-nombre-usuario',\n")
  cat("  token = 'TU_TOKEN',\n")
  cat("  secret = 'TU_SECRET'\n")
  cat(")\n")
  stop("Cuenta no configurada")
}

# Nombre de la aplicación
app_name <- "analisis-prensa-carabineros"

cat("\n=== Desplegando aplicación ===\n")
cat("Nombre de la app:", app_name, "\n")
cat("Directorio:", getwd(), "\n")

# Verificar que estamos en el directorio correcto
if (!file.exists("app.R")) {
  cat("\n⚠️  Error: app.R no encontrado en el directorio actual.\n")
  cat("Por favor, ejecuta este script desde la carpeta shiny-app/\n")
  cat("Directorio actual:", getwd(), "\n")
  stop("app.R no encontrado")
}

cat("✓ app.R encontrado\n\n")

# Usar cuenta matdknu si está disponible, sino la primera
account_name <- if ("matdknu" %in% accounts$name) "matdknu" else accounts$name[1]
cat("Usando cuenta:", account_name, "\n\n")

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
  cat(paste0("https://", accounts$name[1], ".shinyapps.io/", app_name, "/\n"))
}, error = function(e) {
  cat("\n❌ Error durante el despliegue:\n")
  cat(conditionMessage(e), "\n\n")
  
  cat("=== Soluciones alternativas ===\n")
  cat("1. Actualiza rsconnect: install.packages('rsconnect')\n")
  cat("2. Actualiza curl: brew upgrade curl (en macOS)\n")
  cat("3. Intenta desde RStudio usando el botón 'Publish'\n")
  cat("4. Revisa SOLUCION-SSL.md para más opciones\n")
  
  stop(conditionMessage(e))
})

