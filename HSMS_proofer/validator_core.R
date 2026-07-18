# =========================================================
# validator_core.R
# ---------------------------------------------------------
# Núcleo técnico del validador HSMS
#
# Este módulo contiene únicamente validaciones técnicas
# fundamentales e independientes de la estructura editorial.
#
# ---------------------------------------------------------
# RESPONSABILIDADES DE ESTE SCRIPT
# ---------------------------------------------------------
#
#   1. Validación del nombre de fichero
#   2. Validación UTF-8
#   3. Validación de saltos de línea LF
#   4. Balanceo global de:
#
#        < >
#        ( )
#        [ ]
#        { }
#
# ---------------------------------------------------------
# ESTE SCRIPT NO VALIDA
# ---------------------------------------------------------
#
#   - Folios
#   - Columnas {CBn.
#   - Etiquetas HSMS
#   - Reglas editoriales
#   - Espacios invisibles
#   - Puntuación
#
# Todo eso pertenece a otros módulos.
#
# ---------------------------------------------------------
# REGLAS DE ORO DEL PROYECTO
# ---------------------------------------------------------
#
#   1. Nunca mezclar validaciones estructurales
#      con validaciones editoriales.
#
#   2. Ningún módulo debe modificar el texto original.
#
#   3. Primero validar; después normalizar.
#
#   4. Todas las funciones deben devolver:
#
#        line
#        type
#        text
#        explanation
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
# check_file_technical()
# ---------------------------------------------------------
# Valida:
#
#   - nombre del fichero
#   - UTF-8
#   - saltos LF
#
# Parámetros:
#   filepath       : ruta del fichero
#   uploaded_name  : nombre original
#
# Devuelve:
#   data.frame de incidencias
#
# =========================================================

check_file_technical <- function(filepath,
                                 uploaded_name = basename(filepath)) {
  
  issues <- list()
  
  # -------------------------------------------------
  # 1. Nombre del fichero
  # -------------------------------------------------
  
  fname_ok <- grepl(
    "^TEXT\\.[A-Z0-9]+\\.txt$",
    uploaded_name,
    perl = TRUE
  )
  
  if (!fname_ok) {
    
    issues[[length(issues) + 1]] <- list(
      line = NA_integer_,
      type = "filename_invalid",
      text = uploaded_name,
      explanation =
        "Nombre inválido: debe ser TEXT.SIGLA.txt, con SIGLA alfanumérica en mayúsculas."
    )
  }
  
  # -------------------------------------------------
  # 2. Lectura binaria
  # -------------------------------------------------
  
  raw <- readBin(
    filepath,
    what = "raw",
    n = file.info(filepath)$size
  )
  
  # -------------------------------------------------
  # 3. Saltos de línea
  # -------------------------------------------------
  #
  # OBSOLETO / INFORMATIVO.
  #
  # Los saltos de línea dependen del sistema operativo.
  # No se consideran una incidencia HSMS.
  #
  # La función fix_line_endings() se conserva como
  # herramienta manual, pero Proofer no informa de
  # CRLF/CR como error.
  # -------------------------------------------------
  
  
  # -------------------------------------------------
  # 4. UTF-8
  # -------------------------------------------------
  
  txt <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  bad_utf8 <- any(!validEnc(txt))
  
  if (bad_utf8) {
    
    issues[[length(issues) + 1]] <- list(
      line = NA_integer_,
      type = "encoding_not_utf8",
      text = uploaded_name,
      explanation =
        "El fichero no parece estar correctamente codificado en UTF-8."
    )
  }
  
  # -------------------------------------------------
  # 4-bis. Diacríticos Unicode combinantes
  # -------------------------------------------------
  #
  # Regla técnica:
  #
  #   El fichero puede contener caracteres Unicode
  #   precompuestos con diacríticos:
  #
  #     ç, á, ñ, ö, ā, ḍ, etc.
  #
  #   Pero no debe construirlos manualmente mediante:
  #
  #     carácter base + marca combinante Unicode
  #
  #   Proofer no corrige ni normaliza automáticamente.
  #   Solo avisa de la presencia de marcas combinantes.
  #
  # -------------------------------------------------
  
  for (line_no in seq_along(txt)) {
    
    line <- txt[[line_no]]
    
    combining_positions <- gregexpr(
      "\\p{M}",
      line,
      perl = TRUE
    )[[1]]
    
    if (combining_positions[1] == -1) {
      next
    }
    
    for (pos in combining_positions) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = pos,
        type = "combining_diacritic_not_allowed",
        text = line,
        explanation =
          "Se ha detectado un diacrítico Unicode combinante. No construya letras manualmente mediante carácter base + marca combinante; use un carácter Unicode precompuesto o la representación HSMS correspondiente."
      )
    }
  }
  
  # -------------------------------------------------
  # 5. Resultado
  # -------------------------------------------------
  
  if (length(issues) == 0) {
    
    return(data.frame(
      line = integer(0),
      type = character(0),
      text = character(0),
      explanation = character(0)
    ))
  }
  
  do.call(rbind, lapply(issues, as.data.frame))
}


# =========================================================
# tokenize_balanced_chars()
# ---------------------------------------------------------
# Convierte una línea en tokens para el balanceo global.
#
# ---------------------------------------------------------
# Objetivo
# ---------------------------------------------------------
#
#   Tratar como unidades funcionales especiales:
#
#     <<  >>
#     ((  ))
#
# antes de procesar los signos simples:
#
#     < >
#     ( )
#     [ ]
#     { }
#
# ---------------------------------------------------------
# Parámetros:
#
#   line : línea de texto
#
# ---------------------------------------------------------
# Devuelve:
#
#   data.frame con columnas:
#
#     token
#     col
#
# donde col indica la columna inicial del token.
#
# =========================================================

tokenize_balanced_chars <- function(line) {
  
  chars <- strsplit(
    line,
    "",
    fixed = TRUE
  )[[1]]
  
  if (length(chars) == 0) {
    
    return(data.frame(
      token = character(0),
      col = integer(0)
    ))
  }
  
  tokens <- list()
  
  i <- 1
  
  while (i <= length(chars)) {
    
    current <- chars[[i]]
    
    next_char <- if (i < length(chars)) {
      chars[[i + 1]]
    } else {
      ""
    }
    
    two_chars <- paste0(
      current,
      next_char
    )
    
    if (two_chars %in% c("<<", ">>", "((", "))")) {
      
      tokens[[length(tokens) + 1]] <- list(
        token = two_chars,
        col = i
      )
      
      i <- i + 2
      
    } else {
      
      tokens[[length(tokens) + 1]] <- list(
        token = current,
        col = i
      )
      
      i <- i + 1
    }
  }
  
  do.call(rbind, lapply(tokens, as.data.frame))
}

# =========================================================
# check_balanced_pairs()
# ---------------------------------------------------------
# Comprueba el balanceo global de pares funcionales HSMS.
#
# ---------------------------------------------------------
# Pares comprobados
# ---------------------------------------------------------
#
#   << >>   suprascrito
#   (( ))   paréntesis funcional HSMS
#   <  >    abreviatura
#   (  )    texto eliminado
#   [  ]    texto insertado
#   {  }    etiquetas
#
# ---------------------------------------------------------
# Objetivo
# ---------------------------------------------------------
#
#   Detectar cierres sin apertura, cierres incompatibles
#   y aperturas que quedan sin cerrar al final del fichero.
#
# Los pares dobles se tokenizan previamente mediante
# tokenize_balanced_chars() para evitar que << o (( sean
# interpretados como dos aperturas simples consecutivas.
#
# ---------------------------------------------------------
# Parámetros:
#
#   filepath : ruta al fichero TXT que se quiere validar.
#
# ---------------------------------------------------------
# Devuelve:
#
#   data.frame homogéneo con columnas:
#
#     line
#     col
#     type
#     text
#     explanation
#
# =========================================================

check_balanced_pairs <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  openings <- c(
    "<<" = ">>",
    "((" = "))",
    "<"  = ">",
    "("  = ")",
    "["  = "]",
    "{"  = "}"
  )
  
  closings <- c(
    ">>" = "<<",
    "))" = "((",
    ">"  = "<",
    ")"  = "(",
    "]"  = "[",
    "}"  = "{"
  )
  
  stack <- list()
  issues <- list()
  
  # -------------------------------------------------
  # Recorrido línea a línea y token a token
  # -------------------------------------------------
  
  for (line_no in seq_along(lines)) {
    
    tokens <- tokenize_balanced_chars(
      lines[[line_no]]
    )
    
    if (nrow(tokens) == 0) next
    
    for (token_index in seq_len(nrow(tokens))) {
      
      ch <- tokens$token[[token_index]]
      col_no <- tokens$col[[token_index]]
      
      # ---------------------------------------------
      # Aperturas
      # ---------------------------------------------
      
      if (ch %in% names(openings)) {
        
        stack[[length(stack) + 1]] <- list(
          char = ch,
          line = line_no,
          col = col_no
        )
        
        # ---------------------------------------------
        # Cierres
        # ---------------------------------------------
        
      } else if (ch %in% names(closings)) {
        
        if (length(stack) == 0) {
          
          issues[[length(issues) + 1]] <- list(
            line = line_no,
            col = col_no,
            type = "unmatched_closing",
            text = lines[[line_no]],
            explanation = paste0(
              "Cierre '",
              ch,
              "' sin apertura previa."
            )
          )
          
        } else {
          
          top <- stack[[length(stack)]]
          expected_open <- closings[[ch]]
          
          if (top$char == expected_open) {
            
            stack[[length(stack)]] <- NULL
            
          } else {
            
            issues[[length(issues) + 1]] <- list(
              line = line_no,
              col = col_no,
              type = "mismatched_closing",
              text = lines[[line_no]],
              explanation = paste0(
                "Cierre '",
                ch,
                "' no coincide con apertura '",
                top$char,
                "' de línea ",
                top$line,
                ", columna ",
                top$col,
                "."
              )
            )
          }
        }
      }
    }
  }
  
  # -------------------------------------------------
  # Aperturas sin cerrar
  # -------------------------------------------------
  
  if (length(stack) > 0) {
    
    for (item in rev(stack)) {
      
      issues[[length(issues) + 1]] <- list(
        line = item$line,
        col = item$col,
        type = "unclosed_opening",
        text = lines[[item$line]],
        explanation = paste0(
          "Apertura '",
          item$char,
          "' sin cerrar."
        )
      )
    }
  }
  
  # -------------------------------------------------
  # Resultado
  # -------------------------------------------------
  
  if (length(issues) == 0) {
    
    return(data.frame(
      line = integer(0),
      col = integer(0),
      type = character(0),
      text = character(0),
      explanation = character(0)
    ))
  }
  
  do.call(rbind, lapply(issues, as.data.frame))
}
