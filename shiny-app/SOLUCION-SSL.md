# Solución de Error SSL al Desplegar en shinyapps.io

## Error
```
SSL connect error [api.shinyapps.io]:
TLS connect error: error:0BFFF065:x509 certificate routines:CRYPTO_internal:cert already in hash table
```

## Soluciones

### Opción 1: Actualizar paquetes R (Recomendado)

```r
# Actualizar rsconnect y curl
update.packages(c("rsconnect", "curl", "httr"), ask = FALSE)

# Reinstalar rsconnect
install.packages("rsconnect", repos = "https://cran.r-project.org")
```

### Opción 2: Configurar opciones SSL en R

Antes de desplegar, ejecuta en R:

```r
# Configurar opciones SSL
options(RCurlOptions = list(ssl.verifypeer = TRUE, ssl.verifyhost = TRUE))
options(rsconnect.check.certificate = FALSE)  # Solo si es necesario

# Luego intenta desplegar
rsconnect::deployApp(
  appDir = ".",
  appName = "analisis-prensa-carabineros"
)
```

### Opción 3: Actualizar OpenSSL (macOS)

```bash
# Si usas Homebrew
brew update
brew upgrade openssl

# Verificar versión
openssl version
```

### Opción 4: Usar configuración alternativa de curl

En R, antes de desplegar:

```r
# Configurar curl para usar certificados del sistema
Sys.setenv(CURL_CA_BUNDLE = "/etc/ssl/cert.pem")  # Linux
# O en macOS:
Sys.setenv(CURL_CA_BUNDLE = "/usr/local/etc/openssl/cert.pem")

# Luego desplegar
rsconnect::deployApp(".")
```

### Opción 5: Desplegar desde RStudio

A veces RStudio maneja mejor los certificados SSL:

1. Abre `app.R` en RStudio
2. Ve a "Publish" en el panel superior derecho
3. Selecciona "Publish to ShinyApps.io"
4. Sigue las instrucciones

### Opción 6: Verificar configuración de cuenta

```r
# Verificar cuenta configurada
rsconnect::accounts()

# Si hay problemas, reconfigurar
rsconnect::setAccountInfo(
  name = "tu-nombre-usuario",
  token = "TU_TOKEN",
  secret = "TU_SECRET"
)
```

### Opción 7: Desplegar con opciones de debug

```r
# Habilitar debug para ver más detalles
options(rsconnect.http = "libcurl")
options(rsconnect.verbose = TRUE)

# Intentar desplegar
rsconnect::deployApp(
  appDir = ".",
  appName = "analisis-prensa-carabineros",
  forceUpdate = TRUE
)
```

## Verificación

Después de aplicar una solución, verifica:

```r
# Probar conexión
library(rsconnect)
rsconnect::accounts()  # Debería mostrar tu cuenta sin errores
```

## Alternativa: Desplegar manualmente

Si nada funciona, puedes:

1. **Usar Shiny Server propio** - Instalar Shiny Server en tu servidor
2. **Usar RStudio Connect** - Si tienes acceso
3. **Ejecutar localmente** - Para desarrollo, usar `shiny::runApp()`

## Contacto

Si el problema persiste, contacta al soporte de shinyapps.io o revisa:
- https://support.rstudio.com/hc/en-us/articles/200488488-Configuring-RStudio-Connect-and-Shiny-Apps-io

