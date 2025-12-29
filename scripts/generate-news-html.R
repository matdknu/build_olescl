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
# Ahora trabaja con estructura de carpetas: content/noticias/NOMBRE-NOTICIA/index.qmd
generate_news_html <- function(noticia_carpeta) {
  # Buscar index.qmd en la carpeta
  qmd_file <- file.path(noticia_carpeta, "index.qmd")
  
  # Si no existe index.qmd, buscar cualquier .qmd en la carpeta
  if (!file.exists(qmd_file)) {
    qmd_files_in_carpeta <- list.files(noticia_carpeta, pattern = "\\.qmd$", full.names = TRUE)
    if (length(qmd_files_in_carpeta) > 0) {
      qmd_file <- qmd_files_in_carpeta[1]
    } else {
      cat("⚠️  No se encontró archivo .qmd en", noticia_carpeta, "\n")
      return(NULL)
    }
  }
  
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
  
  # Obtener el nombre de la carpeta (nombre de la noticia)
  nombre_noticia <- basename(noticia_carpeta)
  
  # Generar ruta de salida: noticias/NOMBRE-NOTICIA.html (archivo directo, no carpeta)
  output_dir <- "noticias"
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  output_file <- file.path(output_dir, paste0(nombre_noticia, ".html"))
  
  # Convertir markdown a HTML
  html_content <- markdown_to_html(md_content)
  
  # Determinar tipo
  tags <- metadata$tags %||% ""
  # Convertir tags a string si es un vector
  tags_str <- if (is.character(tags) && length(tags) > 1) {
    paste(tags, collapse = " ")
  } else if (is.character(tags)) {
    as.character(tags)
  } else {
    ""
  }
  tipo <- if (grepl("\\[Evento\\]|Evento", tags_str, ignore.case = TRUE)) {
    "Evento"
  } else {
    "Noticia"
  }
  
  # Calcular ruta relativa desde noticias/ hacia la raíz
  # Desde noticias/ necesitamos subir 1 nivel
  rel_path_base <- "../"
  
  # Generar HTML completo
  html_template <- paste0('<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#ffffff">
    <meta name="apple-mobile-web-app-status-bar-style" content="default">
    <meta name="msapplication-navbutton-color" content="#ffffff">
    <title>', metadata$title, ' - Observatorio de Legitimidad</title>
    <link rel="icon" type="image/png" href="', rel_path_base, 'logos/icon.png">
    <link rel="stylesheet" href="', rel_path_base, 'style.css">
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
                <a href="', rel_path_base, 'index.html" style="display: flex; align-items: center; text-decoration: none;">
                    <img src="', rel_path_base, 'logos/logo.png" alt="Observatorio de Legitimidad" style="height: 70px; width: auto; object-fit: contain; filter: brightness(1.1);">
                </a>
            </div>
            <nav class="nav">
                <ul class="nav-menu">
                    <li><a href="', rel_path_base, 'index.html#inicio">Inicio</a></li>
                    <li class="dropdown">
                        <a href="', rel_path_base, 'index.html#nosotros" class="dropdown-toggle">Acerca del Observatorio <span class="arrow">▼</span></a>
                        <ul class="dropdown-menu">
                            <li><a href="', rel_path_base, 'index.html#mision">Misión</a></li>
                            <li><a href="', rel_path_base, 'index.html#equipo">Equipo</a></li>
                        </ul>
                    </li>
                    <li class="dropdown">
                        <a href="', rel_path_base, 'index.html#proyectos" class="dropdown-toggle">Investigación <span class="arrow">▼</span></a>
                        <ul class="dropdown-menu">
                            <li><a href="', rel_path_base, 'index.html#proyectos">Proyectos</a></li>
                            <li><a href="', rel_path_base, 'publicaciones/index.html">Publicaciones</a></li>
                            <li><a href="', rel_path_base, 'index.html#tesis">Tesis y Prácticas</a></li>
                        </ul>
                    </li>
                    <li><a href="', if (grepl("/\\d{4}/", output_file)) "../" else "", 'index.html">Noticias</a></li>
                    <li class="dropdown">
                        <a href="', rel_path_base, 'index.html#biblioteca" class="dropdown-toggle">Biblioteca <span class="arrow">▼</span></a>
                        <ul class="dropdown-menu">
                            <li><a href="', rel_path_base, 'index.html#videos">Videos</a></li>
                            <li><a href="', rel_path_base, 'index.html#entrevistas">Entrevistas</a></li>
                        </ul>
                    </li>
                    <li><a href="', rel_path_base, 'index.html#blog">Blog</a></li>
                    <li><a href="', rel_path_base, 'index.html#contacto">Contacto</a></li>
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
            <a href="', rel_path_base, 'noticias/index.html" class="volver-link">← Volver a Noticias</a>
            
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
                        <li><a href="', rel_path_base, 'index.html#inicio">Inicio</a></li>
                        <li><a href="', rel_path_base, 'noticias/index.html">Noticias</a></li>
                        <li><a href="', rel_path_base, 'index.html#proyectos">Proyectos</a></li>
                        <li><a href="', rel_path_base, 'index.html#nosotros">Nosotros</a></li>
                        <li><a href="', rel_path_base, 'index.html#contacto">Contacto</a></li>
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
                        <li><a href="', rel_path_base, 'index.html#proyectos">Proyectos</a></li>
                        <li><a href="', rel_path_base, 'publicaciones/index.html">Publicaciones</a></li>
                        <li><a href="', rel_path_base, 'index.html#tesis">Tesis y Prácticas</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 Observatorio de Legitimidad. Todos los derechos reservados.</p>
            </div>
        </div>
    </footer>

    <script src="', rel_path_base, 'script.js"></script>
</body>
</html>')
  
  writeLines(html_template, output_file)
  cat("✓ Generado:", output_file, "\n")
}

# Procesar todas las carpetas de noticias en content/noticias/
# Estructura nueva: content/noticias/NOMBRE-NOTICIA/index.qmd
noticias_dir <- "content/noticias"
carpetas_noticias <- list.dirs(noticias_dir, recursive = FALSE)
# Filtrar solo carpetas que no sean archivos especiales
carpetas_noticias <- carpetas_noticias[!grepl("ejemplo|template|_site|site_libs", basename(carpetas_noticias), ignore.case = TRUE)]

cat("Generando HTMLs de noticias desde carpetas...\n\n")
for (carpeta in carpetas_noticias) {
  # Verificar que la carpeta tenga un archivo .qmd
  qmd_files <- list.files(carpeta, pattern = "\\.qmd$", full.names = TRUE)
  if (length(qmd_files) > 0) {
    tryCatch({
      generate_news_html(carpeta)
    }, error = function(e) {
      cat("✗ Error procesando", carpeta, ":", e$message, "\n")
    })
  }
}

cat("\n✓ Proceso completado!\n")

