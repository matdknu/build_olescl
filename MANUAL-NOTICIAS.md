# Manual: Cómo Crear y Publicar Noticias

Este manual te guía paso a paso para crear una noticia y que aparezca en el sitio web del Observatorio de Legitimidad.

---

## 📋 Índice

1. [Requisitos Previos](#requisitos-previos)
2. [Paso 1: Crear el archivo de noticia](#paso-1-crear-el-archivo-de-noticia)
3. [Paso 2: Escribir el contenido](#paso-2-escribir-el-contenido)
4. [Paso 3: Generar el HTML](#paso-3-generar-el-html)
5. [Paso 4: Actualizar el índice de noticias](#paso-4-actualizar-el-índice-de-noticias)
6. [Paso 5: Verificar que se vea correctamente](#paso-5-verificar-que-se-vea-correctamente)
7. [Ejemplos Completos](#ejemplos-completos)
8. [Solución de Problemas](#solución-de-problemas)

---

## 🔧 Requisitos Previos

Antes de comenzar, asegúrate de tener:

- ✅ Acceso a la carpeta del proyecto `build_olescl`
- ✅ R instalado en tu computador (para ejecutar los scripts)
- ✅ Un editor de texto (VS Code, RStudio, o cualquier editor)
- ✅ Terminal o línea de comandos

---

## 📝 Paso 1: Crear el archivo de noticia

### 1.1. Ubicación del archivo

Las noticias se crean en la carpeta:
```
content/noticias/
```

### 1.2. Nombre del archivo

El nombre del archivo debe seguir este formato:
```
AAAA-MM-DD-titulo-de-la-noticia.qmd
```

**Reglas importantes:**
- ✅ Fecha en formato: `AAAA-MM-DD` (año-mes-día)
- ✅ Título en minúsculas
- ✅ Sin espacios, usar guiones (`-`) en lugar de espacios
- ✅ Sin acentos ni caracteres especiales
- ✅ Extensión: `.qmd`

**Ejemplos de nombres correctos:**
- ✅ `2025-12-20-nueva-publicacion-oles.qmd`
- ✅ `2026-01-15-seminario-legitimidad-policial.qmd`
- ✅ `2025-11-06-investigador-asistente-editor-libro.qmd`

**Ejemplos de nombres incorrectos:**
- ❌ `noticia nueva.qmd` (tiene espacios)
- ❌ `2025/12/20-noticia.qmd` (usa barras en lugar de guiones)
- ❌ `Noticia Importante.qmd` (tiene mayúsculas y espacios)

### 1.3. Crear el archivo

1. Abre tu editor de texto
2. Crea un nuevo archivo en `content/noticias/`
3. Guárdalo con el nombre que elegiste (ej: `2025-12-20-mi-nueva-noticia.qmd`)

---

## ✍️ Paso 2: Escribir el contenido

### 2.1. Estructura básica

Cada noticia tiene dos partes:
1. **Encabezado YAML** (metadata)
2. **Contenido** (texto de la noticia en Markdown)

### 2.2. Encabezado YAML

Al inicio del archivo, escribe el encabezado YAML entre líneas con `---`:

```yaml
---
title: "Título de la noticia"
date: "DD Mes AAAA"
image: "URL_de_la_imagen"
author: "Nombre del autor"
tags: ["Noticias", "Categoría"]
destacado: false
tipo: "noticia"
---
```

**Explicación de cada campo:**

| Campo | Descripción | Ejemplo | Requerido |
|-------|-------------|---------|-----------|
| `title` | Título completo de la noticia | `"Nueva investigación publicada"` | ✅ Sí |
| `date` | Fecha en formato legible | `"20 Diciembre 2025"` | ✅ Sí |
| `image` | URL de la imagen principal | `"https://images.unsplash.com/..."` | ✅ Sí |
| `author` | Nombre del autor | `"Equipo OLES"` | ⚠️ Opcional |
| `tags` | Lista de etiquetas | `["Noticias", "Investigación"]` | ⚠️ Opcional |
| `destacado` | Si aparece como destacada | `true` o `false` | ⚠️ Opcional |
| `tipo` | Tipo: "noticia" o "evento" | `"noticia"` | ⚠️ Opcional |

**Nota sobre eventos:** Si es un evento, puedes agregar `tags: ["Evento"]` o `tipo: "evento"` para que se marque como tal.

### 2.3. Contenido de la noticia

Después del encabezado YAML, escribe el contenido usando **Markdown**.

**Elementos de Markdown que puedes usar:**

#### Títulos
```markdown
## Título Principal
### Subtítulo
#### Sub-subtítulo
```

#### Texto en negrita
```markdown
**texto en negrita**
```

#### Texto en cursiva
```markdown
*texto en cursiva*
```

#### Listas
```markdown
- Item 1
- Item 2
- Item 3
```

#### Enlaces
```markdown
[Texto del enlace](https://url.com)
```

#### Párrafos
Simplemente escribe el texto. Los párrafos se separan con una línea en blanco.

### 2.4. Ejemplo completo de archivo

```yaml
---
title: "Nueva investigación sobre legitimidad institucional publicada"
date: "20 Diciembre 2025"
image: "https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=1200&h=600&fit=crop"
author: "Equipo Observatorio"
tags: ["Noticias", "Investigación", "Destacado"]
destacado: true
tipo: "noticia"
---

## Resumen

El Observatorio de Legitimidad se complace en anunciar la publicación de una nueva investigación sobre legitimidad institucional en Chile.

## Contenido Principal

Esta investigación analiza las percepciones ciudadanas sobre la legitimidad de las instituciones públicas durante el período post-estallido social. Los resultados muestran patrones interesantes que contribuyen al debate público sobre confianza institucional.

### Hallazgos Principales

- **Confianza en instituciones**: Se observa una variación significativa según el tipo de institución
- **Factores influyentes**: La justicia procedimental emerge como factor clave
- **Diferencias generacionales**: Los jóvenes muestran patrones distintos a generaciones anteriores

## Implicaciones

Estos hallazgos tienen importantes implicaciones para la formulación de políticas públicas basadas en evidencia.

Para más información, consulta el [artículo completo](https://ejemplo.com/articulo).
```

---

## 🔨 Paso 3: Generar el HTML

Una vez que guardaste tu archivo `.qmd`, necesitas convertirlo a HTML para que se vea en el sitio web.

### 3.1. Abrir la terminal

1. Abre la terminal (Terminal en Mac, PowerShell en Windows, Terminal en Linux)
2. Navega a la carpeta del proyecto:
   ```bash
   cd /ruta/a/build_olescl
   ```
   
   O si estás en la carpeta del proyecto:
   ```bash
   cd build_olescl
   ```

### 3.2. Ejecutar el script de generación

Ejecuta el script que convierte los archivos `.qmd` a HTML:

```bash
Rscript scripts/generate-news-html.R
```

**¿Qué hace este script?**
- ✅ Lee todos los archivos `.qmd` en `content/noticias/`
- ✅ Convierte cada uno a HTML
- ✅ Guarda los HTMLs en la carpeta `noticias/`
- ✅ Crea páginas completas con header, footer y estilos

**Salida esperada:**
```
Generando HTMLs de noticias...

✓ Generado: noticias/2025-12-20-mi-nueva-noticia.html
✓ Generado: noticias/otra-noticia.html
...

✓ Proceso completado!
```

### 3.3. Verificar que se generó

Verifica que el archivo HTML se creó correctamente:

1. Ve a la carpeta `noticias/`
2. Busca tu archivo: `2025-12-20-mi-nueva-noticia.html` (o el nombre que usaste)
3. Si está ahí, ¡perfecto! ✅

---

## 📑 Paso 4: Actualizar el índice de noticias

Para que tu noticia aparezca en la lista de noticias del sitio, necesitas actualizar el índice.

### 4.1. Verificar si existe el script

Primero, verifica si existe el script `scripts/generate-index.R`:

```bash
ls scripts/generate-index.R
```

### 4.2. Opción A: Si existe el script

Ejecuta el script en la terminal:

```bash
Rscript scripts/generate-index.R
```

**¿Qué hace este script?**
- ✅ Lee todos los archivos `.qmd` en `content/noticias/`
- ✅ Extrae la información (título, fecha, imagen, etc.)
- ✅ Genera el archivo `content/noticias/index-generated.html`
- ✅ Este archivo contiene todas las noticias en formato HTML

### 4.3. Opción B: Si NO existe el script

Si el script no existe o está vacío, el índice se actualiza automáticamente cuando ejecutas `generate-news-html.R`, o puedes actualizarlo manualmente (ver sección de solución de problemas más abajo).

**Nota importante:** El archivo `index-generated.html` se carga dinámicamente en `noticias/index.html`, por lo que si tu noticia ya tiene su HTML generado en `noticias/`, debería aparecer automáticamente. Si no aparece, verifica que:
1. El HTML de tu noticia existe en `noticias/`
2. El nombre del archivo sigue el formato correcto
3. La fecha en el YAML es correcta

---

## 👀 Paso 5: Verificar que se vea correctamente

### 5.1. Abrir el sitio localmente

1. Abre tu navegador
2. Ve a la página de noticias:
   ```
   file:///ruta/completa/a/build_olescl/noticias/index.html
   ```
   
   O si tienes un servidor local:
   ```
   http://localhost:8000/noticias/index.html
   ```

### 5.2. Verificar la noticia individual

1. Haz clic en tu noticia en la lista
2. Verifica que:
   - ✅ El título se ve correctamente
   - ✅ La fecha aparece bien
   - ✅ La imagen se carga
   - ✅ El contenido se muestra bien formateado
   - ✅ Los enlaces funcionan

### 5.3. Verificar en la página principal

1. Abre `index.html` en el navegador
2. Ve a la sección de noticias
3. Verifica que tu noticia aparece (si está marcada como destacada)

---

## 📚 Ejemplos Completos

### Ejemplo 1: Noticia simple

**Archivo:** `content/noticias/2025-12-20-nueva-publicacion.qmd`

```yaml
---
title: "Nueva publicación del equipo OLES"
date: "20 Diciembre 2025"
image: "https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=1200&h=600&fit=crop"
author: "Equipo OLES"
tags: ["Noticias", "Publicaciones"]
destacado: false
tipo: "noticia"
---

El equipo del Observatorio de Legitimidad se complace en anunciar la publicación de un nuevo artículo en la revista [Pensamiento Educativo](https://ejemplo.com).

## Contenido

Este artículo analiza los significados atribuidos a la investigación en estudiantes de pregrado que participan en observatorios de investigación universitarios.

### Hallazgos principales

- Los estudiantes valoran positivamente la experiencia
- Se observan cambios en la percepción sobre la investigación
- La práctica investigativa genera conocimiento y cambio social

Para más información, puedes leer el artículo completo [aquí](https://ejemplo.com/articulo).
```

### Ejemplo 2: Evento

**Archivo:** `content/noticias/2026-01-15-seminario-legitimidad.qmd`

```yaml
---
title: "Seminario: ¿Por qué obedecemos e invocamos la ley?"
date: "15 Enero 2026"
image: "https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=1200&h=600&fit=crop"
author: "Equipo OLES"
tags: ["Evento", "Seminario"]
destacado: true
tipo: "evento"
---

## Invitación

El Observatorio de Legitimidad invita a participar en el seminario "¿Por qué obedecemos e invocamos la ley?".

## Detalles del evento

- **Fecha:** 15 de Enero de 2026
- **Hora:** 10:00 a 13:00 hrs
- **Lugar:** Auditorio Principal, Universidad Diego Portales
- **Modalidad:** Presencial y online

## Expositores

- Dra. Mónica Gerber
- Dr. Claudio Fuentes
- Dra. Macarena Orchard

## Inscripciones

Para inscribirte, envía un correo a observatorio@universidad.cl
```

### Ejemplo 3: Noticia con enlaces y formato

**Archivo:** `content/noticias/2025-11-06-investigador-editor.qmd`

```yaml
---
title: "Investigador asistente es editor de libro sobre relaciones interculturales"
date: "6 Noviembre 2025"
image: "https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=1200&h=600&fit=crop"
author: "Equipo OLES"
tags: ["Noticias", "Publicaciones", "Destacado"]
destacado: true
tipo: "noticia"
---

## Anuncio

Felicitamos a nuestro investigador asistente por su participación como editor en un nuevo libro sobre relaciones interculturales.

## Sobre el libro

El libro **"Relaciones Interculturales: Perspectivas y Desafíos"** reúne contribuciones de destacados investigadores en el campo de las relaciones intergrupales y la legitimidad institucional.

### Contenido

El libro incluye capítulos sobre:

- Legitimidad policial en contextos multiculturales
- Percepciones ciudadanas sobre instituciones
- Metodologías de investigación en legitimidad

## Más información

Puedes encontrar más detalles sobre el libro en [este enlace](https://ejemplo.com/libro).

**¡Felicitaciones al equipo!** 🎉
```

---

## 🖼️ Consejos sobre Imágenes

### Opción 1: Usar Unsplash (Recomendado)

1. Ve a https://unsplash.com
2. Busca una imagen relacionada con tu noticia
3. Haz clic en la imagen
4. Haz clic en "Download"
5. Copia la URL de la imagen
6. Agrega parámetros para el tamaño: `?w=1200&h=600&fit=crop`

**Ejemplo:**
```
https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=1200&h=600&fit=crop
```

### Opción 2: Usar tus propias imágenes

1. Guarda tu imagen en una carpeta `images/` dentro del proyecto
2. Usa la ruta relativa en el YAML:
   ```yaml
   image: "../images/mi-imagen.jpg"
   ```

**Tamaños recomendados:**
- Ancho: 1200px
- Alto: 600px
- Formato: JPG o PNG

---

## ⚠️ Solución de Problemas

### Problema 1: El script no funciona

**Error:** `Rscript: command not found`

**Solución:**
1. Verifica que R está instalado: `R --version`
2. Si no está instalado, instálalo desde https://cran.r-project.org
3. Asegúrate de que `Rscript` esté en tu PATH

### Problema 2: La noticia no aparece en el índice

**Posibles causas:**
1. No ejecutaste `generate-news-html.R` (esto es lo más importante)
2. El nombre del archivo no sigue el formato correcto
3. Hay un error en el YAML
4. El script `generate-index.R` no existe o no funciona

**Solución paso a paso:**

1. **Primero, verifica que el HTML se generó:**
   ```bash
   ls noticias/ | grep "tu-noticia"
   ```
   Si no está, ejecuta: `Rscript scripts/generate-news-html.R`

2. **Verifica el nombre del archivo:**
   - Debe ser: `AAAA-MM-DD-titulo.qmd`
   - Sin espacios, sin acentos, solo guiones

3. **Revisa el YAML:**
   - Asegúrate de que `title`, `date` e `image` estén correctos
   - Verifica que no haya errores de sintaxis

4. **Si el script `generate-index.R` no existe:**
   - El índice puede actualizarse automáticamente
   - O puedes actualizarlo manualmente editando `content/noticias/index-generated.html`
   - Agrega una entrada similar a las existentes con el formato correcto

### Problema 3: La imagen no se ve

**Posibles causas:**
1. La URL de la imagen es incorrecta
2. La imagen está en una ubicación incorrecta
3. Problemas de conexión a internet (si es URL externa)

**Solución:**
1. Verifica que la URL sea correcta abriéndola en el navegador
2. Si usas imagen local, verifica la ruta relativa
3. Prueba con una imagen de Unsplash primero

### Problema 4: El contenido no se formatea correctamente

**Posibles causas:**
1. Errores en el Markdown
2. Caracteres especiales sin escapar

**Solución:**
1. Revisa la sintaxis de Markdown
2. Asegúrate de que los títulos usen `##` o `###`
3. Verifica que las listas usen `-` al inicio

### Problema 5: La fecha no se muestra correctamente

**Solución:**
- Usa el formato: `"DD Mes AAAA"` (ej: `"20 Diciembre 2025"`)
- No uses números para el mes (ej: no `"20/12/2025"`)

---

## ✅ Checklist Final

Antes de considerar que tu noticia está lista:

- [ ] El archivo `.qmd` está en `content/noticias/`
- [ ] El nombre del archivo sigue el formato `AAAA-MM-DD-titulo.qmd`
- [ ] El encabezado YAML está completo y correcto
- [ ] El contenido está escrito en Markdown
- [ ] Ejecuté `Rscript scripts/generate-news-html.R`
- [ ] El archivo HTML se generó en `noticias/`
- [ ] Ejecuté `Rscript scripts/generate-index.R`
- [ ] La noticia aparece en `noticias/index.html`
- [ ] La noticia individual se ve correctamente
- [ ] Las imágenes se cargan bien
- [ ] Los enlaces funcionan

---

## 📞 Recursos Adicionales

- **Documentación Markdown:** https://www.markdownguide.org
- **Unsplash (imágenes):** https://unsplash.com
- **R Project:** https://www.r-project.org

---

## 🎯 Resumen Rápido

1. **Crear archivo** en `content/noticias/` con nombre `AAAA-MM-DD-titulo.qmd`
2. **Escribir YAML** con título, fecha, imagen, etc.
3. **Escribir contenido** en Markdown
4. **Ejecutar:** `Rscript scripts/generate-news-html.R` (esto es lo más importante)
5. **Opcional:** Ejecutar `Rscript scripts/generate-index.R` si existe
6. **Verificar** en el navegador que la noticia aparece

**Nota:** El paso 4 (generar HTML) es el más importante. Si tu noticia tiene su HTML en `noticias/`, debería aparecer automáticamente en el sitio.

---

**¡Listo!** Ahora ya sabes cómo crear y publicar noticias en el sitio del Observatorio de Legitimidad. 🎉

Si tienes dudas, revisa los ejemplos o consulta la sección de solución de problemas.

