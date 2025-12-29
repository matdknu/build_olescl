#!/usr/bin/env Rscript
# Script para reorganizar todas las noticias en carpetas
# Cada noticia tendrá su propia carpeta con el nombre de la noticia
# El archivo .qmd se moverá a la carpeta y se renombrará a index.qmd

cat("=== Reorganizando noticias en carpetas ===\n\n")

noticias_dir <- "content/noticias"
# Buscar archivos .qmd que NO estén dentro de carpetas de noticias ya organizadas
# Solo procesar archivos que estén en subdirectorios de año/mes o directamente en content/noticias/
qmd_files <- list.files(noticias_dir, pattern = "\\.qmd$", recursive = TRUE, full.names = TRUE)
# Filtrar: excluir ejemplo, template, y archivos que ya están en carpetas organizadas (que tienen nombre con fecha)
qmd_files <- qmd_files[!grepl("ejemplo|template|index-generated|recientes-generated", basename(qmd_files), ignore.case = TRUE)]
# Excluir archivos que ya están en carpetas de noticias (carpetas con nombres que empiezan con fecha)
qmd_files <- qmd_files[!grepl("content/noticias/\\d{4}-\\d{2}-\\d{2}", qmd_files)]

cat("Encontradas", length(qmd_files), "noticias para reorganizar\n\n")

# Función para crear carpeta y mover archivo
reorganizar_noticia <- function(qmd_file) {
  # Obtener el nombre base sin extensión
  nombre_base <- gsub("\\.qmd$", "", basename(qmd_file))
  
  # Crear ruta de la nueva carpeta (directamente en content/noticias/)
  nueva_carpeta <- file.path(noticias_dir, nombre_base)
  
  # Si la carpeta ya existe, verificar si ya tiene el archivo
  if (dir.exists(nueva_carpeta)) {
    index_qmd <- file.path(nueva_carpeta, "index.qmd")
    if (file.exists(index_qmd)) {
      cat("⚠️  Ya existe:", nueva_carpeta, "- saltando\n")
      return(FALSE)
    }
  }
  
  # Crear la carpeta si no existe
  if (!dir.exists(nueva_carpeta)) {
    dir.create(nueva_carpeta, recursive = TRUE)
    cat("✓ Creada carpeta:", nueva_carpeta, "\n")
  }
  
  # Leer el contenido del archivo original
  contenido <- readLines(qmd_file, warn = FALSE, encoding = "UTF-8")
  
  # Determinar el nombre del archivo en la nueva ubicación
  # Usar index.qmd para mantener consistencia
  nuevo_archivo <- file.path(nueva_carpeta, "index.qmd")
  
  # Escribir el archivo en la nueva ubicación
  writeLines(contenido, nuevo_archivo)
  cat("✓ Movido:", basename(qmd_file), "→", file.path(nombre_base, "index.qmd"), "\n")
  
  # Eliminar el archivo original
  file.remove(qmd_file)
  cat("✓ Eliminado archivo original:", qmd_file, "\n")
  
  # Si el directorio original quedó vacío (excepto por carpetas), intentar limpiarlo
  # Pero no eliminamos carpetas de año/mes por si acaso hay otros archivos
  
  return(TRUE)
}

# Procesar todas las noticias
contador <- 0
for (qmd_file in qmd_files) {
  tryCatch({
    if (reorganizar_noticia(qmd_file)) {
      contador <- contador + 1
    }
  }, error = function(e) {
    cat("✗ Error procesando", qmd_file, ":", e$message, "\n")
  })
}

cat("\n=== Reorganización completada ===\n")
cat("✓ Total de noticias reorganizadas:", contador, "\n")
cat("✓ Estructura nueva: content/noticias/NOMBRE-NOTICIA/index.qmd\n\n")

# Limpiar carpetas vacías de año/mes (opcional, comentado por seguridad)
# cat("Limpiando carpetas vacías...\n")
# años <- list.dirs(noticias_dir, recursive = FALSE)
# for (año_dir in años) {
#   if (grepl("\\d{4}$", basename(año_dir))) {
#     meses <- list.dirs(año_dir, recursive = FALSE)
#     for (mes_dir in meses) {
#       archivos <- list.files(mes_dir, all.files = TRUE, no.. = TRUE)
#       if (length(archivos) == 0) {
#         unlink(mes_dir, recursive = TRUE)
#         cat("✓ Eliminada carpeta vacía:", mes_dir, "\n")
#       }
#     }
#     archivos_año <- list.files(año_dir, all.files = TRUE, no.. = TRUE)
#     if (length(archivos_año) == 0) {
#       unlink(año_dir, recursive = TRUE)
#       cat("✓ Eliminada carpeta vacía:", año_dir, "\n")
#     }
#   }
# }

