# =========================================================
# validator_structure.R
# ---------------------------------------------------------
# Validador estructural HSMS
#
# Este módulo comprueba exclusivamente:
#
#   1. Existencia de folios [fol. Nr/Nv]
#   2. Secuencia correcta r -> v
#   3. Saltos consecutivos de numeración
#   4. Aperturas {CBn.
#   5. Cierre de columnas antes del siguiente folio
#
# ---------------------------------------------------------
# ESTE SCRIPT NO VALIDA
# ---------------------------------------------------------
#
#   - UTF-8 / LF
#   - balanceo global
#   - puntuación
#   - guiones
#   - signos especiales
#   - espacios invisibles
#
# Todo eso pertenece a otros módulos.
#
# ---------------------------------------------------------
# FILOSOFÍA
# ---------------------------------------------------------
#
# Cada módulo debe tener una única responsabilidad.
#
# Nunca mezclar:
#
#   estructura
#   ↔
#   reglas editoriales
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
# hsms_structural_tag_catalog()
# ---------------------------------------------------------
# Catálogo documentado de etiquetas estructurales HSMS.
#
# Cada fila describe una etiqueta legal y algunos rasgos
# heredados del antiguo PROOFER.
#
# position:
#   1 = dentro de columna
#   2 = fuera de columna
#   3 = en cualquier posición
#
# contents:
#   1 = no debe tener texto
#   2 = debe tener texto
#   3 = debe tener texto insertado
#   4 = puede o no tener texto
#   5 = debe tener observación
#
# =========================================================

hsms_structural_tag_catalog <- function() {
  
  data.frame(
    tag = c(
      "BLNK", "CB", "CW", "DIAG", "HD", "IN", "ILL",
      "MIN", "RUB", "SYMB", "SG",
      "AD", "GL",
      "ARB", "ARG", "ARM", "BAS", "CAL", "CAT", "ENG",
      "FRN", "GAL", "GER", "GRK", "HEB", "ITL", "LAM",
      "LAT", "PRT", "PRV",
      "RMK"
    ),
    position = c(
      1, 3, 2, 1, 2, 1, 1,
      1, 1, 1, 2,
      1, 1,
      1, 1, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1, 1, 1,
      1, 1, 1,
      3
    ),
    contents = c(
      1, 4, 2, 4, 2, 1, 4,
      4, 4, 5, 2,
      3, 3,
      2, 2, 2, 2, 2, 2, 2,
      2, 2, 2, 2, 2, 2, 2,
      2, 2, 2,
      5
    ),
    delimiter = c(
      ".", ".", ".", ".", ".", ".", ".",
      ".", ".", ".", ".",
      ".", ".",
      ".", ".", ".", ".", ".", ".", ".",
      ".", ".", ".", ".", ".", ".", ".",
      ".", ".", ".",
      ":"
    ),
    allows_vector_prefix = c(
      FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE,
      TRUE, FALSE, FALSE, FALSE,
      FALSE, FALSE,
      FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
      FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
      FALSE, FALSE, FALSE,
      FALSE
    ),
    allows_vector_suffix = c(
      FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE,
      TRUE, FALSE, FALSE, FALSE,
      FALSE, FALSE,
      FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
      FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
      FALSE, FALSE, FALSE,
      FALSE
    ),
    can_span_lines = c(
      FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, TRUE,
      TRUE, TRUE, TRUE, FALSE,
      TRUE, TRUE,
      TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE,
      TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE,
      TRUE, TRUE, TRUE,
      TRUE
    ),
    can_continue = c(
      FALSE, TRUE, FALSE, TRUE, TRUE, FALSE, FALSE,
      FALSE, TRUE, FALSE, FALSE,
      TRUE, TRUE,
      TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE,
      TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE,
      TRUE, TRUE, TRUE,
      FALSE
    ),
    numbered = c(
      FALSE, TRUE, FALSE, FALSE, NA, TRUE, FALSE,
      FALSE, FALSE, FALSE, FALSE,
      FALSE, FALSE,
      FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
      FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
      FALSE, FALSE, FALSE,
      FALSE
    ),
    tag_group = c(
      "blank",        # BLNK
      "layout",       # CB
      "post_column",  # CW
      "graphic",      # DIAG
      "paratext",     # HD
      "paratext",     # IN
      "decoration",    # ILL
      "graphic",      # MIN
      "paratext",     # RUB
      "symbol",       # SYMB
      "post_column",  # SG
      "addition",     # AD
      "addition",     # GL
      "language",     # ARB
      "language",     # ARG
      "language",     # ARM
      "language",     # BAS
      "language",     # CAL
      "language",     # CAT
      "language",     # ENG
      "language",     # FRN
      "language",     # GAL
      "language",     # GER
      "language",     # GRK
      "language",     # HEB
      "language",     # ITL
      "language",     # LAM
      "language",     # LAT
      "language",     # PRT
      "language",     # PRV
      "remark"        # RMK
    ),
    # allows_empty:
    #
    # TRUE  -> la etiqueta puede aparecer sin contenido
    # FALSE -> debe contener texto, comentario editorial
    #          o alguna estructura válida.
    allows_empty = c(
      FALSE,  # BLNK
      FALSE,  # CB
      FALSE,  # CW
      TRUE,   # DIAG
      FALSE,  # HD
      FALSE,  # IN
      TRUE,   # ILL
      TRUE,   # MIN
      TRUE,   # RUB
      FALSE,  # SYMB
      FALSE,  # SG
      FALSE,  # AD
      FALSE,  # GL
      FALSE,  # ARB
      FALSE,  # ARG
      FALSE,  # ARM
      FALSE,  # BAS
      FALSE,  # CAL
      FALSE,  # CAT
      FALSE,  # ENG
      FALSE,  # FRN
      FALSE,  # GAL
      FALSE,  # GER
      FALSE,  # GRK
      FALSE,  # HEB
      FALSE,  # ITL
      FALSE,  # LAM
      FALSE,  # LAT
      FALSE,  # PRT
      FALSE,  # PRV
      FALSE   # RMK
    ),
    special_rule = c(
      "blank",             # BLNK
      "column_boundary",   # CB
      "catchword",         # CW
      "diagram",           # DIAG
      "headword",          # HD
      "initial",           # IN
      "illimination",      # ILL
      "miniature",         # MIN
      "rubric",            # RUB
      "symbol",            # SYMB
      "signature",         # SG
      "addition_or_gloss", # AD
      "addition_or_gloss", # GL
      "none",              # ARB
      "none",              # ARG
      "none",              # ARM
      "none",              # BAS
      "none",              # CAL
      "none",              # CAT
      "none",              # ENG
      "none",              # FRN
      "none",              # GAL
      "none",              # GER
      "none",              # GRK
      "none",              # HEB
      "none",              # ITL
      "none",              # LAM
      "none",              # LAT
      "none",              # PRT
      "none",              # PRV
      "remark"             # RMK
    ),
    special_processing = c(
      2, 4, 3, 5, 6, 7, 0,
      8, 10, 11, 12,
      1, 1,
      0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0,
      0, 0, 0,
      9
    ),
    stringsAsFactors = FALSE
  )
}

# =========================================================
# hsms_functional_character_catalog()
# ---------------------------------------------------------
# Catálogo interno de caracteres funcionales HSMS.
#
# ---------------------------------------------------------
# Objetivo
# ---------------------------------------------------------
#
#   Centralizar los caracteres que tienen una función
#   estructural, editorial o paleográfica en las
#   transcripciones HSMS.
#
# Esta función NO valida nada por sí misma.
# Solo devuelve datos de referencia para futuras reglas.
#
# ---------------------------------------------------------
# Fuente
# ---------------------------------------------------------
#
#   PROOFER.FNC / PROOFER_FUNCTIONAL.txt
#
# ---------------------------------------------------------
# Nota histórica
# ---------------------------------------------------------
#
#   La convención ((...)) para supresiones extendidas
#   queda obsoleta. Se conserva en el catálogo como
#   fósil histórico.
#
#   La convención vigente para supresiones extendidas es:
#
#     ≺ ... ≻
#
# =========================================================

hsms_functional_character_catalog <- function() {
  
  data.frame(
    symbol = c(
      "[fol.", "]", "\\",
      "{", "}", ".", ":", "+", "=",
      "[", "]",
      "(", ")",
      "<", ">",
      "<<", ">>",
      "((", "))",
      "≺", "≻",
      "^", "##",
      "??", "???",
      "%", "-", "$", "[...]", "[+]", "*", "|"
    ),
    function_name = c(
      "begin_folio", "end_folio", "old_folio_notation",
      "begin_mnemonic", "end_mnemonic",
      "begin_mnemonic_text",
      "begin_mnemonic_remark",
      "mnemonic_continuation",
      "mnemonic_vector",
      "begin_inserted_text", "end_inserted_text",
      "begin_deleted_text", "end_deleted_text",
      "begin_abbreviation", "end_abbreviation",
      "begin_suprascript", "end_suprascript",
      "obsolete_begin_real_parenthesis",
      "obsolete_end_ereal_parenthesis",
      "begin_real_parenthesis",
      "end_real_parenthesis",
      "scribal_hand", "non_original_scribal_hand",
      "illegible_word_or_part",
      "illegible_phrase",
      "calderon",
      "hyphen",
      "inverted_text",
      "non_sequitur_text",
      "prefix",
      "reconstituted_text",
      "text_separator"
    ),
    begin_code = c(
      1, NA, 3,
      4, NA, 6, 7, 8, 9,
      10, NA,
      12, NA,
      14, NA,
      16, NA,
      18, NA,
      32, NA,
      20, 21,
      23, 24,
      25, 26, 27, 28, 29, 30, 31
    ),
    end_code = c(
      NA, 2, NA,
      NA, 5, NA, NA, NA, NA,
      NA, 11,
      NA, 13,
      NA, 15,
      NA, 17,
      NA, 19,
      NA, 33,
      NA, NA,
      NA, NA,
      NA, NA, NA, NA, NA, NA, NA
    ),
    stringsAsFactors = FALSE
  )
}

# =========================================================
# extract_hsms_mnemonics()
# ---------------------------------------------------------
# Extrae etiquetas HSMS presentes en un vector de líneas.
#
# ---------------------------------------------------------
# Objetivo
# ---------------------------------------------------------
#
#   Crear una función auxiliar común para futuras reglas
#   estructurales.
#
# Esta función NO valida nada.
# Solo localiza etiquetas del tipo:
#
#   {TAG.
#   {TAG:
#   {TAGn.
#   {TAG=.
#   {=TAG.
#   {=TAG=.
#
# ---------------------------------------------------------
# Devuelve
# ---------------------------------------------------------
#
#   data.frame con columnas:
#
#     line
#     col
#     raw
#     tag
#     number
#     delimiter
#     has_vector_prefix
#     has_vector_suffix
#
# =========================================================

extract_hsms_mnemonics <- function(lines) {
  
  mnemonics <- list()
  
  pattern <- "\\{(=)?([A-Za-z]+)([0-9]*)(=)?([\\.:])"
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    matches <- gregexpr(
      pattern,
      line,
      perl = TRUE
    )[[1]]
    
    if (matches[1] == -1) next
    
    match_lengths <- attr(matches, "match.length")
    
    for (i in seq_along(matches)) {
      
      pos <- matches[[i]]
      len <- match_lengths[[i]]
      
      raw <- substr(
        line,
        pos,
        pos + len - 1
      )
      
      has_vector_prefix <- grepl(
        "^\\{=",
        raw,
        perl = TRUE
      )
      
      has_vector_suffix <- grepl(
        "=[\\.:]$",
        raw,
        perl = TRUE
      )
      
      tag <- sub(
        "^\\{=?([A-Za-z]+)([0-9]*)(=)?([\\.:])$",
        "\\1",
        raw,
        perl = TRUE
      )
      
      number <- sub(
        "^\\{=?([A-Za-z]+)([0-9]*)(=)?([\\.:])$",
        "\\2",
        raw,
        perl = TRUE
      )
      
      delimiter <- sub(
        "^\\{=?([A-Za-z]+)([0-9]*)(=)?([\\.:])$",
        "\\4",
        raw,
        perl = TRUE
      )
      
      mnemonics[[length(mnemonics) + 1]] <- list(
        line = line_no,
        col = pos,
        raw = raw,
        tag = toupper(tag),
        number = if (number == "") NA_integer_ else as.integer(number),
        delimiter = delimiter,
        has_vector_prefix = has_vector_prefix,
        has_vector_suffix = has_vector_suffix
      )
    }
  }
  
  if (length(mnemonics) == 0) {
    
    return(data.frame(
      line = integer(0),
      col = integer(0),
      raw = character(0),
      tag = character(0),
      number = integer(0),
      delimiter = character(0),
      has_vector_prefix = logical(0),
      has_vector_suffix = logical(0)
    ))
  }
  
  do.call(rbind, lapply(mnemonics, as.data.frame))
}

# =========================================================
# check_inline_angle_delimiters()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   Los delimitadores:
#
#     <...>     abreviatura
#     <<...>>   letra volada / superescrita
#
#   deben abrirse y cerrarse dentro de la misma línea física.
#
# ---------------------------------------------------------
# Notas:
#
#   - No se revisan líneas de folio [fol. nnnr/v].
#   - Se procesa primero <<...>> para no confundirlo
#     con dos signos simples <...>.
#   - Esta regla no interpreta el contenido interno.
#
# =========================================================

check_inline_angle_delimiters <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  folio_pattern <- "^\\[fol\\.\\s*[0-9]{1,4}[rv]\\]$"
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    if (grepl(folio_pattern, line, perl = TRUE)) {
      next
    }
    
    chars <- strsplit(
      line,
      "",
      fixed = TRUE
    )[[1]]
    
    if (length(chars) == 0) {
      next
    }
    
    i <- 1
    
    while (i <= length(chars)) {
      
      current <- chars[[i]]
      next_char <- if (i < length(chars)) chars[[i + 1]] else ""
      two_chars <- paste0(current, next_char)
      
      # ---------------------------------------------
      # Superescrito <<...>>
      # ---------------------------------------------
      
      if (two_chars == "<<") {
        
        rest <- if (i + 2 <= length(chars)) {
          paste0(chars[(i + 2):length(chars)], collapse = "")
        } else {
          ""
        }
        
        close_pos <- regexpr(">>", rest, fixed = TRUE)[[1]]
        
        if (close_pos == -1) {
          
          issues[[length(issues) + 1]] <- list(
            line = line_no,
            col = i,
            type = "unclosed_superscript_delimiter",
            text = line,
            explanation =
              "El delimitador '<<' debe cerrarse con '>>' en la misma línea física."
          )
          
          break
        }
        
        i <- i + 2 + close_pos + 1
        next
      }
      
      # ---------------------------------------------
      # Cierre superescrito sin apertura
      # ---------------------------------------------
      
      if (two_chars == ">>") {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = i,
          type = "unopened_superscript_delimiter",
          text = line,
          explanation =
            "Aparece '>>' sin apertura '<<' previa en la misma línea física."
        )
        
        i <- i + 2
        next
      }
      
      # ---------------------------------------------
      # Abreviatura <...>
      # ---------------------------------------------
      
      if (current == "<") {
        
        rest <- if (i + 1 <= length(chars)) {
          paste0(chars[(i + 1):length(chars)], collapse = "")
        } else {
          ""
        }
        
        close_pos <- regexpr(">", rest, fixed = TRUE)[[1]]
        
        if (close_pos == -1) {
          
          issues[[length(issues) + 1]] <- list(
            line = line_no,
            col = i,
            type = "unclosed_abbreviation_delimiter",
            text = line,
            explanation =
              "El delimitador '<' debe cerrarse con '>' en la misma línea física."
          )
          
          break
        }
        
        i <- i + close_pos + 1
        next
      }
      
      # ---------------------------------------------
      # Cierre de abreviatura sin apertura
      # ---------------------------------------------
      
      if (current == ">") {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = i,
          type = "unopened_abbreviation_delimiter",
          text = line,
          explanation =
            "Aparece '>' sin apertura '<' previa en la misma línea física."
        )
      }
      
      i <- i + 1
    }
  }
  
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

# =========================================================
# check_angle_delimiter_contents()
# ---------------------------------------------------------
# Regla estructural/editorial HSMS:
#
#   Los delimitadores:
#
#     <...>     abreviatura
#     <<...>>   letra volada / superescrita
#
#   no deben estar vacíos ni contener espacios internos.
#
#   Tampoco deben contener signos angulares internos.
#
# ---------------------------------------------------------
# Casos válidos:
#
#   q<u>
#   q<<a>>
#   q<u><<a>>nto
#
# =========================================================

check_angle_delimiter_contents <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  folio_pattern <- "^\\[fol\\.\\s*[0-9]{1,4}[rv]\\]$"
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    if (grepl(folio_pattern, line, perl = TRUE)) {
      next
    }
    
    # ---------------------------------------------
    # Superescritos <<...>>
    # ---------------------------------------------
    
    superscript_matches <- gregexpr(
      "<<[^<>]*>>",
      line,
      perl = TRUE
    )[[1]]
    
    if (superscript_matches[1] != -1) {
      
      superscript_lengths <- attr(
        superscript_matches,
        "match.length"
      )
      
      for (i in seq_along(superscript_matches)) {
        
        pos <- superscript_matches[[i]]
        len <- superscript_lengths[[i]]
        
        raw <- substr(
          line,
          pos,
          pos + len - 1
        )
        
        content <- substr(
          raw,
          3,
          nchar(raw) - 2
        )
        
        if (content == "") {
          
          issues[[length(issues) + 1]] <- list(
            line = line_no,
            col = pos,
            type = "empty_superscript_delimiter",
            text = line,
            explanation =
              "El delimitador '<<...>>' no puede estar vacío."
          )
          
          next
        }
        
        if (grepl("\\s", content, perl = TRUE)) {
          
          issues[[length(issues) + 1]] <- list(
            line = line_no,
            col = pos,
            type = "space_inside_superscript_delimiter",
            text = line,
            explanation =
              "El delimitador '<<...>>' no debe contener espacios internos."
          )
        }
      }
    }
    
    # ---------------------------------------------
    # Eliminar superescritos válidos antes de revisar
    # abreviaturas simples <...>
    # ---------------------------------------------
    
    line_without_superscripts <- gsub(
      "<<[^<>]*>>",
      "",
      line,
      perl = TRUE
    )
    
    # ---------------------------------------------
    # Abreviaturas <...>
    # ---------------------------------------------
    
    abbreviation_matches <- gregexpr(
      "<[^<>]*>",
      line_without_superscripts,
      perl = TRUE
    )[[1]]
    
    if (abbreviation_matches[1] != -1) {
      
      abbreviation_lengths <- attr(
        abbreviation_matches,
        "match.length"
      )
      
      for (i in seq_along(abbreviation_matches)) {
        
        pos <- abbreviation_matches[[i]]
        len <- abbreviation_lengths[[i]]
        
        raw <- substr(
          line_without_superscripts,
          pos,
          pos + len - 1
        )
        
        content <- substr(
          raw,
          2,
          nchar(raw) - 1
        )
        
        if (content == "") {
          
          issues[[length(issues) + 1]] <- list(
            line = line_no,
            col = pos,
            type = "empty_abbreviation_delimiter",
            text = line,
            explanation =
              "El delimitador '<...>' no puede estar vacío."
          )
          
          next
        }
        
        if (grepl("\\s", content, perl = TRUE)) {
          
          issues[[length(issues) + 1]] <- list(
            line = line_no,
            col = pos,
            type = "space_inside_abbreviation_delimiter",
            text = line,
            explanation =
              "El delimitador '<...>' no debe contener espacios internos."
          )
        }
      }
    }
    
    # ---------------------------------------------
    # Anidamientos angulares evidentes
    # ---------------------------------------------
    #
    # Nota:
    #   No se considera error q<<u>>, porque es
    #   superescrito válido.
    # ---------------------------------------------
    
    if (grepl("<[^>]*<", line_without_superscripts, perl = TRUE) ||
        grepl(">[^<]*>", line_without_superscripts, perl = TRUE)) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = regexpr("<|>", line_without_superscripts, perl = TRUE)[[1]],
        type = "nested_abbreviation_delimiter",
        text = line,
        explanation =
          "Los delimitadores '<...>' no deben anidarse ni contener otros signos angulares."
      )
    }
  }
  
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


# =========================================================
# check_insertion_deletion_marker_format()
# ---------------------------------------------------------
# Regla estructural/editorial HSMS:
#
#   [ ... ]  inserción editorial
#   [^... ]  inserción del copista
#   ( ... )  borrado editorial
#   (^... )  borrado del copista
#
# ---------------------------------------------------------
# Reglas validadas:
#
#   - [] no puede estar vacío.
#   - () no puede estar vacío.
#   - [^ texto] es incorrecto: no debe haber espacio
#     tras el caret.
#   - (^ texto) es incorrecto: no debe haber espacio
#     tras el caret.
#   - [^2# texto] es incorrecto: no debe haber espacio
#     tras #.
#   - [^2 #texto] es incorrecto: no debe haber espacio
#     entre número y #.
#
# ---------------------------------------------------------
# Nota:
#
#   No se revisa aquí [fol. nnnr/v].
#
# =========================================================

check_insertion_deletion_marker_format <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  folio_pattern <- "^\\[fol\\.\\s*[0-9]{1,4}[rv]\\]$"
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    if (grepl(folio_pattern, line, perl = TRUE)) {
      next
    }
    
    # ---------------------------------------------
    # Inserción vacía []
    # ---------------------------------------------
    
    pos <- regexpr("\\[\\]", line, perl = TRUE)[[1]]
    
    if (pos != -1) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = pos,
        type = "empty_insertion_brackets",
        text = line,
        explanation =
          "Los corchetes de inserción no pueden estar completamente vacíos; use '[ ]' si lo insertado es un espacio."
      )
    }
    
    # ---------------------------------------------
    # Borrado vacío ()
    # ---------------------------------------------
    
    pos <- regexpr("\\(\\)", line, perl = TRUE)[[1]]
    
    if (pos != -1) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = pos,
        type = "empty_deletion_parentheses",
        text = line,
        explanation =
          "Los paréntesis de borrado no pueden estar completamente vacíos; use '( )' si lo borrado es un espacio."
      )
    }
    
    # ---------------------------------------------
    # Inserción del copista con espacio tras ^
    # ---------------------------------------------
    
    pos <- regexpr("\\[\\^\\s", line, perl = TRUE)[[1]]
    
    if (pos != -1) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = pos,
        type = "space_after_scribal_insertion_caret",
        text = line,
        explanation =
          "En una inserción del copista, el texto debe seguir inmediatamente a '[^' sin espacio."
      )
    }
    
    # ---------------------------------------------
    # Borrado del copista con espacio tras ^
    # ---------------------------------------------
    
    pos <- regexpr("\\(\\^\\s", line, perl = TRUE)[[1]]
    
    if (pos != -1) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = pos,
        type = "space_after_scribal_deletion_caret",
        text = line,
        explanation =
          "En un borrado del copista, el texto debe seguir inmediatamente a '(^' sin espacio."
      )
    }
    
    # ---------------------------------------------
    # Mano no original: espacio entre número y #
    # ---------------------------------------------
    
    pos <- regexpr("\\[\\^[0-9]+\\s+#", line, perl = TRUE)[[1]]
    
    if (pos != -1) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = pos,
        type = "space_before_nonoriginal_hand_hash",
        text = line,
        explanation =
          "En una inserción de mano no original debe escribirse [^2#texto], sin espacio entre el número y '#'."
      )
    }
    
    # ---------------------------------------------
    # Mano no original: espacio después de #
    # ---------------------------------------------
    
    pos <- regexpr("\\[\\^[0-9]+#\\s", line, perl = TRUE)[[1]]
    
    if (pos != -1) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = pos,
        type = "space_after_nonoriginal_hand_hash",
        text = line,
        explanation =
          "En una inserción de mano no original, el texto debe seguir inmediatamente a '#'."
      )
    }
  }
  
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

# =========================================================
# check_crosshatch_usage()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   El signo "#" indica una mano no original.
#
# ---------------------------------------------------------
# Regla:
#
#   "#" debe aparecer inmediatamente después de un número
#   arábigo que sigue a "^".
#
#   Formas válidas:
#
#     [^2#texto]
#     (^2#texto)
#     [*^2#texto]
#
# ---------------------------------------------------------
# Casos inválidos:
#
#     #texto
#     texto # texto
#     [^#texto]
#     (^#texto)
#     [*^#texto]
#     [^2 #texto]
#     [^2# texto]
#     (^2 #texto)
#     (^2# texto)
#
# ---------------------------------------------------------
# Nota:
#
#   La mano original no lleva número ni "#":
#
#     [^texto]
#     (^texto)
#     [*^texto]
#
# =========================================================

check_crosshatch_usage <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    hash_positions <- gregexpr(
      "#",
      line,
      fixed = TRUE
    )[[1]]
    
    if (hash_positions[1] == -1) next
    
    for (pos in hash_positions) {
      
      before_hash <- substr(
        line,
        1,
        pos - 1
      )
      
      after_hash <- substr(
        line,
        pos + 1,
        nchar(line)
      )
      
      # ---------------------------------------------
      # Casos ya cubiertos por reglas específicas
      # ---------------------------------------------
      
      already_handled <- grepl(
        "\\[\\^[0-9]+\\s+#|\\[\\^[0-9]+#\\s|\\[\\*\\^[0-9]+\\s+#|\\[\\*\\^[0-9]+#\\s|\\[\\*\\^#",
        line,
        perl = TRUE
      )
      
      if (already_handled) {
        next
      }
      
      valid_context <- grepl(
        "(\\[\\^[0-9]+|\\(\\^[0-9]+|\\[\\*\\^[0-9]+)$",
        before_hash,
        perl = TRUE
      )
      
      valid_after <- nchar(after_hash) > 0 &&
        !grepl("^\\s", after_hash, perl = TRUE)
      
      if (!valid_context || !valid_after) {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = pos,
          type = "invalid_crosshatch_usage",
          text = line,
          explanation =
            "El signo '#' debe aparecer inmediatamente después de un número arábigo que sigue a '^', sin espacios, como en [^2#texto], (^2#texto) o [*^2#texto]."
        )
      }
    }
  }
  
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

# =========================================================
# check_reconstruction_marker_format()
# ---------------------------------------------------------
# Regla estructural/editorial HSMS:
#
#   [*texto]       reconstrucción editorial
#   [*^2#texto]    reconstrucción en mano no original
#
# ---------------------------------------------------------
# Reglas validadas:
#
#   - [*] no puede estar vacío.
#   - No debe haber espacio después de '*'.
#   - En [*^2#texto], no debe haber espacios entre
#     '*', '^', número, '#', y el texto.
#
# =========================================================

check_reconstruction_marker_format <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  folio_pattern <- "^\\[fol\\.\\s*[0-9]{1,4}[rv]\\]$"
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    if (grepl(folio_pattern, line, perl = TRUE)) {
      next
    }
    
    checks <- list(
      list(
        pattern = "\\[\\*\\]",
        type = "empty_reconstruction_brackets",
        explanation = "La reconstrucción '[*...]' no puede estar vacía."
      ),
      list(
        pattern = "\\[\\*\\s",
        type = "space_after_reconstruction_asterisk",
        explanation = "En una reconstrucción, el texto debe seguir inmediatamente a '[*' sin espacio."
      ),
      list(
        pattern = "\\[\\*\\^\\s",
        type = "space_after_reconstruction_caret",
        explanation = "En una reconstrucción de mano no original, no debe haber espacio después de '^'."
      ),
      list(
        pattern = "\\[\\*\\^[0-9]+\\s+#",
        type = "space_before_reconstruction_hash",
        explanation = "En '[*^2#texto]' no debe haber espacio entre el número y '#'."
      ),
      list(
        pattern = "\\[\\*\\^[0-9]+#\\s",
        type = "space_after_reconstruction_hash",
        explanation = "En '[*^2#texto]' el texto debe seguir inmediatamente a '#'."
      ),
      list(
        pattern = "\\[\\*\\^[^0-9]",
        type = "invalid_reconstruction_hand_marker",
        explanation = "Una reconstrucción en mano no original debe usar la forma '[*^2#texto]'."
      )
    )
    
    for (check in checks) {
      
      pos <- regexpr(
        check$pattern,
        line,
        perl = TRUE
      )[[1]]
      
      if (pos != -1) {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = pos,
          type = check$type,
          text = line,
          explanation = check$explanation
        )
      }
    }
  }
  
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

# =========================================================
# check_illegibility_marker_format()
# ---------------------------------------------------------
# Regla estructural/editorial HSMS:
#
#   La ilegibilidad se marca con:
#
#     [??]       parte de palabra ilegible
#     [???]      palabra/frase ilegible
#     [?? ???]   combinación documentada
#
#   También puede aparecer dentro de borrados:
#
#     (??)
#     (???)
#     (^??)
#     (^???)
#
# ---------------------------------------------------------
# Reglas validadas:
#
#   - No se permite [?].
#   - No se permiten cuatro o más interrogaciones.
#   - No se permite separar los signos: [? ?], [?? ?].
#   - No se permite contenido mixto con interrogaciones
#     salvo [?? ???].
#
# =========================================================

check_illegibility_marker_format <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  folio_pattern <- "^\\[fol\\.\\s*[0-9]{1,4}[rv]\\]$"
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    if (grepl(folio_pattern, line, perl = TRUE)) {
      next
    }
    
    # ---------------------------------------------
    # Corchetes con interrogaciones
    # ---------------------------------------------
    
    bracket_matches <- gregexpr(
      "\\[[^\\]]*\\?[^\\]]*\\]",
      line,
      perl = TRUE
    )[[1]]
    
    if (bracket_matches[1] != -1) {
      
      bracket_lengths <- attr(
        bracket_matches,
        "match.length"
      )
      
      for (i in seq_along(bracket_matches)) {
        
        pos <- bracket_matches[[i]]
        len <- bracket_lengths[[i]]
        
        raw <- substr(
          line,
          pos,
          pos + len - 1
        )
        
        content <- substr(
          raw,
          2,
          nchar(raw) - 1
        )
        
        valid <- content %in% c(
          "??",
          "???",
          "?? ???"
        )
        
        if (!valid) {
          
          issues[[length(issues) + 1]] <- list(
            line = line_no,
            col = pos,
            type = "invalid_illegibility_brackets",
            text = line,
            explanation =
              "La ilegibilidad entre corchetes debe marcarse como [??], [???] o [?? ???]."
          )
        }
      }
    }
    
    # ---------------------------------------------
    # Paréntesis de borrado con interrogaciones
    # ---------------------------------------------
    
    parenthesis_matches <- gregexpr(
      "\\([^\\)]*\\?[^\\)]*\\)",
      line,
      perl = TRUE
    )[[1]]
    
    if (parenthesis_matches[1] != -1) {
      
      parenthesis_lengths <- attr(
        parenthesis_matches,
        "match.length"
      )
      
      for (i in seq_along(parenthesis_matches)) {
        
        pos <- parenthesis_matches[[i]]
        len <- parenthesis_lengths[[i]]
        
        raw <- substr(
          line,
          pos,
          pos + len - 1
        )
        
        content <- substr(
          raw,
          2,
          nchar(raw) - 1
        )
        
        valid <- content %in% c(
          "??",
          "???",
          "^??",
          "^???"
        )
        
        if (!valid) {
          
          issues[[length(issues) + 1]] <- list(
            line = line_no,
            col = pos,
            type = "invalid_illegibility_parentheses",
            text = line,
            explanation =
              "La ilegibilidad dentro de borrado debe marcarse como (??), (???), (^??) o (^???)."
          )
        }
      }
    }
  }
  
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

# =========================================================
# check_deletion_insertion_combination_format()
# ---------------------------------------------------------
# Regla estructural/editorial HSMS:
#
#   En una combinación borrado + inserción:
#
#     (^o)[^a]
#     (m)[nn]
#
#   no debe haber espacio entre ")" y "[" cuando se trata
#   de sustitución de caracteres o segmentos de palabra.
#
# ---------------------------------------------------------
# Nota:
#
#   No se valida aquí el espaciado de palabras completas,
#   porque depende del contexto editorial.
#
# =========================================================

check_deletion_insertion_combination_format <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  folio_pattern <- "^\\[fol\\.\\s*[0-9]{1,4}[rv]\\]$"
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    if (grepl(folio_pattern, line, perl = TRUE)) {
      next
    }
    
    # ---------------------------------------------
    # Espacio indebido entre borrado e inserción
    # cuando ambos parecen ser segmentos sin espacios.
    # ---------------------------------------------
    
    matches <- gregexpr(
      "\\((\\^?[[:alnum:]<>~$#?]+)\\)\\s+\\[(\\^?[[:alnum:]<>~$#?]+)\\]",
      line,
      perl = TRUE
    )[[1]]
    
    if (matches[1] == -1) {
      next
    }
    
    for (pos in matches) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = pos,
        type = "space_between_deletion_and_insertion",
        text = line,
        explanation =
          "En una sustitución de caracteres o segmentos, el borrado y la inserción deben ir juntos: '(x)[y]', sin espacio intermedio."
      )
    }
  }
  
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


# =========================================================
# check_mnemonics_inside_insertions_deletions()
# ---------------------------------------------------------
# Regla HSMS:
#
#   En general, una etiqueta no puede aparecer dentro de:
#
#     [ ... ]
#     ( ... )
#
#   porque las etiquetas no son texto.
#
# ---------------------------------------------------------
# Excepción editorial documentada:
#
#   Dentro de {AD. ...} y {GL. ...}, la inserción [^ ... ]
#   puede contener etiquetas no estructurales, por ejemplo:
#
#     {GL. [^{HEB. ...}]}
#     {GL. [^{LAT. ...}]}
#     {AD. [^{RUB. ...}]}
#     {GL. [^{IN1.} Fijas de tiro]}
#     {GL. [^{SYMB.}]}
#     {AD. [^{=MIN: occupies 8 lines.}]}
#     {GL. [^texto {RMK: ... .}]}
#
#   Siguen prohibidos dentro de estas inserciones:
#
#     CB, HD, CW, SG
#
#   porque son etiquetas estructurales del documento,
#   no contenido textual de la glosa o adición.
#
# =========================================================

check_mnemonics_inside_insertions_deletions <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  structural_tags_not_allowed_in_ad_gl_insertion <- c(
    "CB", "HD", "CW", "SG"
  )
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    # ---------------------------------------------
    # Corchetes
    # ---------------------------------------------
    
    bracket_matches <- gregexpr(
      "\\[[^\\]]*\\{=?[A-Za-z]+[0-9]*=?[\\.:]",
      line,
      perl = TRUE
    )[[1]]
    
    if (bracket_matches[1] != -1) {
      
      for (pos in bracket_matches) {
        
        before_bracket <- substr(
          line,
          1,
          pos - 1
        )
        
        bracket_fragment <- substr(
          line,
          pos,
          nchar(line)
        )
        
        # -----------------------------------------
        # ¿Es una inserción scribal [^ ... ]?
        # -----------------------------------------
        
        is_scribal_insertion <- grepl(
          "^\\[\\^",
          bracket_fragment,
          perl = TRUE
        )
        
        # -----------------------------------------
        # ¿La inserción está dentro de AD o GL?
        # -----------------------------------------
        #
        # Esta prueba es deliberadamente local:
        # busca un {AD. o {GL. abierto antes del
        # corchete en la misma línea.
        # -----------------------------------------
        
        inside_ad_gl <- grepl(
          "\\{(AD|GL)\\.[^\\}]*$",
          before_bracket,
          perl = TRUE
        )
        
        # -----------------------------------------
        # Extraer la primera etiqueta encontrada
        # dentro del corchete.
        # -----------------------------------------
        
        m <- regexec(
          "\\{=?([A-Za-z]+)[0-9]*=?[\\.:]",
          bracket_fragment,
          perl = TRUE
        )
        
        r <- regmatches(
          bracket_fragment,
          m
        )[[1]]
        
        tag <- if (length(r) > 0) {
          toupper(r[[2]])
        } else {
          NA_character_
        }
        
        allowed_ad_gl_insertion <-
          is_scribal_insertion &&
          inside_ad_gl &&
          !is.na(tag) &&
          !tag %in% structural_tags_not_allowed_in_ad_gl_insertion
        
        if (allowed_ad_gl_insertion) {
          next
        }
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = pos,
          type = "mnemonic_inside_insertion",
          text = line,
          explanation =
            "Las etiquetas no pueden aparecer dentro de corchetes de inserción, salvo etiquetas no estructurales dentro de inserciones [^...] en {AD.} o {GL.}."
        )
      }
    }
    
    # ---------------------------------------------
    # Paréntesis
    # ---------------------------------------------
    #
    # La excepción AD/GL afecta solo a inserciones [^...],
    # no a borrados entre paréntesis.
    # ---------------------------------------------
    
    parenthesis_matches <- gregexpr(
      "\\([^\\)]*\\{[A-Z=]+[0-9]*[\\.:]",
      line,
      perl = TRUE
    )[[1]]
    
    if (parenthesis_matches[1] != -1) {
      
      for (pos in parenthesis_matches) {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = pos,
          type = "mnemonic_inside_deletion",
          text = line,
          explanation =
            "Las etiquetas no pueden aparecer dentro de paréntesis de borrado."
        )
      }
    }
  }
  
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

# =========================================================
# check_insertions_deletions_do_not_cross_mnemonics()
# ---------------------------------------------------------
# Regla HSMS:
#
#   Los corchetes [ ] y paréntesis ( ) abiertos dentro
#   de una etiqueta deben cerrarse antes de la llave "}"
#   que cierra esa misma etiqueta.
#
# =========================================================

check_insertions_deletions_do_not_cross_mnemonics <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  mnemonic_open_pattern <- "\\{=?[A-Za-z]+[0-9]*=?[\\.:]"
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    mnemonic_starts <- gregexpr(
      mnemonic_open_pattern,
      line,
      perl = TRUE
    )[[1]]
    
    if (mnemonic_starts[1] == -1) {
      next
    }
    
    for (start_pos in mnemonic_starts) {
      
      mnemonic_fragment <- substr(
        line,
        start_pos,
        nchar(line)
      )
      
      m_tag <- regexec(
        "^\\{=?([A-Za-z]+)[0-9]*=?[\\.:]",
        mnemonic_fragment,
        perl = TRUE
      )
      
      r_tag <- regmatches(
        mnemonic_fragment,
        m_tag
      )[[1]]
      
      current_tag <- if (length(r_tag) > 0) {
        toupper(r_tag[[2]])
      } else {
        NA_character_
      }
      
      # -------------------------------------------------
      # Excepción AD/GL
      # -------------------------------------------------
      #
      # Esta función usa una comprobación local sencilla:
      # considera que el primer "}" cierra la etiqueta.
      # Eso falla en casos documentados como:
      #
      #   {GL. [^{LAT. ...}]}
      #   {GL. [^Canonico. {RMK: marginal gloss in Latin.}]}
      #
      # porque la primera "}" puede cerrar una etiqueta
      # interno, no GL.
      #
      # AD y GL tienen una excepción editorial específica:
      # pueden contener inserciones del copista [^ ... ] con
      # etiquetas no estructurales internos.
      #
      # Los errores reales en estos casos quedan cubiertos por:
      #
      #   - check_mnemonics_inside_insertions_deletions()
      #   - check_balanced_pairs()
      #
      # -------------------------------------------------
      
      if (!is.na(current_tag) && current_tag %in% c("AD", "GL")) {
        next
      }
      
      close_pos_rel <- regexpr(
        "\\}",
        substr(line, start_pos, nchar(line)),
        perl = TRUE
      )[[1]]
      
      if (close_pos_rel == -1) {
        next
      }
      
      close_pos <- start_pos + close_pos_rel - 1
      
      content <- substr(
        line,
        start_pos,
        close_pos
      )
      
      open_square <- gregexpr(
        "\\[",
        content,
        perl = TRUE
      )[[1]]
      
      close_square <- gregexpr(
        "\\]",
        content,
        perl = TRUE
      )[[1]]
      
      n_open_square <- if (open_square[1] == -1) 0 else length(open_square)
      n_close_square <- if (close_square[1] == -1) 0 else length(close_square)
      
      if (n_open_square != n_close_square) {
        
        first_square <- if (open_square[1] != -1) {
          start_pos + open_square[[1]] - 1
        } else {
          start_pos
        }
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = first_square,
          type = "insertion_crosses_mnemonic_container",
          text = line,
          explanation =
            "Los corchetes abiertos dentro de una etiqueta deben cerrarse antes de la llave que cierra esa etiqueta."
        )
      }
      
      open_paren <- gregexpr(
        "\\(",
        content,
        perl = TRUE
      )[[1]]
      
      close_paren <- gregexpr(
        "\\)",
        content,
        perl = TRUE
      )[[1]]
      
      n_open_paren <- if (open_paren[1] == -1) 0 else length(open_paren)
      n_close_paren <- if (close_paren[1] == -1) 0 else length(close_paren)
      
      if (n_open_paren != n_close_paren) {
        
        first_paren <- if (open_paren[1] != -1) {
          start_pos + open_paren[[1]] - 1
        } else {
          start_pos
        }
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = first_paren,
          type = "deletion_crosses_mnemonic_container",
          text = line,
          explanation =
            "Los paréntesis abiertos dentro de una etiqueta deben cerrarse antes de la llave que cierra esa etiqueta."
        )
      }
    }
  }
  
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


# =========================================================
# check_insertions_deletions_do_not_cross_textual_containers()
# ---------------------------------------------------------
# Regla HSMS:
#
#   Los corchetes [ ] y paréntesis ( ) abiertos dentro
#   de un contenedor textual deben cerrarse antes de
#   la llave "}" que cierra ese contenedor.
#
# ---------------------------------------------------------
# Contenedores textuales:
#
#   CB, CW, DIAG, HD, MIN, RUB, SYMB, SG,
#   etiquetas de lengua.
#
# ---------------------------------------------------------
# No incluye:
#
#   AD
#   GL
#   BLNK
#   IN
#   ILL
#   RMK
#
# ---------------------------------------------------------
# Nota sobre AD, GL y RMK:
#
#   AD y GL se excluyen de esta regla general porque
#   pueden contener inserciones del copista [^ ... ] con
#   etiquetas no estructurales internas, por ejemplo:
#
#     {GL. [^Canonico. {RMK: marginal gloss in Latin.}]}
#     {AD. [^{RUB. texto añadido}]}
#
#   Además, esta función no debe interpretar la llave que
#   cierra un RMK interno como si cerrara el contenedor
#   textual exterior.
#
#   Por eso, ciertas etiquetas cerradas en la misma línea
#   se saltan como bloque completo.
#
# ---------------------------------------------------------
# Nota:
#
#   ((...)) no se trata como borrado.
#
# =========================================================

check_insertions_deletions_do_not_cross_textual_containers <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  textual_containers <- c(
    "CB", "CW", "DIAG", "HD", "MIN", "RUB", "SYMB", "SG",
    "ARB", "ARG", "ARM", "BAS", "CAL", "CAT", "ENG",
    "FRN", "GAL", "GER", "GRK", "HEB", "ITL", "LAM",
    "LAT", "PRT", "PRV"
  )
  
  skip_as_block <- c(
    "AD", "GL", "RMK", "BLNK", "IN", "ILL"
  )
  
  folio_pattern <- "^\\[fol\\.\\s*[0-9]{1,4}[rv]\\]$"
  mnemonic_pattern <- "^\\{=?([A-Za-z]+)[0-9]*=?[\\.:]"
  
  find_matching_brace <- function(chars, start_index) {
    
    depth <- 0
    
    for (j in seq(from = start_index, to = length(chars))) {
      
      if (chars[[j]] == "{") {
        depth <- depth + 1
      }
      
      if (chars[[j]] == "}") {
        depth <- depth - 1
        
        if (depth == 0) {
          return(j)
        }
      }
    }
    
    NA_integer_
  }
  
  issues <- list()
  
  container_stack <- list()
  insertion_stack <- list()
  deletion_stack <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    if (grepl(folio_pattern, line, perl = TRUE)) {
      next
    }
    
    chars <- strsplit(
      line,
      "",
      fixed = TRUE
    )[[1]]
    
    if (length(chars) == 0) {
      next
    }
    
    i <- 1
    
    while (i <= length(chars)) {
      
      ch <- chars[[i]]
      next_ch <- if (i < length(chars)) chars[[i + 1]] else ""
      rest <- substr(line, i, nchar(line))
      
      # ---------------------------------------------
      # Apertura de etiqueta
      # ---------------------------------------------
      
      m <- regexec(
        mnemonic_pattern,
        rest,
        perl = TRUE
      )
      
      r <- regmatches(rest, m)[[1]]
      
      if (length(r) > 0) {
        
        tag <- toupper(r[[2]])
        
        # ---------------------------------------------
        # Mnemónicos que se saltan como bloque completo
        # ---------------------------------------------
        #
        # Esto evita que la llave de cierre de un RMK
        # interno sea interpretada como cierre del
        # contenedor textual exterior.
        # ---------------------------------------------
        
        if (tag %in% skip_as_block) {
          
          close_pos <- find_matching_brace(
            chars = chars,
            start_index = i
          )
          
          if (!is.na(close_pos)) {
            i <- close_pos + 1
            next
          }
        }
        
        if (tag %in% textual_containers) {
          
          container_stack[[length(container_stack) + 1]] <- list(
            tag = tag,
            line = line_no,
            col = i
          )
        }
        
        i <- i + 1
        next
      }
      
      # ---------------------------------------------
      # Apertura de inserción [
      # ---------------------------------------------
      
      if (ch == "[") {
        
        insertion_stack[[length(insertion_stack) + 1]] <- list(
          line = line_no,
          col = i,
          container_depth = length(container_stack)
        )
        
        i <- i + 1
        next
      }
      
      # ---------------------------------------------
      # Cierre de inserción ]
      # ---------------------------------------------
      
      if (ch == "]") {
        
        if (length(insertion_stack) > 0) {
          insertion_stack <- insertion_stack[-length(insertion_stack)]
        }
        
        i <- i + 1
        next
      }
      
      # ---------------------------------------------
      # Fósil histórico: no tratar ((...)) como borrado
      # ---------------------------------------------
      
      if (ch == "(" && next_ch == "(") {
        i <- i + 2
        next
      }
      
      if (ch == ")" && next_ch == ")") {
        i <- i + 2
        next
      }
      
      # ---------------------------------------------
      # Apertura de borrado (
      # ---------------------------------------------
      
      if (ch == "(") {
        
        deletion_stack[[length(deletion_stack) + 1]] <- list(
          line = line_no,
          col = i,
          container_depth = length(container_stack)
        )
        
        i <- i + 1
        next
      }
      
      # ---------------------------------------------
      # Cierre de borrado )
      # ---------------------------------------------
      
      if (ch == ")") {
        
        if (length(deletion_stack) > 0) {
          deletion_stack <- deletion_stack[-length(deletion_stack)]
        }
        
        i <- i + 1
        next
      }
      
      # ---------------------------------------------
      # Cierre de contenedor textual
      # ---------------------------------------------
      
      if (ch == "}" && length(container_stack) > 0) {
        
        current_depth <- length(container_stack)
        
        open_insertions <- insertion_stack[
          vapply(
            insertion_stack,
            function(x) x$container_depth >= current_depth,
            logical(1)
          )
        ]
        
        if (length(open_insertions) > 0) {
          
          open <- open_insertions[[length(open_insertions)]]
          
          issues[[length(issues) + 1]] <- list(
            line = open$line,
            col = open$col,
            type = "insertion_crosses_textual_container",
            text = lines[[open$line]],
            explanation =
              "Los corchetes abiertos dentro de un contenedor textual deben cerrarse antes de la llave que cierra ese contenedor."
          )
          
          insertion_stack <- insertion_stack[
            vapply(
              insertion_stack,
              function(x) x$container_depth < current_depth,
              logical(1)
            )
          ]
        }
        
        open_deletions <- deletion_stack[
          vapply(
            deletion_stack,
            function(x) x$container_depth >= current_depth,
            logical(1)
          )
        ]
        
        if (length(open_deletions) > 0) {
          
          open <- open_deletions[[length(open_deletions)]]
          
          issues[[length(issues) + 1]] <- list(
            line = open$line,
            col = open$col,
            type = "deletion_crosses_textual_container",
            text = lines[[open$line]],
            explanation =
              "Los paréntesis abiertos dentro de un contenedor textual deben cerrarse antes de la llave que cierra ese contenedor."
          )
          
          deletion_stack <- deletion_stack[
            vapply(
              deletion_stack,
              function(x) x$container_depth < current_depth,
              logical(1)
            )
          ]
        }
        
        container_stack <- container_stack[-length(container_stack)]
        
        i <- i + 1
        next
      }
      
      i <- i + 1
    }
  }
  
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

# =========================================================
# check_double_parenthesis_spacing()
# ---------------------------------------------------------
# OBSOLETA / FÓSIL HISTÓRICO.
#
# En una fase anterior, los paréntesis reales del texto
# se representaban mediante:
#
#   (( ... ))
#
# Esta convención ha sido sustituida por:
#
#   ≺ ... ≻
#
# Por tanto, ((...)) ya no debe usarse en nuevas
# transcripciones.
#
# ---------------------------------------------------------
# Motivo de la obsolescencia:
#
#   ((...)) podía producir falsos errores de balanceo,
#   especialmente cuando el paréntesis real se abría en
#   una columna y se cerraba en otra.
#
#   Además, entraba en conflicto con la regla HSMS según
#   la cual:
#
#     ( ... )
#
#   representa un borrado.
#
# ---------------------------------------------------------
# Estado actual:
#
#   Esta función se conserva solo como memoria histórica.
#   No debe llamarse en la validación normal.
#
# =========================================================

check_double_parenthesis_spacing <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    checks <- list(
      list(
        pattern = "\\(\\(\\)\\)",
        type = "empty_double_parenthesis",
        explanation =
          "El paréntesis doble '((...))' no puede estar vacío."
      ),
      list(
        pattern = "\\(\\(\\s",
        type = "space_after_double_parenthesis_open",
        explanation =
          "No debe haber espacio inmediatamente después de '(('."
      ),
      list(
        pattern = "\\s\\)\\)",
        type = "space_before_double_parenthesis_close",
        explanation =
          "No debe haber espacio inmediatamente antes de '))'."
      )
    )
    
    for (check in checks) {
      
      pos <- regexpr(
        check$pattern,
        line,
        perl = TRUE
      )[[1]]
      
      if (pos != -1) {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = pos,
          type = check$type,
          text = line,
          explanation = check$explanation
        )
      }
    }
  }
  
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

# =========================================================
# check_mnemonic_uppercase()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   Las etiquetas HSMS deben escribirse en mayúsculas.
#
# ---------------------------------------------------------
# Objetivo
# ---------------------------------------------------------
#
#   Detectar etiquetas conocidas escritas parcial o
#   totalmente en minúsculas.
#
# ---------------------------------------------------------
# Notas
# ---------------------------------------------------------
#
#   Utiliza extract_hsms_mnemonics() como parser central.
#
#   Solo se validan etiquetas reconocidas por el catálogo.
#   Las etiquetas desconocidas se detectan en:
#
#     check_unknown_structural_tags()
#
# =========================================================

check_mnemonic_uppercase <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  catalog <- hsms_structural_tag_catalog()
  
  mnemonics <- extract_hsms_mnemonics(lines)
  
  issues <- list()
  
  if (nrow(mnemonics) == 0) {
    
    return(data.frame(
      line = integer(0),
      col = integer(0),
      type = character(0),
      text = character(0),
      explanation = character(0)
    ))
  }
  
  for (i in seq_len(nrow(mnemonics))) {
    
    row <- mnemonics[i, ]
    
    raw <- row$raw[[1]]
    
    tag_raw <- sub(
      "^\\{=?([A-Za-z]+).*$",
      "\\1",
      raw,
      perl = TRUE
    )
    
    tag_upper <- toupper(tag_raw)
    
    if (!tag_upper %in% catalog$tag) {
      next
    }
    
    if (tag_raw != tag_upper) {
      
      issues[[length(issues) + 1]] <- list(
        line = row$line[[1]],
        col = row$col[[1]],
        type = "mnemonic_not_uppercase",
        text = lines[[row$line[[1]]]],
        explanation = paste0(
          "La etiqueta {",
          tag_raw,
          " debe escribirse en mayúsculas."
        )
      )
    }
  }
  
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


# =========================================================
# check_unknown_structural_tags()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   Detecta etiquetas no definidos en el catálogo.
#
# ---------------------------------------------------------
# Objetivo
# ---------------------------------------------------------
#
#   Validar que todas las etiquetas estructurales usadas
#   en el fichero existan en:
#
#     hsms_structural_tag_catalog()
#
# ---------------------------------------------------------
# Notas
# ---------------------------------------------------------
#
#   Esta función utiliza:
#
#     extract_hsms_mnemonics()
#
# como parser central de etiquetas.
#
# =========================================================

check_unknown_structural_tags <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  catalog <- hsms_structural_tag_catalog()
  
  mnemonics <- extract_hsms_mnemonics(lines)
  
  issues <- list()
  
  if (nrow(mnemonics) == 0) {
    
    return(data.frame(
      line = integer(0),
      col = integer(0),
      type = character(0),
      text = character(0),
      explanation = character(0)
    ))
  }
  
  for (i in seq_len(nrow(mnemonics))) {
    
    row <- mnemonics[i, ]
    
    tag <- row$tag[[1]]
    
    if (!tag %in% catalog$tag) {
      
      issues[[length(issues) + 1]] <- list(
        line = row$line[[1]],
        col = row$col[[1]],
        type = "unknown_structural_tag",
        text = lines[[row$line[[1]]]],
        explanation = paste0(
          "Etiqueta estructural desconocida: {",
          tag,
          "."
        )
      )
    }
  }
  
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

# =========================================================
# check_unexpected_numbered_tags()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   Detecta etiquetas que llevan número aunque el catálogo
#   indique que no deben llevarlo.
#
# ---------------------------------------------------------
# Ejemplos válidos:
#
#   {CB1.
#   {IN2.
#   {HD.
#   {HD1.
#
# ---------------------------------------------------------
# Ejemplos inválidos:
#
#   {LAT1.
#   {RMK1:
#   {RUB2.
#
# ---------------------------------------------------------
# Notas
# ---------------------------------------------------------
#
#   Utiliza extract_hsms_mnemonics() como parser central.
#
#   En la columna numbered del catálogo:
#
#     TRUE  = requiere/admite número
#     FALSE = no admite número
#     NA    = número opcional
#
# =========================================================

check_unexpected_numbered_tags <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  catalog <- hsms_structural_tag_catalog()
  
  mnemonics <- extract_hsms_mnemonics(lines)
  
  issues <- list()
  
  if (nrow(mnemonics) == 0) {
    
    return(data.frame(
      line = integer(0),
      col = integer(0),
      type = character(0),
      text = character(0),
      explanation = character(0)
    ))
  }
  
  for (i in seq_len(nrow(mnemonics))) {
    
    row <- mnemonics[i, ]
    
    tag <- row$tag[[1]]
    
    if (!tag %in% catalog$tag) {
      next
    }
    
    has_number <- !is.na(row$number[[1]])
    
    if (!has_number) {
      next
    }
    
    tag_info <- catalog[
      catalog$tag == tag,
      ,
      drop = FALSE
    ]
    
    if (identical(tag_info$numbered[[1]], FALSE)) {
      
      issues[[length(issues) + 1]] <- list(
        line = row$line[[1]],
        col = row$col[[1]],
        type = "unexpected_numbered_tag",
        text = lines[[row$line[[1]]]],
        explanation = paste0(
          "La etiqueta {",
          tag,
          " no debe llevar número."
        )
      )
    }
  }
  
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

# =========================================================
# check_missing_required_numbers()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   Detecta etiquetas que deben llevar número y no lo
#   llevan.
#
# ---------------------------------------------------------
# Ejemplos válidos:
#
#   {CB1.
#   {IN2.
#
# ---------------------------------------------------------
# Ejemplos inválidos:
#
#   {CB.
#   {IN.
#
# ---------------------------------------------------------
# Notas
# ---------------------------------------------------------
#
#   Utiliza extract_hsms_mnemonics() como parser central.
#
#   En el catálogo:
#
#     TRUE  = número obligatorio
#     FALSE = número prohibido
#     NA    = número opcional
#
# =========================================================

check_missing_required_numbers <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  catalog <- hsms_structural_tag_catalog()
  
  mnemonics <- extract_hsms_mnemonics(lines)
  
  issues <- list()
  
  if (nrow(mnemonics) == 0) {
    
    return(data.frame(
      line = integer(0),
      col = integer(0),
      type = character(0),
      text = character(0),
      explanation = character(0)
    ))
  }
  
  for (i in seq_len(nrow(mnemonics))) {
    
    row <- mnemonics[i, ]
    
    tag <- row$tag[[1]]
    
    if (!tag %in% catalog$tag) {
      next
    }
    
    tag_info <- catalog[
      catalog$tag == tag,
      ,
      drop = FALSE
    ]
    
    requires_number <- identical(
      tag_info$numbered[[1]],
      TRUE
    )
    
    if (!requires_number) {
      next
    }
    
    has_number <- !is.na(row$number[[1]])
    
    if (!has_number) {
      
      issues[[length(issues) + 1]] <- list(
        line = row$line[[1]],
        col = row$col[[1]],
        type = "missing_required_number",
        text = lines[[row$line[[1]]]],
        explanation = paste0(
          "La etiqueta {",
          tag,
          " debe llevar número."
        )
      )
    }
  }
  
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

# =========================================================
# check_tag_delimiters()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   Cada etiqueta debe usar el delimitador definido
#   en el catálogo.
#
# ---------------------------------------------------------
# Ejemplos válidos:
#
#   {LAT.
#   {RMK:
#   {CB1.
#
# ---------------------------------------------------------
# Ejemplos inválidos:
#
#   {LAT:
#   {RMK.
#   {CB1:
#
# ---------------------------------------------------------
# Notas
# ---------------------------------------------------------
#
#   Utiliza extract_hsms_mnemonics() como parser central.
#
# =========================================================

check_tag_delimiters <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  catalog <- hsms_structural_tag_catalog()
  
  mnemonics <- extract_hsms_mnemonics(lines)
  
  issues <- list()
  
  if (nrow(mnemonics) == 0) {
    
    return(data.frame(
      line = integer(0),
      col = integer(0),
      type = character(0),
      text = character(0),
      explanation = character(0)
    ))
  }
  
  for (i in seq_len(nrow(mnemonics))) {
    
    row <- mnemonics[i, ]
    
    tag <- row$tag[[1]]
    
    if (!tag %in% catalog$tag) {
      next
    }
    
    tag_info <- catalog[
      catalog$tag == tag,
      ,
      drop = FALSE
    ]
    
    expected_delimiter <- tag_info$delimiter[[1]]
    
    actual_delimiter <- row$delimiter[[1]]
    
    delimiter_is_valid <- expected_delimiter == actual_delimiter
    
    # ---------------------------------------------
    # Excepciones de delimitador
    # ---------------------------------------------
    #
    # Algunas etiquetas admiten tanto "." como ":"
    # según su uso concreto.
    #
    #   BLNK / SYMB:
    #     ya estaban documentados como flexibles.
    #
    #   DIAG:
    #     puede usar ":" cuando funciona como campo
    #     descriptivo o comentario sobre el diagrama:
    #
    #       {DIAG: Numeric table follows.}
    #       {DIAG: scribally deleted.}
    #       {DIAG: scribally inserted.}
    #       {DIAG: editorially deleted.}
    #
    # ---------------------------------------------
    
    if (tag %in% c("BLNK", "SYMB", "DIAG") &&
        actual_delimiter %in% c(".", ":")) {
      delimiter_is_valid <- TRUE
    }
    
    if (!delimiter_is_valid) {
      
      issues[[length(issues) + 1]] <- list(
        line = row$line[[1]],
        col = row$col[[1]],
        type = "wrong_tag_delimiter",
        text = lines[[row$line[[1]]]],
        explanation = paste0(
          "La etiqueta {",
          tag,
          " debe usar el delimitador '",
          expected_delimiter,
          "'."
        )
      )
    }
  }
  
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

# =========================================================
# get_folio_blocks()
# ---------------------------------------------------------
# Divide un fichero HSMS en bloques de folio.
#
# ---------------------------------------------------------
# Objetivo
# ---------------------------------------------------------
#
#   Proporcionar una estructura común para reglas que
#   necesitan contexto dentro de cada folio.
#
# Esta función NO valida nada.
# Solo localiza:
#
#   - línea inicial del folio;
#   - número de folio;
#   - lado r/v;
#   - línea final antes del siguiente folio.
#
# ---------------------------------------------------------
# Devuelve
# ---------------------------------------------------------
#
#   data.frame con columnas:
#
#     folio_index
#     start_line
#     end_line
#     folio_num
#     folio_side
#
# =========================================================

get_folio_blocks <- function(lines) {
  
  folio_pattern <- "^\\[fol\\.\\s*([0-9]{1,3})([rv])\\]$"
  
  folios <- list()
  
  for (line_no in seq_along(lines)) {
    
    m <- regexec(
      folio_pattern,
      lines[[line_no]],
      perl = TRUE
    )
    
    r <- regmatches(lines[[line_no]], m)[[1]]
    
    if (length(r) > 0) {
      
      folios[[length(folios) + 1]] <- list(
        start_line = line_no,
        folio_num = as.integer(r[2]),
        folio_side = r[3]
      )
    }
  }
  
  if (length(folios) == 0) {
    
    return(data.frame(
      folio_index = integer(0),
      start_line = integer(0),
      end_line = integer(0),
      folio_num = integer(0),
      folio_side = character(0)
    ))
  }
  
  blocks <- list()
  
  for (i in seq_along(folios)) {
    
    start_line <- folios[[i]]$start_line
    
    end_line <- if (i < length(folios)) {
      folios[[i + 1]]$start_line - 1
    } else {
      length(lines)
    }
    
    blocks[[length(blocks) + 1]] <- list(
      folio_index = i,
      start_line = start_line,
      end_line = end_line,
      folio_num = folios[[i]]$folio_num,
      folio_side = folios[[i]]$folio_side
    )
  }
  
  do.call(rbind, lapply(blocks, as.data.frame))
}

# =========================================================
# get_column_boundaries()
# ---------------------------------------------------------
# Localiza etiquetas de columna {CBn. dentro del fichero.
#
# ---------------------------------------------------------
# Objetivo
# ---------------------------------------------------------
#
#   Proporcionar una estructura auxiliar para reglas que
#   necesitan saber dónde comienza una columna.
#
# Esta función NO valida nada.
#
# ---------------------------------------------------------
# Detecta
# ---------------------------------------------------------
#
#   {CBn.
#   {CBn.}
#
# ---------------------------------------------------------
# Devuelve
# ---------------------------------------------------------
#
#   data.frame con columnas:
#
#     line
#     col_number
#     is_empty_column
#
# ---------------------------------------------------------
# Notas
# ---------------------------------------------------------
#
#   Usa extract_hsms_mnemonics() como parser central.
#
# =========================================================

get_column_boundaries <- function(lines) {
  
  mnemonics <- extract_hsms_mnemonics(lines)
  
  if (nrow(mnemonics) == 0) {
    
    return(data.frame(
      line = integer(0),
      col_number = integer(0),
      is_empty_column = logical(0)
    ))
  }
  
  cb_mnemonics <- mnemonics[
    mnemonics$tag == "CB",
    ,
    drop = FALSE
  ]
  
  if (nrow(cb_mnemonics) == 0) {
    
    return(data.frame(
      line = integer(0),
      col_number = integer(0),
      is_empty_column = logical(0)
    ))
  }
  
  boundaries <- list()
  
  for (i in seq_len(nrow(cb_mnemonics))) {
    
    row <- cb_mnemonics[i, ]
    
    line_no <- row$line[[1]]
    
    line <- trimws(
      lines[[line_no]],
      which = "right"
    )
    
    is_valid_cb_boundary <- grepl(
      "^\\{CB[0-9]+\\.\\}?$",
      line,
      perl = TRUE
    )
    
    if (!is_valid_cb_boundary) {
      next
    }
    
    boundaries[[length(boundaries) + 1]] <- list(
      line = line_no,
      col_number = row$number[[1]],
      is_empty_column = grepl(
        "\\}$",
        line,
        perl = TRUE
      )
    )
  }
  
  if (length(boundaries) == 0) {
    
    return(data.frame(
      line = integer(0),
      col_number = integer(0),
      is_empty_column = logical(0)
    ))
  }
  
  do.call(rbind, lapply(boundaries, as.data.frame))
}


# =========================================================
# is_in_post_column_zone()
# ---------------------------------------------------------
# Determina si una línea pertenece a la zona posterior
# a la última columna del folio.
#
# ---------------------------------------------------------
# Regla HSMS
# ---------------------------------------------------------
#
#   {CW.}
#   {SG.}
#
# solo pueden aparecer:
#
#   - después de la última columna válida;
#   - antes del siguiente folio.
#
# ---------------------------------------------------------
# Devuelve:
#
#   TRUE  -> zona posterior a la última columna
#   FALSE -> cualquier otro caso
#
# =========================================================

is_in_post_column_zone <- function(line_no, lines) {
  
  folio_pattern <- "^\\[fol\\.\\s*[0-9]{1,3}[rv]\\]$"
  
  # -------------------------------------------------
  # Folio actual
  # -------------------------------------------------
  
  previous_folios <- grep(
    folio_pattern,
    lines[seq_len(line_no)],
    perl = TRUE
  )
  
  if (length(previous_folios) == 0) {
    return(FALSE)
  }
  
  folio_start <- previous_folios[[length(previous_folios)]]
  
  # -------------------------------------------------
  # Siguiente folio
  # -------------------------------------------------
  
  next_folios <- grep(
    folio_pattern,
    lines,
    perl = TRUE
  )
  
  next_folios <- next_folios[
    next_folios > folio_start
  ]
  
  folio_end <- if (length(next_folios) == 0) {
    length(lines)
  } else {
    next_folios[[1]] - 1
  }
  
  # -------------------------------------------------
  # Columnas válidas del folio
  # -------------------------------------------------
  
  boundaries <- get_column_boundaries(lines)
  
  folio_columns <- boundaries[
    boundaries$line >= folio_start &
      boundaries$line <= folio_end,
    ,
    drop = FALSE
  ]
  
  if (nrow(folio_columns) == 0) {
    return(FALSE)
  }
  
  # -------------------------------------------------
  # Última columna del folio
  # -------------------------------------------------
  
  last_column_line <- max(
    folio_columns$line
  )
  
  # -------------------------------------------------
  # Debe estar después
  # -------------------------------------------------
  
  line_no > last_column_line
}

# =========================================================
# check_cw_sg_position()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   Las etiquetas {CW. y {SG. solo pueden aparecer
#   después del cierre de la columna del folio.
#
# ---------------------------------------------------------
# Reglas:
#
#   1. Deben aparecer después de una línea que cierre
#      columna con "}".
#
#   2. Deben aparecer antes del siguiente folio.
#
#   3. Deben aparecer al comienzo de su línea.
#
# ---------------------------------------------------------
# Ejemplos válidos:
#
#   {CB1.
#   texto}
#   {CW. catchword}
#   {SG. signature}
#   [fol. 2r]
#
# ---------------------------------------------------------
# Ejemplos inválidos:
#
#   {CB1.
#   {CW. catchword}
#   texto}
#
#   texto {CW. catchword}
#
# =========================================================

check_cw_sg_position <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    if (!grepl("\\{(CW|SG)\\.", line, perl = TRUE)) {
      next
    }
    
    if (!grepl("^\\{(CW|SG)\\.", line, perl = TRUE)) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = regexpr("\\{(CW|SG)\\.", line, perl = TRUE)[[1]],
        type = "cw_sg_not_at_line_start",
        text = line,
        explanation =
          "Las etiquetas {CW. y {SG. deben aparecer al comienzo de la línea."
      )
      
      next
    }
    
    if (!is_in_post_column_zone(line_no, lines)) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = 1,
        type = "cw_sg_inside_column",
        text = line,
        explanation =
          "Las etiquetas {CW. y {SG. deben aparecer después del cierre de la columna."
      )
    }
  }
  
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

# =========================================================
# check_cw_sg_line_format()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   Las etiquetas {CW. y {SG. deben tener contenido textual
#   y cerrarse en la misma línea.
#
# ---------------------------------------------------------
# Ejemplos válidos:
#
#   {CW. palabra}
#   {SG. a ii}
#
# ---------------------------------------------------------
# Ejemplos inválidos:
#
#   {CW.
#   {SG.
#   {CW. palabra
#   {SG. a ii
#
# =========================================================

check_cw_sg_line_format <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- trimws(
      lines[[line_no]],
      which = "right"
    )
    
    if (!grepl("^\\{(CW|SG)\\.", line, perl = TRUE)) {
      next
    }
    
    valid_format <- grepl(
      "^\\{(CW|SG)\\.\\s+.+\\}$",
      line,
      perl = TRUE
    )
    
    if (!valid_format) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = 1,
        type = "invalid_cw_sg_format",
        text = lines[[line_no]],
        explanation =
          "Las etiquetas {CW. y {SG. deben tener texto y cerrarse con '}' en la misma línea."
      )
    }
  }
  
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


check_rmk_standalone_context <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  folio_pattern <- "^\\[fol\\.\\s*[0-9]{1,3}[rv]\\]$"
  
  first_folio <- grep(
    folio_pattern,
    lines,
    perl = TRUE
  )
  
  first_folio_line <- if (length(first_folio) == 0) {
    Inf
  } else {
    first_folio[[1]]
  }
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- trimws(
      lines[[line_no]],
      which = "both"
    )
    
    if (!grepl("^\\{RMK:", line, perl = TRUE)) {
      next
    }
    
    if (line_no < first_folio_line && line_no <= 6) {
      next
    }
    
    # Solo es RMK aislada si la línea completa es
    # exactamente un único RMK.
    #
    # No debe marcarse:
    #
    #   {RMK: ... .} {RUB. ...}
    
    is_standalone_rmk <- grepl(
      "^\\{RMK:[^\\}]*\\}$",
      line,
      perl = TRUE
    )
    
    if (is_standalone_rmk) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = 1,
        type = "rmk_standalone_in_text",
        text = lines[[line_no]],
        explanation =
          "La etiqueta {RMK: no debe aparecer sola en una línea dentro del cuerpo textual."
      )
    }
  }
  
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

# =========================================================
# check_rmk_comment_format()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   La etiqueta {RMK: debe:
#
#     - usar ':'
#     - cerrarse con '}' en la misma línea física
#     - terminar en punto antes de '}'
#
# ---------------------------------------------------------
# Cabecera del fichero:
#
#   Antes del primer folio se admite:
#
#     {RMK:.}
#
# ---------------------------------------------------------
# Cuerpo del testimonio:
#
#   Después del primer folio:
#
#     {RMK:.}
#
#   no está permitido.
#
# ---------------------------------------------------------
# Nota:
#
#   RMK no es un contenedor textual y no puede ser
#   multilínea.
#
#   Una RMK puede estar cerrada y seguida de otra
#   etiqueta o de texto en la misma línea:
#
#     {RMK: HSMS-0555-0001: ... .} {IN2.} Aqui...
#
# =========================================================

check_rmk_comment_format <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  folio_pattern <- "^\\[fol\\.\\s*[0-9]{1,4}[rv]\\]$"
  
  first_folio <- grep(
    folio_pattern,
    lines,
    perl = TRUE
  )
  
  first_folio_line <- if (length(first_folio) == 0) {
    Inf
  } else {
    first_folio[[1]]
  }
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- trimws(
      lines[[line_no]],
      which = "both"
    )
    
    # ---------------------------------------------
    # Solo se revisan RMK con delimitador correcto.
    # Los RMK con punto se detectan en:
    #
    #   check_tag_delimiters()
    # ---------------------------------------------
    
    if (!grepl("^\\{RMK:", line, perl = TRUE)) {
      next
    }
    
    # ---------------------------------------------
    # RMK debe cerrarse en la misma línea física
    # ---------------------------------------------
    #
    # No exigimos que la línea termine en "}".
    # Solo exigimos que el token {RMK: ...} tenga
    # una llave de cierre en la misma línea.
    # ---------------------------------------------
    
    rmk_token_match <- regexpr(
      "^\\{RMK:[^\\}]*\\}",
      line,
      perl = TRUE
    )
    
    if (rmk_token_match == -1) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = 1,
        type = "rmk_missing_closing_brace",
        text = lines[[line_no]],
        explanation =
          "La etiqueta {RMK: debe cerrarse con '}' en la misma línea física."
      )
      
      next
    }
    
    rmk_token <- substr(
      line,
      rmk_token_match,
      rmk_token_match + attr(rmk_token_match, "match.length") - 1
    )
    
    # ---------------------------------------------
    # RMK debe terminar en punto antes de }
    # ---------------------------------------------
    #
    # La comprobación se hace sobre el token RMK,
    # no sobre la línea completa.
    # ---------------------------------------------
    
    if (!grepl("\\.\\}$", rmk_token, perl = TRUE)) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = 1,
        type = "rmk_missing_final_period",
        text = lines[[line_no]],
        explanation =
          "La etiqueta {RMK: debe terminar con punto antes de '}'."
      )
      
      next
    }
    
    # ---------------------------------------------
    # RMK vacío solo permitido en cabecera
    # ---------------------------------------------
    
    is_header <- line_no < first_folio_line
    
    if (!is_header && rmk_token == "{RMK:.}") {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = 1,
        type = "empty_rmk_outside_header",
        text = lines[[line_no]],
        explanation =
          "La forma {RMK:.} solo está permitida en la cabecera, antes del primer folio."
      )
    }
  }
  
  if (length(issues) == 0) {
    
    return(data.frame(
      line = integer(0),
      col = integer(0),
      type = character(0),
      text = character(0),
      explanation = character(0)
    ))
  }
  
  do.call(
    rbind,
    lapply(issues, as.data.frame)
  )
}

# =========================================================
# check_initial_rmk_identification_block()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   El bloque inicial de identificación puede contener
#   hasta seis líneas {RMK: ...} antes del primer folio.
#
# ---------------------------------------------------------
# Reglas validadas:
#
#   - Solo las 6 primeras líneas pueden ser RMK iniciales.
#   - Las RMK iniciales deben aparecer antes del primer folio.
#   - Si una RMK inicial contiene barras verticales "|",
#     deben usarse como separadores " | ".
#   - No puede haber barra inicial ni final dentro del texto.
#
# =========================================================

check_initial_rmk_identification_block <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  folio_pattern <- "^\\[fol\\.\\s*[0-9]{1,3}[rv]\\]$"
  
  first_folio <- grep(
    folio_pattern,
    lines,
    perl = TRUE
  )
  
  first_folio_line <- if (length(first_folio) == 0) {
    Inf
  } else {
    first_folio[[1]]
  }
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- trimws(
      lines[[line_no]],
      which = "both"
    )
    
    if (!grepl("^\\{RMK:", line, perl = TRUE)) {
      next
    }
    
    # ---------------------------------------------
    # Solo nos interesa RMK antes del primer folio
    # ---------------------------------------------
    
    if (line_no >= first_folio_line) {
      next
    }
    
    # ---------------------------------------------
    # RMK inicial fuera de las 6 primeras líneas
    # ---------------------------------------------
    
    if (line_no > 6) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = 1,
        type = "initial_rmk_too_late",
        text = lines[[line_no]],
        explanation =
          "Las RMK iniciales de identificación solo pueden ocupar las seis primeras líneas del fichero."
      )
      
      next
    }
    
    # ---------------------------------------------
    # Extraer contenido interno si la línea cierra
    # ---------------------------------------------
    
    if (!grepl("\\}$", line, perl = TRUE)) {
      next
    }
    
    content <- sub(
      "^\\{RMK:\\s*",
      "",
      line,
      perl = TRUE
    )
    
    content <- sub(
      "\\}$",
      "",
      content,
      perl = TRUE
    )
    
    # ---------------------------------------------
    # Barras verticales en identificación
    # ---------------------------------------------
    
    if (grepl("\\|", content, fixed = FALSE)) {
      
      if (grepl("^\\|", content, perl = TRUE)) {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = regexpr("\\|", lines[[line_no]], perl = TRUE)[[1]],
          type = "initial_rmk_leading_bar",
          text = lines[[line_no]],
          explanation =
            "En las RMK iniciales, la barra vertical no puede aparecer al comienzo del contenido."
        )
      }
      
      if (grepl("\\|$", content, perl = TRUE)) {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = regexpr("\\|(?=[^|]*$)", lines[[line_no]], perl = TRUE)[[1]],
          type = "initial_rmk_trailing_bar",
          text = lines[[line_no]],
          explanation =
            "En las RMK iniciales, la barra vertical no puede aparecer al final del contenido."
        )
      }
      
      bad_bar_spacing <- !grepl("^\\|", content, perl = TRUE) &&
        !grepl("\\|$", content, perl = TRUE) &&
        grepl("(?<! )\\||\\|(?! )", content, perl = TRUE)
      
      if (bad_bar_spacing) {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = regexpr("\\|", lines[[line_no]], perl = TRUE)[[1]],
          type = "invalid_initial_rmk_bar_spacing",
          text = lines[[line_no]],
          explanation =
            "En las RMK iniciales, la barra vertical debe usarse como separador con un espacio a cada lado: ' | '."
        )
      }
    }
  }
  
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

# =========================================================
# check_rmk_internal_punctuation()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   Dentro de un comentario RMK no debe aparecer:
#
#     - otro punto "."
#     - otro dos puntos ":"
#
#   antes del punto final obligatorio.
#
# ---------------------------------------------------------
# Fundamento
# ---------------------------------------------------------
#
#   El punto final informa del cierre del campo RMK.
#   Por tanto, no debe haber otros puntos internos.
#
#   Del mismo modo, el delimitador ":" solo debe aparecer
#   tras RMK.
#
# ---------------------------------------------------------
# Excepción: RMK de cabecera
# ---------------------------------------------------------
#
#   Los RMK de cabecera solo se admiten en las seis
#   primeras líneas del fichero. En esa zona inicial
#   se permiten puntos y dos puntos internos, porque
#   pueden formar parte de referencias bibliográficas,
#   signaturas, abreviaturas, nombres de instituciones
#   o descripciones documentales.
#
# =========================================================

check_rmk_internal_punctuation <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- trimws(
      lines[[line_no]],
      which = "both"
    )
    
    rmk_match <- regexpr(
      "^\\{RMK:[^\\}]*\\}",
      line,
      perl = TRUE
    )
    
    if (rmk_match[[1]] == -1) {
      next
    }
    
    # ---------------------------------------------
    # RMK de cabecera
    # ---------------------------------------------
    #
    # Los RMK situados en las seis primeras líneas
    # pueden contener puntuación interna.
    #
    # La regla ordinaria de puntos y dos puntos
    # internos se aplica solo fuera de esa zona.
    # ---------------------------------------------
    
    if (line_no <= 6) {
      next
    }
    
    rmk_token <- regmatches(
      line,
      rmk_match
    )[[1]]
    
    if (!grepl("\\.\\}$", rmk_token, perl = TRUE)) {
      next
    }
    
    content <- sub(
      "^\\{RMK:\\s*",
      "",
      rmk_token,
      perl = TRUE
    )
    
    content <- sub(
      "\\.\\}$",
      "",
      content,
      perl = TRUE
    )
    
    content_start <- nchar(
      sub(
        "^(\\{RMK:\\s*).*",
        "\\1",
        rmk_token,
        perl = TRUE
      )
    ) + 1
    
    # ---------------------------------------------
    # Puntos internos
    # ---------------------------------------------
    #
    # Se permiten abreviaturas breves del tipo:
    #
    #   s.l.
    #   s.n.
    #
    # pero no puntos internos ordinarios:
    #
    #   comentario. interno.
    # ---------------------------------------------
    
    period_positions <- gregexpr(
      "\\.",
      content,
      perl = TRUE
    )[[1]]
    
    if (period_positions[1] != -1) {
      
      for (pos in period_positions) {
        
        previous_char <- if (pos > 1) {
          substr(content, pos - 1, pos - 1)
        } else {
          ""
        }
        
        previous_previous_char <- if (pos > 2) {
          substr(content, pos - 2, pos - 2)
        } else {
          ""
        }
        
        is_abbreviation_dot <-
          grepl("[[:alpha:]]", previous_char, perl = TRUE) &&
          (
            pos == 2 ||
              !grepl("[[:alpha:]]", previous_previous_char, perl = TRUE)
          )
        
        if (!is_abbreviation_dot) {
          
          issues[[length(issues) + 1]] <- list(
            line = line_no,
            col = content_start + pos - 1,
            type = "rmk_internal_period",
            text = lines[[line_no]],
            explanation =
              "El comentario RMK no debe contener puntos internos ordinarios; se admiten abreviaturas breves como 's.l.' o 's.n.'."
          )
          
          break
        }
      }
    }
    
    # ---------------------------------------------
    # Dos puntos internos
    # ---------------------------------------------
    #
    # Se permite el uso documental:
    #
    #   HSMS-0562-0001: título
    #
    # pero no dos puntos internos ordinarios.
    # ---------------------------------------------
    
    colon_positions <- gregexpr(
      ":",
      content,
      fixed = TRUE
    )[[1]]
    
    if (colon_positions[1] != -1) {
      
      for (pos in colon_positions) {
        
        before_colon <- trimws(
          substr(content, 1, pos - 1),
          which = "both"
        )
        
        is_hsms_reference_colon <- grepl(
          "^HSMS-[0-9]{4}(-[0-9]{4})?$",
          before_colon,
          perl = TRUE
        )
        
        if (!is_hsms_reference_colon) {
          
          issues[[length(issues) + 1]] <- list(
            line = line_no,
            col = content_start + pos - 1,
            type = "rmk_internal_colon",
            text = lines[[line_no]],
            explanation =
              "El comentario RMK no debe contener dos puntos internos ordinarios; se permite el uso documental tras una referencia HSMS."
          )
          
          break
        }
      }
    }
  }
  
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

# =========================================================
# check_backslash_only_inside_hd()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   "\" solo puede aparecer dentro de una etiqueta
#   {HD. ...}, {HD1. ...} o {HD2. ...}.
#
# ---------------------------------------------------------
# Regla:
#
#   "\" solo puede aparecer dentro de una etiqueta {HD. ...}.
#
# ---------------------------------------------------------
# Casos válidos:
#
#   {HD. texto \ antiguo}
#
# ---------------------------------------------------------
# Casos inválidos:
#
#   texto \ texto
#   {LAT. texto \ texto}
#   {RUB. texto \ texto}
#
# =========================================================

check_backslash_only_inside_hd <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    backslash_positions <- gregexpr(
      "\\\\",
      line,
      perl = TRUE
    )[[1]]
    
    if (backslash_positions[1] == -1) next
    
    for (pos in backslash_positions) {
      
      before <- substr(line, 1, pos)
      last_mnemonic <- regexpr(
        "\\{=?[A-Za-z]+[0-9]*=?[\\.:][^\\{\\}]*$",
        before,
        perl = TRUE
      )[[1]]
      
      inside_hd <- FALSE
      
      if (last_mnemonic != -1) {
        
        candidate <- substr(
          before,
          last_mnemonic,
          nchar(before)
        )
        
        inside_hd <- grepl(
          "^\\{HD[12]?\\.",
          candidate,
          perl = TRUE
        )
      }
      
      after <- substr(
        line,
        pos,
        nchar(line)
      )
      
      closes_same_mnemonic <- grepl(
        "\\}",
        after,
        perl = TRUE
      )
      
      if (!inside_hd || !closes_same_mnemonic) {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = pos,
          type = "backslash_outside_hd",
          text = line,
          explanation =
            "La barra inversa '\\' solo puede aparecer dentro de la etiqueta {HD. ...}, {HD1. ...} o {HD2. ...} para indicar foliación antigua."
        )
      }
    }
  }
  
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

# =========================================================
# check_hd_position_in_folio()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   Las etiquetas {HD. o {HDn. deben aparecer dentro
#   del encabezamiento del folio.
#
# Es decir:
#
#   - después de la etiqueta [fol. n];
#   - antes de la primera etiqueta {CBn.;
#   - nunca después de haber comenzado una columna.
#
# ---------------------------------------------------------
# Ejemplos válidos:
#
#   [fol. 1r]
#   {HD. encabezado}
#   {CB1.
#
#   [fol. 1v]
#   {HD1. encabezado}
#   {HD2. encabezado}
#   {CB1.
#
# ---------------------------------------------------------
# Ejemplo inválido:
#
#   [fol. 2r]
#   {CB1.
#   texto}
#   {HD. encabezado tardío}
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

check_hd_position_in_folio <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  blocks <- get_folio_blocks(lines)
  
  issues <- list()
  
  if (nrow(blocks) == 0) {
    
    return(data.frame(
      line = integer(0),
      col = integer(0),
      type = character(0),
      text = character(0),
      explanation = character(0)
    ))
  }
  
  for (i in seq_len(nrow(blocks))) {
    
    block <- blocks[i, ]
    
    block_lines <- lines[
      block$start_line:block$end_line
    ]
    
    absolute_lines <- block$start_line:block$end_line
    
    first_cb_relative <- grep(
      "^\\{CB[0-9]+\\.$",
      block_lines,
      perl = TRUE
    )
    
    if (length(first_cb_relative) == 0) {
      next
    }
    
    first_cb_relative <- first_cb_relative[[1]]
    
    hd_relative <- grep(
      "^\\{HD[0-9]*[\\.:]",
      block_lines,
      perl = TRUE
    )
    
    if (length(hd_relative) == 0) {
      next
    }
    
    bad_hd_relative <- hd_relative[
      hd_relative > first_cb_relative
    ]
    
    if (length(bad_hd_relative) == 0) {
      next
    }
    
    for (rel in bad_hd_relative) {
      
      abs_line <- absolute_lines[[rel]]
      
      issues[[length(issues) + 1]] <- list(
        line = abs_line,
        col = 1,
        type = "hd_after_column_start",
        text = lines[[abs_line]],
        explanation =
          "La etiqueta {HD debe aparecer después del folio y antes de la primera etiqueta {CBn."
      )
    }
  }
  
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

# =========================================================
# check_cb_boundary_format()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   La etiqueta de comienzo de columna {CBn. debe tener
#   uno de estos dos formatos:
#
#     {CBn.
#     {CBn.}
#
# ---------------------------------------------------------
# Interpretación
# ---------------------------------------------------------
#
#   {CBn.  abre una columna con contenido.
#   {CBn.} representa una columna vacía cerrada en
#          la misma línea.
#
# ---------------------------------------------------------
# Ejemplos válidos:
#
#   {CB1.
#   {CB2.}
#   {CB27.
#
# ---------------------------------------------------------
# Ejemplos inválidos:
#
#   {CB1. texto
#   {CB2. texto}
#   {CB.}
#   {CB1: texto}
#
# ---------------------------------------------------------
# Notas:
#
#   Esta regla usa extract_hsms_mnemonics() como parser
#   central y solo revisa etiquetas CB reconocidas.
#
# =========================================================

check_cb_boundary_format <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  mnemonics <- extract_hsms_mnemonics(lines)
  
  issues <- list()
  
  if (nrow(mnemonics) == 0) {
    
    return(data.frame(
      line = integer(0),
      col = integer(0),
      type = character(0),
      text = character(0),
      explanation = character(0)
    ))
  }
  
  cb_mnemonics <- mnemonics[
    mnemonics$tag == "CB",
    ,
    drop = FALSE
  ]
  
  if (nrow(cb_mnemonics) == 0) {
    
    return(data.frame(
      line = integer(0),
      col = integer(0),
      type = character(0),
      text = character(0),
      explanation = character(0)
    ))
  }
  
  for (i in seq_len(nrow(cb_mnemonics))) {
    
    row <- cb_mnemonics[i, ]
    
    line_no <- row$line[[1]]
    
    line <- trimws(
      lines[[line_no]],
      which = "right"
    )
    
    valid_open <- grepl(
      "^\\{CB[0-9]+\\.$",
      line,
      perl = TRUE
    )
    
    valid_empty <- grepl(
      "^\\{CB[0-9]+\\.\\}$",
      line,
      perl = TRUE
    )
    
    if (!(valid_open || valid_empty)) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = row$col[[1]],
        type = "invalid_cb_boundary_format",
        text = lines[[line_no]],
        explanation =
          "La etiqueta {CBn. debe aparecer como {CBn. o como {CBn.}."
      )
    }
  }
  
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

# =========================================================
# check_empty_language_tag()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   Las etiquetas de lengua no deben estar vacías.
#
# ---------------------------------------------------------
# Etiquetas afectadas
# ---------------------------------------------------------
#
#   Todas las etiquetas cuyo grupo sea:
#
#     tag_group == "language"
#
# Por ejemplo:
#
#   ARB ARG ARM BAS CAL CAT ENG FRN GAL GER
#   GRK HEB ITL LAM LAT PRT PRV
#
# ---------------------------------------------------------
# Definición de “vacía”
# ---------------------------------------------------------
#
#   En esta regla, una etiqueta se considera vacía solo
#   cuando no contiene ningún carácter entre la apertura
#   de la etiqueta y la llave de cierre.
#
# Es decir:
#
#   {LAT.}
#   {ENG.}
#   {CAT.}
#
# ---------------------------------------------------------
# Casos válidos
# ---------------------------------------------------------
#
#   {LAT. texto latino}
#   {ENG. English text}
#   {CAT. text català}
#   {LAT. {RMK: Latin text illegible}}
#
# Este último caso NO es vacío, porque contiene información
# editorial dentro de {RMK: ...}.
#
# ---------------------------------------------------------
# Casos inválidos
# ---------------------------------------------------------
#
#   {LAT.}
#   {ENG.}
#   {CAT.}
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
# ---------------------------------------------------------
# Notas:
#
#   Esta función no intenta verificar si el contenido
#   corresponde realmente a la lengua indicada.
#
#   Solo detecta el vacío absoluto.
#
# =========================================================

check_empty_language_tag <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  catalog <- hsms_structural_tag_catalog()
  
  language_tags <- catalog$tag[
    catalog$tag_group == "language"
  ]
  
  issues <- list()
  
  pattern <- paste0(
    "^\\{(",
    paste(language_tags, collapse = "|"),
    ")\\.\\}$"
  )
  
  for (line_no in seq_along(lines)) {
    
    line <- trimws(lines[[line_no]])
    
    if (grepl(pattern, line, perl = TRUE)) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = 1,
        type = "empty_language_tag",
        text = lines[[line_no]],
        explanation =
          "Las etiquetas de lengua no pueden estar vacías."
      )
    }
  }
  
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

# =========================================================
# check_empty_addition_tags()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   Las etiquetas de adición y glosa no deben estar vacías.
#
# ---------------------------------------------------------
# Etiquetas afectadas
# ---------------------------------------------------------
#
#   {AD.}
#   {GL.}
#
# Ambas pertenecen conceptualmente al grupo:
#
#   tag_group == "addition"
#
# ---------------------------------------------------------
# Definición de “vacía”
# ---------------------------------------------------------
#
#   En esta regla, una etiqueta se considera vacía solo
#   cuando no contiene ningún carácter entre la apertura
#   de la etiqueta y la llave de cierre.
#
# Es decir:
#
#   {AD.}
#   {GL.}
#
# ---------------------------------------------------------
# Casos válidos
# ---------------------------------------------------------
#
#   {AD. texto añadido}
#   {GL. glosa marginal}
#   {AD. {RMK: addition illegible}}
#   {GL. {RMK: marginal gloss in Latin.}}
#
# Estos dos últimos casos NO son vacíos, porque contienen
# información editorial dentro de {RMK: ...}.
#
# ---------------------------------------------------------
# Casos inválidos
# ---------------------------------------------------------
#
#   {AD.}
#   {GL.}
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
# ---------------------------------------------------------
# Notas:
#
#   Esta función no interpreta todavía si el contenido
#   de AD o GL es textual, editorial o mixto.
#
#   Solo detecta el vacío absoluto.
#
# =========================================================

check_empty_addition_tags <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- trimws(lines[[line_no]])
    
    if (line %in% c("{AD.}", "{GL.}")) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = 1,
        type = "empty_addition_tag",
        text = lines[[line_no]],
        explanation =
          "Las etiquetas AD y GL no pueden estar vacías."
      )
    }
  }
  
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

# =========================================================
# check_empty_illumination_with_space()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   La etiqueta {ILL.} puede aparecer vacía, pero no debe
#   contener únicamente espacios antes de la llave de cierre.
#
# ---------------------------------------------------------
# Casos válidos:
#
#   {ILL.}
#   {ILL. {RMK: right margin.}}
#   {ILL. {MIN.}{AD. ...}}
#
# ---------------------------------------------------------
# Caso inválido:
#
#   {ILL. }
#   {ILL.   }
#
# =========================================================

check_empty_illumination_with_space <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    if (grepl("^\\{ILL\\.\\s+\\}$", line, perl = TRUE)) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = 1,
        type = "empty_illumination_with_space",
        text = line,
        explanation =
          "Use {ILL.} sin espacio interior cuando la iluminación no contiene información transcrita."
      )
    }
  }
  
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

# =========================================================
# check_initial_marker_format()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   La etiqueta de inicial {INn. debe:
#
#     - llevar número
#     - cerrarse correctamente
#     - aparecer en una de estas formas:
#
#         {INn.}
#         {INn. {ILL.}}
#         {INn. {MIN.}}
#
#     - ir seguida de un espacio y de la inicial
#       transcrita.
#
# ---------------------------------------------------------
# Fundamento
# ---------------------------------------------------------
#
#   El manual indica que el número registra las líneas
#   ocupadas por la caja de la inicial y que la letra que
#   aparece como inicial en el manuscrito sigue a la
#   etiqueta completo tras un espacio en blanco.
#
# ---------------------------------------------------------
# Casos válidos:
#
#   {IN1.} A
#   {IN6. {ILL.}} EN
#   {IN10. {MIN.}} A
#   {IN3.} (^H)[^P]riuilegio
#   {IN3.} (N)[L]a
#   {IN7.} [R]Obi
#
# ---------------------------------------------------------
# Casos inválidos:
#
#   {IN1.
#   {IN1.}
#   {IN6. {ILL.}}
#   {IN10. {MIN.}}
#   {IN3. }
#   {IN3. texto}
#   {IN10. {RUB.}}
#
# =========================================================

check_initial_marker_format <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    matches <- gregexpr(
      "\\{IN[0-9]+\\.",
      line,
      perl = TRUE
    )[[1]]
    
    if (matches[1] == -1) next
    
    for (pos in matches) {
      
      after_marker <- substr(
        line,
        pos,
        nchar(line)
      )
      
      # ---------------------------------------------
      # Forma completa válida:
      #
      #   {INn.} X
      #   {INn. {ILL.}} X
      #   {INn. {MIN.}} X
      #
      # donde X es cualquier contenido no vacío que
      # representa la inicial transcrita.
      # ---------------------------------------------
      
      valid_full_format <- grepl(
        "^\\{IN[0-9]+\\.(\\}| \\{(ILL|MIN)\\.\\}\\})\\s+\\S+",
        after_marker,
        perl = TRUE
      )
      
      if (valid_full_format) {
        next
      }
      
      # ---------------------------------------------
      # Mnemónico IN bien formado, pero sin inicial
      # posterior.
      # ---------------------------------------------
      
      valid_header_only <- grepl(
        "^\\{IN[0-9]+\\.(\\}| \\{(ILL|MIN)\\.\\}\\})\\s*$",
        after_marker,
        perl = TRUE
      )
      
      if (valid_header_only) {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = pos,
          type = "missing_initial_after_marker",
          text = line,
          explanation =
            "La etiqueta {INn.} debe ir seguida de un espacio y de la inicial transcrita."
        )
        
        next
      }
      
      # ---------------------------------------------
      # Cualquier otra forma de {INn. es incorrecta:
      #
      #   {IN1.
      #   {IN3. }
      #   {IN3. texto}
      #   {IN10. {RUB.}}
      # ---------------------------------------------
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = pos,
        type = "invalid_initial_marker_format",
        text = line,
        explanation =
          "La etiqueta {INn. debe cerrarse como {INn.} seguida de la inicial, o contener {ILL.}/{MIN.} y después la inicial."
      )
    }
  }
  
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


# =========================================================
# check_consecutive_blank_mnemonics()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   No debe haber más de una etiqueta {BLNK.} consecutivo.
#
# ---------------------------------------------------------
# Fundamento
# ---------------------------------------------------------
#
#   El manual indica que cuando un área en blanco ocupa
#   más de una línea, debe usarse una única etiqueta
#   {BLNK: ...} con campo de observación indicando el
#   número de líneas en blanco.
#
# ---------------------------------------------------------
# Ejemplos válidos:
#
#   texto {BLNK.} texto
#   texto {BLNK: 12 lines left blank.}
#
# ---------------------------------------------------------
# Ejemplo inválido:
#
#   {BLNK.}
#   {BLNK.}
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

check_consecutive_blank_mnemonics <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  previous_blank_line <- NA_integer_
  
  for (line_no in seq_along(lines)) {
    
    line <- trimws(lines[[line_no]])
    
    is_blank_only <- grepl(
      "^\\{BLNK\\.\\}$",
      line,
      perl = TRUE
    )
    
    if (is_blank_only && !is.na(previous_blank_line)) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = 1,
        type = "consecutive_blank_mnemonics",
        text = lines[[line_no]],
        explanation =
          "No debe repetirse {BLNK.}; para varias líneas en blanco use un único {BLNK: ...} con observación."
      )
    }
    
    previous_blank_line <- if (is_blank_only) {
      line_no
    } else {
      NA_integer_
    }
  }
  
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

# =========================================================
# check_empty_symbol_tag()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   La etiqueta {SYMB.} no debe estar vacía.
#
# ---------------------------------------------------------
# Fundamento
# ---------------------------------------------------------
#
#   El manual indica que {SYMB.} se usa para representar
#   letras o símbolos que no pueden reproducirse
#   directamente en el conjunto romano ordinario.
#
#   También puede contener {BLNK.} cuando la información
#   ausente correspondería a símbolo o símbolos.
#
# ---------------------------------------------------------
# Definición de “vacía”
# ---------------------------------------------------------
#
#   En esta regla, una etiqueta se considera vacía solo
#   cuando aparece exactamente como:
#
#     {SYMB.}
#
# ---------------------------------------------------------
# Casos válidos:
#
#   {SYMB. signo}
#   {SYMB. {BLNK.}}
#   {SYMB. {RMK: symbol illegible.}}
#   {SYMB: transliterated Arabic characters. texto}
#
# ---------------------------------------------------------
# Caso inválido:
#
#   {SYMB.}
#
# =========================================================

# ---------------------------------------------------------
# Notas
# ---------------------------------------------------------
#
#   El manual HSMS permite el uso de un campo de
#   observación para identificar transliteraciones:
#
#     {SYMB: transliterated Arabic characters. ttt}
#
#   Asimismo, una etiqueta de lengua puede aparecer
#   embebida dentro de {SYMB.}:
#
#     {SYMB: transliterated Arabic characters.
#       {ARB. ttttt}}
#
#   Por tanto, esta función NO intenta validar la
#   estructura interna de SYMB ni el contenido de su
#   campo de observación.
#
#   Únicamente detecta el caso trivial:
#
#     {SYMB.}
#
#   sin contenido alguno.
#
# =========================================================

check_empty_symbol_tag <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- trimws(lines[[line_no]])
    
    if (line == "{SYMB.}") {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = 1,
        type = "empty_symbol_tag",
        text = lines[[line_no]],
        explanation =
          "La etiqueta {SYMB.} no debe estar vacía."
      )
    }
  }
  
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


# =========================================================
# check_diag_internal_segments()
# ---------------------------------------------------------
# Regla estructural HSMS:
#
#   La etiqueta {DIAG. puede contener segmentos internos
#   separados por el carácter funcional "|".
#
# ---------------------------------------------------------
# Fundamento manual HSMS
# ---------------------------------------------------------
#
#   El manual indica que ciertos diagramas —por ejemplo
#   ruedas, tablas o esquemas astronómicos/astrológicos—
#   pueden estar divididos en unidades físicas discretas
#   que contienen texto.
#
#   En esos casos debe usarse una barra vertical "|":
#
#     - antes del primer segmento de texto;
#     - entre segmentos;
#     - después del segmento final;
#     - la barra final debe aparecer inmediatamente antes
#       de la llave de cierre de la etiqueta.
#
# ---------------------------------------------------------
# Alcance de esta regla
# ---------------------------------------------------------
#
#   Esta función SOLO valida la forma segmentada de DIAG
#   cuando aparece en una única línea.
#
#   No interpreta todavía el contenido textual de cada
#   segmento.
#
#   No intenta validar los casos generales de continuidad
#   de diagramas con "+"; esos ya pertenecen a las reglas
#   de continuidad. Si una forma segmentada se mezcla con
#   "+}" se marca de forma específica porque el manual
#   exige que la barra final preceda inmediatamente a "}".
#
#   No modifica el fichero original.
#
# ---------------------------------------------------------
# Formato aceptado
# ---------------------------------------------------------
#
#   {DIAG. |seg1|seg2|}
#   {DIAG. |seg1|seg2|seg3|}
#   {=DIAG. |seg1|seg2|}
#   {DIAG=. |seg1|seg2|}
#   {=DIAG=. |seg1|seg2|}
#
# ---------------------------------------------------------
# Reglas aplicadas
# ---------------------------------------------------------
#
#   1. La forma segmentada debe comenzar con "|".
#   2. La forma segmentada debe terminar con "|}".
#      No se permite espacio entre la última barra y "}".
#   3. Debe haber al menos dos segmentos textuales.
#   4. No se permiten segmentos vacíos.
#   5. No se permite mezclar provisionalmente segmentos
#      internos con continuidad "+}".
#
# =========================================================

check_diag_internal_segments <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  diag_open_pattern <- "\\{=?DIAG=?\\."
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    diag_matches <- gregexpr(
      diag_open_pattern,
      line,
      perl = TRUE
    )[[1]]
    
    if (diag_matches[1] == -1) {
      next
    }
    
    for (pos in diag_matches) {
      
      diag_fragment <- substr(
        line,
        pos,
        nchar(line)
      )
      
      # -------------------------------------------------
      # Si no hay barra vertical, no estamos ante la
      # variante segmentada de DIAG.
      # -------------------------------------------------
      
      if (!grepl("|", diag_fragment, fixed = TRUE)) {
        next
      }
      
      # -------------------------------------------------
      # Extraer el contenido de DIAG hasta la primera
      # llave de cierre de la misma línea.
      #
      # Nota:
      #   Esta regla se limita a DIAG segmentado en una
      #   línea. Las estructuras multilineales o con llaves
      #   internas se validarán en reglas más específicas si
      #   el corpus las documenta.
      # -------------------------------------------------
      
      m <- regexec(
        "^\\{=?DIAG=?\\.(.*?)(\\})",
        diag_fragment,
        perl = TRUE
      )
      
      r <- regmatches(
        diag_fragment,
        m
      )[[1]]
      
      if (length(r) == 0) {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = pos,
          type = "diag_segments_not_closed",
          text = line,
          explanation =
            "La forma segmentada de {DIAG. debe cerrarse con '}' en la misma línea."
        )
        
        next
      }
      
      segment_text <- sub(
        "^\\s+",
        "",
        r[[2]],
        perl = TRUE
      )
      
      # -------------------------------------------------
      # La continuidad '+}' no se acepta en DIAG segmentado
      # mientras no haya evidencia explícita para combinar
      # ambos mecanismos.
      # -------------------------------------------------
      
      if (grepl("\\+\\s*$", segment_text, perl = TRUE)) {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = pos,
          type = "diag_segments_with_continuation",
          text = line,
          explanation =
            "La forma segmentada de {DIAG. no debe mezclarse todavía con continuidad '+}'."
        )
        
        next
      }
      
      # -------------------------------------------------
      # El manual exige barra inicial, barras entre segmentos
      # y barra final inmediatamente antes de la llave.
      # -------------------------------------------------
      
      valid_outer_pipes <- grepl(
        "^\\|.*\\|$",
        segment_text,
        perl = TRUE
      )
      
      if (!valid_outer_pipes) {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = pos,
          type = "invalid_diag_segment_boundaries",
          text = line,
          explanation =
            "Los segmentos internos de {DIAG. deben empezar con '|' y terminar con '|}' sin espacio entre la última barra y '}'."
        )
        
        next
      }
      
      inner <- sub(
        "^\\|(.*)\\|$",
        "\\1",
        segment_text,
        perl = TRUE
      )
      
      segments <- strsplit(
        inner,
        "|",
        fixed = TRUE
      )[[1]]
      
      empty_segments <- trimws(segments) == ""
      
      if (length(segments) == 0 || any(empty_segments)) {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = pos,
          type = "empty_diag_segment",
          text = line,
          explanation =
            "La forma segmentada de {DIAG. no debe contener segmentos vacíos."
        )
        
        next
      }
      
      if (length(segments) < 2) {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = pos,
          type = "diag_too_few_segments",
          text = line,
          explanation =
            "La forma segmentada de {DIAG. debe contener al menos dos segmentos."
        )
        
        next
      }
    }
  }
  
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


# =========================================================
# check_structure()
# ---------------------------------------------------------
# Valida la estructura formal HSMS.
#
# Parámetros:
#   filepath : ruta al fichero
#
# Devuelve:
#   data.frame con incidencias
#
# =========================================================

check_structure <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  # -------------------------------------------------
  # 0-pre. Delimitadores <...> y <<...>> en línea
  # -------------------------------------------------
  
  angle_delimiter_issues <-
    check_inline_angle_delimiters(filepath)
  
  if (nrow(angle_delimiter_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        angle_delimiter_issues,
        seq_len(nrow(angle_delimiter_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0-pre-bis. Contenido de <...> y <<...>>
  # -------------------------------------------------
  
  angle_content_issues <-
    check_angle_delimiter_contents(filepath)
  
  if (nrow(angle_content_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        angle_content_issues,
        seq_len(nrow(angle_content_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0-pre-ter. Formato básico de [] y ()
  # -------------------------------------------------
  
  insertion_deletion_issues <-
    check_insertion_deletion_marker_format(filepath)
  
  if (nrow(insertion_deletion_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        insertion_deletion_issues,
        seq_len(nrow(insertion_deletion_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0-pre-quater. Formato de reconstrucciones [*...]
  # -------------------------------------------------
  
  reconstruction_issues <-
    check_reconstruction_marker_format(filepath)
  
  if (nrow(reconstruction_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        reconstruction_issues,
        seq_len(nrow(reconstruction_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0-pre-quinquies. Formato de ilegibilidad
  # -------------------------------------------------
  
  illegibility_issues <-
    check_illegibility_marker_format(filepath)
  
  if (nrow(illegibility_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        illegibility_issues,
        seq_len(nrow(illegibility_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0-pre-sexies. Combinación borrado + inserción
  # -------------------------------------------------
  
  deletion_insertion_issues <-
    check_deletion_insertion_combination_format(filepath)
  
  if (nrow(deletion_insertion_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        deletion_insertion_issues,
        seq_len(nrow(deletion_insertion_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0-pre-sexies-bis. Crosshatch: mano no original
  # -------------------------------------------------
  
  crosshatch_issues <- check_crosshatch_usage(filepath)
  
  if (nrow(crosshatch_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        crosshatch_issues,
        seq_len(nrow(crosshatch_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0-pre-septies. Mnemónicos dentro de [] y ()
  # -------------------------------------------------
  
  mnemonic_in_brackets_issues <-
    check_mnemonics_inside_insertions_deletions(filepath)
  
  if (nrow(mnemonic_in_brackets_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        mnemonic_in_brackets_issues,
        seq_len(nrow(mnemonic_in_brackets_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0-pre-octies. [] y () no cruzan etiquetas
  # -------------------------------------------------
  
  crossing_insertions_issues <-
    check_insertions_deletions_do_not_cross_mnemonics(filepath)
  
  if (nrow(crossing_insertions_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        crossing_insertions_issues,
        seq_len(nrow(crossing_insertions_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0-pre-nonies. [] y () no cruzan contenedores textuales
  # -------------------------------------------------
  
  textual_container_crossing_issues <-
    check_insertions_deletions_do_not_cross_textual_containers(filepath)
  
  if (nrow(textual_container_crossing_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        textual_container_crossing_issues,
        seq_len(nrow(textual_container_crossing_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0-pre-decies. Formato de ((...))
  # -------------------------------------------------
  #
  # OBSOLETO / FÓSIL HISTÓRICO.
  #
  # La convención ((...)) para paréntesis reales ha sido
  # sustituida por:
  #
  #   ≺ ... ≻
  #
  # No se valida el balanceo ni el espaciado de ≺...≻,
  # porque estos paréntesis reales pueden atravesar límites
  # de columna o de división textual.
  #
  # La función check_double_parenthesis_spacing() se conserva
  # únicamente como memoria histórica, pero no se llama en la
  # validación normal.
  #
  # double_parenthesis_issues <-
  #   check_double_parenthesis_spacing(filepath)
  #
  # if (nrow(double_parenthesis_issues) > 0) {
  #   
  #   issues <- c(
  #     issues,
  #     split(
  #       double_parenthesis_issues,
  #       seq_len(nrow(double_parenthesis_issues))
  #     )
  #   )
  # }
  
  # -------------------------------------------------
  # 0. Etiquetas estructurales desconocidas
  # -------------------------------------------------
  
  unknown_tag_issues <- check_unknown_structural_tags(filepath)
  
  if (nrow(unknown_tag_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        unknown_tag_issues,
        seq_len(nrow(unknown_tag_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0b. Etiquetas numeradas indebidamente
  # -------------------------------------------------
  
  unexpected_number_issues <- check_unexpected_numbered_tags(filepath)
  
  if (nrow(unexpected_number_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        unexpected_number_issues,
        seq_len(nrow(unexpected_number_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0c. Etiquetas que requieren número
  # -------------------------------------------------
  
  missing_number_issues <-
    check_missing_required_numbers(filepath)
  
  if (nrow(missing_number_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        missing_number_issues,
        seq_len(nrow(missing_number_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0d. Delimitadores incorrectos de etiquetas
  # -------------------------------------------------
  
  delimiter_issues <- check_tag_delimiters(filepath)
  
  if (nrow(delimiter_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        delimiter_issues,
        seq_len(nrow(delimiter_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0e. Posición de {HD dentro del folio
  # -------------------------------------------------
  
  hd_position_issues <- check_hd_position_in_folio(filepath)
  
  if (nrow(hd_position_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        hd_position_issues,
        seq_len(nrow(hd_position_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0f. Formato de etiquetas {CBn.
  # -------------------------------------------------
  
  cb_format_issues <- check_cb_boundary_format(filepath)
  
  if (nrow(cb_format_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        cb_format_issues,
        seq_len(nrow(cb_format_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0g. Posición de {CW. y {SG.
  # -------------------------------------------------
  
  cw_sg_position_issues <- check_cw_sg_position(filepath)
  
  if (nrow(cw_sg_position_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        cw_sg_position_issues,
        seq_len(nrow(cw_sg_position_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0h. Formato de línea de {CW. y {SG.
  # -------------------------------------------------
  
  cw_sg_format_issues <- check_cw_sg_line_format(filepath)
  
  if (nrow(cw_sg_format_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        cw_sg_format_issues,
        seq_len(nrow(cw_sg_format_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0i. {RMK: aislada dentro del texto
  # -------------------------------------------------
  
  rmk_context_issues <- check_rmk_standalone_context(filepath)
  
  if (nrow(rmk_context_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        rmk_context_issues,
        seq_len(nrow(rmk_context_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0i-bis. Formato básico de RMK
  # -------------------------------------------------
  
  rmk_format_issues <- check_rmk_comment_format(filepath)
  
  if (nrow(rmk_format_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        rmk_format_issues,
        seq_len(nrow(rmk_format_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0i-ter. Bloque inicial de identificación RMK
  # -------------------------------------------------
  
  initial_rmk_issues <-
    check_initial_rmk_identification_block(filepath)
  
  if (nrow(initial_rmk_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        initial_rmk_issues,
        seq_len(nrow(initial_rmk_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0i-quater. Puntuación interna indebida en RMK
  # -------------------------------------------------
  
  rmk_punctuation_issues <-
    check_rmk_internal_punctuation(filepath)
  
  if (nrow(rmk_punctuation_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        rmk_punctuation_issues,
        seq_len(nrow(rmk_punctuation_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0j. Mnemónicos en minúsculas
  # -------------------------------------------------
  
  uppercase_issues <- check_mnemonic_uppercase(filepath)
  
  if (nrow(uppercase_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        uppercase_issues,
        seq_len(nrow(uppercase_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0k. Etiquetas de lengua vacías
  # -------------------------------------------------
  
  empty_language_issues <- check_empty_language_tag(filepath)
  
  if (nrow(empty_language_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        empty_language_issues,
        seq_len(nrow(empty_language_issues))
      )
    )
  }

  # -------------------------------------------------
  # 0l. AD y GL vacías
  # -------------------------------------------------
  
  empty_addition_issues <- check_empty_addition_tags(filepath)
  
  if (nrow(empty_addition_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        empty_addition_issues,
        seq_len(nrow(empty_addition_issues))
      )
    )
  }
  
  
  # -------------------------------------------------
  # 0m. {ILL.} con espacio vacío
  # -------------------------------------------------
  
  illumination_space_issues <-
    check_empty_illumination_with_space(filepath)
  
  if (nrow(illumination_space_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        illumination_space_issues,
        seq_len(nrow(illumination_space_issues))
      )
    )
  }
  
  # -------------------------------------------------
  # 0n. Formato de {INn.}
  # -------------------------------------------------
  
  initial_format_issues <- check_initial_marker_format(filepath)
  
  if (nrow(initial_format_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        initial_format_issues,
        seq_len(nrow(initial_format_issues))
      )
    )
  }

  # -------------------------------------------------
  # 0o. {BLNK.} consecutivos
  # -------------------------------------------------
  
  consecutive_blank_issues <-
    check_consecutive_blank_mnemonics(filepath)
  
  if (nrow(consecutive_blank_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        consecutive_blank_issues,
        seq_len(nrow(consecutive_blank_issues))
      )
    )
  }

  # -------------------------------------------------
  # 0p. {SYMB.} vacío
  # -------------------------------------------------
  
  empty_symbol_issues <- check_empty_symbol_tag(filepath)
  
  if (nrow(empty_symbol_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        empty_symbol_issues,
        seq_len(nrow(empty_symbol_issues))
      )
    )
  }


  # -------------------------------------------------
  # 0q. {DIAG.} con segmentos internos "|"
  # -------------------------------------------------

  diag_segment_issues <- check_diag_internal_segments(filepath)

  if (nrow(diag_segment_issues) > 0) {

    issues <- c(
      issues,
      split(
        diag_segment_issues,
        seq_len(nrow(diag_segment_issues))
      )
    )
  }

  # -------------------------------------------------
  # Barra inversa: solo dentro de HD
  # -------------------------------------------------
  
  backslash_issues <- check_backslash_only_inside_hd(filepath)
  
  if (nrow(backslash_issues) > 0) {
    
    issues <- c(
      issues,
      split(
        backslash_issues,
        seq_len(nrow(backslash_issues))
      )
    )
  }
  

  
  # -------------------------------------------------
  # 1. Detectar folios
  # -------------------------------------------------
  
  folio_pattern <- "^\\[fol\\.\\s*([0-9]{1,3})([rv])\\]$"
  
  folios <- list()
  
  for (i in seq_along(lines)) {
    
    m <- regexec(
      folio_pattern,
      lines[[i]],
      perl = TRUE
    )
    
    r <- regmatches(lines[[i]], m)[[1]]
    
    if (length(r) > 0) {
      
      folios[[length(folios) + 1]] <- list(
        line = i,
        num = as.integer(r[2]),
        side = r[3]
      )
    }
  }
  
  # -------------------------------------------------
  # 2. No hay folios
  # -------------------------------------------------
  
  if (length(folios) == 0) {
    
    issues[[length(issues) + 1]] <- list(
      line = NA_integer_,
      type = "no_folios",
      text = "",
      explanation =
        "No se encontraron etiquetas de folio."
    )
    
  } else {
    
    # ---------------------------------------------
    # 3. Validar secuencia r/v
    # ---------------------------------------------
    
    for (k in seq_len(length(folios))[-1]) {
      
      prev <- folios[[k - 1]]
      cur  <- folios[[k]]
      
      if (cur$num == prev$num) {
        
        if (!(prev$side == "r" &&
              cur$side == "v")) {
          
          issues[[length(issues) + 1]] <- list(
            line = cur$line,
            type = "folio_order_error",
            text = lines[[cur$line]],
            explanation = paste0(
              "El folio ",
              cur$num,
              " debe ir de r a v."
            )
          )
        }
        
      } else if (cur$num != prev$num + 1) {
        
        issues[[length(issues) + 1]] <- list(
          line = cur$line,
          type = "folio_gap",
          text = lines[[cur$line]],
          explanation = paste0(
            "Salto de folio entre ",
            prev$num,
            " y ",
            cur$num,
            "."
          )
        )
      }
    }
  }
  
  # -------------------------------------------------
  # 4. Detectar columnas {CBn.
  # -------------------------------------------------
  
  cb_pattern <- "^\\{CB([0-9]+)\\.$"
  
  cb_stack <- list()
  
  for (i in seq_along(lines)) {
    
    line <- trimws(
      lines[[i]],
      which = "right"
    )
    
    m <- regexec(
      cb_pattern,
      line,
      perl = TRUE
    )
    
    r <- regmatches(line, m)[[1]]
    
    # ---------------------------------------------
    # Apertura correcta
    # ---------------------------------------------
    
    if (length(r) > 0) {
      
      cb_stack[[length(cb_stack) + 1]] <- list(
        line = i,
        cb = as.integer(r[2])
      )
      
      next
    }
    
    # ---------------------------------------------
    # Apertura mal formada
    # ---------------------------------------------
    
    if (grepl("\\{CB", line, fixed = TRUE) &&
        !grepl(cb_pattern, line, perl = TRUE)) {
      
      issues[[length(issues) + 1]] <- list(
        line = i,
        type = "cb_malformed",
        text = lines[[i]],
        explanation =
          "La etiqueta {CBn. debe aparecer sola en una línea."
      )
    }
  }
  
  # -------------------------------------------------
  # 5. Verificar cierres
  # -------------------------------------------------
  
  for (cb in cb_stack) {
    
    found_close <- FALSE
    
    for (j in seq(cb$line + 1, length(lines))) {
      
      # -----------------------------------------
      # Llegó el siguiente folio
      # -----------------------------------------
      
      if (grepl("^\\[fol\\.", lines[[j]])) {
        break
      }
      
      # -----------------------------------------
      # Columna vacía cerrada en la misma línea
      # -----------------------------------------
      
      if (grepl("^\\{CB[0-9]+\\.\\}$", lines[[cb$line]], perl = TRUE)) {
        
        found_close <- TRUE
        break
      }
      
      # -----------------------------------------
      # Detectado cierre
      # -----------------------------------------
      
      if (grepl("\\}\\s*$", lines[[j]])) {
        
        found_close <- TRUE
        break
      }
    }
    
    # ---------------------------------------------
    # No se cerró
    # ---------------------------------------------
    
    if (!found_close) {
      
      issues[[length(issues) + 1]] <- list(
        line = cb$line,
        type = "cb_not_closed",
        text = lines[[cb$line]],
        explanation = paste0(
          "{CB",
          cb$cb,
          ". no se cierra antes del siguiente folio."
        )
      )
    }
  }
  
  # -------------------------------------------------
  # 6. Resultado
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
  
  issues <- lapply(
    issues,
    as.data.frame,
    stringsAsFactors = FALSE
  )
  
  issues <- lapply(
    issues,
    standardize_issues
  )
  
  do.call(rbind, issues)
}
