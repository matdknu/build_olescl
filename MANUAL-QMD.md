# Manual de Uso con Quarto (QMD)

Este manual explica cómo usar archivos `.qmd` (Quarto Markdown) para agregar noticias, publicaciones y perfiles del equipo de manera fácil.

## 📋 Tabla de Contenidos

1. [¿Qué es Quarto?](#qué-es-quarto)
2. [Instalación](#instalación)
3. [Agregar una Noticia](#agregar-una-noticia)
4. [Agregar una Publicación](#agregar-una-publicación)
5. [Agregar un Miembro del Equipo](#agregar-un-miembro-del-equipo)
6. [Renderizar los Archivos](#renderizar-los-archivos)
7. [Estructura de Carpetas](#estructura-de-carpetas)

---

## ¿Qué es Quarto?

Quarto es un sistema de publicación que permite escribir contenido en Markdown (texto simple) y convertirlo automáticamente a HTML bonito y estilizado. Esto hace que sea mucho más fácil agregar contenido sin tener que escribir HTML directamente.

**Ventajas:**
- ✅ Escribes en Markdown (texto simple)
- ✅ El HTML se genera automáticamente
- ✅ Mantiene el diseño del sitio
- ✅ Fácil de editar y mantener

---

## Instalación

### 1. Instalar R y Quarto

**En macOS:**
```bash
# Instalar Homebrew si no lo tienes
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Instalar R
brew install r

# Instalar Quarto
brew install quarto
```

**En Windows:**
1. Descarga R desde: https://cran.r-project.org/
2. Descarga Quarto desde: https://quarto.org/docs/get-started/

**En Linux:**
```bash
# Instalar R
sudo apt-get install r-base

# Instalar Quarto
wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.515/quarto-1.4.515-linux-amd64.deb
sudo dpkg -i quarto-1.4.515-linux-amd64.deb
```

### 2. Instalar paquetes R necesarios

Abre R o RStudio y ejecuta:

```r
install.packages(c("quarto", "yaml", "purrr"))
```

### 3. Verificar instalación

```bash
quarto --version
```

Deberías ver algo como: `1.4.515`

---

## Agregar una Noticia

### Paso 1: Crear el archivo

Crea un nuevo archivo en `content/noticias/` con nombre descriptivo:

```
content/noticias/seminario-legitimidad-2025.qmd
```

### Paso 2: Escribir el contenido

Abre el archivo y escribe:

```markdown
---
title: "Seminario sobre Legitimidad Institucional"
date: "20 Diciembre 2025"
image: "https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=1200&h=600&fit=crop"
author: "Equipo Observatorio"
---

## Resumen

El Observatorio de Legitimidad organiza un seminario sobre legitimidad institucional.

## Contenido Principal

Este seminario reunirá a destacados investigadores para analizar...

### Temas a Tratar

- Legitimidad policial
- Confianza institucional
- Justicia procedimental

## Inscripciones

Para inscribirte, envía un email a: observatorio@universidad.cl
```

### Paso 3: Renderizar

Ejecuta en la terminal:

```bash
quarto render content/noticias/seminario-legitimidad-2025.qmd
```

Esto generará `seminario-legitimidad-2025.html` en la misma carpeta.

### Campos disponibles en el header (YAML):

- `title`: Título de la noticia (obligatorio)
- `date`: Fecha en formato "DD Mes AAAA" (obligatorio)
- `image`: URL de la imagen principal (opcional)
- `author`: Autor de la noticia (opcional)

---

## Agregar una Publicación

### Paso 1: Crear el archivo

```
content/publicaciones/gerber-2025-police-fairness.qmd
```

### Paso 2: Escribir el contenido

```markdown
---
title: "Police Fairness, Anger, and Support for Violent and Non-Violent Disruptive Actions in Chile"
date: "2025"
authors: 
  - "M. Varela"
  - "R. Bilali"
  - "E. Godfrey"
  - "J. Bahamondes"
  - "A. Figueiredo"
  - "M.M. Gerber"
journal: "Journal of Community & Applied Social Psychology"
status: "En publicación"
doi: "10.xxxx/xxxxx"
abstract: |
  Este estudio examina la relación entre la percepción de justicia policial...
---

## Resumen Ejecutivo

Esta investigación explora cómo la percepción de justicia procedimental...

## Metodología

El estudio utiliza una metodología cuantitativa...

## Resultados Principales

Los resultados indican que:

1. La percepción de justicia policial...
2. La ira media parcialmente...
3. Se observan diferencias significativas...

## Conclusiones

Estos hallazgos contribuyen a la comprensión...
```

### Paso 3: Renderizar

```bash
quarto render content/publicaciones/gerber-2025-police-fairness.qmd
```

### Campos disponibles:

- `title`: Título de la publicación (obligatorio)
- `authors`: Lista de autores (obligatorio)
- `journal`: Nombre de la revista (opcional)
- `date`: Año de publicación (obligatorio)
- `doi`: DOI de la publicación (opcional)
- `status`: Estado (En publicación, Publicado, etc.) (opcional)
- `abstract`: Resumen (opcional)

---

## Agregar un Miembro del Equipo

### Paso 1: Crear el archivo

```
content/equipo/monica-gerber.qmd
```

### Paso 2: Escribir el contenido

```markdown
---
title: "Mónica Gerber"
cargo: "Directora del Observatorio"
email: "mgerber@uc.cl"
pagina-personal: "https://gobierno.uc.cl/profesores/monica-gerber/"
google-scholar: "https://scholar.google.com/..."
image: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=400&fit=crop"
areas-interes: 
  - "Justicia social, violencias, policías"
  - "Legitimidad y justicia procedimental"
  - "Psicología política y social"
---

## Descripción

Profesora de la Escuela de Gobierno UC. Socióloga de la Universidad de Chile...

## Formación

- **Doctorado**: London School of Economics, 2010
- **Magíster**: London School of Economics, 2007
- **Pregrado**: Universidad de Chile, 2005

## Publicaciones Recientes

### 2025

**Police Fairness, Anger, and Support for Violent Actions**  
Varela, M., Bilali, R., & Gerber, M.M. (2025). *Journal of Community Psychology*.  
DOI: [10.xxxx/xxxxx](https://doi.org/10.xxxx/xxxxx)

### 2024

**Legitimidad y Justicia en Chile**  
Gerber, M.M. (2024). *Revista Psykhe*, 32(1).  
DOI: [10.xxxx/xxxxx](https://doi.org/10.xxxx/xxxxx)

## Proyectos en Curso

### Observatorio de Violencia y Legitimidad Social (OLES)

**Rol**: Directora  
**Período**: 2023 - Presente  
**Financiamiento**: Fondos ANID, UDP, COES

Descripción del proyecto...

## Otras Actividades

- **Senior Research Fellow**: London School of Economics (2022 - 2026)
- **Academy Director**: International Society of Political Psychology (2025 - 2028)
```

### Paso 3: Renderizar

```bash
quarto render content/equipo/monica-gerber.qmd
```

### Campos disponibles:

- `title`: Nombre completo (obligatorio)
- `cargo`: Cargo en el Observatorio (obligatorio)
- `email`: Email de contacto (obligatorio)
- `image`: URL de la foto de perfil (opcional)
- `pagina-personal`: URL de página personal (opcional)
- `google-scholar`: URL de Google Scholar (opcional)
- `areas-interes`: Lista de áreas de interés (opcional)

---

## Renderizar los Archivos

### Opción 1: Renderizar uno por uno

```bash
quarto render content/noticias/mi-noticia.qmd
```

### Opción 2: Renderizar todos los archivos de una carpeta

Usa el script R incluido:

```bash
Rscript scripts/render-qmd.R
```

Este script renderiza todos los archivos `.qmd` en:
- `content/noticias/`
- `content/publicaciones/`
- `content/equipo/`

### Opción 3: Renderizar todo el sitio

```bash
quarto render
```

Esto renderiza todo según la configuración en `_quarto.yml`.

---

## Estructura de Carpetas

```
build_olescl/
├── content/
│   ├── noticias/
│   │   ├── ejemplo-noticia.qmd
│   │   ├── ejemplo-noticia.html (generado)
│   │   └── index-generated.html (generado automáticamente)
│   ├── publicaciones/
│   │   ├── ejemplo-publicacion.qmd
│   │   ├── ejemplo-publicacion.html (generado)
│   │   └── index-generated.html (generado automáticamente)
│   └── equipo/
│       ├── monica-gerber.qmd
│       ├── monica-gerber.html (generado)
│       └── index-generated.html (generado automáticamente)
├── scripts/
│   ├── render-qmd.R
│   └── generate-index.R
├── _quarto.yml
└── index.html
```

---

## Generar Índices Automáticos

Para generar automáticamente los índices de noticias, publicaciones y equipo:

```bash
Rscript scripts/generate-index.R
```

Esto crea archivos `index-generated.html` en cada carpeta que puedes incluir en tu `index.html` principal.

---

## Integrar con la Página Principal

### Opción 1: Incluir HTML generado

En `index.html`, puedes incluir el HTML generado:

```html
<!-- Noticias Section -->
<section id="noticias" class="noticias-section">
    <div class="container">
        <h2 class="section-title">Noticias</h2>
        <!-- Incluir aquí el contenido de content/noticias/index-generated.html -->
    </div>
</section>
```

### Opción 2: Usar JavaScript para cargar dinámicamente

```javascript
fetch('content/noticias/index-generated.html')
  .then(response => response.text())
  .then(html => {
    document.querySelector('.noticias-grid').innerHTML = html;
  });
```

---

## Tips y Mejores Práctices

### 1. Nombres de archivos

Usa nombres descriptivos y con fecha:
- ✅ `seminario-legitimidad-2025-12-20.qmd`
- ✅ `publicacion-gerber-2025.qmd`
- ❌ `noticia1.qmd`

### 2. Imágenes

- Usa URLs de Unsplash para imágenes placeholder
- O sube imágenes a una carpeta `images/` y referencia con rutas relativas
- Tamaños recomendados:
  - Noticias: 1200x600px
  - Perfiles: 400x400px (cuadrada)

### 3. Fechas

- Noticias: Formato "DD Mes AAAA" (ej: "20 Diciembre 2025")
- Publicaciones: Solo el año (ej: "2025")

### 4. Markdown

Puedes usar todo el poder de Markdown:
- **Negrita**: `**texto**`
- *Cursiva*: `*texto*`
- Listas: `- item` o `1. item`
- Enlaces: `[texto](url)`
- Imágenes: `![alt](url)`

### 5. Renderizar antes de subir

Siempre renderiza los archivos QMD antes de hacer commit:

```bash
Rscript scripts/render-qmd.R
git add .
git commit -m "Agregar nueva noticia sobre seminario"
git push
```

---

## Solución de Problemas

### Error: "quarto: command not found"

**Solución**: Instala Quarto siguiendo las instrucciones de instalación.

### Error al renderizar

**Solución**: Verifica que:
1. El archivo tiene el header YAML correcto (entre `---`)
2. Todos los campos obligatorios están presentes
3. La sintaxis YAML es correcta (espacios, no tabs)

### El HTML no se ve bien

**Solución**: 
1. Verifica que `style.css` está en la ruta correcta
2. Revisa las rutas relativas en el HTML generado
3. Asegúrate de que el template HTML está correcto

### Los índices no se generan

**Solución**:
1. Instala los paquetes R necesarios: `install.packages(c("yaml", "purrr"))`
2. Verifica que los archivos QMD tienen metadata válida
3. Revisa los errores en la consola de R

---

## Ejemplos Completos

### Noticia Completa

Ver: `content/noticias/ejemplo-noticia.qmd`

### Publicación Completa

Ver: `content/publicaciones/ejemplo-publicacion.qmd`

### Perfil Completo

Ver: `content/equipo/perfil-template.qmd`

---

## Recursos Adicionales

- **Documentación de Quarto**: https://quarto.org/docs/
- **Guía de Markdown**: https://www.markdownguide.org/
- **YAML Syntax**: https://yaml.org/spec/

---

**Última actualización**: Diciembre 2025

