# Observatorio de Legitimidad - Sitio Web

Sitio web del Observatorio de Legitimidad. Página moderna y responsive diseñada para WordPress o GitHub Pages.

## Características

- ✅ **Menú desplegable (dropdown)** - Navegación con submenús animados
- ✅ **Sistema de Tabs** - Pestañas interactivas para organizar contenido
- ✅ **Diseño Responsive** - Se adapta perfectamente a móviles, tablets y desktop
- ✅ **Menú móvil** - Hamburger menu para dispositivos móviles
- ✅ **Animaciones suaves** - Transiciones y efectos visuales modernos
- ✅ **Diseño moderno** - UI/UX profesional con gradientes y sombras

## Archivos incluidos

- `index.html` - Estructura HTML de la página
- `style.css` - Estilos CSS con diseño moderno
- `script.js` - JavaScript para interactividad
- `README.md` - Este archivo

## Cómo usar en WordPress

### Opción 1: Como contenido de página
1. Copia el contenido de `index.html` y pégalo en el editor HTML de WordPress
2. Agrega el CSS de `style.css` en **Apariencia > Personalizar > CSS adicional**
3. Agrega el JavaScript de `script.js` en un plugin de código personalizado o en el footer

### Opción 2: Como tema personalizado
1. Crea una carpeta en `/wp-content/themes/`
2. Copia todos los archivos
3. Crea un `functions.php` para cargar los estilos y scripts
4. Crea un `style.css` con la cabecera del tema WordPress

### Opción 3: Usando un plugin de HTML personalizado
1. Instala un plugin como "Insert Headers and Footers" o "Code Snippets"
2. Agrega el CSS en la sección de header
3. Agrega el JavaScript en la sección de footer
4. Crea una nueva página y pega el HTML en el editor

## Personalización

### Colores
Los colores principales están definidos como variables CSS en `style.css`:
```css
:root {
    --primary-color: #2563eb;
    --secondary-color: #1e40af;
    --accent-color: #3b82f6;
}
```

### Contenido
Modifica el contenido HTML en `index.html` según tus necesidades:
- Cambia los textos en las secciones
- Ajusta los items del menú
- Personaliza las tabs y su contenido

## Compatibilidad

- ✅ WordPress 5.0+
- ✅ Navegadores modernos (Chrome, Firefox, Safari, Edge)
- ✅ Dispositivos móviles (iOS, Android)
- ✅ Tablets y desktop

## GitHub Pages

Este sitio está configurado para desplegarse automáticamente en GitHub Pages. Para activarlo:

### Opción 1: GitHub Actions (Recomendado - ya configurado)

1. Ve a: https://github.com/matdknu/build_olescl/settings/pages
2. En **Source**, selecciona: **GitHub Actions**
3. Guarda los cambios
4. El workflow se ejecutará automáticamente en cada push a `main`
5. Tu sitio estará disponible en: **https://matdknu.github.io/build_olescl/**

### Opción 2: Deploy from a branch

1. Ve a: https://github.com/matdknu/build_olescl/settings/pages
2. En **Source**, selecciona:
   - Branch: `main`
   - Folder: `/ (root)`
3. Guarda los cambios
4. Tu sitio estará disponible en: **https://matdknu.github.io/build_olescl/**

### Notas

- El archivo `.nojekyll` está incluido para asegurar que GitHub Pages sirva los archivos estáticos correctamente
- El workflow de GitHub Actions está configurado en `.github/workflows/pages.yml`
- Los cambios se despliegan automáticamente después de cada push a `main`

## Notas

- El menú desplegable funciona con hover en desktop y con click en móvil
- Las tabs son completamente funcionales y animadas
- El diseño es responsive y se adapta automáticamente
- Todos los enlaces están preparados para usar anchors (#) o URLs reales
- Las imágenes usan Unsplash como placeholder y pueden ser reemplazadas

