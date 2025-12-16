# Quarto Preview - Explicación y Uso

## ¿Qué hace el comando?

```bash
quarto preview --render all --no-watch-inputs --no-browse
```

### Desglose del comando:

1. **`quarto preview`**
   - Inicia un servidor de preview local
   - Por defecto corre en `http://localhost:4200`
   - Permite ver el sitio antes de publicarlo

2. **`--render all`**
   - Renderiza **todos** los archivos QMD del proyecto antes de iniciar
   - Asegura que todo esté actualizado
   - Útil cuando haces cambios y quieres ver todo renderizado

3. **`--no-watch-inputs`**
   - **NO** observa cambios en archivos automáticamente
   - No recarga la página cuando cambias un archivo
   - Útil si quieres control manual del renderizado

4. **`--no-browse`**
   - **NO** abre el navegador automáticamente
   - Útil si ya tienes el navegador abierto o quieres abrirlo manualmente

## Cómo ejecutarlo desde R

### Opción 1: Desde RStudio o R Console

```r
# Cargar librería
library(quarto)

# Ejecutar preview
system("quarto preview --render all --no-watch-inputs --no-browse")
```

### Opción 2: Desde RScript (línea de comandos)

```bash
Rscript scripts/quarto-preview-local.R
```

### Opción 3: Usando la función de Quarto (limitada)

```r
library(quarto)

# Esta función tiene opciones limitadas
quarto::quarto_preview()
# Nota: No permite todas las opciones de línea de comandos
```

## Acceso en la Red Local

Por defecto, `quarto preview` solo escucha en `localhost` (127.0.0.1), lo que significa que solo es accesible desde la misma computadora.

### Para hacerlo accesible en la red local:

**Opción A: Usar el script de Python (ya configurado)**
```bash
python3 -m http.server 7431 --bind 0.0.0.0
```
- Accesible en: `http://192.168.1.14:7431` (desde otros dispositivos)

**Opción B: Modificar Quarto Preview (más complejo)**

Quarto preview no tiene una opción directa para escuchar en todas las interfaces. Pero puedes:

1. Usar un proxy reverso
2. O usar el servidor Python que ya está configurado

## Comparación: Quarto Preview vs Servidor Python

| Característica | Quarto Preview | Python HTTP Server |
|----------------|----------------|-------------------|
| **Puerto** | 4200 | 7431 (configurable) |
| **Auto-render** | Sí (con watch) | No |
| **Red local** | Solo localhost | Sí (0.0.0.0) |
| **Recarga automática** | Sí (con watch) | No |
| **Renderiza QMD** | Sí | No (sirve HTML estático) |

## Recomendación

**Para desarrollo y preview de QMD:**
```bash
quarto preview --render all --no-watch-inputs --no-browse
```
- Útil para ver cómo se renderizan los archivos QMD
- Accesible solo en localhost:4200

**Para servir el sitio completo en red local:**
```bash
python3 -m http.server 7431 --bind 0.0.0.0
```
- Útil para compartir el sitio con otros dispositivos
- Accesible en la red local (ej: 192.168.1.14:7431)
- Sirve los archivos HTML ya generados

## Scripts Disponibles

1. **`scripts/quarto-preview-local.R`** - Ejecuta quarto preview desde R
2. **Servidor Python** - Ya corriendo en puerto 7431 (red local)

