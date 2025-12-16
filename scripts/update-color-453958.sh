#!/bin/bash
# Script para actualizar el color a #453958 en todas las páginas

update_color() {
    local file=$1
    
    # Actualizar theme-color
    sed -i '' 's/#3F3451/#453958/g' "$file"
    sed -i '' 's/#3F3351/#453958/g' "$file"
}

# Actualizar style.css
echo "Actualizando style.css..."
update_color "style.css"

# Actualizar todas las páginas HTML
echo "Actualizando páginas HTML..."
for file in $(find . -name "*.html" -not -path "./_site/*" -not -path "./.quarto/*" -not -path "./site_libs/*"); do
    if [ -f "$file" ]; then
        update_color "$file"
    fi
done

echo "✓ Color actualizado a #453958 en todas las páginas"



