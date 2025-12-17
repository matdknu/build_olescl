#!/usr/bin/env Rscript
# Script para reorganizar noticias en carpetas por fecha (año/mes)
# Esto facilita el manejo de imágenes y otros recursos

library(lubridate)

cat("=== Reorganizando noticias por fecha (año/mes) ===\n\n")

noticias_dir <- "content/noticias"
if (!dir.exists(noticias_dir)) {
  stop("No se encontró content/noticias")
}

# Encontrar todos los archivos .qmd de noticias
qmd_files <- list.files(noticias_dir, pattern = "\\.qmd$", recursive = TRUE, full.names = TRUE)
qmd_files <- qmd_files[!grepl("ejemplo|template", basename(qmd_files), ignore.case = TRUE)]

cat("Encontradas", length(qmd_files), "noticias\n\n")

moved_count <- 0
skipped_count <- 0

for (qmd_file in qmd_files) {
  # Leer el archivo para extraer la fecha
  content <- readLines(qmd_file, warn = FALSE, encoding = "UTF-8")
  
  # Buscar la fecha en el YAML front matter
  date_line <- grep("^date:", content)
  if (length(date_line) == 0) {
    cat("⚠️  No se encontró fecha en:", basename(qmd_file), "\n")
    skipped_count <- skipped_count + 1
    next
  }
  
  # Extraer fecha
  date_str <- gsub("^date:\\s*[\"']?|[\"']?$", "", content[date_line[1]])
  
  # Intentar parsear la fecha
  fecha <- tryCatch({
    # Intentar diferentes formatos
    if (grepl("\\d{4}-\\d{2}-\\d{2}", date_str)) {
      as.Date(date_str)
    } else if (grepl("\\d{1,2}\\s+\\w+\\s+\\d{4}", date_str)) {
      # Formato "13 Octubre 2022"
      fecha_parseada <- parse_date_time(date_str, orders = c("dmy", "d b Y", "d B Y"), locale = "es_ES.UTF-8")
      if (is.na(fecha_parseada)) {
        # Intentar con inglés como fallback
        fecha_parseada <- parse_date_time(date_str, orders = c("dmy", "d b Y", "d B Y"))
      }
      as.Date(fecha_parseada)
    } else {
      # Intentar parsear directamente
      as.Date(date_str)
    }
  }, error = function(e) {
    cat("⚠️  Error parseando fecha en:", basename(qmd_file), "-", date_str, "\n")
    return(NA)
  })
  
  if (is.na(fecha)) {
    skipped_count <- skipped_count + 1
    next
  }
  
  # Crear estructura año/mes
  año <- year(fecha)
  mes <- sprintf("%02d", month(fecha))
  nueva_carpeta <- file.path(noticias_dir, as.character(año), mes)
  
  # Crear carpeta si no existe
  if (!dir.exists(nueva_carpeta)) {
    dir.create(nueva_carpeta, recursive = TRUE, showWarnings = FALSE)
    cat("✓ Creada carpeta:", nueva_carpeta, "\n")
  }
  
  # Nombre del archivo
  nombre_archivo <- basename(qmd_file)
  nuevo_path <- file.path(nueva_carpeta, nombre_archivo)
  
  # Mover archivo si no está ya en la ubicación correcta
  if (qmd_file != nuevo_path) {
    # Mover archivo .qmd
    file.rename(qmd_file, nuevo_path)
    cat("✓ Movido:", nombre_archivo, "→", file.path(año, mes, nombre_archivo), "\n")
    
    # Mover carpeta _files si existe
    files_dir <- gsub("\\.qmd$", "_files", qmd_file)
    if (dir.exists(files_dir)) {
      nuevo_files_dir <- gsub("\\.qmd$", "_files", nuevo_path)
      if (file.exists(nuevo_files_dir)) {
        # Si ya existe, eliminar el viejo
        unlink(files_dir, recursive = TRUE)
      } else {
        file.rename(files_dir, nuevo_files_dir)
      }
      cat("  ✓ Movida carpeta _files\n")
    }
    
    moved_count <- moved_count + 1
  } else {
    skipped_count <- skipped_count + 1
  }
}

cat("\n=== Resumen ===\n")
cat("✓ Noticias movidas:", moved_count, "\n")
cat("⚠️  Noticias omitidas:", skipped_count, "\n")
cat("\n✓ Reorganización completada\n")
