#!/bin/bash
# Script para sacar los últimos diez ficheros modificados de un directorio y sus directorios.
# Se ejecuta el script en el directorio actual o se le pasa como parámetro.
# sh lastmodified.sh o sh lastmodified.sh /ruta/del/archivo

# Utilizado para saber qué repositorios de Subversion han sido modificados recientemente 
# para migrar realizar una migración de ~100GB.
find $1 -type f -exec stat --format '%Y :%y %n' "{}" \; | sort -nr | cut -d: -f2- | head
