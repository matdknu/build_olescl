#!/usr/bin/env Rscript
# Script para generar content/noticias/recientes-generated.html
# Incluye las últimas noticias que NO son destacadas

library(yaml)
library(lubridate)

cat("=== Generando noticias recientes (no destacadas) ===\n\n")

noticias_dir <- "content/noticias"
# Buscar carpetas de noticias (estructura nueva: content/noticias/NOMBRE-NOTICIA/)
carpetas_noticias <- list.dirs(noticias_dir, recursive = FALSE)
carpetas_noticias <- carpetas_noticias[!grepl("ejemplo|template|_site|site_libs", basename(carpetas_noticias), ignore.case = TRUE)]

noticias_data <- list()

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
  
  # Solo incluir noticias NO destacadas
  if (metadata$destacado %||% FALSE) next
  
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

  noticias_data[[length(noticias_data) + 1]] <- list(
    title = metadata$title,
    date = metadata$date,
    fecha_obj = fecha,
    image = metadata$image,
    url = url
  )
}

# Ordenar por fecha (descendente) y tomar solo 4 (las más recientes)
noticias_data <- noticias_data[order(sapply(noticias_data, function(x) x$fecha_obj), decreasing = TRUE)]
noticias_data <- noticias_data[1:min(4, length(noticias_data))]  # Solo 4 noticias en el index

# Generar HTML (sin el div wrapper, el contenedor ya lo tiene)
recientes_html <- ''
for (n in noticias_data) {
  recientes_html <- paste0(recientes_html,
    '<article class="noticia-card">\n',
    '          <div class="noticia-imagen">\n',
    '            <img src="', n$image, '" alt="', n$title, '">\n',
    '          </div>\n',
    '          <div class="noticia-fecha">', n$date, '</div>\n',
    '          <h3><a href="', n$url, '" style="text-decoration: none; color: inherit;">', n$title, '</a></h3>\n',
    '        </article>\n')
}

writeLines(recientes_html, "content/noticias/recientes-generated.html")
cat("✓ Generado: content/noticias/recientes-generated.html\n")
cat("✓ Total de noticias recientes (no destacadas):", length(noticias_data), "\n\n")

