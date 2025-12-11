#!/usr/bin/env Rscript
# Script para actualizar perfiles HTML con biografías desde QMD

library(yaml)

# Función para leer metadata de QMD
read_qmd_metadata <- function(qmd_file) {
  lines <- readLines(qmd_file)
  yaml_start <- which(lines == "---")[1]
  yaml_end <- which(lines == "---")[2]
  
  if (is.na(yaml_start) || is.na(yaml_end)) {
    return(NULL)
  }
  
  yaml_content <- paste(lines[(yaml_start+1):(yaml_end-1)], collapse = "\n")
  metadata <- yaml::yaml.load(yaml_content)
  
  # Leer descripción (después del segundo ---)
  desc_start <- yaml_end + 1
  desc_lines <- lines[desc_start:length(lines)]
  desc_text <- paste(desc_lines, collapse = "\n")
  
  # Extraer descripción (hasta el siguiente ##)
  desc_match <- regexpr("## Descripción\\s*\\n\\s*\\n", desc_text)
  if (desc_match > 0) {
    desc_end <- regexpr("## ", desc_text, start = desc_match + attr(desc_match, "match.length"))
    if (desc_end > 0) {
      desc <- substr(desc_text, desc_match + attr(desc_match, "match.length"), desc_end - 1)
    } else {
      desc <- substr(desc_text, desc_match + attr(desc_match, "match.length"), nchar(desc_text))
    }
    desc <- trimws(desc)
    metadata$descripcion <- desc
  }
  
  return(metadata)
}

# Función para actualizar HTML
update_profile_html <- function(qmd_file, html_file) {
  meta <- read_qmd_metadata(qmd_file)
  if (is.null(meta)) {
    cat("No se pudo leer metadata de:", qmd_file, "\n")
    return()
  }
  
  html_content <- readLines(html_file)
  
  # Buscar y reemplazar la descripción
  desc_pattern <- '<div class="perfil-descripcion">'
  desc_start <- grep(desc_pattern, html_content)
  
  if (length(desc_start) > 0) {
    # Encontrar el cierre del div
    desc_end <- grep('</div>', html_content)
    desc_end <- desc_end[desc_end > desc_start][1]
    
    if (!is.na(desc_end)) {
      # Construir nueva descripción
      new_desc <- c(
        '        <div class="perfil-descripcion">',
        paste0('            <p>', meta$descripcion, '</p>'),
        '        </div>'
      )
      
      # Reemplazar
      html_content <- c(
        html_content[1:(desc_start-1)],
        new_desc,
        html_content[(desc_end+1):length(html_content)]
      )
      
      writeLines(html_content, html_file)
      cat("✓ Actualizado:", html_file, "\n")
    }
  }
}

# Mapeo de archivos
qmd_files <- list.files("content/equipo", pattern = "\\.qmd$", full.names = TRUE)

for (qmd_file in qmd_files) {
  # Obtener nombre base
  base_name <- tools::file_path_sans_ext(basename(qmd_file))
  
  # Convertir nombre a formato HTML (sin acentos, sin títulos)
  html_name <- tolower(base_name)
  html_name <- gsub("investigador-principal-", "", html_name)
  html_name <- gsub("investigador-asociado-", "", html_name)
  html_name <- gsub("investigador-doctoral-", "", html_name)
  html_name <- gsub("asistente-", "", html_name)
  
  # Mapeo especial
  name_map <- list(
    "subdirectora" = "maria-gonzalez",
    "investigador-principal-1" = "carlos-rodriguez",
    "investigador-principal-2" = "ana-martinez",
    "investigador-principal-3" = "luis-fernandez",
    "investigador-principal-4" = "patricia-lopez",
    "investigador-principal-5" = "roberto-sanchez",
    "investigador-asociado-1" = "fernando-torres",
    "investigador-asociado-2" = "carmen-silva",
    "investigador-asociado-3" = "diego-morales",
    "investigador-asociado-4" = "isabel-ramirez",
    "investigador-doctoral-1" = "andres-vargas",
    "investigador-doctoral-2" = "valentina-herrera",
    "asistente-2" = "sofia-mendoza",
    "asistente-3" = "miguel-castro",
    "asistente-4" = "camila-rojas"
  )
  
  html_name <- if (base_name %in% names(name_map)) {
    name_map[[base_name]]
  } else {
    html_name
  }
  
  html_file <- paste0("equipo/", html_name, ".html")
  
  if (file.exists(html_file)) {
    update_profile_html(qmd_file, html_file)
  } else {
    cat("No se encontró HTML para:", base_name, "\n")
  }
}

cat("\n✓ Proceso completado!\n")

