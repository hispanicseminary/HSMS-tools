# =========================================================
# validator_editorial.R
# ---------------------------------------------------------
# Validaciones editoriales y tipográficas HSMS
#
# Este módulo contiene reglas relacionadas con:
#
#   - signos especiales
#   - puntuación
#   - espacios
#   - secuencias editoriales
#   - convenciones tipográficas
#
# ---------------------------------------------------------
# ESTE SCRIPT NO VALIDA
# ---------------------------------------------------------
#
#   - UTF-8 / LF
#   - estructura HSMS
#   - folios
#   - columnas
#   - balanceo global
#
# Todo eso pertenece a otros módulos.
#
# ---------------------------------------------------------
# FILOSOFÍA
# ---------------------------------------------------------
#
# Las reglas editoriales cambian con frecuencia.
#
# Por tanto:
#
#   - cada regla debe ser independiente;
#   - nunca deben mezclarse reglas;
#   - una regla rota no debe afectar a las demás.
#
# Ninguna función de este módulo modifica el fichero.
# Solo detecta incidencias y las devuelve en forma de tabla.
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
# check_ellipsis()
# ---------------------------------------------------------
# Regla HSMS:
#
#   Los tres puntos "..." solo pueden aparecer
#   dentro de corchetes "[...]".
#
# ---------------------------------------------------------
# Ejemplos válidos:
#
#   [...]
#   [abc ... xyz]
#
# ---------------------------------------------------------
# Ejemplos inválidos:
#
#   texto...
#   ... texto
#   abc ... def
#
# ---------------------------------------------------------
# Parámetros:
#
#   filepath : ruta al fichero TXT que se quiere validar.
#
# ---------------------------------------------------------
# Devuelve:
#
#   data.frame con incidencias.
#
# =========================================================

check_ellipsis <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    matches <- gregexpr(
      "\\.\\.\\.",
      line,
      perl = TRUE
    )[[1]]
    
    if (matches[1] == -1) next
    
    for (pos in matches) {
      
      left  <- substr(line, 1, pos - 1)
      
      right <- substr(
        line,
        pos + 3,
        nchar(line)
      )
      
      inside_brackets <-
        grepl("\\[[^\\]]*$", left) &&
        grepl("^[^\\[]*\\]", right)
      
      if (!inside_brackets) {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = pos,
          type = "ellipsis_outside_brackets",
          text = line,
          explanation =
            "Los tres puntos '...' solo pueden aparecer dentro de corchetes '[...]'."
        )
      }
    }
  }
  
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
# check_percent_spacing()
# ---------------------------------------------------------
# Regla HSMS:
#
#   Los signos de calderón deben aparecer separados por
#   espacios, salvo cuando:
#
#     - aparecen al inicio de línea;
#     - aparecen al final de línea.
#
# ---------------------------------------------------------
# Tokens validados:
#
#   %
#   %2
#   %3
#   ¶
#   ¶2
#   ¶3
#   [%]
#   [^%]
#   [%2]
#   [^%2]
#   [%3]
#   [^%3]
#   [¶]
#   [^¶]
#   [¶2]
#   [^¶2]
#   [¶3]
#   [^¶3]
#
# ---------------------------------------------------------
# Ejemplos válidos:
#
#   % abc
#   abc % def
#   abc %
#   abc %2 def
#   abc %3 def
#   abc [%] def
#   abc [^%2] def
#
#   ¶ abc
#   abc ¶ def
#   abc ¶2 def
#   abc [¶] def
#   abc [^¶2] def
#
# ---------------------------------------------------------
# Ejemplos inválidos:
#
#   abc%def
#   abc%2 def
#   abc %3def
#
#   abc¶def
#   abc¶2 def
#   abc ¶3def
#
# =========================================================

check_percent_spacing <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  token_pattern <- "\\[(?:\\^[0-9]*#?)?%[23]?\\]|\\[\\^[0-9]*#?%[23]?|%%|%[23]?"
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    # ---------------------------------------------
    # Normalización interna:
    #   ¶ ≡ %
    # ---------------------------------------------
    
    line_for_check <- chartr(
      "¶",
      "%",
      line
    )
    
    matches <- gregexpr(
      token_pattern,
      line_for_check,
      perl = TRUE
    )[[1]]
    
    if (matches[1] == -1) next
    
    match_lengths <- attr(
      matches,
      "match.length"
    )
    
    for (i in seq_along(matches)) {
      
      start_pos <- matches[[i]]
      token_len <- match_lengths[[i]]
      end_pos <- start_pos + token_len - 1
      
      prev <- if (start_pos > 1) {
        substr(
          line_for_check,
          start_pos - 1,
          start_pos - 1
        )
      } else {
        ""
      }
      
      next_char <- if (end_pos < nchar(line_for_check)) {
        substr(
          line_for_check,
          end_pos + 1,
          end_pos + 1
        )
      } else {
        ""
      }
      
      if (start_pos > 1 && prev != " ") {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = start_pos,
          type = "percent_missing_space_before",
          text = line,
          explanation =
            "El calderón %, %2, %3, ¶, ¶2, ¶3 o sus formas insertadas debe ir precedido por espacio, salvo si está al inicio de línea."
        )
      }
      
      if (end_pos < nchar(line_for_check) &&
          next_char != " ") {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = start_pos,
          type = "percent_missing_space_after",
          text = line,
          explanation =
            "El calderón %, %2, %3, ¶, ¶2, ¶3 o sus formas insertadas debe ir seguido por espacio, salvo si está al final de línea."
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
  
  do.call(
    rbind,
    lapply(
      issues,
      as.data.frame
    )
  )
}

# =========================================================
# check_double_calderon_marker()
# ---------------------------------------------------------
# Regla editorial HSMS:
#
#   En algunos impresos pueden aparecer dos calderones
#   consecutivos:
#
#     ¶¶
#
#   Internamente, "¶" se trata como equivalente de "%".
#   Por tanto:
#
#     ¶¶ == %%
#
# ---------------------------------------------------------
# Interpretación:
#
#   Dos calderones consecutivos pueden ser una marca
#   impresa intencional, pero también una duplicación
#   accidental del cajista.
#
#   Proofer no decide: solo señala el caso para revisión.
#
# =========================================================

check_double_calderon_marker <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line_original <- lines[[line_no]]
    
    line_for_check <- chartr(
      "¶",
      "%",
      line_original
    )
    
    double_positions <- gregexpr(
      "%%",
      line_for_check,
      fixed = TRUE
    )[[1]]
    
    if (double_positions[1] == -1) {
      next
    }
    
    for (pos in double_positions) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = pos,
        type = "double_calderon_marker",
        text = line_original,
        explanation =
          "Se han detectado dos calderones consecutivos. Puede tratarse de una marca impresa intencional o de una duplicación accidental del cajista; revísese editorialmente."
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
# check_para_spacing()
# ---------------------------------------------------------
# OBSOLETA.
# El signo ¶ se valida ahora en check_percent_spacing(),
# donde se trata como equivalente Unicode de %.
# Se conserva temporalmente por memoria histórica.
# ---------------------------------------------------------
# Regla HSMS:
#
#   El signo de párrafo "¶" debe aparecer separado
#   por espacios.
#
# ---------------------------------------------------------
# Ejemplos válidos:
#
#   ¶ abc
#   abc ¶ def
#   abc ¶
#
# ---------------------------------------------------------
# Ejemplos inválidos:
#
#   abc¶def
#   abc¶ def
#   abc ¶def
#
# ---------------------------------------------------------
# Parámetros:
#
#   filepath : ruta al fichero TXT que se quiere validar.
#
# ---------------------------------------------------------
# Devuelve:
#
#   data.frame con incidencias.
#
# =========================================================

check_para_spacing <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    matches <- gregexpr(
      "¶",
      line,
      fixed = TRUE
    )[[1]]
    
    if (matches[1] == -1) next
    
    for (pos in matches) {
      
      prev <- if (pos > 1) {
        substr(line, pos - 1, pos - 1)
      } else {
        ""
      }
      
      next_char <- if (pos < nchar(line)) {
        substr(line, pos + 1, pos + 1)
      } else {
        ""
      }
      
      if (pos > 1 && prev != " ") {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = pos,
          type = "para_missing_space_before",
          text = line,
          explanation =
            "El signo '¶' debe ir precedido por espacio."
        )
      }
      
      if (pos < nchar(line) && next_char != " ") {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = pos,
          type = "para_missing_space_after",
          text = line,
          explanation =
            "El signo '¶' debe ir seguido por espacio."
        )
      }
    }
  }
  
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
# check_double_spaces()
# ---------------------------------------------------------
# Regla editorial:
#
#   No debe haber dos o más espacios ASCII consecutivos
#   dentro de una línea.
#
# =========================================================

check_double_spaces <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    pos <- regexpr(" {2,}", line, perl = TRUE)[[1]]
    
    if (pos != -1) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = pos,
        type = "double_space",
        text = line,
        explanation =
          "La línea contiene dos o más espacios ASCII consecutivos."
      )
    }
  }
  
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
# check_edge_spaces()
# ---------------------------------------------------------
# Regla editorial:
#
#   Las líneas no deben comenzar ni terminar
#   con espacios ASCII visibles.
#
# =========================================================

check_edge_spaces <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    if (grepl("^ ", line, perl = TRUE)) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = 1,
        type = "leading_space",
        text = line,
        explanation =
          "La línea comienza con un espacio ASCII."
      )
    }
    
    if (grepl(" $", line, perl = TRUE)) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = nchar(line),
        type = "trailing_space",
        text = line,
        explanation =
          "La línea termina con un espacio ASCII."
      )
    }
  }
  
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
# check_invisible_spaces()
# ---------------------------------------------------------
# Regla editorial/técnica:
#
#   No deben aparecer caracteres invisibles problemáticos.
#
# Detecta:
#
#   - NBSP
#   - TAB
#   - ZWSP
#
# =========================================================

check_invisible_spaces <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    # ---------------------------------------------
    # NBSP U+00A0
    # ---------------------------------------------
    
    pos_nbsp <- regexpr("\u00A0", line, fixed = TRUE)[[1]]
    
    if (pos_nbsp != -1) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = pos_nbsp,
        type = "nbsp_detected",
        text = line,
        explanation =
          "La línea contiene NBSP U+00A0."
      )
    }
    
    # ---------------------------------------------
    # TAB U+0009
    # ---------------------------------------------
    
    pos_tab <- regexpr("\t", line, fixed = TRUE)[[1]]
    
    if (pos_tab != -1) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = pos_tab,
        type = "tab_detected",
        text = line,
        explanation =
          "La línea contiene un tabulador."
      )
    }
    
    # ---------------------------------------------
    # ZWSP U+200B
    # ---------------------------------------------
    
    pos_zwsp <- regexpr("\u200B", line, fixed = TRUE)[[1]]
    
    if (pos_zwsp != -1) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = pos_zwsp,
        type = "zwsp_detected",
        text = line,
        explanation =
          "La línea contiene ZWSP U+200B."
      )
    }
  }
  
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
# check_grave_accent_superscript_marker()
# ---------------------------------------------------------
# Regla editorial/técnica HSMS:
#
#   En las trasncriopciones HTR, con los modelos UVa-HSMS
#   el acento grave "`" se utiliza para marcar letras
#   voladas o superescritas.
#
#   En la transcripción HSMS final, esas letras deben
#   marcarse mediante:
#
#     <<...>>
#
# ---------------------------------------------------------
# Objetivo:
#
#   Detectar restos del marcador provisional "`" para que
#   el editor pueda sustituirlo por la codificación HSMS
#   definitiva.
#
#   Proofer no corrige automáticamente el texto.
#
# =========================================================

check_grave_accent_superscript_marker <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    grave_positions <- gregexpr(
      "`",
      line,
      fixed = TRUE
    )[[1]]
    
    if (grave_positions[1] == -1) {
      next
    }
    
    for (pos in grave_positions) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = pos,
        type = "grave_accent_superscript_marker",
        text = line,
        explanation =
          "Se ha detectado un acento grave (`). En el flujo HTR UVa-HSMS puede usarse provisionalmente para marcar letras voladas, pero en la transcripción HSMS final debe sustituirse por la forma <<...>>."
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
# check_htr_abbreviation_markers()
# ---------------------------------------------------------
# Regla editorial/técnica HSMS:
#
#   En algunos flujos HTR, las abreviaturas pueden marcarse
#   provisionalmente con signos alternativos para evitar
#   conflictos con los delimitadores angulares ordinarios:
#
#     ＜...＞
#     ⊂...⊃
#
#   En la transcripción HSMS final, esas marcas deben
#   convertirse a:
#
#     <...>
#
# ---------------------------------------------------------
# Objetivo:
#
#   Detectar restos de marcas provisionales del flujo HTR
#   para que el editor pueda sustituirlas por la codificación
#   HSMS definitiva.
#
#   Proofer no corrige automáticamente el texto.
#
# =========================================================

check_htr_abbreviation_markers <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  marker_pattern <- "[＜＞⊂⊃]"
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    marker_positions <- gregexpr(
      marker_pattern,
      line,
      perl = TRUE
    )[[1]]
    
    if (marker_positions[1] == -1) {
      next
    }
    
    for (pos in marker_positions) {
      
      marker <- substr(
        line,
        pos,
        pos
      )
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = pos,
        type = "htr_abbreviation_marker_not_converted",
        text = line,
        explanation =
          paste0(
            "Se ha detectado la marca provisional HTR '",
            marker,
            "'. Antes de pasar el texto por Proofer y por el analizador, las marcas ＜...＞ o ⊂...⊃ deben convertirse a la forma HSMS <...>."
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
# check_close_open_spacing()
# ---------------------------------------------------------
# Regla editorial/técnica:
#
#   Debe existir un espacio ASCII visible entre
#   una llave de cierre "}" y una llave de apertura "{"
#   cuando ambas aparecen en la misma línea.
#
# =========================================================

check_close_open_spacing <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    pos <- regexpr("\\}\\{", line, perl = TRUE)[[1]]
    
    if (pos != -1) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = pos,
        type = "close_open_no_space",
        text = line,
        explanation =
          "Debe existir un espacio ASCII visible entre '}' y '{'."
      )
    }
  }
  
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
# check_hyphen_before_closing_brace()
# ---------------------------------------------------------
# Regla editorial:
#
#   No debe aparecer un guion "-" inmediatamente antes
#   de una llave de cierre "}".
#
# ---------------------------------------------------------
# Ejemplo válido:
#
#   pala-
#   bra}
#
# ---------------------------------------------------------
# Ejemplo inválido:
#
#   palabra-}
#
# ---------------------------------------------------------
# Parámetros:
#
#   filepath : ruta al fichero TXT que se quiere validar.
#
# ---------------------------------------------------------
# Devuelve:
#
#   data.frame con incidencias.
#
# ---------------------------------------------------------
# Notas:
#
#   - Esta función no interpreta todos los usos del guion.
#   - Solo detecta el caso específico "-}".
#   - Las demás reglas de guion se validarán aparte.
#   - No modifica el fichero original.
#
# =========================================================

check_hyphen_before_closing_brace <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    pos <- regexpr("-\\}", line, perl = TRUE)[[1]]
    
    if (pos != -1) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = pos,
        type = "hyphen_before_closing_brace",
        text = line,
        explanation =
          "Hay un guion '-' inmediatamente antes de '}'."
      )
    }
  }
  
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
# check_multiple_blank_lines()
# ---------------------------------------------------------
# Regla editorial:
#
#   No debe haber más de una línea vacía consecutiva.
#
# ---------------------------------------------------------
# Ejemplo válido:
#
#   línea 1
#
#   línea 2
#
# ---------------------------------------------------------
# Ejemplo inválido:
#
#   línea 1
#
#
#   línea 2
#
# ---------------------------------------------------------
# Parámetros:
#
#   filepath : ruta al fichero TXT que se quiere validar.
#
# ---------------------------------------------------------
# Devuelve:
#
#   data.frame con incidencias.
#
# ---------------------------------------------------------
# Notas:
#
#   - Una única línea vacía consecutiva es aceptable.
#   - Dos o más líneas vacías consecutivas generan aviso.
#   - No modifica el fichero original.
#
# =========================================================

check_multiple_blank_lines <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  blank_run <- 0
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    if (trimws(line) == "") {
      
      blank_run <- blank_run + 1
      
    } else {
      
      blank_run <- 0
    }
    
    if (blank_run >= 2) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = 1,
        type = "multiple_blank_lines",
        text = "",
        explanation =
          "Hay más de una línea vacía consecutiva."
      )
    }
  }
  
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
# check_line_length()
# ---------------------------------------------------------
# Regla editorial/técnica:
#
#   Las líneas excesivamente largas suelen indicar:
#
#     - saltos de línea perdidos;
#     - etiquetas mal cerradas;
#     - pegados accidentales;
#     - errores de OCR/HTR;
#     - corrupción del texto.
#
# ---------------------------------------------------------
# Regla aplicada:
#
#   Se genera incidencia cuando una línea supera
#   un número configurable de caracteres.
#
# ---------------------------------------------------------
# Parámetros:
#
#   filepath   : ruta al fichero TXT que se quiere validar.
#
#   max_length : longitud máxima permitida.
#                Valor por defecto: 120.
#
# ---------------------------------------------------------
# Devuelve:
#
#   data.frame con incidencias.
#
# ---------------------------------------------------------
# Notas:
#
#   - Esta función NO corta líneas.
#   - Esta función NO modifica el texto.
#   - Solo detecta posibles anomalías.
#   - El umbral puede ajustarse más adelante
#     según el corpus real HSMS.
#
# =========================================================

check_line_length <- function(filepath,
                              max_length = 150) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  # -------------------------------------------------
  # Recorrido línea a línea
  # -------------------------------------------------
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    line_length <- nchar(
      line,
      type = "chars"
    )
    
    if (line_length > max_length) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = max_length + 1,
        type = "line_too_long",
        text = line,
        explanation = paste0(
          "La línea tiene ",
          line_length,
          " caracteres y supera el máximo recomendado de ",
          max_length,
          "."
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
# Ejemplos válidos:
#
#   {CB1.
#   {LAT.
#   {RMK:
#
# ---------------------------------------------------------
# Ejemplos inválidos:
#
#   {cb1.
#   {Lat.
#   {rMk:
#
# ---------------------------------------------------------
# Notas:
#
#   Solo se validan etiquetas reconocidas por el catálogo.
#   Las etiquetas desconocidas ya se detectan en:
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
  
  issues <- list()
  
  pattern <- "\\{=?([A-Za-z]+)([0-9]*)(=)?([\\.:])"
  
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
      
      tag_raw <- sub(
        "^\\{=?([A-Za-z]+)([0-9]*)(=)?([\\.:])$",
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
          line = line_no,
          col = pos,
          type = "mnemonic_not_uppercase",
          text = line,
          explanation = paste0(
            "La etiqueta {",
            tag_raw,
            " debe escribirse en mayúsculas."
          )
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
# check_illegible_marker_length()
# ---------------------------------------------------------
# Regla editorial/paleográfica HSMS:
#
#   Las marcas de ilegibilidad reconocidas son:
#
#     ??   = palabra o parte de palabra ilegible
#     ???  = frase ilegible
#
# ---------------------------------------------------------
# Objetivo
# ---------------------------------------------------------
#
#   Detectar secuencias de cuatro o más signos de
#   interrogación consecutivos, porque no corresponden
#   a ninguna marca funcional definida por PROOFER.
#
# ---------------------------------------------------------
# Ejemplos válidos:
#
#   ??
#   ???
#
# ---------------------------------------------------------
# Ejemplos inválidos:
#
#   ????
#   ?????
#
# =========================================================

check_illegible_marker_length <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    matches <- gregexpr(
      "\\?{4,}",
      line,
      perl = TRUE
    )[[1]]
    
    if (matches[1] == -1) next
    
    for (pos in matches) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = pos,
        type = "invalid_illegible_marker_length",
        text = line,
        explanation =
          "Las marcas de ilegibilidad válidas son '??' y '???'; no debe usarse una secuencia de cuatro o más signos '?'."
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
# check_mnemonic_continuation_plus()
# ---------------------------------------------------------
# Regla editorial/funcional HSMS:
#
#   El signo "+" indica continuación lógica del texto
#   contenido en un mnemónico.
#
# Reglas:
#
#   1. Debe aparecer como " +}".
#   2. Debe estar dentro de un mnemónico.
#   3. El mnemónico debe permitir continuación según
#      hsms_structural_tag_catalog()$can_continue.
#   4. La etiqueta puede haberse abierto en una línea
#      anterior y cerrarse en la línea actual.
#
# ---------------------------------------------------------
# Caso documentado:
#
#   {RUB. texto rubricado interrumpido +
#   } texto no rubricado {RUB. continuación}
#
# En la práctica puede aparecer como:
#
#   {RUB. ¶ Memoria d<e> to-
#   dos los sanctos como aueys echo a maytynes. +}
#   Sanctos de dios to. {RUB. co<n>(n) esta. Oracion.}
#
# Proofer debe entender que el "+}" pertenece a RUB,
# aunque "{RUB." no esté en la misma línea física.
#
# =========================================================

check_mnemonic_continuation_plus <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  catalog <- hsms_structural_tag_catalog()
  
  continuation_tags <- catalog$tag[
    catalog$can_continue %in% TRUE
  ]
  
  issues <- list()
  
  mnemonic_pattern <- "^\\{=?([A-Za-z]+)[0-9]*=?[\\.:]"
  
  mnemonic_stack <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
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
      rest <- substr(
        line,
        i,
        nchar(line)
      )
      
      # ---------------------------------------------
      # Apertura de mnemónico
      # ---------------------------------------------
      
      m <- regexec(
        mnemonic_pattern,
        rest,
        perl = TRUE
      )
      
      r <- regmatches(
        rest,
        m
      )[[1]]
      
      if (length(r) > 0) {
        
        tag <- toupper(r[[2]])
        
        mnemonic_stack[[length(mnemonic_stack) + 1]] <- list(
          tag = tag,
          line = line_no,
          col = i
        )
        
        i <- i + 1
        next
      }
      
      # ---------------------------------------------
      # Cierre de mnemónico
      # ---------------------------------------------
      
      if (ch == "}") {
        
        has_plus_before_closing <- (
          i > 1 &&
            chars[[i - 1]] == "+"
        )
        
        if (has_plus_before_closing) {
          
          has_required_space <- (
            i > 2 &&
              chars[[i - 2]] == " "
          )
          
          current_tag <- if (length(mnemonic_stack) > 0) {
            mnemonic_stack[[length(mnemonic_stack)]]$tag
          } else {
            NA_character_
          }
          
          plus_col <- i - 1
          
          if (!has_required_space) {
            
            issues[[length(issues) + 1]] <- list(
              line = line_no,
              col = plus_col,
              type = "continuation_plus_wrong_format",
              text = line,
              explanation =
                "El signo '+' de continuación debe aparecer como ' +}' antes de la llave de cierre."
            )
            
          } else if (is.na(current_tag)) {
            
            issues[[length(issues) + 1]] <- list(
              line = line_no,
              col = plus_col,
              type = "continuation_plus_without_mnemonic",
              text = line,
              explanation =
                "El signo '+' de continuación debe pertenecer a una etiqueta."
            )
            
          } else if (!(current_tag %in% continuation_tags)) {
            
            issues[[length(issues) + 1]] <- list(
              line = line_no,
              col = plus_col,
              type = "continuation_plus_not_allowed",
              text = line,
              explanation =
                paste0(
                  "El mnemónico {",
                  current_tag,
                  ".} no permite continuación con '+'."
                )
            )
          }
        }
        
        if (length(mnemonic_stack) > 0) {
          mnemonic_stack <- mnemonic_stack[-length(mnemonic_stack)]
        }
        
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
  
  do.call(
    rbind,
    lapply(
      issues,
      as.data.frame,
      stringsAsFactors = FALSE
    )
  )
}


# =========================================================
# check_mnemonic_continuation_target()
# ---------------------------------------------------------
# Regla editorial/funcional HSMS:
#
#   Si una etiqueta textual termina con " +}", debe existir
#   posteriormente otra etiqueta del mismo tipo.
#
# ---------------------------------------------------------
# Notas:
#
#   - La posibilidad de continuación se toma del catálogo:
#       can_continue == TRUE
#
#   - Se excluyen explícitamente etiquetas no textuales
#     o estructurales como CB, CW y SG.
#
# =========================================================

# =========================================================
# FUTURE HSMS EXTENSION
# ---------------------------------------------------------
# Actualmente se implementa únicamente la continuidad
# documentada en el sistema HSMS clásico:
#
#   RUB
#   HD
#
# Existe una propuesta editorial para permitir también:
#
#   AD
#   GL
#
# cuando una adición o glosa marginal se prolonga a lo
# largo de varios folios.
#
# La arquitectura actual ya lo soporta mediante:
#
#   hsms_structural_tag_catalog()$can_continue
#
# Por tanto, la ampliación futura consistirá únicamente
# en modificar el catálogo, sin reescribir las reglas
# de validación.
#
# Estado: PENDIENTE DE DECISIÓN EDITORIAL.
# =========================================================

check_mnemonic_continuation_target <- function(filepath) {
  
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
  
  non_textual_tags <- c("CB", "CW", "SG")
  
  for (i in seq_len(nrow(mnemonics))) {
    
    row <- mnemonics[i, ]
    
    line_no <- row$line[[1]]
    tag <- row$tag[[1]]
    
    if (tag %in% non_textual_tags) next
    
    if (!tag %in% catalog$tag) next
    
    tag_info <- catalog[
      catalog$tag == tag,
      ,
      drop = FALSE
    ]
    
    if (!isTRUE(tag_info$can_continue[[1]])) next
    
    line <- lines[[line_no]]
    
    has_continuation_plus <- grepl(
      " \\+\\}\\s*$",
      line,
      perl = TRUE
    )
    
    if (!has_continuation_plus) next
    
    later_same_tag <- mnemonics[
      mnemonics$tag == tag &
        (
          mnemonics$line > line_no |
            (
              mnemonics$line == line_no &
                mnemonics$col > row$col[[1]]
            )
        ),
      ,
      drop = FALSE
    ]
    
    if (nrow(later_same_tag) == 0) {
      
      issues[[length(issues) + 1]] <- list(
        line = line_no,
        col = row$col[[1]],
        type = "continuation_without_target",
        text = line,
        explanation = paste0(
          "La etiqueta {",
          tag,
          " termina con ' +}', pero no se encontró otra etiqueta {",
          tag,
          " posterior para continuar el texto."
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
# check_mnemonic_vector_equals()
# ---------------------------------------------------------
# Regla editorial/funcional HSMS:
#
#   El signo "=" tiene función especial en PROOFER:
#   marca vector en las etiquetas que lo permiten.
#
# ---------------------------------------------------------
# Regla aplicada:
#
#   "=" solo puede aparecer como prefijo o sufijo
#   funcional si el catálogo lo permite.
#
# Actualmente lo permiten:
#
#   {MIN
#   {DIAG
#
# ---------------------------------------------------------
# Ejemplos válidos:
#
#   {=MIN.}
#   {MIN=.}
#   {=MIN=.}
#
# ---------------------------------------------------------
# Ejemplos inválidos:
#
#   texto = texto
#   {LAT=. texto}
#   {=LAT. texto}
#
# =========================================================

check_mnemonic_vector_equals <- function(filepath) {
  
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
    
    has_vector_prefix <- isTRUE(
      row$has_vector_prefix[[1]]
    )
    
    has_vector_suffix <- isTRUE(
      row$has_vector_suffix[[1]]
    )
    
    if (!(has_vector_prefix || has_vector_suffix)) {
      next
    }
    
    if (!tag %in% catalog$tag) {
      next
    }
    
    tag_info <- catalog[
      catalog$tag == tag,
      ,
      drop = FALSE
    ]
    
    prefix_allowed <- isTRUE(
      tag_info$allows_vector_prefix[[1]]
    )
    
    suffix_allowed <- isTRUE(
      tag_info$allows_vector_suffix[[1]]
    )
    
    invalid_prefix <- has_vector_prefix && !prefix_allowed
    invalid_suffix <- has_vector_suffix && !suffix_allowed
    
    if (invalid_prefix || invalid_suffix) {
      
      issues[[length(issues) + 1]] <- list(
        line = row$line[[1]],
        col = row$col[[1]],
        type = "invalid_mnemonic_vector_equals",
        text = lines[[row$line[[1]]]],
        explanation = paste0(
          "La etiqueta {",
          tag,
          " no permite el uso de '=' como vector."
        )
      )
    }
  }
  
  # -------------------------------------------------
  # Detectar signos "=" que no pertenecen a ninguna
  # etiqueta reconocida por extract_hsms_mnemonics().
  # -------------------------------------------------
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    equals_positions <- gregexpr(
      "=",
      line,
      fixed = TRUE
    )[[1]]
    
    if (equals_positions[1] == -1) next
    
    line_mnemonics <- mnemonics[
      mnemonics$line == line_no &
        (mnemonics$has_vector_prefix |
           mnemonics$has_vector_suffix),
      ,
      drop = FALSE
    ]
    
    valid_ranges <- list()
    
    if (nrow(line_mnemonics) > 0) {
      
      for (i in seq_len(nrow(line_mnemonics))) {
        
        raw <- line_mnemonics$raw[[i]]
        start <- line_mnemonics$col[[i]]
        end <- start + nchar(raw) - 1
        
        valid_ranges[[length(valid_ranges) + 1]] <- c(
          start,
          end
        )
      }
    }
    
    for (pos in equals_positions) {
      
      inside_any_mnemonic_vector <- FALSE
      
      if (length(valid_ranges) > 0) {
        
        for (range in valid_ranges) {
          
          if (pos >= range[[1]] && pos <= range[[2]]) {
            inside_any_mnemonic_vector <- TRUE
            break
          }
        }
      }
      
      if (!inside_any_mnemonic_vector) {
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = pos,
          type = "invalid_mnemonic_vector_equals",
          text = line,
          explanation =
            "El signo '=' solo debe usarse como vector dentro de una etiqueta que lo permita."
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
# check_ad_gl_inserted_text_format()
# ---------------------------------------------------------
# Regla editorial/funcional HSMS:
#
#   Las etiquetas {AD. y {GL. tienen procesamiento
#   especial en PROOFER.
#
# Deben ir seguidos de:
#
#   espacio + [^ + texto
#
# ---------------------------------------------------------
# Ejemplos válidos:
#
#   {AD. [^texto añadido]}
#   {GL. [^glosa añadida]}
#
# ---------------------------------------------------------
# Ejemplos inválidos:
#
#   {AD. texto}
#   {GL. glosa}
#   {AD.[^texto]}
#
# =========================================================

check_ad_gl_inserted_text_format <- function(filepath) {
  
  lines <- readLines(
    filepath,
    encoding = "UTF-8",
    warn = FALSE
  )
  
  issues <- list()
  
  for (line_no in seq_along(lines)) {
    
    line <- lines[[line_no]]
    
    matches <- gregexpr(
      "\\{(AD|GL)\\.",
      line,
      perl = TRUE
    )[[1]]
    
    if (matches[1] == -1) next
    
    for (pos in matches) {
      
      after_tag <- substr(
        line,
        pos,
        nchar(line)
      )
      
      valid_format <- grepl(
        "^\\{(AD|GL)\\. \\[\\^.+",
        after_tag,
        perl = TRUE
      )
      
      if (!valid_format) {
        
        tag <- sub(
          "^\\{(AD|GL)\\..*$",
          "\\1",
          after_tag,
          perl = TRUE
        )
        
        issues[[length(issues) + 1]] <- list(
          line = line_no,
          col = pos,
          type = "invalid_ad_gl_inserted_text_format",
          text = line,
          explanation = paste0(
            "La etiqueta {",
            tag,
            ". debe ir seguida de espacio + '[^' + texto."
          )
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
# check_editorial()
# ---------------------------------------------------------
# Ensamblador de reglas editoriales
#
# Esta función ejecuta todas las reglas editoriales
# actualmente activas y combina sus resultados.
#
# =========================================================

check_editorial <- function(filepath) {
  
  editorial_issues <- list(
    check_ellipsis(filepath),
    check_grave_accent_superscript_marker(filepath),
    check_htr_abbreviation_markers(filepath),
    check_double_calderon_marker(filepath),
    check_percent_spacing(filepath),
    #check_para_spacing(filepath),
    check_double_spaces(filepath),
    check_edge_spaces(filepath),
    check_invisible_spaces(filepath),
    check_close_open_spacing(filepath),
    check_hyphen_before_closing_brace(filepath),
    check_multiple_blank_lines(filepath),
    check_line_length(filepath),
    check_illegible_marker_length(filepath),
    check_mnemonic_continuation_plus(filepath),
    check_mnemonic_continuation_target(filepath),
    check_mnemonic_vector_equals(filepath),
    check_ad_gl_inserted_text_format(filepath)
  )
  
  editorial_issues <- lapply(editorial_issues, standardize_issues)
  
  do.call(rbind, editorial_issues)
}

