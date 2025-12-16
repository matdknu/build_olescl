# Solución: Renderizado con Quarto vs Scripts Personalizados

## 🔍 Problema

Cuando renderizas archivos QMD con Quarto (usando R), el resultado no se ve bien porque:

1. **Quarto genera HTML con su propio formato** (navbar, sidebar, scripts de Quarto)
2. **Los scripts personalizados generan HTML plano** con la estructura completa del sitio (header, footer, estilos inline)

## ✅ Solución Implementada

### 1. Configuración de Quarto Actualizada

El archivo `_quarto.yml` ahora está configurado para:
- Generar HTML standalone (sin navbar, sidebar, footer de Quarto)
- Incluir los recursos embebidos
- Usar solo el CSS del sitio (`style.css`)

### 2. Scripts Separados por Tipo de Contenido

**Para perfiles del equipo:**
```bash
Rscript scripts/generate-profiles-from-qmd.R
```
- Genera HTML completo con header, footer, y estructura del sitio
- NO uses Quarto para estos archivos

**Para noticias, eventos, proyectos, publicaciones:**
```bash
Rscript scripts/render-qmd.R
```
- Usa Quarto para renderizar
- Genera HTML standalone sin navbar

## 📝 Cómo Usar

### Opción 1: Renderizar Todo (Recomendado)

```bash
# 1. Generar perfiles del equipo (script personalizado)
Rscript scripts/generate-profiles-from-qmd.R

# 2. Renderizar noticias, eventos, proyectos, publicaciones (Quarto)
Rscript scripts/render-qmd.R

# 3. Generar índices
Rscript scripts/generate-index.R
```

### Opción 2: Renderizar Solo con Quarto (para preview)

Si solo quieres hacer preview de noticias/eventos/proyectos:

```bash
quarto preview
```

**Nota:** Los perfiles del equipo NO se verán bien con `quarto preview` porque usan un formato diferente.

### Opción 3: Renderizar Archivo Individual

**Para perfiles del equipo:**
```bash
# NO uses Quarto, usa el script personalizado
Rscript scripts/generate-profiles-from-qmd.R
```

**Para noticias/eventos/proyectos:**
```bash
quarto render content/noticias/nombre-noticia.qmd
```

## 🎯 Recomendación

**Usa los scripts personalizados para generar el sitio completo:**

```bash
# Script maestro (crea este si quieres):
# 1. Generar perfiles
Rscript scripts/generate-profiles-from-qmd.R

# 2. Renderizar otros contenidos
Rscript scripts/render-qmd.R

# 3. Generar índices
Rscript scripts/generate-index.R
```

## ⚠️ Importante

- **NO renderices perfiles del equipo con Quarto** - Usa `generate-profiles-from-qmd.R`
- **Los archivos en `equipo/` se generan automáticamente** desde `content/equipo/*.qmd`
- **Quarto preview funciona bien** para noticias, eventos, proyectos, pero NO para perfiles

## 🔧 Si Quieres Usar Solo Quarto

Si prefieres usar solo Quarto para todo, necesitarías:

1. Crear plantillas personalizadas de Quarto
2. Configurar cada tipo de archivo con su propio formato
3. Esto es más complejo y no recomendado

**La solución actual (scripts personalizados + Quarto) es la más flexible y mantiene el diseño consistente.**

