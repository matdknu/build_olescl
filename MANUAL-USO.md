# Manual de Uso - Observatorio de Legitimidad

Este manual explica cómo editar y mantener el sitio web del Observatorio de Legitimidad.

## 📋 Tabla de Contenidos

1. [Estructura del Sitio](#estructura-del-sitio)
2. [Cómo Subir Noticias](#cómo-subir-noticias)
3. [Cómo Editar la Sección de Destacados](#cómo-editar-la-sección-de-destacados)
4. [Cómo Editar la Agenda](#cómo-editar-la-agenda)
5. [Cómo Editar los Proyectos](#cómo-editar-los-proyectos)
6. [Cómo Editar la Sección Nosotros](#cómo-editar-la-sección-nosotros)
7. [Cómo Agregar Miembros del Equipo](#cómo-agregar-miembros-del-equipo)
8. [Cómo Editar Tabs](#cómo-editar-tabs)
9. [Cómo Cambiar Imágenes](#cómo-cambiar-imágenes)
10. [Cómo Cambiar Colores](#cómo-cambiar-colores)
11. [Subir Cambios a GitHub](#subir-cambios-a-github)

---

## 📁 Estructura del Sitio

```
build_olescl/
├── index.html              # Página principal
├── style.css               # Estilos del sitio
├── script.js               # JavaScript para interactividad
├── equipo/                  # Perfiles del equipo
│   └── monica-gerber.html
├── proyectos/              # Páginas de proyectos
│   ├── encuestas.html
│   ├── cualitativos.html
│   ├── prensa-redes.html
│   └── datos-administrativos.html
└── README.md
```

---

## 📰 Cómo Subir Noticias

### Ubicación en el código

Las noticias se encuentran en `index.html`, en la sección con `id="noticias"`.

### Pasos para agregar una noticia:

1. **Abre el archivo `index.html`**

2. **Busca la sección de noticias:**
   ```html
   <section id="noticias" class="noticias-section">
   ```

3. **Dentro de `<div class="noticias-grid">`, agrega una nueva tarjeta:**
   ```html
   <article class="noticia-card">
       <div class="noticia-imagen">
           <img src="URL_DE_LA_IMAGEN" alt="Descripción de la imagen">
       </div>
       <div class="noticia-fecha">DD Mes AAAA</div>
       <h3>Título de la Noticia</h3>
   </article>
   ```

### Ejemplo completo:

```html
<article class="noticia-card">
    <div class="noticia-imagen">
        <img src="https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=400&h=250&fit=crop" alt="Investigación">
    </div>
    <div class="noticia-fecha">15 Diciembre 2025</div>
    <h3>Nueva investigación sobre legitimidad institucional publicada</h3>
</article>
```

### Tips:

- **Imágenes**: Usa Unsplash o sube imágenes a una carpeta `images/` y referencia con `images/nombre-imagen.jpg`
- **Fecha**: Formato recomendado: "DD Mes AAAA" (ej: "15 Diciembre 2025")
- **Orden**: Las noticias más recientes van primero

---

## ⭐ Cómo Editar la Sección de Destacados

### Ubicación:

En `index.html`, busca `<section class="destacados-section">`

### Agregar un destacado:

```html
<article class="destacado-card evento">  <!-- o "noticia" -->
    <div class="destacado-imagen">
        <img src="URL_IMAGEN" alt="Descripción">
    </div>
    <div class="destacado-tipo">Evento</div>  <!-- o "Noticia" -->
    <h3>Título del Destacado</h3>
    <div class="destacado-fecha">DD Mes AAAA</div>
</article>
```

### Tipos de destacados:

- `destacado-card evento` - Para eventos
- `destacado-card noticia` - Para noticias

### Ejemplo:

```html
<article class="destacado-card noticia">
    <div class="destacado-imagen">
        <img src="https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=400&h=250&fit=crop" alt="Seminario">
    </div>
    <div class="destacado-tipo">Noticia</div>
    <h3>Nuevo seminario sobre legitimidad policial</h3>
    <div class="destacado-fecha">20 Diciembre 2025</div>
</article>
```

---

## 📅 Cómo Editar la Agenda

### Ubicación:

En `index.html`, busca `<section id="eventos" class="agenda-section">`

### Agregar un evento:

```html
<article class="agenda-item">
    <div class="agenda-fecha">
        <div class="agenda-dia">DD</div>
        <div class="agenda-mes">mes</div>
        <div class="agenda-ano">AAAA</div>  <!-- Opcional -->
    </div>
    <div class="agenda-content">
        <h3>Nombre del Evento</h3>
        <p class="agenda-lugar">Lugar del evento</p>  <!-- Opcional -->
        <p class="agenda-hora">HH:MM hrs</p>
    </div>
</article>
```

### Ejemplo:

```html
<article class="agenda-item">
    <div class="agenda-fecha">
        <div class="agenda-dia">25</div>
        <div class="agenda-mes">diciembre</div>
        <div class="agenda-ano">2025</div>
    </div>
    <div class="agenda-content">
        <h3>Conferencia Anual del Observatorio</h3>
        <p class="agenda-lugar">Auditorio Principal, Universidad</p>
        <p class="agenda-hora">10:00 a 18:00 hrs</p>
    </div>
</article>
```

---

## 🔬 Cómo Editar los Proyectos

### Opción 1: Editar los cuadrantes principales

En `index.html`, busca `<section id="proyectos" class="proyectos-section">`

Cada cuadrante tiene esta estructura:

```html
<a href="proyectos/TIPO.html" class="proyecto-cuadrante">
    <div class="proyecto-imagen">
        <img src="URL_IMAGEN" alt="Descripción">
    </div>
    <div class="proyecto-cuadrante-content">
        <h3>Título del Tipo de Proyecto</h3>
        <p>Descripción del tipo de proyecto</p>
        <span class="proyecto-link">Ver proyectos →</span>
    </div>
</a>
```

### Opción 2: Editar proyectos individuales

Cada tipo de proyecto tiene su propia página en `proyectos/`:

- `proyectos/encuestas.html`
- `proyectos/cualitativos.html`
- `proyectos/prensa-redes.html`
- `proyectos/datos-administrativos.html`

### Agregar un proyecto en una página específica:

1. Abre el archivo correspondiente (ej: `proyectos/encuestas.html`)

2. Busca `<div class="proyectos-grid">`

3. Agrega una nueva tarjeta:

```html
<div class="proyecto-card">
    <h3>Nombre del Proyecto</h3>
    <p>Descripción detallada del proyecto.</p>
    <div class="proyecto-meta">
        <span class="proyecto-estado estado-en-curso">En curso</span>
        <span class="proyecto-fecha">2024 - Presente</span>
    </div>
</div>
```

### Estados disponibles:

- `estado-en-curso` - Proyecto en curso
- `estado-finalizado` - Proyecto finalizado
- `estado-planificado` - Proyecto planificado

---

## 👥 Cómo Editar la Sección Nosotros

### Editar Misión y Visión:

En `index.html`, busca `<div id="mision" class="nosotros-texto">`

```html
<div id="mision" class="nosotros-texto">
    <h3>Misión</h3>
    <p>Texto de la misión aquí...</p>
    
    <h3>Visión</h3>
    <p>Texto de la visión aquí...</p>
</div>
```

---

## 👤 Cómo Agregar Miembros del Equipo

### Opción 1: Agregar tarjeta simple

En `index.html`, busca `<div class="equipo-grid">`

Agrega una tarjeta:

```html
<div class="equipo-card">
    <div class="equipo-avatar">👤</div>
    <h4>Nombre Completo</h4>
    <p>Cargo o posición</p>
</div>
```

### Opción 2: Agregar perfil completo (como Mónica Gerber)

1. **Crea un nuevo archivo** en `equipo/nombre-apellido.html`

2. **Copia la estructura** de `equipo/monica-gerber.html`

3. **Modifica:**
   - Nombre y cargo
   - Email
   - Imagen de perfil
   - Áreas de interés
   - Descripción
   - Publicaciones (tab)
   - Proyectos (tab)
   - Actividades (tab)

4. **Haz la tarjeta clickeable** en `index.html`:

```html
<a href="equipo/nombre-apellido.html" class="equipo-card" style="text-decoration: none; color: inherit;">
    <div class="equipo-avatar">
        <img src="URL_IMAGEN" alt="Nombre" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
    </div>
    <h4>Nombre Completo</h4>
    <p>Cargo</p>
</a>
```

---

## 📑 Cómo Editar Tabs

### Tabs en la página de proyectos:

En `index.html`, busca la sección de proyectos con tabs:

```html
<div class="tab-buttons">
    <button class="tab-button active" data-tab="tab1">En curso</button>
    <button class="tab-button" data-tab="tab2">Finalizados</button>
    <button class="tab-button" data-tab="tab3">Futuros</button>
</div>
```

### Agregar una nueva tab:

1. **Agrega el botón:**
```html
<button class="tab-button" data-tab="tab4">Nueva Tab</button>
```

2. **Agrega el contenido:**
```html
<div class="tab-pane" id="tab4">
    <div class="proyectos-grid">
        <!-- Contenido aquí -->
    </div>
</div>
```

3. **Importante:** El `data-tab` del botón debe coincidir con el `id` del `tab-pane`

### Tabs en perfiles del equipo:

En los archivos de perfil (ej: `equipo/monica-gerber.html`), las tabs funcionan igual:

```html
<button class="perfil-tab-button active" data-tab="publicaciones">Últimas Publicaciones</button>
<button class="perfil-tab-button" data-tab="proyectos">Proyectos en curso</button>
```

---

## 🖼️ Cómo Cambiar Imágenes

### Opción 1: Usar imágenes de Unsplash

```html
<img src="https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=400&h=250&fit=crop" alt="Descripción">
```

**Cómo encontrar imágenes:**
1. Ve a https://unsplash.com
2. Busca una imagen
3. Haz clic en "Download"
4. Copia la URL de la imagen
5. Agrega parámetros: `?w=400&h=250&fit=crop` para tamaño

### Opción 2: Subir imágenes propias

1. **Crea una carpeta `images/`** en la raíz del proyecto

2. **Sube tus imágenes** a esa carpeta

3. **Referencia en el HTML:**
```html
<img src="images/nombre-imagen.jpg" alt="Descripción">
```

### Tamaños recomendados:

- **Hero/Header**: 1920x1080px
- **Destacados**: 400x250px
- **Noticias**: 400x250px
- **Proyectos**: 600x400px
- **Perfiles**: 400x400px (cuadrada)

---

## 🎨 Cómo Cambiar Colores

### Ubicación:

Abre `style.css` y busca la sección `:root` al inicio:

```css
:root {
    --primary-color: #4E4976;
    --secondary-color: #3F3351;
    --accent-color: #998AAF;
    --text-color: #220223;
    --lavender-light: #C3B8D3;
    --lavender-medium: #998AAF;
}
```

### Cambiar colores:

1. **Elige tu paleta de colores**

2. **Reemplaza los valores hex:**
```css
:root {
    --primary-color: #TU_COLOR_AQUI;
    --secondary-color: #TU_COLOR_AQUI;
    --accent-color: #TU_COLOR_AQUI;
}
```

3. **Guarda el archivo** - Los cambios se aplicarán automáticamente

### Herramientas para elegir colores:

- [Coolors.co](https://coolors.co) - Generador de paletas
- [Adobe Color](https://color.adobe.com) - Paletas profesionales

---

## 🔧 Cómo Editar el Menú

### Ubicación:

En `index.html`, busca `<nav class="nav">`

### Estructura del menú:

```html
<ul class="nav-menu">
    <li><a href="#inicio" class="active">Inicio</a></li>
    <li class="dropdown">
        <a href="#nosotros" class="dropdown-toggle">Acerca del Observatorio <span class="arrow">▼</span></a>
        <ul class="dropdown-menu">
            <li><a href="#mision">Misión</a></li>
            <li><a href="#equipo">Equipo</a></li>
        </ul>
    </li>
    <!-- Más items -->
</ul>
```

### Agregar un item al menú:

```html
<li><a href="#seccion">Nuevo Item</a></li>
```

### Agregar un dropdown:

```html
<li class="dropdown">
    <a href="#seccion" class="dropdown-toggle">Título <span class="arrow">▼</span></a>
    <ul class="dropdown-menu">
        <li><a href="#subseccion1">Subitem 1</a></li>
        <li><a href="#subseccion2">Subitem 2</a></li>
    </ul>
</li>
```

---

## 📤 Subir Cambios a GitHub

### Pasos:

1. **Abre la terminal** en la carpeta del proyecto

2. **Verifica los cambios:**
```bash
git status
```

3. **Agrega los archivos modificados:**
```bash
git add .
```
O archivos específicos:
```bash
git add index.html style.css
```

4. **Haz commit con un mensaje descriptivo:**
```bash
git commit -m "Agregar nueva noticia sobre seminario"
```

5. **Sube a GitHub:**
```bash
git push
```

### Ejemplo completo:

```bash
cd /ruta/al/proyecto/build_olescl
git add index.html
git commit -m "Agregar noticia: Nuevo seminario sobre legitimidad"
git push
```

### Si GitHub Pages está activado:

Los cambios aparecerán automáticamente en:
**https://matdknu.github.io/build_olescl/**

Puede tardar unos minutos en actualizarse.

---

## 💡 Tips y Mejores Prácticas

### 1. **Siempre prueba localmente primero**

Antes de subir cambios, prueba en `http://localhost:8000`

### 2. **Mensajes de commit descriptivos**

Buenos ejemplos:
- "Agregar noticia: Seminario sobre legitimidad"
- "Actualizar perfil de Mónica Gerber"
- "Agregar nuevo proyecto de encuestas"

### 3. **Mantén las imágenes optimizadas**

- Usa formatos JPG para fotos
- Usa formatos PNG para logos
- Tamaños razonables (no más de 500KB por imagen)

### 4. **Revisa en diferentes dispositivos**

El sitio es responsive, pero siempre verifica:
- Desktop
- Tablet
- Móvil

### 5. **Backup antes de cambios grandes**

```bash
git branch backup-antes-cambios
git checkout backup-antes-cambios
git add .
git commit -m "Backup antes de cambios"
git checkout main
```

---

## 🆘 Solución de Problemas

### Las imágenes no se ven:

- Verifica que la URL sea correcta
- Si usas imágenes locales, asegúrate de que estén en la carpeta correcta
- Revisa la consola del navegador (F12) para ver errores

### Los cambios no se reflejan:

- Limpia la caché del navegador (Ctrl+Shift+R o Cmd+Shift+R)
- Verifica que guardaste el archivo
- Si usas GitHub Pages, espera unos minutos

### El menú no funciona en móvil:

- Verifica que `script.js` esté cargado
- Revisa la consola del navegador para errores de JavaScript

### Los colores no cambian:

- Verifica que editaste `style.css` y no otro archivo
- Limpia la caché del navegador
- Verifica que los valores hex sean correctos (empiezan con #)

---

## 📞 Recursos Adicionales

- **Documentación HTML**: https://developer.mozilla.org/es/docs/Web/HTML
- **Documentación CSS**: https://developer.mozilla.org/es/docs/Web/CSS
- **GitHub Pages**: https://pages.github.com
- **Unsplash**: https://unsplash.com (imágenes gratuitas)

---

## 📝 Checklist para Actualizar el Sitio

- [ ] Revisar noticias antiguas
- [ ] Agregar nuevas noticias
- [ ] Actualizar destacados
- [ ] Revisar agenda de eventos
- [ ] Actualizar proyectos
- [ ] Verificar enlaces
- [ ] Probar en diferentes navegadores
- [ ] Probar en móvil
- [ ] Hacer commit y push a GitHub

---

**Última actualización**: Diciembre 2025

