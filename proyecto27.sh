#!/bin/bash

#P27. Implementa la creación de usuarios de manera masiva. Se indicará una base
#de nombre de usuario usu y un número N. Se crearán los usuarios usu1, usuN...
#anotando en un fichero de log los usuarios que no se han podido crear en el
#caso de que ya existiesen.
clear

if [ `whoami` != "root" ]
then
	echo "Usted no es usuario root."
	echo "Ejecute 'su' para identificarse y vuelva a ejecutar el script."
else
	if [ -e log.txt ]
	then
		rm log.txt	
	fi
	read -p "Introduzca el nombre base: " base
	read -p "Introduzca el número de usuarios a crear: " nummax
	for i in $(seq 1 $nummax)
	do
		useradd $base$i
		if [ $? != "0" ]
		then	
			echo $base$i >> log.txt
			log=on
		else
			echo "Creando" $base$i
		fi
	done
fi

echo "Fin"