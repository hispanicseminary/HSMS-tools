# =========================================================
# HTR to HSMS
# =========================================================
library(shiny)
library(bslib)

APP_VERSION <- "0.1.0"

# ============================================================
# REGLAS DE SUSTITUCIÓN
# ============================================================
#
# IMPORTANTE:
# - Guardar este fichero R con codificación UTF-8.
# - Las reglas se aplican secuencialmente.
# - El orden evita que una regla general impida aplicar
#   posteriormente otra más específica.
# ============================================================

patron <- c(
  "--------------- .* ---------------\\r\\n",
  "\\{CB([0-9]+)\\.",  # 1
  "\\{HD([0-9]*)\\.",  # 2
  "⊂",                 # 3
  "⊃",                 # 4
  "＜",                 # 5
  "＞",                 # 6
  "\\(\\(",             # 7
  "\\)\\)",             # 8
  "%",                 # 9
  "¶2",                 # 9a
  "¶3",                 # 9b  
  "([a-z])`",          # 10
  "c'",                # 11
  "C'",                # 12
  "n~",                # 13
  "N~",                # 14
  "cͥ",                 # 15
  "qͥs",                # 16: antes de la regla general ͥ
  "ͥ",                   # 17
  "oẽ",                # 18: antes de ẽ
  "tiẽp",              # 19: antes de ẽ
  "ẽ",                 # 20
  "õe",                # 21: antes de õ
  "õs",                # 22: antes de õ
  "õ",                 # 23
  "ã",                 # 24
  "ĩ",                 # 25
  "ũ",                 # 26
  "q̃r",                # 27: antes de q̃
  "q̃",                 # 28
  "om̃e",               # 29
  "om̃s",               # 30
  "m̃t",                # 31
  "ꝰ",                 # 32
  "⁊",                 # 33
  "at̾",                # 34: antes de la regla general ̾
  "̾",                  # 35
  "Qnͣ",                # 36: antes de la regla general ͣ
  "qnͣd",               # 37: antes de la regla general ͣ
  "qͣ",                 # 38: antes de la regla general ͣ
  "tͣ",                 # 39: antes de la regla general ͣ
  "ͣ",                  # 40
  "ꝑa",                # 41: antes de la regla general ꝑ
  "ꝑd",                # 42: antes de la regla general ꝑ
  "ꝑ",                 # 43
  "ç",                 # 44
  " ꝯ",                # 45: espacio U+0020 antes de ꝯ
  "ꝯ ",                # 46: espacio U+0020 después de ꝯ
  "ꝓ",                 # 47
  "głi",                # 48
  "cłi",                # 49
  "cłp",                # 50
  "q̈",                 # 51
  "ñ",                 # 52
  "ẜ",                 # 53
  "pła",                # 54
  "ᷤ",                  # 55
  "ͦ"                   # 56
)

reemplazo <- c(
  "",
  "\r\n{CB\\1.\r\n",    # 1
  "\r\n{HD\\1.",        # 2
  "<",                  # 3
  ">",                  # 4
  "<",                  # 5
  ">",                  # 6
  "≺",                  # 7
  "≻",                  # 8
  "¶",                  # 9
  "%2",                  # 9a
  "%3",                  # 9b
  "<<\\1>>",            # 10
  "ç",                  # 11
  "Ç",                  # 12
  "ñ",                  # 13
  "Ñ",                  # 14
  "c<r><<i>>",          # 15
  "q<u><<i>>s",         # 16
  "<r><<i>>",           # 17
  "o<mn>e",             # 18
  "tie<n>p",            # 19
  "e<n>",               # 20
  "o<mn>e",             # 21
  "o<mne>s",            # 22
  "o<n>",               # 23
  "a<n>",               # 24
  "i<n>",               # 25
  "u<n>",               # 26
  "q<u><<a>>r",         # 27
  "q<ue>",              # 28
  "om<n>e",             # 29
  "om<ne>s",            # 30
  "m<en>t",             # 31
  "<os>",                # 32
  "&",                   # 33
  "at<ur>",              # 34
  "<er>",                # 35
  "Q<u><<a>>n",         # 36
  "q<u><<a>>nd",        # 37
  "q<u><<a>>",          # 38
  "t<r><<a>>",          # 39
  "<<a>>",               # 40
  "p<ar>a",             # 41
  "p<er>d",              # 42
  "p<or>",               # 43
  "ç",                   # 44
  " c<on>",              # 45
  "<os> ",               # 46
  "p<ro>",               # 47
  "gl<es>i",             # 48
  "cl<er>i",             # 49
  "c<u>lp",              # 50
  "q<u><<a>>",          # 51
  "ñ",                   # 52
  "s<er>",               # 53
  "pl<anet>a",           # 54
  "<<s>>",               # 55
  "<<o>>"                # 56
)

descripcion <- c(
  "Eliminar la línea separadora de sección",
  "Añadir saltos de línea antes y después de la etiqueta CB",
  "Añadir saltos de línea antes de la etiqueta HD",
  "Convertir el símbolo ⊂ en <",
  "Convertir el símbolo ⊃ en >",
  "Convertir el signo menor que de ancho completo en <",
  "Convertir el signo mayor que de ancho completo en >",
  "Convertir (( en ≺",
  "Convertir )) en ≻",
  "Convertir % en ¶",
  "Convertir ¶2 en %2",
  "Convertir ¶3 en %3",
  "Marcar una letra volada",
  "Convertir c seguida de apóstrofo en ç",
  "Convertir C seguida de apóstrofo en Ç",
  "Convertir n seguida de virgulilla en ñ",
  "Convertir N seguida de virgulilla en Ñ",
  "Expandir c con i volada",
  "Expandir q con i volada seguida de s",
  "Expandir el signo general de i volada",
  "Expandir oe con virgulilla",
  "Expandir tie con virgulilla seguida de p",
  "Expandir e con virgulilla",
  "Expandir o con virgulilla seguida de e",
  "Expandir o con virgulilla seguida de s",
  "Expandir o con virgulilla",
  "Expandir a con virgulilla",
  "Expandir i con virgulilla",
  "Expandir u con virgulilla",
  "Expandir q con virgulilla seguida de r",
  "Expandir q con virgulilla",
  "Expandir om con virgulilla seguida de e",
  "Expandir om con virgulilla seguida de s",
  "Expandir m con virgulilla seguida de t",
  "Expandir el signo de abreviación ꝰ",
  "Convertir el signo tironiano ⁊ en ampersand",
  "Expandir at con signo de abreviación",
  "Expandir el signo general de abreviación er",
  "Expandir Qn con a volada",
  "Expandir qn con a volada seguida de d",
  "Expandir q con a volada",
  "Expandir t con a volada",
  "Expandir el signo general de a volada",
  "Expandir ꝑ seguida de a",
  "Expandir ꝑ seguida de d",
  "Expandir el signo general ꝑ",
  "Normalizar c con cedilla combinada como ç",
  "Expandir ꝯ precedido de un espacio",
  "Expandir ꝯ seguido de un espacio",
  "Expandir el signo ꝓ",
  "Expandir głi",
  "Expandir cłi",
  "Expandir cłp",
  "Expandir q con diéresis",
  "Normalizar n con virgulilla combinada como ñ",
  "Expandir el carácter ẜ",
  "Expandir pła",
  "Convertir el signo de s volada",
  "Convertir el signo de o volada"
)

stopifnot(
  length(patron) == length(reemplazo),
  length(patron) == length(descripcion)
)

reglas <- data.frame(
  numero = seq_along(patron),
  patron = patron,
  reemplazo = reemplazo,
  descripcion = descripcion,
  stringsAsFactors = FALSE
)

reglas_espacios <- data.frame(
  patron = c(
    "\\x09",  # TAB U+0009
    "\u200B",
    " {2,}",
    " +(\\r\\n|\\n|\\r)",
    "(\\r\\n|\\n|\\r) +",
    "(\\r\\n|\\n|\\r)(?:\\r\\n|\\n|\\r)+"
  ),

  reemplazo = c(
    " ",
    " ",
    " ",
    "\\1",
    "\\1",
    "\\1"
  ),

  descripcion = c(
    "Convertir tabulación U+0009 en un espacio en blanco",
    "Convertir el espacio de ancho cero U+200B en un espacio en blanco",
    "Reducir dos o más espacios en blanco a uno",
    "Eliminar espacios antes de un salto de línea",
    "Eliminar espacios después de un salto de línea",
    "Reducir dos o más saltos de línea consecutivos a uno"
  ),

  stringsAsFactors = FALSE
)

# Incorporar estas reglas a la tabla que procesa la aplicación
reglas_espacios$numero <- seq.int(
  from = nrow(reglas) + 1L,
  length.out = nrow(reglas_espacios)
)

reglas_espacios <- reglas_espacios[, c(
  "numero",
  "patron",
  "reemplazo",
  "descripcion"
)]

reglas <- rbind(
  reglas,
  reglas_espacios
)

stopifnot(nrow(reglas) == 65L)

# ============================================================
# FUNCIONES AUXILIARES
# ============================================================

leer_archivo_utf8 <- function(filepath) {

  tamano <- file.info(filepath)$size

  if (is.na(tamano) || tamano == 0) {
    stop("El fichero está vacío.")
  }

  contenido_raw <- readBin(
    con = filepath,
    what = "raw",
    n = tamano
  )

  texto <- rawToChar(contenido_raw)

  # Eliminación de BOM UTF-8, si está presente.
  texto <- sub("^\ufeff", "", texto)

  # Validación de la codificación.
  texto_utf8 <- iconv(
    texto,
    from = "UTF-8",
    to = "UTF-8",
    sub = NA_character_
  )

  if (is.na(texto_utf8)) {
    stop(
      paste(
        "El fichero no contiene texto UTF-8 válido.",
        "Compruebe su codificación antes de volver a subirlo."
      )
    )
  }

  Encoding(texto_utf8) <- "UTF-8"
  texto_utf8
}


normalizar_saltos_linea <- function(texto) {

  # Las expresiones proporcionadas utilizan CRLF (\r\n).
  # Por ello se convierten los saltos de línea de Windows,
  # Linux y macOS al formato CRLF antes de procesar el texto.

  gsub(
    pattern = "\r\n|\r|\n",
    replacement = "\r\n",
    x = texto,
    perl = TRUE,
    useBytes = FALSE
  )
}


contar_coincidencias <- function(texto, patron) {

  coincidencias <- gregexpr(
    pattern = patron,
    text = texto,
    perl = TRUE,
    useBytes = FALSE
  )[[1]]

  if (length(coincidencias) == 1 && coincidencias[1] == -1) {
    return(0L)
  }

  length(coincidencias)
}


procesar_texto <- function(texto, reglas) {

  resultado <- normalizar_saltos_linea(texto)

  informe <- data.frame(
    numero = reglas$numero,
    descripcion = reglas$descripcion,
    coincidencias = integer(nrow(reglas)),
    stringsAsFactors = FALSE
  )

  # Todas las reglas se recorren, aunque no encuentren coincidencias.
  for (i in seq_len(nrow(reglas))) {

    informe$coincidencias[i] <- contar_coincidencias(
      texto = resultado,
      patron = reglas$patron[i]
    )

    resultado <- gsub(
      pattern = reglas$patron[i],
      replacement = reglas$reemplazo[i],
      x = resultado,
      perl = TRUE,
      useBytes = FALSE
    )
  }

  list(
    texto = resultado,
    informe = informe
  )
}


# ============================================================
# INTERFAZ DE USUARIO
# ============================================================

ui <- navbarPage(

  theme = bs_theme(
    version = 5,
    bootswatch = "sandstone"
  ),

  title = tagList(
    tags$img(
      src = "https://oldspanishtextualarchive.org/css/hsms.png",
      height = "80px",
      style = "margin-right: 15px; margin-top: -5px;"
    ),
    "HSMS Text Processor"
  ),

  # ==========================================================
  # PESTAÑA DE PROCESAMIENTO
  # ==========================================================

  tabPanel(
    "Procesamiento / Processing",

    sidebarLayout(

      sidebarPanel(
        fileInput(
          inputId = "file",
          label = "Seleccionar fichero / Select file",
          accept = c(".txt", "text/plain")
        ),

        helpText(
          HTML(
            paste0(
              "El fichero debe ser texto plano codificado en UTF-8.",
              "<br/>",
              "The file must be UTF-8 plain text."
            )
          )
        ),

        hr(),

        downloadButton(
          outputId = "download",
          label = "Descargar resultado / Download result",
          class = "btn-primary"
        ),

        hr(),

        tags$p(
          tags$strong("Proceso:")
        ),

        tags$ol(
          tags$li("Lectura y validación del fichero UTF-8."),
          tags$li("Normalización de saltos de línea."),
          tags$li("Aplicación secuencial de todas las reglas."),
          tags$li("Generación del nuevo fichero TXT.")
        )
      ),

      mainPanel(
        uiOutput("summary"),

        tabsetPanel(
          tabPanel(
            "Resultado / Result",
            br(),
            verbatimTextOutput(
              outputId = "preview",
              placeholder = TRUE
            )
          ),

          tabPanel(
            "Informe / Report",
            br(),
            tableOutput("report")
          ),

          tabPanel(
            "Reglas / Rules",
            br(),
            tableOutput("rules")
          )
        )
      )
    )
  ),

  # ==========================================================
  # PESTAÑA ACERCA DE
  # ==========================================================

  tabPanel(
    "Acerca de / About",

    fluidPage(
      br(),

      h2("HSMS Text Processor"),

      p(
        paste("Versión / Version:", APP_VERSION)
      ),

      hr(),

      h3("Descripción / Description"),

      p(
        paste(
          "Esta aplicación procesa ficheros de texto plano",
          "mediante la aplicación secuencial de expresiones",
          "regulares y reglas de sustitución."
        )
      ),

      p(
        paste(
          "This application processes plain-text files by",
          "sequentially applying regular expressions and",
          "replacement rules."
        )
      ),

      hr(),

      h3("Funcionamiento / How it works"),

      tags$ul(
        tags$li(
          paste(
            "Carga y valida ficheros de texto codificados",
            "en UTF-8."
          )
        ),
        tags$li(
          paste(
            "Normaliza los finales de línea y aplica todas",
            "las reglas de sustitución en el orden establecido."
          )
        ),
        tags$li(
          paste(
            "Muestra una previsualización y un informe",
            "de las coincidencias encontradas."
          )
        ),
        tags$li(
          paste(
            "Genera un nuevo fichero de texto codificado",
            "en UTF-8 con finales de línea CRLF."
          )
        )
      ),

      tags$ul(
        tags$li(
          "Uploads and validates UTF-8 plain-text files."
        ),
        tags$li(
          paste(
            "Normalizes line endings and applies all",
            "replacement rules in the specified order."
          )
        ),
        tags$li(
          paste(
            "Displays a preview and a report of the",
            "matches found."
          )
        ),
        tags$li(
          paste(
            "Generates a new UTF-8 text file with CRLF",
            "line endings."
          )
        )
      ),

      hr(),

      h3("Codificación / Encoding"),

      p(
        paste(
          "Los ficheros de entrada deben estar codificados",
          "en UTF-8. El fichero resultante también se genera",
          "en UTF-8."
        )
      ),

      p(
        paste(
          "Input files must use UTF-8 encoding.",
          "The resulting file is also generated in UTF-8."
        )
      ),

      hr(),

      h3("Proyecto / Project"),

      p(
        tags$a(
          href = "https://oldspanishtextualarchive.org/",
          target = "_blank",
          rel = "noopener noreferrer",
          "Old Spanish Textual Archive"
        )
      )
    )
  )
)


# ============================================================
# LÓGICA DEL SERVIDOR
# ============================================================

server <- function(input, output, session) {

  processing_result <- reactive({

    req(input$file)

    withProgress(
      message = paste(
        "Procesando fichero /",
        "Processing file"
      ),
      detail = "Espere, por favor... / Please wait...",
      value = 0,
      {

        incProgress(
          0.2,
          detail = paste(
            "Leyendo y comprobando el fichero /",
            "Reading and checking file"
          )
        )

        tryCatch(
          {
            texto_original <- leer_archivo_utf8(
              input$file$datapath
            )

            incProgress(
              0.5,
              detail = paste(
                "Aplicando expresiones regulares /",
                "Applying regular expressions"
              )
            )

            procesado <- procesar_texto(
              texto = texto_original,
              reglas = reglas
            )

            incProgress(
              0.3,
              detail = paste(
                "Preparando el resultado /",
                "Preparing result"
              )
            )

            list(
              ok = TRUE,
              texto = procesado$texto,
              informe = procesado$informe,
              error = NULL
            )
          },

          error = function(e) {
            list(
              ok = FALSE,
              texto = NULL,
              informe = NULL,
              error = conditionMessage(e)
            )
          }
        )
      }
    )
  })


  output$summary <- renderUI({

    if (is.null(input$file)) {
      return(
        div(
          class = "alert alert-info",
          HTML(
            paste0(
              "Seleccione un fichero TXT para iniciar el procesamiento.",
              "<br/>",
              "Select a TXT file to start processing."
            )
          )
        )
      )
    }

    resultado <- processing_result()

    if (!resultado$ok) {
      return(
        div(
          class = "alert alert-danger",
          h4(
            HTML(
              "&#9888; No se ha podido procesar el fichero. / ",
              "The file could not be processed."
            )
          ),
          p(resultado$error)
        )
      )
    }

    total_coincidencias <- sum(
      resultado$informe$coincidencias
    )

    reglas_con_coincidencias <- sum(
      resultado$informe$coincidencias > 0
    )

    div(
      class = "alert alert-success",

      h4(
        HTML(
          paste0(
            "&#10004; Fichero procesado correctamente.",
            "<br/>",
            "&#10004; File processed successfully."
          )
        )
      ),

      p(
        HTML(
          paste0(
            "<strong>",
            htmltools::htmlEscape(input$file$name),
            "</strong><br/>",
            nrow(reglas),
            " reglas ejecutadas; ",
            reglas_con_coincidencias,
            " con coincidencias; ",
            total_coincidencias,
            " sustituciones."
          )
        )
      )
    )
  })


output$preview <- renderText({
  req(input$file)

  resultado <- processing_result()

  validate(
    need(
      resultado$ok,
      resultado$error
    )
  )

  # Normalizar a LF únicamente para mostrar el texto en el navegador.
  texto_vista <- gsub(
    "\r\n",
    "\n",
    resultado$texto,
    fixed = TRUE
  )

  texto_vista <- gsub(
    "\r",
    "\n",
    texto_vista,
    fixed = TRUE
  )

  limite <- 20000

  if (nchar(texto_vista, type = "chars") > limite) {
    paste0(
      substr(texto_vista, 1, limite),
      "\n\n",
      "[Previsualización limitada a 20.000 caracteres / ",
      "Preview limited to 20,000 characters]"
    )
  } else {
    texto_vista
  }
})


  output$report <- renderTable({

    req(input$file)

    resultado <- processing_result()

    validate(
      need(
        resultado$ok,
        resultado$error
      )
    )

    informe <- resultado$informe

    names(informe) <- c(
      "Regla",
      "Descripción",
      "Coincidencias"
    )

    informe
  }, striped = TRUE, bordered = TRUE, spacing = "s")


  output$rules <- renderTable({

    tabla <- reglas[, c(
      "numero",
      "patron",
      "reemplazo",
      "descripcion"
    )]

    # Representación legible de los saltos de línea.
    tabla$patron <- gsub(
      "\r",
      "\\\\r",
      tabla$patron,
      fixed = TRUE
    )

    tabla$patron <- gsub(
      "\n",
      "\\\\n",
      tabla$patron,
      fixed = TRUE
    )

    tabla$reemplazo <- gsub(
      "\r",
      "\\\\r",
      tabla$reemplazo,
      fixed = TRUE
    )

    tabla$reemplazo <- gsub(
      "\n",
      "\\\\n",
      tabla$reemplazo,
      fixed = TRUE
    )

    names(tabla) <- c(
      "Regla",
      "Patrón",
      "Reemplazo",
      "Descripción"
    )

    tabla
  }, striped = TRUE, bordered = TRUE, spacing = "s")


output$download <- downloadHandler(
  filename = function() {
    req(input$file)

    nombre_base <- tools::file_path_sans_ext(
      basename(input$file$name)
    )

    paste0(
      nombre_base,
      "_procesado.txt"
    )
  },

  content = function(file) {
    resultado <- processing_result()

    validate(
      need(
        resultado$ok,
        resultado$error
      )
    )

    texto_descarga <- resultado$texto

    # Unificar primero todos los finales de línea como LF.
    texto_descarga <- gsub(
      pattern = "\r\n|\r|\n",
      replacement = "\n",
      x = texto_descarga,
      perl = TRUE,
      useBytes = FALSE
    )

    # Convertir después LF a CRLF.
    texto_descarga <- gsub(
      pattern = "\n",
      replacement = "\r\n",
      x = texto_descarga,
      fixed = TRUE,
      useBytes = FALSE
    )

    writeBin(
      object = charToRaw(enc2utf8(texto_descarga)),
      con = file
    )
  },

  contentType = "text/plain; charset=UTF-8"
)
}


shinyApp(ui = ui, server = server)