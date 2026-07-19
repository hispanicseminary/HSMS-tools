# HTR_to_HSMS

Validation and proofing tool for HSMS manuscript transcriptions.

HTR_to_HSMS Proofer is a Shiny application that processes plain text files, converting them from HTR (Handwritten Text Recognition) output format, either Transkribus or eScriptorium, to HSMS-compatible format.

## Authors

* Francisco Gago Jover (The College of the Holy Cross)
* * José Manuel Fradejas Rueda (Universidad de Valladolid)

## Features

The application processes uploaded files through the following sequential steps:

* File reading and validation: Reads and checks the uploaded UTF-8 encoded file
* Line break normalization: Standardizes line breaks throughout the text
* Sequential rule application: Applies a series of regular expressions to transform the text
* Output generation: Produces a new processed TXT file ready for download

## Running the application

Open RStudio and execute:

```r
source("HTR_to_HSMS.R")
```

or just double click on `HTR_to_HSMS.R` and it will open RStudio and load the code.

Then launch the Shiny app.

More details in the app [manual](https://hispanicseminary.org/manuales/procesador/index.html)

## Repository

Developed within the framework of the Hispanic Seminary of Medieval Studies.

https://www.hispanicseminary.org/

Corrected and annotated transcriptions are incorporated into the Old Spanish Textual Archive (OSTA):

https://oldspanishtextualarchive.org/

## License

MIT License
