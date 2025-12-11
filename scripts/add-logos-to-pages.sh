#!/bin/bash
# Script para agregar favicon y logo a todas las páginas HTML

# Función para agregar favicon
add_favicon() {
    local file=$1
    local base_path=$2
    
    # Verificar si ya tiene favicon
    if ! grep -q "favicon\|icon.png" "$file"; then
        # Agregar después de <meta name="viewport"
        sed -i '' "/<meta name=\"viewport\"/a\\
    <link rel=\"icon\" type=\"image/png\" href=\"${base_path}logos/icon.png\">" "$file"
    fi
}

# Función para actualizar logo en header
update_logo() {
    local file=$1
    local base_path=$2
    
    # Reemplazar logo de texto por logo con imagen
    if grep -q "<h1><a href.*Observatorio de Legitimidad</a></h1>" "$file" || grep -q "<h1>Observatorio de Legitimidad</h1>" "$file"; then
        # Reemplazar diferentes variaciones
        sed -i '' "s|<h1><a href=\"\([^\"]*\)\" style=\"color: white; text-decoration: none;\">Observatorio de Legitimidad</a></h1>|<a href=\"\1\" style=\"display: flex; align-items: center; gap: 1rem; text-decoration: none; color: white;\"><img src=\"${base_path}logos/logo.png\" alt=\"Observatorio de Legitimidad\" style=\"height: 50px; width: auto;\"><h1 style=\"margin: 0; font-size: 1.5rem;\">Observatorio de Legitimidad</h1></a>|g" "$file"
        sed -i '' "s|<h1>Observatorio de Legitimidad</h1>|<a href=\"${base_path}index.html\" style=\"display: flex; align-items: center; gap: 1rem; text-decoration: none; color: white;\"><img src=\"${base_path}logos/logo.png\" alt=\"Observatorio de Legitimidad\" style=\"height: 50px; width: auto;\"><h1 style=\"margin: 0; font-size: 1.5rem;\">Observatorio de Legitimidad</h1></a>|g" "$file"
    fi
}

# Actualizar index.html (ya tiene base_path "")
echo "Actualizando index.html..."
add_favicon "index.html" ""
update_logo "index.html" ""

# Actualizar páginas en noticias/
echo "Actualizando páginas en noticias/..."
for file in noticias/*.html; do
    if [ -f "$file" ]; then
        add_favicon "$file" "../"
        update_logo "$file" "../"
    fi
done

# Actualizar noticias/index.html
if [ -f "noticias/index.html" ]; then
    add_favicon "noticias/index.html" "../"
    update_logo "noticias/index.html" "../"
fi

# Actualizar publicaciones/index.html
if [ -f "publicaciones/index.html" ]; then
    add_favicon "publicaciones/index.html" "../"
    update_logo "publicaciones/index.html" "../"
fi

# Actualizar páginas en proyectos/
echo "Actualizando páginas en proyectos/..."
for file in proyectos/*.html; do
    if [ -f "$file" ]; then
        add_favicon "$file" "../"
        update_logo "$file" "../"
    fi
done

# Actualizar páginas en equipo/
echo "Actualizando páginas en equipo/..."
for file in equipo/*.html; do
    if [ -f "$file" ]; then
        add_favicon "$file" "../"
        update_logo "$file" "../"
    fi
done

echo "✓ Logos agregados a todas las páginas"

