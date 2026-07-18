# HSMS Proofer: manual técnico de validación

> Borrador generado a partir de los comentarios internos de los scripts de HSMS Proofer. Conviene revisarlo a mano antes de publicarlo como documentación estable.

**Borrador interno**  
**Fecha:** 2026-06-24

Este documento resume las reglas técnicas, estructurales y editoriales aplicadas por HSMS Proofer. Se ha generado a partir de la documentación interna del código y está destinado a revisión interna del equipo editorial.

## Índice

- [Validaciones técnicas y balanceo global](#validaciones-técnicas-y-balanceo-global)
- [Validaciones estructurales](#validaciones-estructurales)
- [Validaciones editoriales y funcionales](#validaciones-editoriales-y-funcionales)
- [Ejecución global de la validación](#ejecución-global-de-la-validación)

## Convenciones generales

HSMS Proofer valida transcripciones en texto plano preparadas de acuerdo con las convenciones del Hispanic Seminary of Medieval Studies. El programa no modifica el texto: señala posibles incidencias estructurales, editoriales o técnicas para que el editor las revise.

Todas las incidencias se devuelven, cuando procede, con las columnas `line`, `col`, `type`, `text` y `explanation`.

Los saltos de línea LF/CRLF/CR no se consideran incidencia, porque dependen del sistema operativo. La equivalencia `¶ = %` se usa solo para validación y no modifica el texto original.

## Validaciones técnicas y balanceo global

**Fuente:** `validator_core.R`

### `check_file_technical()`

Valida:

  - nombre del fichero
  - UTF-8
  - saltos de línea dependientes del sistema operativo: no se informan como incidencia

**Parámetros.**

  filepath       : ruta del fichero
  uploaded_name  : nombre original

**Devuelve.**

  data.frame de incidencias

Nota actual:

  Los saltos de línea LF/CRLF/CR dependen del sistema operativo y no se informan como incidencia HSMS.

### `check_balanced_pairs()`

Comprueba el balanceo global de pares funcionales HSMS.

**Pares comprobados.**

  << >>   suprascrito
  (( ))   paréntesis real obsoleto / fósil histórico
  <  >    abreviatura
  (  )    texto eliminado
  [  ]    texto insertado
  {  }    mnemónicos / etiquetas

**Objetivo.**

  Detectar cierres sin apertura, cierres incompatibles
  y aperturas que quedan sin cerrar al final del fichero.

Los pares dobles se tokenizan previamente mediante
tokenize_balanced_chars() para evitar que << o (( sean
interpretados como dos aperturas simples consecutivas.

**Parámetros.**

  filepath : ruta al fichero TXT que se quiere validar.

**Devuelve.**

  data.frame homogéneo con columnas:

    line
    col
    type
    text
    explanation

## Validaciones estructurales

**Fuente:** `validator_structure.R`

### `hsms_structural_tag_catalog()`

Catálogo documentado de etiquetas estructurales HSMS.

Cada fila describe una etiqueta legal y algunos rasgos
heredados del antiguo PROOFER.

position:
  1 = dentro de columna
  2 = fuera de columna
  3 = en cualquier posición

contents:
  1 = no debe tener texto
  2 = debe tener texto
  3 = debe tener texto insertado
  4 = puede o no tener texto
  5 = debe tener observación

### `hsms_functional_character_catalog()`

Catálogo interno de caracteres funcionales HSMS.

**Objetivo.**

  Centralizar los caracteres que tienen una función
  estructural, editorial o paleográfica en las
  transcripciones HSMS.

Esta función NO valida nada por sí misma.
Solo devuelve datos de referencia para futuras reglas.

**Fuente.**

  PROOFER.FNC / PROOFER_FUNCTIONAL.txt

**Nota histórica.**

  La convención ((...)) para paréntesis reales
  queda obsoleta. Se conserva en el catálogo como
  fósil histórico.

  La convención vigente para paréntesis reales es:

    ≺ ... ≻

Estado actual de paréntesis reales:

  (( y )) se conservan como marcadores obsoletos de paréntesis reales.
  ≺ y ≻ son los marcadores vigentes para paréntesis reales.
  No se valida su balanceo porque pueden atravesar límites de columna o división textual.

### `check_inline_angle_delimiters()`

Regla estructural HSMS:

  Los delimitadores:

    <...>     abreviatura
    <<...>>   letra volada / superescrita

  deben abrirse y cerrarse dentro de la misma línea física.

**Notas.**

  - No se revisan líneas de folio [fol. nnnr/v].
  - Se procesa primero <<...>> para no confundirlo
    con dos signos simples <...>.
  - Esta regla no interpreta el contenido interno.

### `check_angle_delimiter_contents()`

Regla estructural/editorial HSMS:

  Los delimitadores:

    <...>     abreviatura
    <<...>>   letra volada / superescrita

  no deben estar vacíos ni contener espacios internos.

  Tampoco deben contener signos angulares internos.

**Casos válidos.**

  q<u>
  q<<a>>
  q<u><<a>>nto

### `check_insertion_deletion_marker_format()`

Regla estructural/editorial HSMS:

  [ ... ]  inserción editorial
  [^... ]  inserción escribal
  ( ... )  borrado editorial
  (^... )  borrado escribal

Reglas validadas:

  - [] no puede estar vacío.
  - () no puede estar vacío.
  - [^ texto] es incorrecto: no debe haber espacio
    tras el caret.
  - (^ texto) es incorrecto: no debe haber espacio
    tras el caret.
  - [^2# texto] es incorrecto: no debe haber espacio
    tras #.
  - [^2 #texto] es incorrecto: no debe haber espacio
    entre número y #.

Nota:

  No se revisa aquí [fol. nnnr/v].

### `check_crosshatch_usage()`

Regla estructural HSMS:

  El signo "#" indica una mano no original.

**Regla.**

  "#" debe aparecer inmediatamente después de un número
  arábigo que sigue a "^".

  Formas válidas:

    [^2#texto]
    (^2#texto)
    [*^2#texto]

**Casos inválidos.**

    #texto
    texto # texto
    [^#texto]
    (^#texto)
    [*^#texto]
    [^2 #texto]
    [^2# texto]
    (^2 #texto)
    (^2# texto)

Nota:

  La mano original no lleva número ni "#":

    [^texto]
    (^texto)
    [*^texto]

### `check_reconstruction_marker_format()`

Regla estructural/editorial HSMS:

  [*texto]       reconstrucción editorial
  [*^2#texto]    reconstrucción en mano no original

Reglas validadas:

  - [*] no puede estar vacío.
  - No debe haber espacio después de '*'.
  - En [*^2#texto], no debe haber espacios entre
    '*', '^', número, '#', y el texto.

### `check_illegibility_marker_format()`

Regla estructural/editorial HSMS:

  La ilegibilidad se marca con:

    [??]       parte de palabra ilegible
    [???]      palabra/frase ilegible
    [?? ???]   combinación documentada

  También puede aparecer dentro de borrados:

    (??)
    (???)
    (^??)
    (^???)

Reglas validadas:

  - No se permite [?].
  - No se permiten cuatro o más interrogaciones.
  - No se permite separar los signos: [? ?], [?? ?].
  - No se permite contenido mixto con interrogaciones
    salvo [?? ???].

### `check_deletion_insertion_combination_format()`

Regla estructural/editorial HSMS:

  En una combinación borrado + inserción:

    (^o)[^a]
    (m)[nn]

  no debe haber espacio entre ")" y "[" cuando se trata
  de sustitución de caracteres o segmentos de palabra.

Nota:

  No se valida aquí el espaciado de palabras completas,
  porque depende del contexto editorial.

### `check_mnemonics_inside_insertions_deletions()`

Regla HSMS:

  En general, un mnemónico no puede aparecer dentro de:

    [ ... ]
    ( ... )

  porque los mnemónicos no son texto.

Excepción editorial documentada:

  Dentro de {AD. ...} y {GL. ...}, la inserción [^ ... ]
  puede contener mnemónicos no estructurales, por ejemplo:

    {GL. [^{HEB. ...}]}
    {GL. [^{LAT. ...}]}
    {AD. [^{RUB. ...}]}
    {GL. [^{IN1.} Fijas de tiro]}
    {GL. [^{SYMB.}]}
    {AD. [^{=MIN: occupies 8 lines.}]}
    {GL. [^texto {RMK: ... .}]}

  Siguen prohibidos dentro de estas inserciones:

    CB, HD, CW, SG

  porque son mnemónicos estructurales del documento,
  no contenido textual de la glosa o adición.

### `check_insertions_deletions_do_not_cross_mnemonics()`

Regla HSMS:

  Los corchetes [ ] y paréntesis ( ) abiertos dentro
  de un mnemónico deben cerrarse antes de la llave "}"
  que cierra ese mismo mnemónico.

### `check_insertions_deletions_do_not_cross_textual_containers()`

Regla HSMS:

  Los corchetes [ ] y paréntesis ( ) abiertos dentro
  de un contenedor textual deben cerrarse antes de
  la llave "}" que cierra ese contenedor.

**Contenedores textuales.**

  CB, CW, DIAG, HD, MIN, RUB, SYMB, SG,
  AD, GL,
  etiquetas de lengua.

**No incluye.**

  BLNK
  IN
  ILL
  RMK

Nota:

  ((...)) no se trata como borrado; se conserva solo como fósil histórico.

### `check_double_parenthesis_spacing()`

OBSOLETA / FÓSIL HISTÓRICO.

En una fase anterior, los paréntesis reales del texto
se representaban mediante:

  (( ... ))

Esta convención ha sido sustituida por:

  ≺ ... ≻

Por tanto, ((...)) ya no debe usarse en nuevas
transcripciones.

**Motivo de la obsolescencia.**

  ((...)) podía producir falsos errores de balanceo,
  especialmente cuando el paréntesis real se abría en
  una columna y se cerraba en otra.

  Además, entraba en conflicto con la regla HSMS según
  la cual:

    ( ... )

  representa un borrado.

**Estado actual.**

  Esta función se conserva solo como memoria histórica.
  No debe llamarse en la validación normal.

### `check_mnemonic_uppercase()`

Regla estructural HSMS:

  Los mnemónicos HSMS deben escribirse en mayúsculas.

**Objetivo.**

  Detectar etiquetas conocidas escritas parcial o
  totalmente en minúsculas.

**Notas.**

  Utiliza extract_hsms_mnemonics() como parser central.

  Solo se validan etiquetas reconocidas por el catálogo.
  Las etiquetas desconocidas se detectan en:

    check_unknown_structural_tags()

### `check_unknown_structural_tags()`

Regla estructural HSMS:

  Detecta mnemónicos no definidos en el catálogo HSMS.

**Objetivo.**

  Validar que todas las etiquetas estructurales usadas
  en el fichero existan en:

    hsms_structural_tag_catalog()

**Notas.**

  Esta función utiliza:

    extract_hsms_mnemonics()

como parser central de mnemónicos.

### `check_unexpected_numbered_tags()`

Regla estructural HSMS:

  Detecta mnemónicos que llevan número aunque el catálogo
  indique que no deben llevarlo.

**Ejemplos válidos.**

  {CB1.
  {IN2.
  {HD.
  {HD1.

**Ejemplos inválidos.**

  {LAT1.
  {RMK1:
  {RUB2.

**Notas.**

  Utiliza extract_hsms_mnemonics() como parser central.

  En la columna numbered del catálogo:

    TRUE  = requiere/admite número
    FALSE = no admite número
    NA    = número opcional

### `check_missing_required_numbers()`

Regla estructural HSMS:

  Detecta etiquetas que deben llevar número y no lo
  llevan.

**Ejemplos válidos.**

  {CB1.
  {IN2.

**Ejemplos inválidos.**

  {CB.
  {IN.

**Notas.**

  Utiliza extract_hsms_mnemonics() como parser central.

  En el catálogo:

    TRUE  = número obligatorio
    FALSE = número prohibido
    NA    = número opcional

### `check_tag_delimiters()`

Regla estructural HSMS:

  Cada mnemónico debe usar el delimitador definido
  en el catálogo HSMS.

**Ejemplos válidos.**

  {LAT.
  {RMK:
  {CB1.

**Ejemplos inválidos.**

  {LAT:
  {RMK.
  {CB1:

**Notas.**

  Utiliza extract_hsms_mnemonics() como parser central.

Excepciones actuales:

  BLNK, SYMB y DIAG admiten tanto . como : según el uso documentado.
  En particular, {DIAG: ...} es válido cuando introduce una descripción o comentario del diagrama.

### `check_cw_sg_position()`

Regla estructural HSMS:

  Las etiquetas {CW. y {SG. solo pueden aparecer
  después del cierre de la columna del folio.

**Reglas.**

  1. Deben aparecer después de una línea que cierre
     columna con "}".

  2. Deben aparecer antes del siguiente folio.

  3. Deben aparecer al comienzo de su línea.

**Ejemplos válidos.**

  {CB1.
  texto}
  {CW. catchword}
  {SG. signature}
  [fol. 2r]

**Ejemplos inválidos.**

  {CB1.
  {CW. catchword}
  texto}

  texto {CW. catchword}

### `check_cw_sg_line_format()`

Regla estructural HSMS:

  Las etiquetas {CW. y {SG. deben tener contenido textual
  y cerrarse en la misma línea.

**Ejemplos válidos.**

  {CW. palabra}
  {SG. a ii}

**Ejemplos inválidos.**

  {CW.
  {SG.
  {CW. palabra
  {SG. a ii

### `check_rmk_comment_format()`

Regla estructural HSMS:

  La etiqueta {RMK: debe:

    - usar ':'
    - cerrarse con '}' en la misma línea física
    - terminar en punto antes de '}'

**Cabecera del fichero.**

  Antes del primer folio se admite:

    {RMK:.}

**Cuerpo del testimonio.**

  Después del primer folio:

    {RMK:.}

  no está permitido.

Nota:

  RMK no es un contenedor textual y no puede ser
  multilínea.

  Una RMK puede estar cerrada y seguida de otro
  mnemónico o de texto en la misma línea:

    {RMK: HSMS-0555-0001: ... .} {IN2.} Aqui...

### `check_initial_rmk_identification_block()`

Regla estructural HSMS:

  El bloque inicial de identificación puede contener
  hasta seis líneas {RMK: ...} antes del primer folio.

Reglas validadas:

  - Solo las 6 primeras líneas pueden ser RMK iniciales.
  - Las RMK iniciales deben aparecer antes del primer folio.
  - Si una RMK inicial contiene barras verticales "|",
    deben usarse como separadores " | ".
  - No puede haber barra inicial ni final dentro del texto.

### `check_rmk_internal_punctuation()`

Regla estructural HSMS:

  Dentro de un comentario RMK no debe aparecer:

    - otro punto "."
    - otro dos puntos ":"

  antes del punto final obligatorio.

**Fundamento.**

  El punto final informa del cierre del campo RMK.
  Por tanto, no debe haber otros puntos internos.

  Del mismo modo, el delimitador ":" solo debe aparecer
  tras RMK.

**Excepción: RMK de cabecera.**

  Los RMK de cabecera solo se admiten en las seis
  primeras líneas del fichero. En esa zona inicial
  se permiten puntos y dos puntos internos, porque
  pueden formar parte de referencias bibliográficas,
  signaturas, abreviaturas, nombres de instituciones
  o descripciones documentales.

### `check_backslash_only_inside_hd()`

Regla estructural HSMS:

  "\" solo puede aparecer dentro de una etiqueta
  {HD. ...}, {HD1. ...} o {HD2. ...}.

**Regla.**

  "\" solo puede aparecer dentro de una etiqueta {HD. ...}, {HD1. ...} o {HD2. ...}.

**Casos válidos.**

  {HD. texto \ antiguo}
  {HD1. texto \ antiguo}
  {HD2. texto \ antiguo}

**Casos inválidos.**

  texto \ texto
  {LAT. texto \ texto}
  {RUB. texto \ texto}

### `check_hd_position_in_folio()`

Regla estructural HSMS:

  Las etiquetas {HD. o {HDn. deben aparecer dentro
  del encabezamiento del folio.

Es decir:

  - después de la marca [fol. n];
  - antes de la primera marca {CBn.;
  - nunca después de haber comenzado una columna.

**Ejemplos válidos.**

  [fol. 1r]
  {HD. encabezado}
  {CB1.

  [fol. 1v]
  {HD1. encabezado}
  {HD2. encabezado}
  {CB1.

**Ejemplo inválido.**

  [fol. 2r]
  {CB1.
  texto}
  {HD. encabezado tardío}

**Parámetros.**

  filepath : ruta al fichero TXT que se quiere validar.

**Devuelve.**

  data.frame homogéneo con columnas:

    line
    col
    type
    text
    explanation

### `check_cb_boundary_format()`

Regla estructural HSMS:

  La marca de comienzo de columna {CBn. debe tener
  uno de estos dos formatos:

    {CBn.
    {CBn.}

**Interpretación.**

  {CBn.  abre una columna con contenido.
  {CBn.} representa una columna vacía cerrada en
         la misma línea.

**Ejemplos válidos.**

  {CB1.
  {CB2.}
  {CB27.

**Ejemplos inválidos.**

  {CB1. texto
  {CB2. texto}
  {CB.}
  {CB1: texto}

**Notas.**

  Esta regla usa extract_hsms_mnemonics() como parser
  central y solo revisa mnemónicos CB reconocidos.

### `check_empty_language_tag()`

Regla estructural HSMS:

  Las etiquetas de lengua no deben estar vacías.

**Etiquetas afectadas.**

  Todas las etiquetas cuyo grupo sea:

    tag_group == "language"

Por ejemplo:

  ARB ARG ARM BAS CAL CAT ENG FRN GAL GER
  GRK HEB ITL LAM LAT PRT PRV

**Definición de “vacía”.**

  En esta regla, una etiqueta se considera vacía solo
  cuando no contiene ningún carácter entre la apertura
  del mnemónico y la llave de cierre.

Es decir:

  {LAT.}
  {ENG.}
  {CAT.}

**Casos válidos.**

  {LAT. texto latino}
  {ENG. English text}
  {CAT. text català}
  {LAT. {RMK: Latin text illegible}}

Este último caso NO es vacío, porque contiene información
editorial dentro de {RMK: ...}.

**Casos inválidos.**

  {LAT.}
  {ENG.}
  {CAT.}

**Parámetros.**

  filepath : ruta al fichero TXT que se quiere validar.

**Devuelve.**

  data.frame homogéneo con columnas:

    line
    col
    type
    text
    explanation

**Notas.**

  Esta función no intenta verificar si el contenido
  corresponde realmente a la lengua indicada.

  Solo detecta el vacío absoluto.

### `check_empty_addition_tags()`

Regla estructural HSMS:

  Las etiquetas de adición y glosa no deben estar vacías.

**Etiquetas afectadas.**

  {AD.}
  {GL.}

Ambas pertenecen conceptualmente al grupo:

  tag_group == "addition"

**Definición de “vacía”.**

  En esta regla, una etiqueta se considera vacía solo
  cuando no contiene ningún carácter entre la apertura
  del mnemónico y la llave de cierre.

Es decir:

  {AD.}
  {GL.}

**Casos válidos.**

  {AD. texto añadido}
  {GL. glosa marginal}
  {AD. {RMK: addition illegible}}
  {GL. {RMK: marginal gloss in Latin.}}

Estos dos últimos casos NO son vacíos, porque contienen
información editorial dentro de {RMK: ...}.

**Casos inválidos.**

  {AD.}
  {GL.}

**Parámetros.**

  filepath : ruta al fichero TXT que se quiere validar.

**Devuelve.**

  data.frame homogéneo con columnas:

    line
    col
    type
    text
    explanation

**Notas.**

  Esta función no interpreta todavía si el contenido
  de AD o GL es textual, editorial o mixto.

  Solo detecta el vacío absoluto.

### `check_empty_illumination_with_space()`

Regla estructural HSMS:

  La etiqueta {ILL.} puede aparecer vacía, pero no debe
  contener únicamente espacios antes de la llave de cierre.

**Casos válidos.**

  {ILL.}
  {ILL. {RMK: right margin.}}
  {ILL. {MIN.}{AD. ...}}

Caso inválido:

  {ILL. }
  {ILL.   }

### `check_initial_marker_format()`

Regla estructural HSMS:

  La marca de inicial {INn. debe:

    - llevar número
    - cerrarse correctamente
    - aparecer en una de estas formas:

        {INn.}
        {INn. {ILL.}}
        {INn. {MIN.}}

    - ir seguida de un espacio y de la inicial
      transcrita.

**Fundamento.**

  El manual indica que el número registra las líneas
  ocupadas por la caja de la inicial y que la letra que
  aparece como inicial en el manuscrito sigue al
  mnemónico completo tras un espacio en blanco.

**Casos válidos.**

  {IN1.} A
  {IN6. {ILL.}} EN
  {IN10. {MIN.}} A
  {IN3.} (^H)[^P]riuilegio
  {IN3.} (N)[L]a
  {IN7.} [R]Obi

**Casos inválidos.**

  {IN1.
  {IN1.}
  {IN6. {ILL.}}
  {IN10. {MIN.}}
  {IN3. }
  {IN3. texto}
  {IN10. {RUB.}}

### `check_consecutive_blank_mnemonics()`

Regla estructural HSMS:

  No debe haber más de un mnemónico {BLNK.} consecutivo.

**Fundamento.**

  El manual indica que cuando un área en blanco ocupa
  más de una línea, debe usarse un único mnemónico
  {BLNK: ...} con campo de observación indicando el
  número de líneas en blanco.

**Ejemplos válidos.**

  texto {BLNK.} texto
  texto {BLNK: 12 lines left blank.}

**Ejemplo inválido.**

  {BLNK.}
  {BLNK.}

**Parámetros.**

  filepath : ruta al fichero TXT que se quiere validar.

**Devuelve.**

  data.frame homogéneo con columnas:

    line
    col
    type
    text
    explanation

### `check_empty_symbol_tag()`

Regla estructural HSMS:

  La etiqueta {SYMB.} no debe estar vacía.

**Fundamento.**

  El manual indica que {SYMB.} se usa para representar
  letras o símbolos que no pueden reproducirse
  directamente en el conjunto romano ordinario.

  También puede contener {BLNK.} cuando la información
  ausente correspondería a símbolo o símbolos.

**Definición de “vacía”.**

  En esta regla, una etiqueta se considera vacía solo
  cuando aparece exactamente como:

    {SYMB.}

**Casos válidos.**

  {SYMB. signo}
  {SYMB. {BLNK.}}
  {SYMB. {RMK: symbol illegible.}}
  {SYMB: transliterated Arabic characters. texto}

Caso inválido:

  {SYMB.}

## Validaciones editoriales y funcionales

**Fuente:** `validator_editorial.R`

### `check_ellipsis()`

Regla HSMS:

  Los tres puntos "..." solo pueden aparecer
  dentro de corchetes "[...]".

**Ejemplos válidos.**

  [...]
  [abc ... xyz]

**Ejemplos inválidos.**

  texto...
  ... texto
  abc ... def

**Parámetros.**

  filepath : ruta al fichero TXT que se quiere validar.

**Devuelve.**

  data.frame con incidencias.

### `check_percent_spacing()`

Regla HSMS:

  Los signos de calderón deben aparecer separados por
  espacios, salvo cuando:

    - aparecen al inicio de línea;
    - aparecen al final de línea.

**Tokens validados.**

  %
  %2
  %3
  ¶
  ¶2
  ¶3
  [%]
  [^%]
  [%2]
  [^%2]
  [%3]
  [^%3]
  [¶]
  [^¶]
  [¶2]
  [^¶2]
  [¶3]
  [^¶3]

**Ejemplos válidos.**

  % abc
  abc % def
  abc %
  abc %2 def
  abc %3 def
  abc [%] def
  abc [^%2] def

  ¶ abc
  abc ¶ def
  abc ¶2 def
  abc [¶] def
  abc [^¶2] def

**Ejemplos inválidos.**

  abc%def
  abc%2 def
  abc %3def

  abc¶def
  abc¶2 def
  abc ¶3def

Nota actual:

  Para la validación, el signo Unicode ¶ se trata como equivalente funcional de %.
  También se reconocen como tokens completos las formas insertadas con mano no original,
  como [^2#%], [^2#%2], [^2#%3] y sus equivalentes con ¶.
  En esas formas, el espaciado se comprueba alrededor del token completo, no alrededor del signo interno.

### `check_para_spacing()`

OBSOLETA.
El signo ¶ se valida ahora en check_percent_spacing(),
donde se trata como equivalente Unicode de %.
Se conserva temporalmente por memoria histórica.
Regla HSMS:

  El signo de párrafo "¶" debe aparecer separado
  por espacios.

**Ejemplos válidos.**

  ¶ abc
  abc ¶ def
  abc ¶

**Ejemplos inválidos.**

  abc¶def
  abc¶ def
  abc ¶def

**Parámetros.**

  filepath : ruta al fichero TXT que se quiere validar.

**Devuelve.**

  data.frame con incidencias.

### `check_double_spaces()`

Regla editorial:

  No debe haber dos o más espacios ASCII consecutivos
  dentro de una línea.

### `check_edge_spaces()`

Regla editorial:

  Las líneas no deben comenzar ni terminar
  con espacios ASCII visibles.

### `check_invisible_spaces()`

Regla editorial/técnica:

  No deben aparecer caracteres invisibles problemáticos.

Detecta:

  - NBSP
  - TAB
  - ZWSP

### `check_close_open_spacing()`

Regla editorial/técnica:

  Debe existir un espacio ASCII visible entre
  una llave de cierre "}" y una llave de apertura "{"
  cuando ambas aparecen en la misma línea.

### `check_hyphen_before_closing_brace()`

Regla editorial:

  No debe aparecer un guion "-" inmediatamente antes
  de una llave de cierre "}".

**Ejemplo válido.**

  pala-
  bra}

**Ejemplo inválido.**

  palabra-}

**Parámetros.**

  filepath : ruta al fichero TXT que se quiere validar.

**Devuelve.**

  data.frame con incidencias.

**Notas.**

  - Esta función no interpreta todos los usos del guion.
  - Solo detecta el caso específico "-}".
  - Las demás reglas de guion se validarán aparte.
  - No modifica el fichero original.

### `check_multiple_blank_lines()`

Regla editorial:

  No debe haber más de una línea vacía consecutiva.

**Ejemplo válido.**

  línea 1

  línea 2

**Ejemplo inválido.**

  línea 1

  línea 2

**Parámetros.**

  filepath : ruta al fichero TXT que se quiere validar.

**Devuelve.**

  data.frame con incidencias.

**Notas.**

  - Una única línea vacía consecutiva es aceptable.
  - Dos o más líneas vacías consecutivas generan aviso.
  - No modifica el fichero original.

### `check_line_length()`

Regla editorial/técnica:

  Las líneas excesivamente largas suelen indicar:

    - saltos de línea perdidos;
    - etiquetas mal cerradas;
    - pegados accidentales;
    - errores de OCR/HTR;
    - corrupción del texto.

**Regla aplicada.**

  Se genera incidencia cuando una línea supera
  un número configurable de caracteres.

**Parámetros.**

  filepath   : ruta al fichero TXT que se quiere validar.

  max_length : longitud máxima permitida.
               Valor por defecto: 120.

**Devuelve.**

  data.frame con incidencias.

**Notas.**

  - Esta función NO corta líneas.
  - Esta función NO modifica el texto.
  - Solo detecta posibles anomalías.
  - El umbral puede ajustarse más adelante
    según el corpus real HSMS.

### `check_mnemonic_uppercase()`

Regla estructural HSMS:

  Los mnemónicos HSMS deben escribirse en mayúsculas.

**Objetivo.**

  Detectar etiquetas conocidas escritas parcial o
  totalmente en minúsculas.

**Ejemplos válidos.**

  {CB1.
  {LAT.
  {RMK:

**Ejemplos inválidos.**

  {cb1.
  {Lat.
  {rMk:

**Notas.**

  Solo se validan etiquetas reconocidas por el catálogo.
  Las etiquetas desconocidas ya se detectan en:

    check_unknown_structural_tags()

### `check_illegible_marker_length()`

Regla editorial/paleográfica HSMS:

  Las marcas de ilegibilidad reconocidas son:

    ??   = palabra o parte de palabra ilegible
    ???  = frase ilegible

**Objetivo.**

  Detectar secuencias de cuatro o más signos de
  interrogación consecutivos, porque no corresponden
  a ninguna marca funcional definida por PROOFER.

**Ejemplos válidos.**

  ??
  ???

**Ejemplos inválidos.**

  ????
  ?????

### `check_mnemonic_continuation_plus()`

Regla editorial/funcional HSMS:

  El signo "+" indica continuación lógica del texto
  contenido en un mnemónico.

**Reglas.**

  1. Debe aparecer como " +}".
  2. El mnemónico debe permitir continuación según
     hsms_structural_tag_catalog()$can_continue.
  3. Se ignora "[+]", que es otro signo funcional.

### `check_mnemonic_continuation_target()`

Regla editorial/funcional HSMS:

  Si un mnemónico textual termina con " +}", debe existir
  posteriormente otro mnemónico del mismo tipo.

**Notas.**

  - La posibilidad de continuación se toma del catálogo:
      can_continue == TRUE

  - Se excluyen explícitamente mnemónicos no textuales
    o estructurales como CB, CW y SG.

### `check_mnemonic_vector_equals()`

Regla editorial/funcional HSMS:

  El signo "=" tiene función especial en PROOFER:
  marca vector en los mnemónicos que lo permiten.

**Regla aplicada.**

  "=" solo puede aparecer como prefijo o sufijo
  funcional si el catálogo HSMS lo permite.

Actualmente lo permiten:

  {MIN
  {DIAG

**Ejemplos válidos.**

  {=MIN.}
  {MIN=.}
  {=MIN=.}

**Ejemplos inválidos.**

  texto = texto
  {LAT=. texto}
  {=LAT. texto}

### `check_ad_gl_inserted_text_format()`

Regla editorial/funcional HSMS:

  Los mnemónicos {AD. y {GL. tienen procesamiento
  especial en PROOFER.

Deben ir seguidos de:

  espacio + [^ + texto

**Ejemplos válidos.**

  {AD. [^texto añadido]}
  {GL. [^glosa añadida]}

**Ejemplos inválidos.**

  {AD. texto}
  {GL. glosa}
  {AD.[^texto]}

### `check_editorial()`

Ensamblador de reglas editoriales

Esta función ejecuta todas las reglas editoriales
actualmente activas y combina sus resultados.

## Ejecución global de la validación

**Fuente:** `validator_main.R`

### `validate_file()`

Ejecuta todas las validaciones HSMS disponibles.

**Parámetros.**

  filepath:
    Ruta al fichero TXT que se quiere validar.

  uploaded_name:
    Nombre original del fichero.
    Por defecto se toma basename(filepath).

**Devuelve.**

  Lista con:

    df:
      data.frame con todas las incidencias detectadas.

    n_issues:
      número total de incidencias.

    filepath:
      ruta validada.

    uploaded_name:
      nombre usado para validar el patrón TEXT.SIGLA.txt.

Columnas de df:

  line
  col
  type
  text
  explanation
