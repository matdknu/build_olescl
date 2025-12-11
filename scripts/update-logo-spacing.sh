#!/bin/bash
# Script para actualizar el tamaño del logo y espaciado

update_logo_size() {
    local file=$1
    
    # Actualizar altura del logo de 60px a 70px
    sed -i '' 's/height: 60px/height: 70px/g' "$file"
}

# Actualizar index.html
echo "Actualizando index.html..."
update_logo_size "index.html"

# Actualizar páginas en noticias/
echo "Actualizando páginas en noticias/..."
for file in noticias/*.html; do
    if [ -f "$file" ]; then
        update_logo_size "$file"
    fi
done

# Actualizar noticias/index.html
if [ -f "noticias/index.html" ]; then
    update_logo_size "noticias/index.html"
fi

# Actualizar publicaciones/index.html
if [ -f "publicaciones/index.html" ]; then
    update_logo_size "publicaciones/index.html"
fi

# Actualizar páginas en proyectos/
echo "Actualizando páginas en proyectos/..."
for file in proyectos/*.html; do
    if [ -f "$file" ]; then
        update_logo_size "$file"
    fi
done

# Actualizar páginas en equipo/
echo "Actualizando páginas en equipo/..."
for file in equipo/*.html; do
    if [ -f "$file" ]; then
        update_logo_size "$file"
    fi
done

echo "✓ Tamaño del logo actualizado a 70px"

