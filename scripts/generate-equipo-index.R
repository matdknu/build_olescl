#!/usr/bin/env Rscript
# Script para generar automáticamente equipo/index.html desde archivos QMD

library(yaml)

# Función para leer metadata de QMD
read_qmd_metadata <- function(qmd_file) {
  content <- readLines(qmd_file, warn = FALSE, encoding = "UTF-8")
  
  yaml_start <- which(grepl("^---$", content))[1]
  yaml_end <- which(grepl("^---$", content))[2]
  
  if (is.na(yaml_start) || is.na(yaml_end)) {
    return(NULL)
  }
  
  yaml_content <- paste(content[(yaml_start+1):(yaml_end-1)], collapse = "\n")
  metadata <- yaml.load(yaml_content)
  
  # Generar nombre de archivo HTML
  name_slug <- tolower(gsub(" ", "-", metadata$title))
  name_slug <- gsub("[áàäâ]", "a", name_slug)
  name_slug <- gsub("[éèëê]", "e", name_slug)
  name_slug <- gsub("[íìïî]", "i", name_slug)
  name_slug <- gsub("[óòöô]", "o", name_slug)
  name_slug <- gsub("[úùüû]", "u", name_slug)
  name_slug <- gsub("ñ", "n", name_slug)
  name_slug <- gsub("[^a-z0-9-]", "", name_slug)
  
  metadata$html_file <- paste0(name_slug, ".html")
  
  return(metadata)
}

# Función para categorizar por cargo
categorize_cargo <- function(cargo) {
  cargo_lower <- tolower(cargo)
  
  if (grepl("director|directora", cargo_lower) && !grepl("sub", cargo_lower)) {
    return("direccion")
  } else if (grepl("subdirector|subdirectora", cargo_lower)) {
    return("subdireccion")
  } else if (grepl("investigador principal|investigadora principal", cargo_lower)) {
    return("investigadores_principales")
  } else if (grepl("investigador asociado|investigadora asociada", cargo_lower)) {
    return("investigadores_asociados")
  } else if (grepl("investigador doctoral|investigadora doctoral", cargo_lower)) {
    return("investigadores_doctorales")
  } else if (grepl("asistente anterior|investigador asistente anterior|investigadora asistente anterior", cargo_lower)) {
    return("asistentes_anteriores")
  } else if (grepl("asistente", cargo_lower)) {
    return("asistentes")
  } else {
    return("otros")
  }
}

# Función para generar tarjeta de equipo
generate_equipo_card <- function(persona) {
  sprintf(
    '                    <a href="%s" class="equipo-card">
                        <div class="equipo-avatar">
                            <img src="%s" alt="%s">
                        </div>
                        <h4>%s</h4>
                        <p>%s</p>
                    </a>',
    persona$html_file,
    persona$image %||% "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&h=200&fit=crop",
    persona$title,
    persona$title,
    persona$cargo
  )
}

# Leer todos los archivos QMD
qmd_files <- list.files("content/equipo", pattern = "\\.qmd$", full.names = TRUE)

equipo_list <- list()
for (qmd_file in qmd_files) {
  if (basename(qmd_file) == "perfil-template.qmd") next
  
  meta <- read_qmd_metadata(qmd_file)
  if (!is.null(meta) && !is.null(meta$cargo)) {
    categoria <- categorize_cargo(meta$cargo)
    if (is.null(equipo_list[[categoria]])) {
      equipo_list[[categoria]] <- list()
    }
    equipo_list[[categoria]] <- c(equipo_list[[categoria]], list(meta))
  }
}

# Generar HTML
html_header <- '<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#ffffff">
    <meta name="apple-mobile-web-app-status-bar-style" content="default">
    <meta name="msapplication-navbutton-color" content="#ffffff">
    <link rel="icon" type="image/png" href="../logos/icon.png">
    <title>Equipo - Observatorio de Legitimidad</title>
    <link rel="stylesheet" href="../style.css">
    <style>
        .equipo-completo {
            padding: 4rem 0;
            background-color: var(--bg-color);
        }
        .equipo-categoria-section {
            margin-bottom: 2.5rem;
        }
        .equipo-categoria-title {
            font-size: 1.75rem;
            margin-bottom: 1.25rem;
            color: var(--primary-color);
            padding-bottom: 0.75rem;
            border-bottom: 2px solid var(--primary-color);
        }
        .equipo-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 0;
        }
        .equipo-card {
            background: white;
            padding: 2rem;
            border-radius: 0.5rem;
            box-shadow: var(--shadow);
            text-align: center;
            transition: var(--transition);
            text-decoration: none;
            color: inherit;
        }
        .equipo-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }
        .equipo-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            margin: 0 auto 1rem;
            color: white;
            overflow: hidden;
        }
        .equipo-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .equipo-card h4 {
            font-size: 1.25rem;
            margin-bottom: 0.5rem;
            color: var(--text-color);
        }
        .equipo-card p {
            color: var(--text-light);
            font-size: 0.9rem;
        }
        .volver-link {
            display: inline-block;
            margin-bottom: 2rem;
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
            transition: var(--transition);
        }
        .volver-link:hover {
            color: var(--secondary-color);
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="container">
            <div class="logo">
                <a href="../index.html" style="display: flex; align-items: center; text-decoration: none;"><img src="../logos/logo.png" alt="Observatorio de Legitimidad" style="height: 60px; width: auto; object-fit: contain; filter: brightness(1.1);"></a>
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

    <section class="equipo-completo">
        <div class="container">
            <a href="../index.html#equipo" class="volver-link">← Volver a Nosotros</a>
            <h1 class="section-title">Equipo Completo</h1>

'

# Generar secciones por categoría
categorias <- list(
  direccion = "Dirección",
  subdireccion = "Subdirección",
  investigadores_principales = "Investigadores Principales",
  investigadores_asociados = "Investigadores Asociados",
  investigadores_doctorales = "Investigadores Doctorales",
  asistentes = "Asistentes de Investigación",
  asistentes_anteriores = "Investigadores Asistentes Anteriores"
)

html_sections <- character()

for (cat_key in names(categorias)) {
  if (!is.null(equipo_list[[cat_key]]) && length(equipo_list[[cat_key]]) > 0) {
    html_sections <- c(html_sections, sprintf('            <!-- %s -->
            <div class="equipo-categoria-section">
                <h2 class="equipo-categoria-title">%s</h2>
                <div class="equipo-grid">
', categorias[[cat_key]], categorias[[cat_key]]))
    
    for (persona in equipo_list[[cat_key]]) {
      html_sections <- c(html_sections, generate_equipo_card(persona))
    }
    
    html_sections <- c(html_sections, '                </div>
            </div>

')
  }
}

# Sección de Tesistas y Pasantes (estática)
html_footer <- '            <!-- Tesistas y Pasantes -->
            <div class="equipo-categoria-section">
                <h2 class="equipo-categoria-title">Tesistas y Pasantes</h2>
                <div style="text-align: center; margin-top: 2rem;">
                    <a href="tesistas-pasantes.html" class="btn-ver-mas" style="display: inline-block; padding: 1rem 2.5rem; background: var(--primary-color); color: white; text-decoration: none; border-radius: 0.5rem; font-weight: 600; transition: var(--transition);">
                        Ver Tesistas y Pasantes →
                    </a>
                </div>
            </div>
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
'

# Combinar todo
html_completo <- paste0(html_header, paste(html_sections, collapse = "\n"), html_footer)

# Escribir archivo
writeLines(html_completo, "equipo/index.html")
cat("✓ Archivo equipo/index.html generado automáticamente\n")
cat(sprintf("  - Total de miembros procesados: %d\n", sum(sapply(equipo_list, length))))

