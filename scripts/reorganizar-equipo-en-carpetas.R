#!/usr/bin/env Rscript
# Script para reorganizar equipo en carpetas individuales
# Estructura: content/equipo/nombre-apellido/nombre-apellido.qmd

cat("=== Reorganizando equipo en carpetas individuales ===\n\n")

# Directorio base
base_dir <- "content/equipo"
qmd_files <- list.files(base_dir, pattern = "\\.qmd$", full.names = TRUE, recursive = FALSE)

# Filtrar archivos de ejemplo y template
qmd_files <- qmd_files[!grepl("ejemplo|template", basename(qmd_files), ignore.case = TRUE)]

cat("Encontrados", length(qmd_files), "perfiles para reorganizar\n\n")

moved_count <- 0
error_count <- 0

for (qmd_file in qmd_files) {
  tryCatch({
    # Obtener nombre base (sin extensión)
    filename <- basename(qmd_file)
    name_base <- gsub("\\.qmd$", "", filename)
    
    # Crear directorio para la persona
    person_dir <- file.path(base_dir, name_base)
    if (!dir.exists(person_dir)) {
      dir.create(person_dir, recursive = TRUE)
      cat("✓ Creado directorio:", person_dir, "\n")
    }
    
    # Mover archivo QMD
    new_path <- file.path(person_dir, filename)
    
    if (file.exists(new_path)) {
      cat("⚠️  Ya existe:", new_path, "(omitiendo)\n")
    } else {
      file.rename(qmd_file, new_path)
      cat("✓ Movido:", filename, "→", person_dir, "\n")
      moved_count <- moved_count + 1
    }
    
    # Mover carpeta _files si existe
    files_dir <- gsub("\\.qmd$", "_files", qmd_file)
    if (dir.exists(files_dir)) {
      new_files_dir <- file.path(person_dir, basename(files_dir))
      if (dir.exists(new_files_dir)) {
        cat("⚠️  Ya existe carpeta _files para:", filename, "(omitiendo)\n")
      } else {
        file.rename(files_dir, new_files_dir)
        cat("✓ Movida carpeta _files:", basename(files_dir), "→", person_dir, "\n")
      }
    }
    
  }, error = function(e) {
    cat("✗ Error procesando", qmd_file, ":", e$message, "\n")
    error_count <- error_count + 1
  })
}

cat("\n=== Resumen ===\n")
cat("✓ Perfiles movidos:", moved_count, "\n")
if (error_count > 0) {
  cat("✗ Errores:", error_count, "\n")
}
cat("\n✓ Reorganización completada!\n")

