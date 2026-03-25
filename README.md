# HSMS-tools
## Repository of tools used in the processing of the paleographical transcriptions
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18912253.svg)](https://doi.org/10.5281/zenodo.18912253)

There are two folders in this repository: 

## analizador

This folder contains the _analizador_. To install it, you need to download the `analizador.zip` file from the repository and then extract it into a working folder. The paleographical transcriptions to be processed must be in their own folder. Although they can be located anywhere, even in the cloud, we recommend the following structure for better organization:

> `C:\HSMS-tools` [*general folder*]<br>
> `C:\HSMS-tools\analizador` [*folder with the* Analizador Corpus OSTA]<br>
> `C:\HSMS-tools\textos` [*folder with the paleographical transcriptions*]

The manual can be found here:  [https://hispanicseminary.org/analizador/](https://hispanicseminary.org/analizador/)

## diccionario

This folder contains the most recent version of `hsms.src`, the dictionary file used by FreeLing for text processing. To install, copy the file to `C:\HSMS-tools\analizador\hsms-es\`, or the corresponding folder in your local instalation.

The manual explains how to edit the dictionary and troubleshoot known issues that may occur during text processing.

################################################################################

### Analizador Corpus OSTA

The *Analizador Corpus OSTA* is a textual analysis tool developed by F. Javier Pueyo Mena and Francisco Gago Jover for processing the paleographic transcriptions used in the creation of the [*Old Spanish Textual Archive*](http://osta.oldspanishtextualarchive.org/).

It integrates the libraries of [*FreeLing*](https://nlp.lsi.upc.edu/freeling/node/1) (Carreras, Chao et al. [2004](http://nlp.lsi.upc.edu/publications/papers/carreras04.pdf); Padró [2011](http://nlp.lsi.upc.edu/publications/papers/padro11.pdf), [2012](http://nlp.lsi.upc.edu/publications/papers/padro12.pdf)) and combines them with a series of routines so that, from the plain text of the HSMS paleographic transcriptions, it is possible to obtain a text in XML format with all the linguistic information incorporated, while also maintaining all the structural characteristics of the work to facilitate its reading and its subsequent presentation in query results.

Sánchez Marco ([2010](https://aclanthology.org/L10-1368/), [2011](https://nlp.lsi.upc.edu/papers/sanchezmarco11.pdf), [2012](https://repositori.upf.edu/items/b01d1597-8d27-4cf2-bfbf-ac79a6951f8f?locale=en)) carried out a first adaptation of _FreeLing_ to medieval Spanish, using part of the [semi-paleographic transcriptions of the HSMS](https://github.com/hispanicseminary/OSTA/tree/main/transcriptions) to form a _golden corpus_, train the program, and create and modify the resources and rules in the areas mentioned above. For our part, we have significantly improved and expanded the linguistic resources of _FreeLing_, particularly the dictionary, which now only contains medieval forms (more than 275,000), and the affixation rules, whose clitic analysis section has been expanded.

################################################################################

El *Analizador Corpus OSTA* es una herramienta de análisis textual desarrollada por F. Javier Pueyo Mena y Francisco Gago Jover para el procesamiento de las transcripciones paleográficas utilizadas en la elaboración del [*Old Spanish Textual Archive*](http://osta.oldspanishtextualarchive.org/).

Integra las librerías de [*FreeLing*](https://nlp.lsi.upc.edu/freeling/node/1) (Carreras, Chao et al. [2004](http://nlp.lsi.upc.edu/publications/papers/carreras04.pdf); Padró [2011](http://nlp.lsi.upc.edu/publications/papers/padro11.pdf), [2012](http://nlp.lsi.upc.edu/publications/papers/padro12.pdf)) y las combina con una serie de rutinas para que, a partir del texto plano de las [transcripciones paleográficas del HSMS](https://github.com/hispanicseminary/OSTA/tree/main/transcriptions), sea posible obtener un texto en formato XML con toda la información lingüística incorporada, manteniendo también todas las características estructurales de la obra para facilitar su lectura y su posterior presentación en los resultados de las consultas.

Sánchez Marco ([2010](https://aclanthology.org/L10-1368/), [2011](https://nlp.lsi.upc.edu/papers/sanchezmarco11.pdf), [2012](https://repositori.upf.edu/items/b01d1597-8d27-4cf2-bfbf-ac79a6951f8f?locale=en)) realizó una primera adaptación de *FreeLing* al español medieval, utilizando parte de las transcripciones semi-paleográficas del HSMS para conformar su *golden corpus*, entrenar el programa, y crear y modificar los recursos y las reglas en los ámbitos arriba señalados. Por nuestra parte, hemos mejorado y ampliado considerablemente los recursos lingüísticos de *FreeLing*, en particular el diccionario, que ahora solo contiene formas medievales (más de 275.000), y las reglas de afijación, cuya sección de análisis de clíticos ha sido expandida.

**########## LICENSE ##########**

Copyright (C) 2026  F Javier Pueyo Mena and Francisco Gago Jover

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

