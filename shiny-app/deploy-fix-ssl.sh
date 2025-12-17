#!/bin/bash
# Script para desplegar con fix de SSL en macOS

echo "=== Despliegue de Aplicación Shiny con Fix SSL ==="
echo ""

# Verificar que estamos en el directorio correcto
if [ ! -f "app.R" ]; then
    echo "Error: app.R no encontrado. Ejecuta este script desde shiny-app/"
    exit 1
fi

# Actualizar paquetes si es necesario
echo "Verificando paquetes R..."
Rscript -e "if (!require('rsconnect')) install.packages('rsconnect', repos='https://cran.r-project.org')"

# Configurar variables de entorno para SSL
export CURL_CA_BUNDLE=""
export SSL_CERT_FILE=""

# Ejecutar script de despliegue
echo ""
echo "Ejecutando despliegue..."
Rscript deploy.R


