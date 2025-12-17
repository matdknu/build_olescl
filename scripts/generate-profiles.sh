#!/bin/bash
# Script para generar perfiles HTML desde QMD

# Función para crear perfil HTML básico
create_profile_html() {
    local name=$1
    local cargo=$2
    local email=$3
    local image=$4
    local filename=$(echo "$name" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
    
    cat > "equipo/${filename}.html" << EOF
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${name} - Observatorio de Legitimidad</title>
    <link rel="stylesheet" href="../style.css">
    <style>
        .perfil-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 20px;
        }
        .perfil-header {
            display: flex;
            gap: 3rem;
            margin-bottom: 3rem;
            padding-bottom: 2rem;
            border-bottom: 2px solid var(--border-color);
        }
        .perfil-imagen {
            flex-shrink: 0;
            width: 250px;
            height: 250px;
            border-radius: 50%;
            overflow: hidden;
            background: linear-gradient(135deg, var(--lavender-light), var(--lavender-medium));
            box-shadow: var(--shadow-lg);
        }
        .perfil-imagen img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .perfil-info {
            flex: 1;
        }
        .perfil-nombre {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            color: var(--text-color);
        }
        .perfil-cargo {
            font-size: 1.5rem;
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 1rem;
        }
        .perfil-contacto {
            margin-bottom: 1.5rem;
        }
        .perfil-contacto p {
            margin-bottom: 0.5rem;
            color: var(--text-light);
        }
        .perfil-contacto a {
            color: var(--primary-color);
            text-decoration: none;
        }
        .perfil-contacto a:hover {
            text-decoration: underline;
        }
        .perfil-descripcion {
            margin-bottom: 3rem;
            line-height: 1.8;
            color: var(--text-light);
            font-size: 1.1rem;
        }
        @media (max-width: 768px) {
            .perfil-header {
                flex-direction: column;
                text-align: center;
            }
            .perfil-imagen {
                margin: 0 auto;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="container">
            <div class="logo">
                <h1><a href="../index.html" style="color: white; text-decoration: none;">Observatorio de Legitimidad</a></h1>
            </div>
            <nav class="nav">
                <ul class="nav-menu">
                    <li><a href="../index.html#inicio">Inicio</a></li>
                    <li><a href="../index.html#proyectos">Proyectos</a></li>
                    <li><a href="../index.html#nosotros">Nosotros</a></li>
                    <li><a href="../index.html#contacto">Contacto</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <section class="perfil-container">
        <div class="perfil-header">
            <div class="perfil-imagen">
                <img src="${image}" alt="${name}">
            </div>
            <div class="perfil-info">
                <h1 class="perfil-nombre">${name}</h1>
                <p class="perfil-cargo">${cargo}</p>
                
                <div class="perfil-contacto">
                    <p><strong>Email:</strong> <a href="mailto:${email}">${email}</a></p>
                </div>
            </div>
        </div>

        <div class="perfil-descripcion">
            <p>Información detallada disponible próximamente.</p>
        </div>
    </section>

    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h4>Enlaces</h4>
                    <ul>
                        <li><a href="../index.html#inicio">Inicio</a></li>
                        <li><a href="../index.html#noticias">Noticias</a></li>
                        <li><a href="../index.html#proyectos">Proyectos</a></li>
                        <li><a href="../index.html#nosotros">Nosotros</a></li>
                        <li><a href="../index.html#contacto">Contacto</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4>Contacto</h4>
                    <p>Email: observatorio@universidad.cl</p>
                    <p>Teléfono: +56 2 2676 8479</p>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 Observatorio de Legitimidad. Todos los derechos reservados.</p>
            </div>
        </div>
    </footer>
</body>
</html>
EOF
}

# Crear perfiles
create_profile_html "María González" "Subdirectora" "maria.gonzalez@universidad.cl" "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&h=400&fit=crop"
create_profile_html "Dr. Carlos Rodríguez" "Investigador Principal" "carlos.rodriguez@universidad.cl" "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&h=400&fit=crop"
create_profile_html "Dra. Ana Martínez" "Investigadora Principal" "ana.martinez@universidad.cl" "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop"
create_profile_html "Dr. Luis Fernández" "Investigador Principal" "luis.fernandez@universidad.cl" "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop"
create_profile_html "Dra. Patricia López" "Investigadora Principal" "patricia.lopez@universidad.cl" "https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=400&h=400&fit=crop"
create_profile_html "Dr. Roberto Sánchez" "Investigador Principal" "roberto.sanchez@universidad.cl" "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop"
create_profile_html "Dr. Fernando Torres" "Investigador Asociado" "fernando.torres@universidad.cl" "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop"
create_profile_html "Dra. Carmen Silva" "Investigadora Asociada" "carmen.silva@universidad.cl" "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=400&fit=crop"
create_profile_html "Dr. Diego Morales" "Investigador Asociado" "diego.morales@universidad.cl" "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&h=400&fit=crop"
create_profile_html "Dra. Isabel Ramírez" "Investigadora Asociada" "isabel.ramirez@universidad.cl" "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=400&fit=crop"
create_profile_html "Andrés Vargas" "Investigador Doctoral" "andres.vargas@universidad.cl" "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop"
create_profile_html "Valentina Herrera" "Investigadora Doctoral" "valentina.herrera@universidad.cl" "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=400&fit=crop"
create_profile_html "Sofía Mendoza" "Asistente de Investigación" "sofia.mendoza@universidad.cl" "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop"
create_profile_html "Miguel Castro" "Asistente de Investigación" "miguel.castro@universidad.cl" "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop"
create_profile_html "Camila Rojas" "Asistente de Investigación" "camila.rojas@universidad.cl" "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=400&fit=crop"

echo "Perfiles HTML generados exitosamente"





