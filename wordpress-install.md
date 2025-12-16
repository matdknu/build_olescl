# Instalación en WordPress

Este sitio puede instalarse en WordPress de varias formas. Elige la opción que mejor se adapte a tus necesidades.

## Opción 1: Como Tema Personalizado (Recomendado)

Esta es la mejor opción si quieres tener control total sobre el diseño.

### Pasos:

1. **Crea una carpeta para el tema:**
   - Ve a tu servidor WordPress
   - Navega a `/wp-content/themes/`
   - Crea una nueva carpeta llamada `observatorio-legitimidad`

2. **Copia los archivos:**
   - Copia `index.html` y renómbralo a `index.php`
   - Copia `style.css` (ya tiene la cabecera de WordPress)
   - Copia `script.js`
   - Copia la carpeta `proyectos/` completa
   - Copia `functions.php` (ya está creado para WordPress)

3. **Activa el tema:**
   - Ve a WordPress Admin → Apariencia → Temas
   - Activa el tema "Observatorio de Legitimidad"

### Ventajas:
- ✅ Control total sobre el diseño
- ✅ Fácil de personalizar
- ✅ No depende de plugins

## Opción 2: Como Contenido de Página (Más Simple)

Ideal si solo quieres usar esta página como una página específica en tu sitio WordPress.

### Pasos:

1. **Instala un plugin de código personalizado:**
   - Instala "Insert Headers and Footers" o "Code Snippets"

2. **Agrega el CSS:**
   - Ve a Insert Headers and Footers → Settings
   - Pega el contenido de `style.css` en la sección "Scripts in Header"
   - O usa "Code Snippets" para agregar el CSS

3. **Agrega el JavaScript:**
   - En Insert Headers and Footers
   - Pega el contenido de `script.js` en la sección "Scripts in Footer"

4. **Crea una nueva página:**
   - Ve a Páginas → Añadir nueva
   - Cambia el editor a "HTML" o "Código"
   - Copia el contenido del `<body>` de `index.html` (sin las etiquetas `<body>`)
   - Publica la página

### Ventajas:
- ✅ Rápido de implementar
- ✅ No necesitas acceso FTP
- ✅ Funciona con cualquier tema

## Opción 3: Usando un Page Builder

Si usas Elementor, Gutenberg, o Beaver Builder:

1. **Agrega CSS y JS como en la Opción 2**

2. **Crea la página con el page builder:**
   - Usa bloques HTML personalizados
   - O importa el HTML en un bloque de código HTML

## Opción 4: Como Tema Hijo (Child Theme)

Si ya tienes un tema activo y quieres mantenerlo:

1. **Crea un tema hijo:**
   - Usa un plugin como "Child Theme Configurator"
   - O crea manualmente un tema hijo

2. **Sobrescribe las plantillas:**
   - Copia `index.php` al tema hijo
   - Agrega el CSS y JS al tema hijo

## Ajustes Necesarios para WordPress

### 1. Rutas de Imágenes
Si las imágenes no se cargan, ajusta las rutas:
- Cambia rutas relativas por rutas absolutas
- O usa la función `get_template_directory_uri()` de WordPress

### 2. Menú de WordPress
Puedes reemplazar el menú HTML por el menú de WordPress:
```php
<?php wp_nav_menu(array('theme_location' => 'primary')); ?>
```

### 3. Footer de WordPress
Agrega el footer de WordPress:
```php
<?php wp_footer(); ?>
```

## Plugins Recomendados

- **Insert Headers and Footers**: Para agregar CSS/JS fácilmente
- **Code Snippets**: Alternativa para código personalizado
- **Custom Post Type UI**: Si quieres crear tipos de contenido personalizados para proyectos

## Soporte

Si tienes problemas con la instalación:
1. Verifica que los archivos estén en la ubicación correcta
2. Asegúrate de que los permisos de archivo sean correctos
3. Revisa la consola del navegador para errores de JavaScript
4. Verifica que el CSS no esté siendo sobrescrito por el tema activo




