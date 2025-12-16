#!/usr/bin/env Rscript
# Script para generar perfiles HTML desde archivos QMD con estructura completa como monica-gerber.html

library(yaml)

# Función para extraer secciones del markdown
extract_sections <- function(md_content) {
  sections <- list(
    descripcion = "",
    publicaciones = "",
    proyectos = "",
    actividades = ""
  )
  
  lines <- strsplit(md_content, "\n")[[1]]
  current_section <- "descripcion"
  current_content <- character()
  
  for (line in lines) {
    # Detectar secciones principales
    if (grepl("^## Descripción", line, ignore.case = TRUE)) {
      if (length(current_content) > 0) {
        sections[[current_section]] <- paste(current_content, collapse = "\n")
      }
      current_section <- "descripcion"
      current_content <- character()
    } else if (grepl("^## (Publicaciones|Últimas Publicaciones|Publicaciones Recientes)", line, ignore.case = TRUE)) {
      if (length(current_content) > 0) {
        sections[[current_section]] <- paste(current_content, collapse = "\n")
      }
      current_section <- "publicaciones"
      current_content <- character()
    } else if (grepl("^## (Proyectos|Proyectos en Curso|Proyectos en los que Participa)", line, ignore.case = TRUE)) {
      if (length(current_content) > 0) {
        sections[[current_section]] <- paste(current_content, collapse = "\n")
      }
      current_section <- "proyectos"
      current_content <- character()
    } else if (grepl("^## (Otras Actividades|Actividades)", line, ignore.case = TRUE)) {
      if (length(current_content) > 0) {
        sections[[current_section]] <- paste(current_content, collapse = "\n")
      }
      current_section <- "actividades"
      current_content <- character()
    } else {
      # Incluir todas las demás líneas (incluyendo ## Formación, etc.) en la sección actual
      current_content <- c(current_content, line)
    }
  }
  
  # Guardar última sección
  if (length(current_content) > 0) {
    sections[[current_section]] <- paste(current_content, collapse = "\n")
  }
  
  return(sections)
}

# Función para convertir markdown a HTML
markdown_to_html <- function(md_text) {
  if (nchar(trimws(md_text)) == 0) return("")
  
  # Procesar líneas
  lines <- strsplit(md_text, "\n")[[1]]
  html_lines <- character()
  in_list <- FALSE
  in_paragraph <- FALSE
  
  for (line in lines) {
    trimmed <- trimws(line)
    
    # Detectar encabezados ## (h2) y convertirlos a h3
    if (grepl("^## ", trimmed)) {
      if (in_paragraph) {
        html_lines <- c(html_lines, "</p>")
        in_paragraph <- FALSE
      }
      if (in_list) {
        html_lines <- c(html_lines, "</ul>")
        in_list <- FALSE
      }
      title <- gsub("^## ", "", trimmed)
      html_lines <- c(html_lines, paste0("<h3>", title, "</h3>"))
    }
    # Detectar encabezados ### (h3) y convertirlos a h4
    else if (grepl("^### ", trimmed)) {
      if (in_paragraph) {
        html_lines <- c(html_lines, "</p>")
        in_paragraph <- FALSE
      }
      if (in_list) {
        html_lines <- c(html_lines, "</ul>")
        in_list <- FALSE
      }
      title <- gsub("^### ", "", trimmed)
      html_lines <- c(html_lines, paste0("<h4>", title, "</h4>"))
    }
    # Detectar listas
    else if (grepl("^\\- ", trimmed)) {
      if (in_paragraph) {
        html_lines <- c(html_lines, "</p>")
        in_paragraph <- FALSE
      }
      if (!in_list) {
        html_lines <- c(html_lines, "<ul>")
        in_list <- TRUE
      }
      # Convertir negritas en listas
      list_item <- gsub("^\\- ", "", trimmed)
      list_item <- gsub("\\*\\*([^*]+)\\*\\*", "<strong>\\1</strong>", list_item, perl = TRUE)
      html_lines <- c(html_lines, paste0("<li>", list_item, "</li>"))
    }
    # Líneas de texto normal
    else if (nchar(trimmed) > 0) {
      if (in_list) {
        html_lines <- c(html_lines, "</ul>")
        in_list <- FALSE
      }
      if (!in_paragraph) {
        html_lines <- c(html_lines, "<p>")
        in_paragraph <- TRUE
      }
      # Convertir negritas
      trimmed <- gsub("\\*\\*([^*]+)\\*\\*", "<strong>\\1</strong>", trimmed, perl = TRUE)
      # Convertir enlaces
      trimmed <- gsub("\\[([^\\]]+)\\]\\(([^)]+)\\)", "<a href=\"\\2\" target=\"_blank\">\\1</a>", trimmed, perl = TRUE)
      html_lines <- c(html_lines, trimmed)
    }
  }
  
  if (in_list) html_lines <- c(html_lines, "</ul>")
  if (in_paragraph) html_lines <- c(html_lines, "</p>")
  
  return(paste(html_lines, collapse = "\n"))
}

# Función para generar HTML de perfil completo
generate_profile_html <- function(qmd_file) {
  content <- readLines(qmd_file, warn = FALSE, encoding = "UTF-8")
  
  yaml_start <- which(grepl("^---$", content))[1]
  yaml_end <- which(grepl("^---$", content))[2]
  
  if (is.na(yaml_start) || is.na(yaml_end)) {
    cat("Error: No se encontró YAML en", qmd_file, "\n")
    return(NULL)
  }
  
  yaml_content <- paste(content[(yaml_start+1):(yaml_end-1)], collapse = "\n")
  md_content <- paste(content[(yaml_end+1):length(content)], collapse = "\n")
  
  metadata <- yaml.load(yaml_content)
  
  # Extraer secciones
  sections <- extract_sections(md_content)
  
  # Generar nombre de archivo
  name_slug <- tolower(gsub(" ", "-", metadata$title))
  name_slug <- gsub("[áàäâ]", "a", name_slug)
  name_slug <- gsub("[éèëê]", "e", name_slug)
  name_slug <- gsub("[íìïî]", "i", name_slug)
  name_slug <- gsub("[óòöô]", "o", name_slug)
  name_slug <- gsub("[úùüû]", "u", name_slug)
  name_slug <- gsub("ñ", "n", name_slug)
  name_slug <- gsub("[^a-z0-9-]", "", name_slug)
  
  output_file <- paste0("equipo/", name_slug, ".html")
  
  # Convertir secciones a HTML
  descripcion_html <- markdown_to_html(sections$descripcion)
  publicaciones_html <- markdown_to_html(sections$publicaciones)
  proyectos_html <- markdown_to_html(sections$proyectos)
  actividades_html <- markdown_to_html(sections$actividades)
  
  # Determinar qué tabs mostrar
  has_publicaciones <- nchar(trimws(publicaciones_html)) > 0
  has_proyectos <- nchar(trimws(proyectos_html)) > 0
  has_actividades <- nchar(trimws(actividades_html)) > 0
  
  # Generar HTML completo con estructura de monica-gerber.html
  html_template <- paste0('<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>', metadata$title, ' - Observatorio de Legitimidad</title>
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
        .perfil-enlaces {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }
        .perfil-enlace {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: var(--bg-light);
            border-radius: 0.5rem;
            text-decoration: none;
            color: var(--text-color);
            transition: var(--transition);
        }
        .perfil-enlace:hover {
            background: var(--lavender-light);
            color: var(--primary-color);
        }
        .perfil-areas {
            margin-top: 1.5rem;
        }
        .perfil-areas h3 {
            font-size: 1.25rem;
            margin-bottom: 1rem;
            color: var(--text-color);
        }
        .perfil-areas ul {
            list-style: none;
            padding: 0;
        }
        .perfil-areas li {
            padding: 0.5rem 0;
            color: var(--text-light);
            border-bottom: 1px solid var(--border-color);
        }
        .perfil-areas li:last-child {
            border-bottom: none;
        }
        .perfil-descripcion {
            margin-bottom: 3rem;
            line-height: 1.8;
            color: var(--text-light);
            font-size: 1.1rem;
        }
        .perfil-tabs {
            margin-top: 2rem;
        }
        .perfil-tab-buttons {
            display: flex;
            gap: 1rem;
            border-bottom: 2px solid var(--border-color);
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }
        .perfil-tab-button {
            background: none;
            border: none;
            padding: 1rem 2rem;
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-light);
            cursor: pointer;
            position: relative;
            transition: var(--transition);
            border-bottom: 3px solid transparent;
            margin-bottom: -2px;
        }
        .perfil-tab-button:hover {
            color: var(--primary-color);
        }
        .perfil-tab-button.active {
            color: var(--primary-color);
            border-bottom-color: var(--primary-color);
        }
        .perfil-tab-content {
            min-height: 400px;
        }
        .perfil-tab-pane {
            display: none;
            animation: fadeIn 0.5s ease;
        }
        .perfil-tab-pane.active {
            display: block;
        }
        .publicacion-item {
            padding: 1.5rem;
            background: white;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
            box-shadow: var(--shadow);
            border-left: 4px solid var(--primary-color);
        }
        .publicacion-item h4 {
            font-size: 1.1rem;
            margin-bottom: 0.75rem;
            color: var(--text-color);
            line-height: 1.4;
        }
        .publicacion-item p {
            color: var(--text-light);
            line-height: 1.7;
            margin-bottom: 0.5rem;
        }
        .publicacion-item a {
            color: var(--primary-color);
            text-decoration: none;
            font-size: 0.9rem;
        }
        .publicacion-item a:hover {
            text-decoration: underline;
        }
        .proyecto-item {
            padding: 1.5rem;
            background: white;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
            box-shadow: var(--shadow);
        }
        .proyecto-item h4 {
            font-size: 1.25rem;
            margin-bottom: 0.75rem;
            color: var(--text-color);
        }
        .proyecto-item p {
            color: var(--text-light);
            line-height: 1.7;
            margin-bottom: 1rem;
        }
        .proyecto-meta {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            padding-top: 1rem;
            border-top: 1px solid var(--border-color);
        }
        .proyecto-meta span {
            font-size: 0.875rem;
            color: var(--text-light);
        }
        .actividad-item {
            padding: 1.5rem;
            background: white;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
            box-shadow: var(--shadow);
        }
        .actividad-item h4 {
            font-size: 1.25rem;
            margin-bottom: 0.5rem;
            color: var(--text-color);
        }
        .actividad-item p {
            color: var(--text-light);
            line-height: 1.7;
        }
        @media (max-width: 768px) {
            .perfil-header {
                flex-direction: column;
                text-align: center;
            }
            .perfil-imagen {
                margin: 0 auto;
            }
            .perfil-tab-buttons {
                flex-direction: column;
            }
            .perfil-tab-button {
                width: 100%;
                text-align: left;
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
                <div class="mobile-menu-toggle">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
            </nav>
        </div>
    </header>

    <section class="perfil-container">
        <div class="perfil-header">
            <div class="perfil-imagen">
                <img src="', metadata$image, '" alt="', metadata$title, '">
            </div>
            <div class="perfil-info">
                <h1 class="perfil-nombre">', metadata$title, '</h1>
                <p class="perfil-cargo">', metadata$cargo, '</p>
                
                <div class="perfil-contacto">
                    <p><strong>Email:</strong> <a href="mailto:', metadata$email, '">', metadata$email, '</a></p>
                </div>

                <div class="perfil-enlaces">',
  if (!is.null(metadata$`pagina-personal`) && metadata$`pagina-personal` != "" && metadata$`pagina-personal` != "#") {
    paste0('<a href="', metadata$`pagina-personal`, '" class="perfil-enlace" target="_blank">
                        <span>📄</span> Página personal
                    </a>')
  } else "",
  if (!is.null(metadata$`google-scholar`) && metadata$`google-scholar` != "" && metadata$`google-scholar` != "#") {
    paste0('<a href="', metadata$`google-scholar`, '" class="perfil-enlace" target="_blank">
                        <span>🔬</span> Google Scholar
                    </a>')
  } else "",
'                </div>

                <div class="perfil-areas">
                    <h3>Áreas de interés:</h3>
                    <ul>',
  paste0('                        <li>', metadata$`areas-interes`, '</li>', collapse = "\n"),
'                    </ul>
                </div>
            </div>
        </div>

        <div class="perfil-descripcion">
            ', descripcion_html, '
        </div>

        ', if (has_publicaciones || has_proyectos || has_actividades) {
          paste0('<div class="perfil-tabs">
            <div class="perfil-tab-buttons">',
            if (has_publicaciones) '<button class="perfil-tab-button active" data-tab="publicaciones">Últimas Publicaciones</button>',
            if (has_proyectos) paste0('<button class="perfil-tab-button', if (!has_publicaciones) ' active', '" data-tab="proyectos">Proyectos en curso</button>'),
            if (has_actividades) paste0('<button class="perfil-tab-button', if (!has_publicaciones && !has_proyectos) ' active', '" data-tab="actividades">Otras actividades</button>'),
'            </div>

            <div class="perfil-tab-content">',
            if (has_publicaciones) paste0('<div class="perfil-tab-pane', if (has_publicaciones) ' active', '" id="publicaciones">
                    <div class="publicacion-item">
                        ', publicaciones_html, '
                    </div>
                </div>'),
            if (has_proyectos) paste0('<div class="perfil-tab-pane', if (!has_publicaciones) ' active', '" id="proyectos">
                    <div class="proyecto-item">
                        ', proyectos_html, '
                    </div>
                </div>'),
            if (has_actividades) paste0('<div class="perfil-tab-pane', if (!has_publicaciones && !has_proyectos) ' active', '" id="actividades">
                    <div class="actividad-item">
                        ', actividades_html, '
                    </div>
                </div>'),
'            </div>
        </div>')
        } else "",
'    </section>

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
                <div class="footer-section" id="contacto">
                    <h4>Contacto</h4>
                    <p>Email: observatorio@universidad.cl</p>
                    <p>Teléfono: +56 2 2676 8479</p>
                    <p>Dirección: Avenida Ejército #333, Santiago, Chile</p>
                </div>
                <div class="footer-section">
                    <h4>Investigación</h4>
                    <ul>
                        <li><a href="../index.html#proyectos">Proyectos</a></li>
                        <li><a href="#publicaciones">Publicaciones</a></li>
                        <li><a href="#tesis">Tesis y Prácticas</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 Observatorio de Legitimidad. Todos los derechos reservados.</p>
            </div>
        </div>
    </footer>

    <script>
        // Tabs functionality
        const perfilTabButtons = document.querySelectorAll(".perfil-tab-button");
        const perfilTabPanes = document.querySelectorAll(".perfil-tab-pane");

        perfilTabButtons.forEach(button => {
            button.addEventListener("click", () => {
                const targetTab = button.getAttribute("data-tab");
                
                // Remove active class from all buttons and panes
                perfilTabButtons.forEach(btn => btn.classList.remove("active"));
                perfilTabPanes.forEach(pane => pane.classList.remove("active"));
                
                // Add active class to clicked button and corresponding pane
                button.classList.add("active");
                document.getElementById(targetTab).classList.add("active");
            });
        });

        // Mobile menu
        const mobileMenuToggle = document.querySelector(".mobile-menu-toggle");
        const navMenu = document.querySelector(".nav-menu");

        if (mobileMenuToggle) {
            mobileMenuToggle.addEventListener("click", () => {
                navMenu.classList.toggle("active");
                
                const spans = mobileMenuToggle.querySelectorAll("span");
                if (navMenu.classList.contains("active")) {
                    spans[0].style.transform = "rotate(45deg) translateY(8px)";
                    spans[1].style.opacity = "0";
                    spans[2].style.transform = "rotate(-45deg) translateY(-8px)";
                } else {
                    spans[0].style.transform = "none";
                    spans[1].style.opacity = "1";
                    spans[2].style.transform = "none";
                }
            });
        }
    </script>
</body>
</html>')
  
  writeLines(html_template, output_file)
  cat("✓ Generado:", output_file, "\n")
}

# Procesar todos los QMD en content/equipo
qmd_files <- list.files("content/equipo", pattern = "\\.qmd$", full.names = TRUE)

cat("Generando perfiles HTML desde QMD...\n\n")
for (qmd_file in qmd_files) {
  if (basename(qmd_file) != "perfil-template.qmd") {
    tryCatch({
      generate_profile_html(qmd_file)
    }, error = function(e) {
      cat("✗ Error procesando", qmd_file, ":", e$message, "\n")
    })
  }
}

cat("\n✓ Proceso completado!\n")

# Generar índice del equipo automáticamente
cat("\n=== Generando índice del equipo ===\n")
system("Rscript scripts/generate-equipo-index.R")
