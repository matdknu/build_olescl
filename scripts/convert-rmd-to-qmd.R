#!/usr/bin/env Rscript
# Script para convertir archivos Rmd de oles_cl/content/post a QMD en el nuevo formato

library(yaml)
library(stringr)

# Ruta de origen y destino
source_dir <- "/Users/matdknu/Dropbox/OLES/oles_cl/content/post"
dest_dir <- "content/noticias"

# Función para leer metadata de Rmd
read_rmd_metadata <- function(rmd_file) {
  lines <- readLines(rmd_file, warn = FALSE, encoding = "UTF-8")
  
  yaml_start <- which(grepl("^---$", lines))[1]
  yaml_end <- which(grepl("^---$", lines))[2]
  
  if (is.na(yaml_start) || is.na(yaml_end)) {
    return(NULL)
  }
  
  yaml_content <- paste(lines[(yaml_start+1):(yaml_end-1)], collapse = "\n")
  metadata <- yaml.load(yaml_content)
  
  # Leer contenido (después del segundo ---)
  content <- paste(lines[(yaml_end+1):length(lines)], collapse = "\n")
  metadata$content <- content
  
  return(metadata)
}

# Función para convertir fecha ISO a formato legible
convert_date <- function(date_str) {
  if (is.null(date_str)) return("")
  
  # Si ya está en formato legible, devolverlo
  if (grepl("^\\d{1,2} \\w+ \\d{4}", date_str)) {
    return(date_str)
  }
  
  # Intentar parsear fecha ISO
  tryCatch({
    date_obj <- as.Date(date_str)
    months_es <- c("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
                   "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre")
    day <- as.numeric(format(date_obj, "%d"))
    month <- months_es[as.numeric(format(date_obj, "%m"))]
    year <- format(date_obj, "%Y")
    return(paste(day, month, year))
  }, error = function(e) {
    return(date_str)
  })
}

# Función para determinar tipo y tags
determine_type_and_tags <- function(categories, tags, title) {
  tipo <- "noticia"
  tags_list <- c()
  
  # Determinar tipo
  if (!is.null(categories)) {
    if (any(grepl("Evento|evento", categories))) {
      tipo <- "evento"
    }
  }
  
  if (!is.null(tags)) {
    # Convertir tags a array si es necesario
    if (is.character(tags) && length(tags) == 1) {
      tags_list <- strsplit(tags, ",")[[1]]
      tags_list <- trimws(tags_list)
    } else if (is.character(tags)) {
      tags_list <- tags
    }
    
    # Agregar "Destacado" si está en tags
    if (any(grepl("Destacado|destacado|Fondos|fondos", tags_list))) {
      tags_list <- c(tags_list, "Destacado")
    }
    
    # Agregar "Noticia" o "Evento" según tipo
    if (tipo == "evento") {
      if (!any(grepl("Evento", tags_list, ignore.case = TRUE))) {
        tags_list <- c(tags_list, "Evento")
      }
    } else {
      if (!any(grepl("Noticia", tags_list, ignore.case = TRUE))) {
        tags_list <- c(tags_list, "Noticia")
      }
    }
  } else {
    tags_list <- if (tipo == "evento") c("Evento") else c("Noticia")
  }
  
  # Determinar si es destacado
  destacado <- any(grepl("Destacado|destacado|Fondos|fondos", tags_list, ignore.case = TRUE))
  
  return(list(tipo = tipo, tags = unique(tags_list), destacado = destacado))
}

# Función para obtener imagen
get_image <- function(metadata, post_dir) {
  # Buscar imagen en metadata
  if (!is.null(metadata$image)) {
    if (is.character(metadata$image)) {
      return(metadata$image)
    } else if (is.list(metadata$image) && !is.null(metadata$image$caption)) {
      # Si es lista, buscar el archivo featured
      featured_files <- list.files(post_dir, pattern = "featured\\.(jpg|jpeg|png|JPG|JPEG|PNG)", full.names = FALSE)
      if (length(featured_files) > 0) {
        # Por ahora usar placeholder, luego se puede copiar la imagen
        return("https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=1200&h=600&fit=crop")
      }
    }
  }
  
  # Buscar archivo featured en el directorio
  featured_files <- list.files(post_dir, pattern = "featured\\.(jpg|jpeg|png|JPG|JPEG|PNG)", full.names = FALSE)
  if (length(featured_files) > 0) {
    return("https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=1200&h=600&fit=crop")
  }
  
  return("https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=1200&h=600&fit=crop")
}

# Función para obtener autor
get_author <- function(authors) {
  if (is.null(authors)) return("Equipo OLES")
  
  # Mapeo de autores
  author_map <- list(
    "matias_deneken" = "Matías Deneken",
    "bruno_r" = "Bruno Rojas",
    "monica" = "Mónica Gerber",
    "matias" = "Matías Deneken"
  )
  
  if (is.character(authors) && length(authors) > 0) {
    author_names <- sapply(authors, function(a) {
      if (a %in% names(author_map)) {
        return(author_map[[a]])
      } else {
        return(a)
      }
    })
    return(paste(author_names, collapse = ", "))
  }
  
  return("Equipo OLES")
}

# Función para procesar contenido
process_content <- function(content) {
  # Remover referencias a imágenes locales (se pueden agregar después)
  content <- gsub("!\\[.*?\\]\\(.*?featured.*?\\)", "", content)
  content <- gsub("!\\[.*?\\]\\(.*?foto.*?\\)", "", content)
  
  # Limpiar espacios múltiples
  content <- gsub("\\n{3,}", "\\n\\n", content)
  
  return(trimws(content))
}

# Función para generar nombre de archivo
generate_filename <- function(date_str, title) {
  # Extraer fecha
  date_obj <- tryCatch({
    as.Date(date_str)
  }, error = function(e) {
    return(Sys.Date())
  })
  
  date_formatted <- format(date_obj, "%Y-%m-%d")
  
  # Crear slug del título
  title_slug <- tolower(title)
  title_slug <- gsub("[áàäâ]", "a", title_slug)
  title_slug <- gsub("[éèëê]", "e", title_slug)
  title_slug <- gsub("[íìïî]", "i", title_slug)
  title_slug <- gsub("[óòöô]", "o", title_slug)
  title_slug <- gsub("[úùüû]", "u", title_slug)
  title_slug <- gsub("ñ", "n", title_slug)
  title_slug <- gsub("[^a-z0-9\\s]", "", title_slug)
  title_slug <- gsub("\\s+", "-", title_slug)
  title_slug <- substr(title_slug, 1, 50)  # Limitar longitud
  
  return(paste0(date_formatted, "-", title_slug, ".qmd"))
}

# Procesar todos los archivos Rmd
cat("=== Convirtiendo archivos Rmd a QMD ===\n\n")

rmd_files <- list.files(source_dir, pattern = "index\\.en\\.(Rmd|rmd)$", 
                        recursive = TRUE, full.names = TRUE)

converted <- 0
skipped <- 0

for (rmd_file in rmd_files) {
  tryCatch({
    # Obtener directorio del post
    post_dir <- dirname(rmd_file)
    post_date_dir <- basename(dirname(post_dir))
    
    # Leer metadata y contenido
    metadata <- read_rmd_metadata(rmd_file)
    if (is.null(metadata)) {
      cat("✗ No se pudo leer metadata:", rmd_file, "\n")
      skipped <- skipped + 1
      next
    }
    
    # Convertir metadata
    title <- metadata$title %||% "Sin título"
    date_iso <- metadata$date %||% post_date_dir
    date_formatted <- convert_date(date_iso)
    
    # Determinar tipo y tags
    type_tags <- determine_type_and_tags(metadata$categories, metadata$tags, title)
    
    # Obtener otros campos
    image <- get_image(metadata, post_dir)
    author <- get_author(metadata$authors)
    content <- process_content(metadata$content %||% "")
    
    # Generar nombre de archivo
    filename <- generate_filename(date_iso, title)
    output_file <- file.path(dest_dir, filename)
    
    # Verificar si ya existe
    if (file.exists(output_file)) {
      cat("⚠ Ya existe:", filename, "- Omitiendo\n")
      skipped <- skipped + 1
      next
    }
    
    # Generar QMD
    qmd_content <- paste0(
      "---\n",
      "title: \"", title, "\"\n",
      "date: \"", date_formatted, "\"\n",
      "image: \"", image, "\"\n",
      "author: \"", author, "\"\n",
      "tags: [", paste0("\"", type_tags$tags, "\"", collapse = ", "), "]\n",
      "destacado: ", tolower(type_tags$destacado), "\n",
      "tipo: \"", type_tags$tipo, "\"\n",
      "---\n\n",
      content, "\n"
    )
    
    # Escribir archivo
    writeLines(qmd_content, output_file, useBytes = TRUE)
    cat("✓ Convertido:", filename, "\n")
    converted <- converted + 1
    
  }, error = function(e) {
    cat("✗ Error procesando", rmd_file, ":", e$message, "\n")
    skipped <- skipped + 1
  })
}

cat("\n=== Resumen ===\n")
cat("✓ Convertidos:", converted, "\n")
cat("⚠ Omitidos/Errores:", skipped, "\n")
cat("✓ Proceso completado!\n")

