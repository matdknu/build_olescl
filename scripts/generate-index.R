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

# Generar índice de eventos
generate_eventos_index <- function() {
  qmd_files <- list.files("content/eventos", pattern = "\\.qmd$", full.names = TRUE)
  
  eventos <- map(qmd_files, function(file) {
    meta <- read_qmd_metadata(file)
    if (!is.null(meta)) {
      list(
        title = meta$title %||% "Sin título",
        date = meta$date %||% "",
        hora = meta$hora %||% "",
        lugar = meta$lugar %||% "",
        tipo = meta$tipo %||% "Evento",
        image = meta$image %||% "",
        file = basename(file)
      )
    }
  }) %>% compact()
  
  # Ordenar por fecha (más recientes primero)
  eventos <- eventos[order(sapply(eventos, function(x) x$date), decreasing = TRUE)]
  
  # Generar HTML
  html <- c(
    '<div class="agenda-grid">',
    map_chr(eventos, function(evento) {
      sprintf(
        '<article class="agenda-item">
          <div class="agenda-fecha">
            <div class="agenda-dia">%s</div>
            <div class="agenda-mes">%s</div>
          </div>
          <div class="agenda-content">
            <h3><a href="content/eventos/%s">%s</a></h3>
            <p class="agenda-lugar">%s</p>
            <p class="agenda-hora">%s</p>
          </div>
        </article>',
        strsplit(evento$date, " ")[[1]][1],  # día
        tolower(strsplit(evento$date, " ")[[1]][2]),  # mes
        gsub("\\.qmd$", ".html", evento$file),
        evento$title,
        evento$lugar,
        evento$hora
      )
    }),
    '</div>'
  )
  
  writeLines(html, "content/eventos/index-generated.html")
  cat("✓ Índice de eventos generado\n")
}

# Generar índice de proyectos
generate_proyectos_index <- function() {
  qmd_files <- list.files("content/proyectos", pattern = "\\.qmd$", full.names = TRUE)
  
  proyectos <- map(qmd_files, function(file) {
    meta <- read_qmd_metadata(file)
    if (!is.null(meta)) {
      list(
        title = meta$title %||% "Sin título",
        tipo = meta$tipo %||% "",
        estado = meta$estado %||% "",
        fecha_inicio = meta$`fecha-inicio` %||% "",
        fecha_fin = meta$`fecha-fin` %||% "",
        file = basename(file)
      )
    }
  }) %>% compact()
  
  # Generar HTML
  html <- c(
    '<div class="proyectos-grid">',
    map_chr(proyectos, function(proyecto) {
      sprintf(
        '<div class="proyecto-card">
          <h3><a href="content/proyectos/%s">%s</a></h3>
          <p>Tipo: %s</p>
          <div class="proyecto-meta">
            <span class="proyecto-estado estado-%s">%s</span>
            <span class="proyecto-fecha">%s - %s</span>
          </div>
        </div>',
        gsub("\\.qmd$", ".html", proyecto$file),
        proyecto$title,
        proyecto$tipo,
        tolower(gsub(" ", "-", proyecto$estado)),
        proyecto$estado,
        proyecto$fecha_inicio,
        proyecto$fecha_fin
      )
    }),
    '</div>'
  )
  
  writeLines(html, "content/proyectos/index-generated.html")
  cat("✓ Índice de proyectos generado\n")
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
generate_eventos_index()
generate_proyectos_index()
cat("\n✓ Todos los índices generados!\n")

