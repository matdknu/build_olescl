#!/usr/bin/env Rscript
# Script para generar content/noticias/recientes-generated.html
# Incluye las últimas noticias que NO son destacadas

library(yaml)
library(lubridate)

cat("=== Generando noticias recientes (no destacadas) ===\n\n")

noticias_dir <- "content/noticias"
qmd_files <- list.files(noticias_dir, pattern = "\\.qmd$", recursive = TRUE, full.names = TRUE)
qmd_files <- qmd_files[!grepl("ejemplo|template", basename(qmd_files), ignore.case = TRUE)]

noticias_data <- list()

for (qmd_file in qmd_files) {
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
  
  # Calcular ruta del HTML
  name_slug <- gsub("\\.qmd$", "", basename(qmd_file))
  rel_path <- dirname(qmd_file)
  
  if (grepl("content/noticias/\\d{4}/\\d{2}", rel_path)) {
    path_parts <- strsplit(rel_path, "/")[[1]]
    year_idx <- which(grepl("^\\d{4}$", path_parts))
    year <- path_parts[year_idx[1]]
    month <- path_parts[year_idx[1] + 1]
    url <- paste0("noticias/", year, "/", month, "/", name_slug, ".html")
  } else if (grepl("content/noticias/\\d{4}", rel_path)) {
    year <- regmatches(rel_path, regexpr("\\d{4}", rel_path))
    url <- paste0("noticias/", year, "/", name_slug, ".html")
  } else {
    url <- paste0("noticias/", name_slug, ".html")
  }

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

