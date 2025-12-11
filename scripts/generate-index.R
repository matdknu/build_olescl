#!/usr/bin/env Rscript
# Script para generar índices automáticos de noticias, publicaciones y equipo

library(quarto)
library(yaml)
library(purrr)

# Función para leer metadata de archivos QMD
read_qmd_metadata <- function(qmd_file) {
  lines <- readLines(qmd_file)
  yaml_start <- which(lines == "---")[1]
  yaml_end <- which(lines == "---")[2]
  
  if (is.na(yaml_start) || is.na(yaml_end)) {
    return(NULL)
  }
  
  yaml_content <- paste(lines[(yaml_start+1):(yaml_end-1)], collapse = "\n")
  yaml::yaml.load(yaml_content)
}

# Generar índice de noticias
generate_noticias_index <- function() {
  qmd_files <- list.files("content/noticias", pattern = "\\.qmd$", full.names = TRUE)
  
  noticias <- map(qmd_files, function(file) {
    meta <- read_qmd_metadata(file)
    if (!is.null(meta)) {
      list(
        title = meta$title %||% "Sin título",
        date = meta$date %||% "",
        image = meta$image %||% "",
        file = basename(file)
      )
    }
  }) %>% compact()
  
  # Ordenar por fecha (más recientes primero)
  noticias <- noticias[order(sapply(noticias, function(x) x$date), decreasing = TRUE)]
  
  # Generar HTML
  html <- c(
    '<div class="noticias-grid">',
    map_chr(noticias, function(noticia) {
      sprintf(
        '<article class="noticia-card">
          <div class="noticia-imagen">
            <img src="%s" alt="%s">
          </div>
          <div class="noticia-fecha">%s</div>
          <h3><a href="content/noticias/%s">%s</a></h3>
        </article>',
        noticia$image,
        noticia$title,
        noticia$date,
        gsub("\\.qmd$", ".html", noticia$file),
        noticia$title
      )
    }),
    '</div>'
  )
  
  writeLines(html, "content/noticias/index-generated.html")
  cat("✓ Índice de noticias generado\n")
}

# Generar índice de publicaciones
generate_publicaciones_index <- function() {
  qmd_files <- list.files("content/publicaciones", pattern = "\\.qmd$", full.names = TRUE)
  
  publicaciones <- map(qmd_files, function(file) {
    meta <- read_qmd_metadata(file)
    if (!is.null(meta)) {
      list(
        title = meta$title %||% "Sin título",
        authors = paste(meta$authors %||% "", collapse = ", "),
        journal = meta$journal %||% "",
        year = meta$date %||% "",
        file = basename(file)
      )
    }
  }) %>% compact()
  
  # Ordenar por año (más recientes primero)
  publicaciones <- publicaciones[order(sapply(publicaciones, function(x) x$year), decreasing = TRUE)]
  
  # Generar HTML
  html <- c(
    '<div class="publicaciones-grid">',
    map_chr(publicaciones, function(pub) {
      sprintf(
        '<div class="publicacion-item">
          <h4><a href="content/publicaciones/%s">%s</a></h4>
          <p><strong>Autores:</strong> %s</p>
          <p><em>%s</em> (%s)</p>
        </div>',
        gsub("\\.qmd$", ".html", pub$file),
        pub$title,
        pub$authors,
        pub$journal,
        pub$year
      )
    }),
    '</div>'
  )
  
  writeLines(html, "content/publicaciones/index-generated.html")
  cat("✓ Índice de publicaciones generado\n")
}

# Generar índice de equipo
generate_equipo_index <- function() {
  qmd_files <- list.files("content/equipo", pattern = "\\.qmd$", full.names = TRUE)
  
  equipo <- map(qmd_files, function(file) {
    meta <- read_qmd_metadata(file)
    if (!is.null(meta)) {
      list(
        name = meta$title %||% "Sin nombre",
        cargo = meta$cargo %||% "",
        image = meta$image %||% "",
        file = basename(file)
      )
    }
  }) %>% compact()
  
  # Generar HTML
  html <- c(
    '<div class="equipo-grid">',
    map_chr(equipo, function(persona) {
      sprintf(
        '<a href="content/equipo/%s" class="equipo-card" style="text-decoration: none; color: inherit;">
          <div class="equipo-avatar">
            <img src="%s" alt="%s" style="width: 100%%; height: 100%%; object-fit: cover; border-radius: 50%%;">
          </div>
          <h4>%s</h4>
          <p>%s</p>
        </a>',
        gsub("\\.qmd$", ".html", persona$file),
        persona$image,
        persona$name,
        persona$name,
        persona$cargo
      )
    }),
    '</div>'
  )
  
  writeLines(html, "content/equipo/index-generated.html")
  cat("✓ Índice de equipo generado\n")
}

# Ejecutar generación
cat("=== Generando índices ===\n")
generate_noticias_index()
generate_publicaciones_index()
generate_equipo_index()
cat("\n✓ Todos los índices generados!\n")

