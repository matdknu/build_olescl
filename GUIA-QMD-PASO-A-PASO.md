# Guía Paso a Paso: Crear Contenido con QMD

Esta guía te muestra paso a paso cómo crear noticias, eventos y proyectos usando archivos QMD (Quarto Markdown).

## 📋 Índice Rápido

- [Crear una Noticia](#crear-una-noticia)
- [Crear un Evento](#crear-un-evento)
- [Crear un Proyecto](#crear-un-proyecto)
- [Renderizar y Publicar](#renderizar-y-publicar)

---

## 📰 Crear una Noticia

### Paso 1: Crear el archivo

1. Ve a la carpeta `content/noticias/`
2. Crea un nuevo archivo con nombre descriptivo:
   - Ejemplo: `seminario-legitimidad-2025-12-20.qmd`
   - Usa formato: `tema-fecha.qmd`

### Paso 2: Copiar el template

Copia este contenido básico:

```markdown
---
title: "Título de tu Noticia"
date: "DD Mes AAAA"
image: "URL_DE_IMAGEN"
author: "Autor (opcional)"
---

## Resumen

Escribe aquí un resumen breve de la noticia (2-3 líneas).

## Contenido Principal

Escribe aquí el contenido completo de la noticia.

### Subtítulo (opcional)

Puedes usar subtítulos para organizar el contenido.

- Lista de puntos
- Otro punto
- Y otro más

## Conclusión

Cierra la noticia con una conclusión o llamado a la acción.
```

### Paso 3: Llenar la información

**En el header (entre `---`):**

- `title`: Título de la noticia
- `date`: Fecha en formato "20 Diciembre 2025"
- `image`: URL de imagen (puedes usar Unsplash)
- `author`: Quien escribió la noticia (opcional)

**En el cuerpo:**

- Escribe en Markdown normal
- Usa `##` para subtítulos
- Usa `-` para listas
- Usa `**texto**` para negrita

### Paso 4: Guardar y renderizar

```bash
quarto render content/noticias/tu-noticia.qmd
```

### Ejemplo Completo

Ver: `content/noticias/ejemplo-noticia.qmd`

---

## 📅 Crear un Evento

### Paso 1: Crear el archivo

1. Ve a la carpeta `content/eventos/`
2. Crea un archivo: `seminario-2025-12-15.qmd`

### Paso 2: Usar este template

```markdown
---
title: "Nombre del Evento"
date: "DD Mes AAAA"
hora: "HH:MM hrs" o "HH:MM a HH:MM hrs"
lugar: "Lugar del evento"
image: "URL_IMAGEN"
tipo: "Seminario" o "Conferencia" o "Taller"
---

## Descripción del Evento

Describe brevemente el evento.

## Programa

### Hora | Título de la Sesión

- **Ponente**: Título de la ponencia
- **Ponente**: Título de la ponencia

## Inscripciones

Cómo inscribirse al evento.

## Organizadores

Quien organiza el evento.
```

### Paso 3: Llenar información

**Header:**
- `title`: Nombre del evento
- `date`: Fecha
- `hora`: Hora del evento
- `lugar`: Dónde se realiza
- `image`: Imagen del evento
- `tipo`: Tipo de evento

### Paso 4: Renderizar

```bash
quarto render content/eventos/tu-evento.qmd
```

### Ejemplo Completo

Ver: `content/eventos/ejemplo-evento.qmd`

---

## 🔬 Crear un Proyecto

### Paso 1: Crear el archivo

1. Ve a la carpeta `content/proyectos/`
2. Crea un archivo: `proyecto-legitimidad-2020.qmd`

### Paso 2: Usar este template

```markdown
---
title: "Nombre del Proyecto"
tipo: "Estudios de Encuesta" o "Estudios Cualitativos" etc.
estado: "En curso" o "Finalizado" o "Planificado"
fecha-inicio: "AAAA"
fecha-fin: "AAAA" o "Presente"
investigadores:
  - "Nombre Investigador 1"
  - "Nombre Investigador 2"
financiamiento: "FONDECYT Regular N. 1234567"
image: "URL_IMAGEN"
---

## Descripción del Proyecto

Describe el proyecto en 2-3 párrafos.

## Objetivos

1. **Objetivo Principal**: El objetivo principal del proyecto

2. **Objetivos Específicos**:
   - Objetivo específico 1
   - Objetivo específico 2
   - Objetivo específico 3

## Metodología

Explica cómo se realiza el proyecto.

### Diseño

- **Tipo**: Longitudinal, Transversal, etc.
- **Muestra**: Número de participantes
- **Período**: Años del proyecto

## Resultados Esperados

Qué se espera lograr con este proyecto.

## Publicaciones Relacionadas

- Autor (Año). "Título". *Revista*.

## Contacto

Email para más información.
```

### Paso 3: Llenar información

**Header:**
- `title`: Nombre del proyecto
- `tipo`: Tipo de estudio (debe coincidir con los cuadrantes)
- `estado`: Estado actual
- `fecha-inicio` y `fecha-fin`: Período
- `investigadores`: Lista de investigadores
- `financiamiento`: Cómo se financia
- `image`: Imagen del proyecto

### Paso 4: Renderizar

```bash
quarto render content/proyectos/tu-proyecto.qmd
```

### Ejemplo Completo

Ver: `content/proyectos/ejemplo-proyecto.qmd`

---

## 🔄 Renderizar y Publicar

### Opción 1: Renderizar uno por uno

```bash
# Noticia
quarto render content/noticias/mi-noticia.qmd

# Evento
quarto render content/eventos/mi-evento.qmd

# Proyecto
quarto render content/proyectos/mi-proyecto.qmd
```

### Opción 2: Renderizar todos

```bash
Rscript scripts/render-qmd.R
```

Este script renderiza todos los archivos `.qmd` en:
- `content/noticias/`
- `content/eventos/`
- `content/proyectos/`

### Opción 3: Subir a GitHub

Después de renderizar:

```bash
git add .
git commit -m "Agregar nueva noticia: Título"
git push
```

---

## 📝 Tips Importantes

### Nombres de archivos

✅ **Buenos nombres:**
- `seminario-legitimidad-2025-12-20.qmd`
- `proyecto-encuesta-2020.qmd`
- `conferencia-anual-2025.qmd`

❌ **Nombres malos:**
- `noticia1.qmd`
- `evento.qmd`
- `proyecto.qmd`

### Imágenes

**Opción 1: Unsplash (fácil)**
```
image: "https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=1200&h=600&fit=crop"
```

**Opción 2: Imágenes propias**
1. Crea carpeta `images/` en la raíz
2. Sube tu imagen
3. Referencia: `image: "images/mi-imagen.jpg"`

### Fechas

- **Noticias**: "20 Diciembre 2025"
- **Eventos**: "20 Diciembre 2025"
- **Proyectos**: Solo año "2020" o rango "2020 - 2025"

### Markdown Básico

```markdown
# Título Principal
## Subtítulo
### Sub-subtítulo

**Negrita**
*Cursiva*

- Lista
- Con puntos

1. Lista
2. Numerada

[Texto del enlace](URL)
```

---

## 🎯 Checklist Antes de Publicar

- [ ] Archivo tiene nombre descriptivo
- [ ] Header YAML está completo
- [ ] Fecha está en formato correcto
- [ ] Imagen funciona (verifica la URL)
- [ ] Contenido está bien escrito
- [ ] Archivo se renderiza sin errores
- [ ] HTML generado se ve bien
- [ ] Cambios subidos a GitHub

---

## 🆘 Problemas Comunes

### Error al renderizar

**Problema**: "Error: could not find function..."

**Solución**: Instala Quarto correctamente:
```bash
brew install quarto  # macOS
```

### El HTML no se ve bien

**Problema**: Estilos no se aplican

**Solución**: Verifica que `style.css` esté en la ruta correcta en el template

### La fecha no aparece

**Problema**: Fecha no se muestra

**Solución**: Verifica que el campo `date` esté en el header YAML

---

## 📚 Recursos

- **Ejemplos**: Revisa los archivos `ejemplo-*.qmd` en cada carpeta
- **Markdown Guide**: https://www.markdownguide.org/
- **Quarto Docs**: https://quarto.org/docs/

---

**¿Necesitas ayuda?** Revisa los ejemplos en las carpetas `content/`






