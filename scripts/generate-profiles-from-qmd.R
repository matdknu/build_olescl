#!/usr/bin/env Rscript
# Script para generar perfiles HTML desde archivos QMD

library(yaml)
library(rmarkdown)

# Función para convertir markdown a HTML básico
markdown_to_html <- function(md_text) {
  # Convertir markdown básico a HTML
  md_text <- gsub("^## (.+)$", "<h2>\\1</h2>", md_text, perl = TRUE)
  md_text <- gsub("^### (.+)$", "<h3>\\1</h3>", md_text, perl = TRUE)
  md_text <- gsub("^\\*\\* (.+)$", "<strong>\\1</strong>", md_text, perl = TRUE)
  md_text <- gsub("^\\- (.+)$", "<li>\\1</li>", md_text, perl = TRUE)
  md_text <- gsub("\\[([^\\]]+)\\]\\(([^)]+)\\)", "<a href=\"\\2\">\\1</a>", md_text, perl = TRUE)
  md_text <- gsub("\n\n", "</p><p>", md_text)
  md_text <- paste0("<p>", md_text, "</p>")
  return(md_text)
}

# Función para generar HTML de perfil
generate_profile_html <- function(qmd_file) {
  # Leer el archivo QMD
  content <- readLines(qmd_file, warn = FALSE)
  
  # Separar YAML y contenido
  yaml_start <- which(grepl("^---$", content))[1]
  yaml_end <- which(grepl("^---$", content))[2]
  
  if (is.na(yaml_start) || is.na(yaml_end)) {
    cat("Error: No se encontró YAML en", qmd_file, "\n")
    return(NULL)
  }
  
  yaml_content <- paste(content[(yaml_start+1):(yaml_end-1)], collapse = "\n")
  md_content <- paste(content[(yaml_end+1):length(content)], collapse = "\n")
  
  # Parsear YAML
  metadata <- yaml.load(yaml_content)
  
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
  
  # Convertir markdown a HTML básico
  html_content <- md_content
  # Convertir encabezados
  html_content <- gsub("^## (.+)$", "<h2>\\1</h2>", html_content, perl = TRUE, useBytes = TRUE)
  html_content <- gsub("^### (.+)$", "<h3>\\1</h3>", html_content, perl = TRUE, useBytes = TRUE)
  # Convertir negritas
  html_content <- gsub("\\*\\*([^*]+)\\*\\*", "<strong>\\1</strong>", html_content, perl = TRUE)
  # Convertir listas
  html_content <- gsub("^\\- (.+)$", "<li>\\1</li>", html_content, perl = TRUE, useBytes = TRUE)
  # Convertir enlaces
  html_content <- gsub("\\[([^\\]]+)\\]\\(([^)]+)\\)", "<a href=\"\\2\">\\1</a>", html_content, perl = TRUE)
  # Convertir párrafos (líneas que no son encabezados ni listas)
  lines <- strsplit(html_content, "\n")[[1]]
  html_lines <- character()
  in_list <- FALSE
  for (line in lines) {
    if (grepl("^<h[23]>", line) || grepl("^<li>", line)) {
      if (in_list && !grepl("^<li>", line)) {
        html_lines <- c(html_lines, "</ul>")
        in_list <- FALSE
      }
      if (grepl("^<li>", line) && !in_list) {
        html_lines <- c(html_lines, "<ul>")
        in_list <- TRUE
      }
      html_lines <- c(html_lines, line)
    } else if (nchar(trimws(line)) > 0) {
      if (in_list) {
        html_lines <- c(html_lines, "</ul>")
        in_list <- FALSE
      }
      html_lines <- c(html_lines, paste0("<p>", line, "</p>"))
    }
  }
  if (in_list) {
    html_lines <- c(html_lines, "</ul>")
  }
  html_content <- paste(html_lines, collapse = "\n")
  
  # Generar HTML completo
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
            margin-bottom: 1.5rem;
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
        .perfil-descripcion h2 {
            font-size: 1.75rem;
            margin-top: 2rem;
            margin-bottom: 1rem;
            color: var(--text-color);
        }
        .perfil-descripcion h3 {
            font-size: 1.5rem;
            margin-top: 1.5rem;
            margin-bottom: 0.75rem;
            color: var(--text-color);
        }
        .perfil-descripcion ul {
            margin-left: 1.5rem;
            margin-bottom: 1rem;
        }
        .perfil-descripcion li {
            margin-bottom: 0.5rem;
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
                <img src="', metadata$image, '" alt="', metadata$title, '">
            </div>
            <div class="perfil-info">
                <h1 class="perfil-nombre">', metadata$title, '</h1>
                <p class="perfil-cargo">', metadata$cargo, '</p>
                
                <div class="perfil-contacto">
                    <p><strong>Email:</strong> <a href="mailto:', metadata$email, '">', metadata$email, '</a></p>
                </div>

                <div class="perfil-enlaces">',
  if (!is.null(metadata$`pagina-personal`) && metadata$`pagina-personal` != "") {
    paste0('<a href="', metadata$`pagina-personal`, '" class="perfil-enlace" target="_blank">
                        <span>📄</span> Página personal
                    </a>')
  } else "",
  if (!is.null(metadata$`google-scholar`) && metadata$`google-scholar` != "") {
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
            ', html_content, '
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
</html>')
  
  # Escribir archivo
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

