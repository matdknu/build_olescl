# Instrucción para Desplegar Correctamente

## ⚠️ IMPORTANTE: Ejecutar desde shiny-app/

El error "Application mode static not supported" ocurre cuando se despliega desde el directorio raíz.

### Solución:

1. **Abre una terminal**
2. **Navega a la carpeta shiny-app:**
   ```bash
   cd shiny-app
   ```
3. **Ejecuta el script de despliegue:**
   ```bash
   Rscript deploy.R
   ```

### Verificación:

Antes de desplegar, verifica que estás en el directorio correcto:
```bash
pwd
# Debe mostrar: .../build_olescl/shiny-app

ls app.R
# Debe mostrar: app.R
```

### Si estás en R directamente:

```r
# Cambiar al directorio correcto
setwd("shiny-app")

# Verificar
getwd()  # Debe terminar en "shiny-app"
file.exists("app.R")  # Debe ser TRUE

# Ejecutar despliegue
source("deploy.R")
```

### Archivos que se incluirán:

Solo estos archivos deben estar en el bundle:
- app.R
- run-app.R (opcional)
- .gitignore
- .rsconnectignore

**NO debe incluir:**
- _site/
- _quarto.yml
- content/
- proyectos/
- etc.
