# =========================================================
# technical_fixers.R
# ---------------------------------------------------------
# Herramientas técnicas auxiliares para HSMS Proofer
#
# IMPORTANTE
# ---------------------------------------------------------
# Estas funciones SOLO corrigen aspectos técnicos:
#
#   - BOM UTF-8
#   - CRLF / CR -> LF
#   - recodificación UTF-8
#
# Estas funciones NUNCA modifican:
#
#   - contenido textual
#   - puntuación
#   - espacios internos
#   - etiquetas HSMS
#   - balanceo de signos
#   - estructura documental
#
# ---------------------------------------------------------
# FILOSOFÍA
# ---------------------------------------------------------
#
# Toda corrección:
#
#   1. genera copia de seguridad;
#   2. informa al usuario;
#   3. nunca sobrescribe silenciosamente.
#
# ---------------------------------------------------------
# Proyecto:
#   HSMS Proofer
#
# Autor:
#   José Manuel Fradejas Rueda
#
# =========================================================



# =========================================================
# make_backup()
# ---------------------------------------------------------
# Genera copia de seguridad .bak
#
# Parámetros:
#   filepath : fichero original
#
# Devuelve:
#   ruta de la copia
#
# =========================================================

make_backup <- function(filepath) {
  
  backup_path <- paste0(filepath, ".bak")
  
  ok <- file.copy(
    filepath,
    backup_path,
    overwrite = TRUE
  )
  
  if (!ok) {
    stop("No se pudo crear la copia de seguridad.")
  }
  
  message("Copia de seguridad creada:")
  message(backup_path)
  
  return(backup_path)
}



# =========================================================
# remove_bom()
# ---------------------------------------------------------
# Elimina BOM UTF-8 si existe.
#
# Parámetros:
#   filepath : fichero original
#
# Devuelve:
#   TRUE/FALSE
#
# =========================================================

remove_bom <- function(filepath) {
  
  make_backup(filepath)
  
  raw <- readBin(
    filepath,
    what = "raw",
    n = file.info(filepath)$size
  )
  
  bom <- as.raw(c(0xEF, 0xBB, 0xBF))
  
  has_bom <- length(raw) >= 3 &&
    identical(raw[1:3], bom)
  
  if (!has_bom) {
    
    message("No se detectó BOM UTF-8.")
    return(FALSE)
  }
  
  raw_clean <- raw[-c(1:3)]
  
  con <- file(filepath, "wb")
  writeBin(raw_clean, con)
  close(con)
  
  message("BOM UTF-8 eliminado.")
  
  return(TRUE)
}



# =========================================================
# fix_line_endings()
# ---------------------------------------------------------
# Convierte:
#
#   CRLF -> LF
#   CR   -> LF
#
# Parámetros:
#   filepath : fichero original
#
# Devuelve:
#   TRUE/FALSE
#
# =========================================================

fix_line_endings <- function(filepath) {
  
  make_backup(filepath)
  
  txt <- readChar(
    filepath,
    nchars = file.info(filepath)$size,
    useBytes = TRUE
  )
  
  original <- txt
  
  txt <- gsub("\r\n", "\n", txt, fixed = TRUE)
  txt <- gsub("\r", "\n", txt, fixed = TRUE)
  
  changed <- !identical(original, txt)
  
  if (!changed) {
    
    message("Los saltos de línea ya eran LF.")
    return(FALSE)
  }
  
  con <- file(filepath, "wb")
  
  writeChar(
    txt,
    con,
    eos = NULL,
    useBytes = TRUE
  )
  
  close(con)
  
  message("Saltos de línea convertidos a LF.")
  
  return(TRUE)
}



# =========================================================
# convert_to_utf8()
# ---------------------------------------------------------
# Regraba el fichero en UTF-8.
#
# IMPORTANTE:
# ---------------------------------------------------------
# Esta función intenta preservar el contenido textual.
#
# No debe utilizarse para modificar:
#
#   - ortografía
#   - puntuación
#   - espacios internos
#
# Parámetros:
#   filepath : fichero original
#   from     : codificación original
#
# Devuelve:
#   TRUE/FALSE
#
# =========================================================

convert_to_utf8 <- function(filepath,
                            from = "latin1") {
  
  make_backup(filepath)
  
  txt <- readLines(
    filepath,
    encoding = from,
    warn = FALSE
  )
  
  con <- file(
    filepath,
    open = "w",
    encoding = "UTF-8"
  )
  
  writeLines(
    txt,
    con = con,
    sep = "\n",
    useBytes = TRUE
  )
  
  close(con)
  
  message("Fichero convertido a UTF-8.")
  
  return(TRUE)
}



# =========================================================
# technical_cleanup()
# ---------------------------------------------------------
# Pipeline técnico opcional:
#
#   1. eliminar BOM
#   2. convertir LF
#   3. convertir UTF-8
#
# Parámetros:
#   filepath : fichero original
#   encoding : codificación de origen
#
# =========================================================

technical_cleanup <- function(filepath,
                              encoding = "latin1") {
  
  message("===================================")
  message("HSMS TECHNICAL CLEANUP")
  message("===================================")
  
  remove_bom(filepath)
  
  fix_line_endings(filepath)
  
  convert_to_utf8(
    filepath,
    from = encoding
  )
  
  message("===================================")
  message("Proceso técnico finalizado.")
  message("===================================")
}