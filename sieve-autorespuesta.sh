#!/bin/bash

# Script para la creación de mensajes de autorespuesta en el servidor de correo
# Dovecot a través de filtros con Sieve con tareas at.

# Correo electrónico para enviar las notificaciones de activación/desactivación #
notificacion='notificacion@dominio.com'

# Guarda la ruta del buzón en una variable. #
ruta=/srv/vmail/dominio.com/$usuario/

echo -e '### SCRIPT PARA LA CREACIÓN DE MENSAJES DE AUTORESPUESTA EN DOVECOT ###\n'

# Se ejecuta mientras $usuario esté vacía. #
while [ -z "$usuario" ];
do
	read -p 'Introduzca el nombre de usuario: ' usuario
done

# Comprueba si el usuario/directorio existe. #
if [ -d $ruta ];
then

	# Consulta si el fichero .dovecot.sieve existe para ese usuario. #
	if [ -e $ruta.dovecot.sieve ]
	then
		echo -e '\nExiste un fichero .dovecot.sieve en la ruta /srv/vmail/dominio.com/'$usuario'/'
		echo 'Por favor, edítelo e inserte manualmente los nuevos filtros en él.'
		break
	else
		echo -e '\nSe creará un fichero .dovecot.sieve en la ruta /srv/vmail/dominio.com/'$usuario'/'

		read -p 'Introduzca el asunto (Enter por defecto): ' asuntomail
		read -p 'Introduzca el cuerpo (Enter por defecto): ' cuerpomail

		while [ -z "$fechainicio" ];
		do
			read -p 'Fecha de inicio (Formato DD/MM/YYYY): ' fechainicio
		done
		horainicio='00:00'
		
		# Consulta si el filtro ha de activarse en el día de hoy. #
		if [ $fechainicio = `date +%d'/'%m'/'%Y` ];
		then
			fechainicioUK=`echo $fechainicio | awk '{split($1,a,"/");$1=a[2]"/"a[1]"/"a[3]}1'`
			horainicio='15:00'
		else
			fechainicioUK=`echo $fechainicio | awk '{split($1,a,"/");$1=a[2]"/"a[1]"/"a[3]}1'`
		fi

		while [ -z "$fechafin" ];
		do
			read -p 'Fecha de fin (Formato DD/MM/YYYY): ' fechafin
			fechafinUK=`echo $fechafin | awk '{split($1,a,"/");$1=a[2]"/"a[1]"/"a[3]}1'`
		done

		# Establece valor por defecto para asunto y cuerpo de email.
		if [ -z "$asuntomail" ];
		then
			asuntomail="Temporalmente ausente (Mensaje automático)"
		fi
		
		if [ -z "$cuerpomail" ];
		then
			cuerpomail="Por motivo de ausencia, este correo electrónico no será atendido desde el $fechainicio hasta el $fechafin. Disculpe las molestias."
		fi
		
		echo -e '\n### CONFIRMACIÓN DE LOS DATOS DEL FILTRO ###'
		echo 'Usuario:' $usuario
		echo 'Ruta:' $ruta
		echo 'Fecha de inicio:' `date -d $fechainicioUK +%A', '%d' de '%B' de '%Y` 'a las' $horainicio
		echo 'Fecha de fin:' `date -d $fechafinUK +%A', '%d' de '%B' de '%Y` 'a las 23:59'
		echo 'Asunto:' $asuntomail
		echo 'Cuerpo:' $cuerpomail
		
		echo -e "\nPulse Enter para crear el filtro. Ctrl+C para cancelar."
		read enterKey

		# Inserta el contenido en un nuevo fichero. #
		echo "require [\"fileinto\", \"vacation\"];
vacation
# Responder como maximo una vez al dia al mismo remitente.
:days 1
# Asunto del email.
:subject \"$asuntomail\"
# Cuerpo del email.
\"$cuerpomail\";" > $ruta.dovecot.sieve_inactivo

		chown vmail:vmail $ruta.dovecot.sieve_inactivo

		# Crea dos tareas para activar y desactivar el filtro, moviendo el archivo .dovecot.sieve #
		echo -e '\nCreando tareas at para habilitar y deshabilitar el filtro del usuario' $usuario
		# Transforma fechafin en formato YYYYMMDD para el nombre del fichero. #
		fechafinFi=`echo $fechafin | awk '{split($1,a,"/");$1=a[3]a[2]a[1]}1'`
		at -m $horainicio $fechainicioUK <<< "mv '$ruta'/.dovecot.sieve_inactivo '$ruta'/.dovecot.sieve \
		| echo Ejecutada la tarea que activa el filtro Sieve de autorespuesta del usuario '$usuario'. Se desactivará el `date -d $fechainicioUK +%A', '%d' de '%B' de '%Y`. \
		| mail -s 'Activado el mensaje de vacaciones de '$usuario'' -r \"remitente@dominio.com\" '$notificacion'"
		at -m 23:59 $fechafinUK <<< "mv '$ruta'/.dovecot.sieve '$ruta'/.dovecot.sieve\_'$fechafinFi' \
		| echo Ejecutada la tarea que desactiva el filtro Sieve del usuario '$usuario'. \
		| mail -s mail -s 'Ejecutada la tarea que desactiva el filtro Sieve de autorespuesta del usuario '$usuario'.' -r \"remitente@dominio.com\" '$notificacion'"
		
		echo -e '\nTareas pendientes en at en el servidor' `hostname`
		atq
	fi
else
	echo -e '\nLa ruta '$ruta' no existe.'
	echo 'Por favor, comprueba que el usuario '$usuario' existe.'
fi
