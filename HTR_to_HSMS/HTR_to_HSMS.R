library(shiny)
library(bslib)

# ============================================================
# REGLAS DE SUSTITUCIÓN
# ============================================================
#
# U+0020 se ha convertido en un espacio real.
# Las reglas se aplican secuencialmente en el orden indicado.
#
# En replacement:
#   \\1 representa el primer grupo de captura.
# ============================================================

reglas <- data.frame(
  numero = seq_len(17),

  patron = c(
    "--------------- .* ---------------\\r\\n",
    "\\{CB([0-9]+)\\.",
	"\\{HD([0-9]*)\\.",
    "⊂",
    "⊃",
    "＜",
    "＞",
	"%",
    "([a-z])`",
    "c'",
    "C'",
    "n~",
    "N~",
    "  ",                   # U+0020 U+0020
    " \\r\\n",              # U+0020 seguido de CRLF
    "\\r\\nrn ",            # Interpretación literal de la regla recibida
    "\\r\\n\\r\\n"
  ),

  reemplazo = c(
    "",
    "\r\n{CB\\1.\r\n",
    "\r\n{HD\\1.",
	"<",
    ">",
    "<",
    ">",
	"¶",
    "<<\\1>>",
    "ç",
    "Ç",
    "ñ",
    "Ñ",
    " ",                    # U+0020
    "\r\n",
    "\r\n",
    "\r\n"
  ),

  descripcion = c(
    "Eliminar separador y sustituirlo por un espacio",
    "Añadir saltos de línea alrededor de la etiqueta CB",
    "Añadir saltos de línea alrededor de la etiqueta HD",
	"Convertir ⊂ en <",
    "Convertir ⊃ en >",
	"Convertir ＜ en <",
    "Convertir ＞ en >",
    "Convertir % en ¶",	
    "Convertir letra volada",
    "Convertir c' en ç",
    "Convertir C' en Ç",
    "Convertir n~ en ñ",
    "Convertir N~ en Ñ",
    "Reducir dos espacios a uno",
    "Eliminar espacio antes de salto de línea",
    "Eliminar la secuencia indicada antes de un espacio",
    "Reducir dos saltos de línea a uno"
  ),

  stringsAsFactors = FALSE
)


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

    limite <- 20000
    texto <- resultado$texto

    if (nchar(texto, type = "chars") > limite) {
      paste0(
        substr(texto, 1, limite),
        "\n\n",
        "[Previsualización limitada a 20.000 caracteres / ",
        "Preview limited to 20,000 characters]"
      )
    } else {
      texto
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

      # Se escribe UTF-8 sin BOM y sin modificar el contenido
      # producido por las expresiones regulares.
      writeBin(
        object = charToRaw(
          enc2utf8(resultado$texto)
        ),
        con = file
      )
    },

    contentType = "text/plain; charset=UTF-8"
  )
}


shinyApp(ui = ui, server = server)