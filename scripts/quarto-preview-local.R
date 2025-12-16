#!/usr/bin/env Rscript
# Script para ejecutar quarto preview en la red local desde R

library(quarto)

# Explicación del comando:
# quarto preview --render all --no-watch-inputs --no-browse
#
# --render all: Renderiza todos los archivos QMD antes de iniciar el preview
# --no-watch-inputs: NO observa cambios en archivos (no recarga automáticamente)
# --no-browse: NO abre el navegador automáticamente

cat("=== Iniciando Quarto Preview ===\n")
cat("El servidor estará disponible en:\n")
cat("  - http://localhost:4200\n")
cat("  - http://127.0.0.1:4200\n")
cat("\n")
cat("Para acceder desde otros dispositivos en la red local,\n")
cat("usa la IP de esta computadora con el puerto 4200\n")
cat("(ej: http://192.168.1.14:4200)\n")
cat("\n")
cat("Presiona Ctrl+C para detener el servidor\n\n")

# Ejecutar quarto preview
# Nota: quarto_preview() de la librería quarto no tiene todas las opciones
# Por eso usamos system() para ejecutar el comando completo
system("quarto preview --render all --no-watch-inputs --no-browse")

