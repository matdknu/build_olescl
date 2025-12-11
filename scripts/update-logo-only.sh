#!/bin/bash
# Script para quitar texto y dejar solo logo más grande

# Función para actualizar logo en header
update_logo() {
    local file=$1
    local base_path=$2
    
    # Reemplazar logo con texto por solo logo más grande
    sed -i '' "s|<a href=\"\([^\"]*\)\" style=\"display: flex; align-items: center; gap: 0.75rem; text-decoration: none; color: white;\"><img src=\"${base_path}logos/logo.png\" alt=\"[^\"]*\" style=\"height: 45px; width: auto; object-fit: contain; filter: brightness(1.1);\"><h1 style=\"margin: 0; font-size: 1.5rem; font-weight: 600;\">Observatorio de Legitimidad</h1></a>|<a href=\"\1\" style=\"display: flex; align-items: center; text-decoration: none;\"><img src=\"${base_path}logos/logo.png\" alt=\"Observatorio de Legitimidad\" style=\"height: 60px; width: auto; object-fit: contain; filter: brightness(1.1);\"></a>|g" "$file"
    sed -i '' "s|<a href=\"\([^\"]*\)\" style=\"text-decoration: none; color: white;\"><h1 style=\"margin: 0; font-size: 1.5rem;\">Observatorio de Legitimidad</h1></a>|<a href=\"\1\" style=\"display: flex; align-items: center; text-decoration: none;\"><img src=\"${base_path}logos/logo.png\" alt=\"Observatorio de Legitimidad\" style=\"height: 60px; width: auto; object-fit: contain; filter: brightness(1.1);\"></a>|g" "$file"
    sed -i '' "s|<h1><a href=\"\([^\"]*\)\" style=\"color: white; text-decoration: none;\">Observatorio de Legitimidad</a></h1>|<a href=\"\1\" style=\"display: flex; align-items: center; text-decoration: none;\"><img src=\"${base_path}logos/logo.png\" alt=\"Observatorio de Legitimidad\" style=\"height: 60px; width: auto; object-fit: contain; filter: brightness(1.1);\"></a>|g" "$file"
}

# Actualizar index.html
echo "Actualizando index.html..."
update_logo "index.html" ""

# Actualizar páginas en noticias/
echo "Actualizando páginas en noticias/..."
for file in noticias/*.html; do
    if [ -f "$file" ]; then
        update_logo "$file" "../"
    fi
done

# Actualizar noticias/index.html
if [ -f "noticias/index.html" ]; then
    update_logo "noticias/index.html" "../"
fi

# Actualizar publicaciones/index.html
if [ -f "publicaciones/index.html" ]; then
    update_logo "publicaciones/index.html" "../"
fi

# Actualizar páginas en proyectos/
echo "Actualizando páginas en proyectos/..."
for file in proyectos/*.html; do
    if [ -f "$file" ]; then
        update_logo "$file" "../"
    fi
done

# Actualizar páginas en equipo/
echo "Actualizando páginas en equipo/..."
for file in equipo/*.html; do
    if [ -f "$file" ]; then
        update_logo "$file" "../"
    fi
done

echo "✓ Logo actualizado (solo logo, más grande)"

