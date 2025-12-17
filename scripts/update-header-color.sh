#!/bin/bash
# Script para actualizar el color del header a #3F3351 y quitar logo del header

# Actualizar todos los headers HTML
for file in $(find . -name "*.html" -not -path "./_site/*" -not -path "./.quarto/*" -not -path "./site_libs/*"); do
    if grep -q "background: linear-gradient(135deg, var(--primary-color), var(--secondary-color))" "$file" || grep -q "background.*primary-color.*secondary-color" "$file"; then
        # Reemplazar gradiente por color sólido
        sed -i '' 's/background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));/background: #3F3351;/g' "$file"
        sed -i '' 's/background.*linear-gradient.*primary.*secondary.*;/background: #3F3351;/g' "$file"
    fi
    
    # Quitar logo del header si existe (dejar solo texto)
    if grep -q '<img src.*logo.png.*alt.*Observatorio' "$file"; then
        # Reemplazar logo + texto por solo texto
        sed -i '' 's|<a href="\([^"]*\)" style="display: flex; align-items: center; gap: 1rem; text-decoration: none; color: white;"><img src="[^"]*logo.png[^"]*" alt="[^"]*" style="[^"]*"><h1 style="margin: 0; font-size: 1.5rem;">Observatorio de Legitimidad</h1></a>|<a href="\1" style="text-decoration: none; color: white;"><h1 style="margin: 0; font-size: 1.5rem;">Observatorio de Legitimidad</h1></a>|g' "$file"
    fi
done

echo "✓ Headers actualizados"






