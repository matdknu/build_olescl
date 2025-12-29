#!/usr/bin/env Rscript
# Script para completar todas las noticias vacías con YAML básico válido
# Extrae información del nombre de la carpeta para crear el YAML

cat("=== Completando noticias vacías ===\n\n")

noticias_dir <- "content/noticias"
carpetas_noticias <- list.dirs(noticias_dir, recursive = FALSE)
carpetas_noticias <- carpetas_noticias[grepl("^content/noticias/\\d{4}-", carpetas_noticias)]

# Función para extraer fecha del nombre de la carpeta
extraer_fecha <- function(nombre_carpeta) {
  # Buscar patrón YYYY-MM-DD
  fecha_match <- regmatches(nombre_carpeta, regexpr("\\d{4}-\\d{2}-\\d{2}", nombre_carpeta))
  if (length(fecha_match) > 0 && nchar(fecha_match) == 10) {
    fecha <- as.Date(fecha_match)
    meses <- c("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
               "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre")
    dia <- format(fecha, "%d")
    mes <- meses[as.numeric(format(fecha, "%m"))]
    año <- format(fecha, "%Y")
    return(paste(dia, mes, año))
  }
  return("")
}

# Función para generar título desde el nombre de la carpeta
generar_titulo <- function(nombre_carpeta) {
  # Remover fecha del inicio (YYYY-MM-DD-)
  titulo <- gsub("^\\d{4}-\\d{2}-\\d{2}-", "", basename(nombre_carpeta))
  # Reemplazar guiones con espacios
  titulo <- gsub("-", " ", titulo)
  # Capitalizar primera letra de cada palabra
  palabras <- strsplit(titulo, " ")[[1]]
  palabras <- sapply(palabras, function(p) {
    if (nchar(p) > 0) {
      paste0(toupper(substring(p, 1, 1)), substring(p, 2))
    } else {
      p
    }
  })
  return(paste(palabras, collapse = " "))
}

# Función para determinar si es evento o noticia
es_evento <- function(nombre_carpeta) {
  nombre_lower <- tolower(basename(nombre_carpeta))
  return(grepl("evento|seminario|taller|jornada|congreso|conferencia", nombre_lower))
}

completar_noticia <- function(carpeta) {
  qmd_file <- file.path(carpeta, "index.qmd")
  
  # Leer contenido actual
  contenido_actual <- ""
  tiene_yaml <- FALSE
  
  if (file.exists(qmd_file)) {
    contenido_actual <- readLines(qmd_file, warn = FALSE, encoding = "UTF-8")
    # Verificar si tiene YAML válido y completo
    if (any(grepl("^---$", contenido_actual))) {
      yaml_start <- which(grepl("^---$", contenido_actual))[1]
      yaml_end <- which(grepl("^---$", contenido_actual))[2]
      if (!is.na(yaml_start) && !is.na(yaml_end) && yaml_end > yaml_start + 1) {
        # Verificar si el YAML tiene campos completos
        yaml_lines <- contenido_actual[(yaml_start+1):(yaml_end-1)]
        yaml_text <- paste(yaml_lines, collapse = "\n")
        # Si tiene title y date con valores no vacíos, considerar válido
        if (grepl("title:\\s+\"[^\"]+\"|title:\\s+[^\\s]+", yaml_text) && 
            grepl("date:\\s+\"[^\"]+\"|date:\\s+[^\\s]+", yaml_text) &&
            !grepl("title:\\s+\"\"|date:\\s+\"\"", yaml_text)) {
          tiene_yaml <- TRUE
          # Si ya tiene YAML válido y completo, no hacer nada
          return(FALSE)
        }
      }
    }
  }
  
  # Extraer información del nombre de la carpeta
  nombre_carpeta <- basename(carpeta)
  fecha <- extraer_fecha(nombre_carpeta)
  titulo <- generar_titulo(nombre_carpeta)
  es_evento_flag <- es_evento(nombre_carpeta)
  
  # Si no se pudo extraer fecha, usar fecha por defecto
  if (fecha == "") {
    fecha <- "1 Enero 2025"
  }
  
  # Generar YAML básico
  yaml_content <- paste0(
    "---\n",
    "title: \"", titulo, "\"\n",
    "date: \"", fecha, "\"\n",
    "image: \"https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=1200&h=600&fit=crop\"\n",
    "author: \"Equipo OLES\"\n",
    "tags: [\"", ifelse(es_evento_flag, "Evento", "Noticias"), "\"]\n",
    "destacado: false\n",
    "tipo: \"", ifelse(es_evento_flag, "evento", "noticia"), "\"\n",
    "---\n"
  )
  
  # Extraer contenido markdown válido (después del YAML)
  contenido_md <- ""
  if (length(contenido_actual) > 0) {
    # Buscar YAML existente
    yaml_start <- which(grepl("^---$", contenido_actual))[1]
    yaml_end <- which(grepl("^---$", contenido_actual))[2]
    
    if (!is.na(yaml_start) && !is.na(yaml_end) && yaml_end < length(contenido_actual)) {
      # Extraer solo el contenido después del YAML
      contenido_md <- paste(contenido_actual[(yaml_end+1):length(contenido_actual)], collapse = "\n")
    } else if (!is.na(yaml_start) && is.na(yaml_end)) {
      # YAML incompleto, tomar todo después del primer ---
      contenido_md <- paste(contenido_actual[(yaml_start+1):length(contenido_actual)], collapse = "\n")
    } else {
      # No hay YAML, tomar todo el contenido
      contenido_md <- paste(contenido_actual, collapse = "\n")
    }
    
    # Limpiar contenido: remover líneas que parecen YAML incompleto
    contenido_md <- gsub("^title:\\s*\"\"\\s*$", "", contenido_md, perl = TRUE, useBytes = TRUE)
    contenido_md <- gsub("^date:\\s*\"\"\\s*$", "", contenido_md, perl = TRUE, useBytes = TRUE)
    contenido_md <- gsub("^---\\s*$", "", contenido_md, perl = TRUE, useBytes = TRUE)
    contenido_md <- trimws(contenido_md)
  }
  
  # Si no hay contenido válido, agregar placeholder
  if (contenido_md == "" || nchar(trimws(contenido_md)) == 0) {
    contenido_md <- "\n\n*Contenido pendiente de completar.*\n"
  } else {
    # Asegurar que empiece con nueva línea
    if (!grepl("^\n", contenido_md)) {
      contenido_md <- paste0("\n\n", contenido_md)
    }
  }
  
  # Escribir archivo completo (siempre reescribir para evitar duplicados)
  contenido_completo <- paste0(yaml_content, contenido_md)
  # Asegurar que el archivo termine con nueva línea
  if (!grepl("\n$", contenido_completo)) {
    contenido_completo <- paste0(contenido_completo, "\n")
  }
  writeLines(contenido_completo, qmd_file)
  
  cat("✓ Completada:", basename(carpeta), "\n")
  return(TRUE)
}

# Procesar todas las carpetas
contador <- 0
for (carpeta in carpetas_noticias) {
  tryCatch({
    if (completar_noticia(carpeta)) {
      contador <- contador + 1
    }
  }, error = function(e) {
    cat("✗ Error procesando", carpeta, ":", e$message, "\n")
  })
}

cat("\n=== Completado ===\n")
cat("✓ Total de noticias completadas:", contador, "\n")
cat("✓ Todas las noticias ahora tienen YAML válido\n\n")

