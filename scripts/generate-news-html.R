#!/usr/bin/env Rscript
# Script para generar HTMLs simples y limpios para noticias desde QMD

library(yaml)
library(rmarkdown)

# Función para convertir markdown a HTML
markdown_to_html <- function(md_text) {
  if (nchar(trimws(md_text)) == 0) return("")
  
  # Procesar línea por línea
  lines <- strsplit(md_text, "\n")[[1]]
  html_lines <- character()
  in_list <- FALSE
  in_paragraph <- FALSE
  
  for (line in lines) {
    trimmed <- trimws(line)
    
    # Detectar encabezados
    if (grepl("^## ", trimmed)) {
      if (in_paragraph) {
        html_lines <- c(html_lines, "</p>")
        in_paragraph <- FALSE
      }
      if (in_list) {
        html_lines <- c(html_lines, "</ul>")
        in_list <- FALSE
      }
      texto <- gsub("^## ", "", trimmed)
      html_lines <- c(html_lines, paste0("<h2>", texto, "</h2>"))
    } else if (grepl("^### ", trimmed)) {
      if (in_paragraph) {
        html_lines <- c(html_lines, "</p>")
        in_paragraph <- FALSE
      }
      if (in_list) {
        html_lines <- c(html_lines, "</ul>")
        in_list <- FALSE
      }
      texto <- gsub("^### ", "", trimmed)
      html_lines <- c(html_lines, paste0("<h3>", texto, "</h3>"))
    } else if (grepl("^\\- ", trimmed)) {
      # Lista
      if (in_paragraph) {
        html_lines <- c(html_lines, "</p>")
        in_paragraph <- FALSE
      }
      if (!in_list) {
        html_lines <- c(html_lines, "<ul>")
        in_list <- TRUE
      }
      texto <- gsub("^\\- ", "", trimmed)
      # Procesar negritas y cursivas en el item
      texto <- gsub("\\*\\*([^*]+)\\*\\*", "<strong>\\1</strong>", texto, perl = TRUE)
      texto <- gsub("_([^_]+)_", "<em>\\1</em>", texto, perl = TRUE)
      html_lines <- c(html_lines, paste0("<li>", texto, "</li>"))
    } else if (nchar(trimmed) > 0) {
      # Párrafo normal
      if (in_list) {
        html_lines <- c(html_lines, "</ul>")
        in_list <- FALSE
      }
      if (!in_paragraph) {
        html_lines <- c(html_lines, "<p>")
        in_paragraph <- TRUE
      }
      # Procesar negritas, cursivas y enlaces
      texto <- trimmed
      texto <- gsub("\\*\\*([^*]+)\\*\\*", "<strong>\\1</strong>", texto, perl = TRUE)
      texto <- gsub("_([^_]+)_", "<em>\\1</em>", texto, perl = TRUE)
      texto <- gsub("\\[([^\\]]+)\\]\\(([^)]+)\\)", "<a href=\"\\2\" target=\"_blank\" style=\"color: var(--primary-color); text-decoration: none;\">\\1</a>", texto, perl = TRUE)
      html_lines <- c(html_lines, texto)
    } else {
      # Línea vacía - cerrar párrafo o lista
      if (in_paragraph) {
        html_lines <- c(html_lines, "</p>")
        in_paragraph <- FALSE
      }
      if (in_list) {
        html_lines <- c(html_lines, "</ul>")
        in_list <- FALSE
      }
    }
  }
  
  # Cerrar elementos abiertos
  if (in_list) html_lines <- c(html_lines, "</ul>")
  if (in_paragraph) html_lines <- c(html_lines, "</p>")
  
  return(paste(html_lines, collapse = "\n"))
}

# Función para generar HTML de noticia
generate_news_html <- function(qmd_file) {
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
  
  # Generar nombre de archivo
  name_slug <- gsub("\\.qmd$", "", basename(qmd_file))
  output_file <- paste0("noticias/", name_slug, ".html")
  
  # Convertir markdown a HTML
  html_content <- markdown_to_html(md_content)
  
  # Determinar tipo
  tags <- metadata$tags %||% ""
  tipo <- if (grepl("\\[Evento\\]", tags, ignore.case = TRUE)) {
    "Evento"
  } else {
    "Noticia"
  }
  
  # Generar HTML completo
  html_template <- paste0('<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>', metadata$title, ' - Observatorio de Legitimidad</title>
    <link rel="icon" type="image/png" href="../logos/icon.png">
    <link rel="stylesheet" href="../style.css">
    <style>
        .noticia-detalle {
            max-width: 900px;
            margin: 0 auto;
            padding: 2rem 20px;
        }
        .noticia-header {
            margin-bottom: 2rem;
            padding-bottom: 2rem;
            border-bottom: 2px solid var(--border-color);
        }
        .noticia-tipo {
            display: inline-block;
            padding: 0.5rem 1rem;
            background: var(--primary-color);
            color: white;
            border-radius: 0.25rem;
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }
        .noticia-titulo {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: var(--text-color);
            line-height: 1.3;
        }
        .noticia-meta {
            display: flex;
            gap: 2rem;
            flex-wrap: wrap;
            color: var(--text-light);
            font-size: 0.9rem;
            margin-top: 1rem;
        }
        .noticia-imagen-principal {
            width: 100%;
            max-height: 500px;
            object-fit: cover;
            border-radius: 0.5rem;
            margin: 2rem 0;
            box-shadow: var(--shadow-lg);
        }
        .noticia-contenido {
            line-height: 1.8;
            color: var(--text-color);
            font-size: 1.1rem;
        }
        .noticia-contenido h2 {
            font-size: 2rem;
            margin-top: 2.5rem;
            margin-bottom: 1rem;
            color: var(--primary-color);
        }
        .noticia-contenido h3 {
            font-size: 1.5rem;
            margin-top: 2rem;
            margin-bottom: 0.75rem;
            color: var(--text-color);
        }
        .noticia-contenido p {
            margin-bottom: 1.5rem;
        }
        .noticia-contenido ul {
            margin-left: 2rem;
            margin-bottom: 1.5rem;
        }
        .noticia-contenido li {
            margin-bottom: 0.75rem;
        }
        .noticia-contenido a {
            color: var(--primary-color);
            text-decoration: none;
        }
        .noticia-contenido a:hover {
            text-decoration: underline;
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
                <a href="../index.html" style="display: flex; align-items: center; gap: 0.75rem; text-decoration: none; color: white;">
                    <img src="../logos/logo.png" alt="Observatorio de Legitimidad" style="height: 45px; width: auto; object-fit: contain; filter: brightness(1.1);">
                    <h1 style="margin: 0; font-size: 1.5rem; font-weight: 600;">Observatorio de Legitimidad</h1>
                </a>
            </div>
            <nav class="nav">
                <ul class="nav-menu">
                    <li><a href="../index.html#inicio">Inicio</a></li>
                    <li class="dropdown">
                        <a href="../index.html#nosotros" class="dropdown-toggle">Acerca del Observatorio <span class="arrow">▼</span></a>
                        <ul class="dropdown-menu">
                            <li><a href="../index.html#mision">Misión</a></li>
                            <li><a href="../index.html#equipo">Equipo</a></li>
                        </ul>
                    </li>
                    <li class="dropdown">
                        <a href="../index.html#proyectos" class="dropdown-toggle">Investigación <span class="arrow">▼</span></a>
                        <ul class="dropdown-menu">
                            <li><a href="../index.html#proyectos">Proyectos</a></li>
                            <li><a href="../publicaciones/index.html">Publicaciones</a></li>
                            <li><a href="../index.html#tesis">Tesis y Prácticas</a></li>
                        </ul>
                    </li>
                    <li><a href="index.html">Noticias</a></li>
                    <li class="dropdown">
                        <a href="../index.html#biblioteca" class="dropdown-toggle">Biblioteca <span class="arrow">▼</span></a>
                        <ul class="dropdown-menu">
                            <li><a href="../index.html#videos">Videos</a></li>
                            <li><a href="../index.html#entrevistas">Entrevistas</a></li>
                        </ul>
                    </li>
                    <li><a href="../index.html#blog">Blog</a></li>
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

    <section class="noticia-detalle" style="padding-top: 4rem;">
        <div class="container">
            <a href="index.html" class="volver-link">← Volver a Noticias</a>
            
            <div class="noticia-header">
                <span class="noticia-tipo">', tipo, '</span>
                <h1 class="noticia-titulo">', metadata$title, '</h1>
                <div class="noticia-meta">
                    <span><strong>Fecha:</strong> ', metadata$date, '</span>
                    <span><strong>Autor:</strong> ', metadata$author %||% "Equipo OLES", '</span>
                </div>
            </div>
            
            <img src="', metadata$image, '" alt="', metadata$title, '" class="noticia-imagen-principal">
            
            <div class="noticia-contenido">
                ', html_content, '
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
                        <li><a href="index.html">Noticias</a></li>
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
                        <li><a href="../publicaciones/index.html">Publicaciones</a></li>
                        <li><a href="../index.html#tesis">Tesis y Prácticas</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 Observatorio de Legitimidad. Todos los derechos reservados.</p>
            </div>
        </div>
    </footer>

    <script src="../script.js"></script>
</body>
</html>')
  
  writeLines(html_template, output_file)
  cat("✓ Generado:", output_file, "\n")
}

# Procesar todos los QMD en content/noticias
qmd_files <- list.files("content/noticias", pattern = "\\.qmd$", full.names = TRUE)

cat("Generando HTMLs de noticias...\n\n")
for (qmd_file in qmd_files) {
  if (!grepl("ejemplo|template", basename(qmd_file), ignore.case = TRUE)) {
    tryCatch({
      generate_news_html(qmd_file)
    }, error = function(e) {
      cat("✗ Error procesando", qmd_file, ":", e$message, "\n")
    })
  }
}

cat("\n✓ Proceso completado!\n")

