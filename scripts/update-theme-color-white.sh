#!/bin/bash
# Script para cambiar theme-color a blanco en todas las páginas

update_theme_color() {
    local file=$1
    
    # Actualizar theme-color a blanco
    sed -i '' 's/<meta name="theme-color" content="#453958">/<meta name="theme-color" content="#ffffff">/g' "$file"
    sed -i '' 's/<meta name="apple-mobile-web-app-status-bar-style" content="#453958">/<meta name="apple-mobile-web-app-status-bar-style" content="default">/g' "$file"
    sed -i '' 's/<meta name="msapplication-navbutton-color" content="#453958">/<meta name="msapplication-navbutton-color" content="#ffffff">/g' "$file"
}

# Actualizar todas las páginas HTML
echo "Actualizando páginas HTML..."
for file in $(find . -name "*.html" -not -path "./_site/*" -not -path "./.quarto/*" -not -path "./site_libs/*"); do
    if [ -f "$file" ]; then
        update_theme_color "$file"
    fi
done

echo "✓ Theme-color actualizado a blanco en todas las páginas"





