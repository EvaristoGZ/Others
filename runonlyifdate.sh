#!/bin/bash

# Script que controla la fecha actual para ejecutar las instrucciones.
# En este caso, también controla si un fichero no contiene un valor para
# realizar una serie de comandos a continuación

currentdate=`date +"%Y%m%d"` # Extrae fecha actual
executedate='20211231' # Especificar fecha que debe ejecutarse
value="abc123def456" # Cadena presente en el nuevo athento.crt

if [ ${executedate} = ${currentdate} ]; then

# Si el valor de $value no está en el fichero, ejecuta el resto de comandos
    if ! grep -q "$value" /path/file.txt ; then
        echo "El valor de presente en el fichero. Se va a ejecutar los comandos del script"
        cp /path/file.txt /path/file_without_value.txt_BK
        mv /path/file_with_value.txt /path/file.txt
    fi

fi
