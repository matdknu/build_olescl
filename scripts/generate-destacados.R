#!/usr/bin/env Rscript
# Script para generar content/destacados-generated.html
# Solo incluye 1 noticia destacada (la más reciente)

library(yaml)
library(lubridate)

cat("=== Generando destacados (máximo 3) ===\n\n")

noticias_dir <- "content/noticias"
# Buscar carpetas de noticias (estructura nueva: content/noticias/NOMBRE-NOTICIA/)
carpetas_noticias <- list.dirs(noticias_dir, recursive = FALSE)
carpetas_noticias <- carpetas_noticias[!grepl("ejemplo|template|_site|site_libs", basename(carpetas_noticias), ignore.case = TRUE)]

destacados_data <- list()

for (carpeta in carpetas_noticias) {
  # Buscar index.qmd en la carpeta
  qmd_file <- file.path(carpeta, "index.qmd")
  
  # Si no existe index.qmd, buscar cualquier .qmd en la carpeta
  if (!file.exists(qmd_file)) {
    qmd_files_in_carpeta <- list.files(carpeta, pattern = "\\.qmd$", full.names = TRUE)
    if (length(qmd_files_in_carpeta) > 0) {
      qmd_file <- qmd_files_in_carpeta[1]
    } else {
      next
    }
  }
  
  content <- readLines(qmd_file, warn = FALSE, encoding = "UTF-8")
  
  yaml_start <- which(grepl("^---$", content))[1]
  yaml_end <- which(grepl("^---$", content))[2]
  
  if (is.na(yaml_start) || is.na(yaml_end)) next
  
  yaml_content <- paste(content[(yaml_start+1):(yaml_end-1)], collapse = "\n")
  metadata <- yaml.load(yaml_content)
  
  # Solo incluir noticias destacadas
  if (!(metadata$destacado %||% FALSE)) next
  
  # Extraer fecha
  date_str <- metadata$date
  fecha <- tryCatch({
    if (grepl("\\d{4}-\\d{2}-\\d{2}", date_str)) {
      as.Date(date_str)
    } else {
      parts <- strsplit(date_str, "\\s+")[[1]]
      if (length(parts) == 3) {
        day <- as.numeric(parts[1])
        year <- as.numeric(parts[3])
        month_name <- tolower(parts[2])
        meses <- c("enero"=1, "febrero"=2, "marzo"=3, "abril"=4, "mayo"=5, "junio"=6, 
                   "julio"=7, "agosto"=8, "septiembre"=9, "octubre"=10, "noviembre"=11, "diciembre"=12)
        month <- meses[month_name]
        if (is.na(month)) {
          as.Date(parse_date_time(date_str, orders = c("dmy", "d B Y"), locale = "es_ES.UTF-8"))
        } else {
          as.Date(paste(year, month, day, sep="-"))
        }
      } else {
        as.Date(date_str)
      }
    }
  }, error = function(e) NA)
  
  if (is.na(fecha)) next
  
  # Calcular ruta del HTML (nueva estructura: noticias/NOMBRE-NOTICIA.html)
  nombre_noticia <- basename(carpeta)
  url <- paste0("noticias/", nombre_noticia, ".html")

  # Ajustar ruta de imagen si es relativa
  image_url <- metadata$image
  if (grepl("^\\.\\./", image_url)) {
    # Si la imagen está en ../MDKN.png desde content/noticias/2025/12/
    # La ruta correcta desde index.html es content/noticias/2025/MDKN.png
    clean_image <- gsub("^\\.\\./", "", image_url)
    parent_path <- dirname(rel_path)
    # Construir ruta relativa desde la raíz del proyecto
    image_url <- file.path("content", "noticias", basename(parent_path), clean_image)
  }

  destacados_data[[length(destacados_data) + 1]] <- list(
    title = metadata$title,
    date = metadata$date,
    fecha_obj = fecha,
    image = image_url,
    tipo = if (grepl("\\[Evento\\]", paste(metadata$tags, collapse=" "), ignore.case = TRUE)) "evento" else "noticia",
    url = url
  )
}

# Ordenar por fecha (descendente) y tomar máximo 3 (las más recientes)
if (length(destacados_data) > 0) {
  destacados_data <- destacados_data[order(sapply(destacados_data, function(x) x$fecha_obj), decreasing = TRUE)]
  destacados_data <- destacados_data[1:min(3, length(destacados_data))]  # Máximo 3 destacados
  
  # Generar HTML
  destacados_html <- '<div class="destacados-grid">\n'
  for (d in destacados_data) {
    destacados_html <- paste0(destacados_html,
      '<article class="destacado-card ', d$tipo, '">\n',
      '          <a href="', d$url, '" style="text-decoration: none; color: inherit; display: block;">\n',
      '            <div class="destacado-imagen">\n',
      '              <img src="', d$image, '" alt="', d$title, '">\n',
      '            </div>\n',
      '            <div class="destacado-tipo">', ifelse(d$tipo == "evento", "Evento", "Noticia"), '</div>\n',
      '            <h3>', d$title, '</h3>\n',
      '            <div class="destacado-fecha">', d$date, '</div>\n',
      '          </a>\n',
      '        </article>\n')
  }
  destacados_html <- paste0(destacados_html, '</div>')
  
  writeLines(destacados_html, "content/destacados-generated.html")
  cat("✓ Generado: content/destacados-generated.html\n")
  cat("✓ Total de destacados:", length(destacados_data), "\n\n")
} else {
  cat("⚠️  No se encontraron noticias destacadas\n")
  # Crear archivo vacío
  writeLines('<div class="destacados-grid"></div>', "content/destacados-generated.html")
}

