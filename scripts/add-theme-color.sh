#!/bin/bash
# Script para agregar theme-color a todas las páginas HTML

add_theme_color() {
    local file=$1
    
    # Verificar si ya tiene theme-color
    if ! grep -q "theme-color" "$file"; then
        # Agregar después de <meta name="viewport"
        sed -i '' "/<meta name=\"viewport\"/a\\
    <meta name=\"theme-color\" content=\"#3F3451\">\\
    <meta name=\"apple-mobile-web-app-status-bar-style\" content=\"#3F3451\">\\
    <meta name=\"msapplication-navbutton-color\" content=\"#3F3451\">" "$file"
    fi
}

# Actualizar index.html
echo "Actualizando index.html..."
add_theme_color "index.html"

# Actualizar páginas en noticias/
echo "Actualizando páginas en noticias/..."
for file in noticias/*.html; do
    if [ -f "$file" ]; then
        add_theme_color "$file"
    fi
done

# Actualizar noticias/index.html
if [ -f "noticias/index.html" ]; then
    add_theme_color "noticias/index.html"
fi

# Actualizar publicaciones/index.html
if [ -f "publicaciones/index.html" ]; then
    add_theme_color "publicaciones/index.html"
fi

# Actualizar páginas en proyectos/
echo "Actualizando páginas en proyectos/..."
for file in proyectos/*.html; do
    if [ -f "$file" ]; then
        add_theme_color "$file"
    fi
done

# Actualizar páginas en equipo/
echo "Actualizando páginas en equipo/..."
for file in equipo/*.html; do
    if [ -f "$file" ]; then
        add_theme_color "$file"
    fi
done

echo "✓ Theme-color agregado a todas las páginas"






