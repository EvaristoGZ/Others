#!/bin/bash
# Script para listar los últimos diez ficheros modificados de un directorio y sus subdirectorios.
# Se ejecuta dentro del directorio a listar o se le pasa como parámetro.
# sh lastmodified.sh o sh lastmodified.sh /ruta/del/archivo

#Utilizado para migrar una instalación de Subversion de unos 100GB, manteniéndose la instalación
#de producción activa y migrando de nuevo únicamente los repositorios modificados.
find $1 -type f -exec stat --format '%Y :%y %n' "{}" \; | sort -nr | cut -d: -f2- | head
