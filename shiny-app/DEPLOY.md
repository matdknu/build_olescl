# Guía de Despliegue - Aplicación Shiny

## Opción 1: shinyapps.io (Recomendado para producción)

### Paso 1: Instalar rsconnect

```r
install.packages("rsconnect")
```

### Paso 2: Configurar cuenta

1. Ve a https://www.shinyapps.io/
2. Crea una cuenta gratuita
3. Ve a "Tokens" en tu perfil
4. Copia el token y secret

### Paso 3: Configurar en R

```r
library(rsconnect)

rsconnect::setAccountInfo(
  name = "tu-nombre-usuario",
  token = "TU_TOKEN",
  secret = "TU_SECRET"
)
```

### Paso 4: Desplegar

#### Opción A: Usar script de despliegue (Recomendado - soluciona errores SSL)

Desde la carpeta `shiny-app`:

```bash
# Método 1: Script bash (recomendado para macOS)
./deploy-fix-ssl.sh

# Método 2: Script R
Rscript deploy.R
```

#### Opción B: Desplegar manualmente

```r
# Configurar opciones SSL primero (importante para evitar errores)
options(rsconnect.check.certificate = FALSE)
options(RCurlOptions = list(ssl.verifypeer = TRUE, ssl.verifyhost = TRUE))

# Desplegar
rsconnect::deployApp(
  appDir = ".",
  appName = "analisis-prensa-carabineros",
  account = "tu-nombre-usuario",
  forceUpdate = TRUE
)
```

#### ⚠️ Solución de Error SSL

Si obtienes el error:
```
SSL connect error: cert already in hash table
```

**Solución rápida:**
1. Usa el script `deploy.R` o `deploy-fix-ssl.sh` (ya incluye el fix)
2. O ejecuta antes de desplegar:
   ```r
   options(rsconnect.check.certificate = FALSE)
   ```

Para más soluciones, ver `SOLUCION-SSL.md`

### Paso 5: Actualizar URL en HTML

Una vez desplegado, actualiza la URL en `proyectos/prensa-redes.html`:

```html
<iframe 
  src="https://tu-usuario.shinyapps.io/analisis-prensa-carabineros/" 
  ...
></iframe>
```

## Opción 2: Servidor Shiny propio

### Requisitos
- Servidor con R y Shiny Server instalado
- Acceso SSH al servidor

### Pasos

1. Sube la carpeta `shiny-app` al servidor
2. Asegúrate de que el archivo de datos esté accesible
3. Configura Shiny Server para servir la aplicación
4. Actualiza la URL en el HTML

## Opción 3: Ejecución local para desarrollo

### Desde RStudio
1. Abre `app.R` en RStudio
2. Haz clic en "Run App"

### Desde terminal
```bash
cd shiny-app
Rscript run-app.R
```

O directamente:
```bash
Rscript -e "shiny::runApp('shiny-app', port=3838, host='0.0.0.0')"
```

Luego actualiza el iframe en `prensa-redes.html` para usar:
```html
<iframe src="http://localhost:3838" ...></iframe>
```

## Notas importantes

- **Datos**: Asegúrate de que el archivo `data/noticias_carabineros.rds` esté accesible desde la aplicación
- **Permisos**: En shinyapps.io, el plan gratuito tiene límites de uso
- **Rendimiento**: Para datasets grandes, considera optimizar la carga de datos
- **Seguridad**: No subas datos sensibles a repositorios públicos


