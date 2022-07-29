#!/bin/bash

# Convierte una clave pública de formato Putty a OpenSSH.
# Crea un usuario con el nombre pasado por parámetro, lo añade a sudo (si se desea) e inserta la clave pública en authorized_keys.
# Es necesario ubicar la clave pública del usuario en formato Putty en /tmp/publickey_nombreusuario

#######
# USO #
#######
# - Para usuarios sin sudo: sh create_user_with_publickey.sh usuario
# - Para usuarios con sudo: sh create_user_with_publickey.sh usuario sudo

publickey=/tmp/publickey_$1

# Comprobación ubicación de la clave pública facilitada y que esté en formato Putty
if [ -f $publickey ];
then
        if grep -q "rsa-key-*" $publickey
        then
                echo "El fichero /tmp/publickey_$1 existe y está en formato Putty."
                echo "Se convierte a formato OpenSSH."
                ssh-keygen -i -f $publickey > $1.pub
        else
                echo "Parece que el fichero /tmp/publickey_$1 no está en formato Putty. Este es su contenido:"
                cat $publickey
                exit
        fi
else
        echo "El fichero $publickey parece que no existe."
        echo "Por favor, cree el fichero y asegurese que la clave pública está en formato Putty".
        exit
fi

# Crea el usuario
useradd -s /bin/bash -m $1


# Comprueba si existe segundo parámetro en el comando.
# Por ejemplo: sh create_user_with_publickey.sh egz sudo
if [ -z "$2" ];
    then
        echo "El usuario $1 no ha sido añadido al grupo sudo. Para añadirlo manualmente ejecute:"
       echo "usermod -a -G sudo $1"
    else
        # Comprueba si el segundo parámetro es sudo
        if [ "$2" = "sudo" ] ;
        then
            echo "El usuario $1 será añadido al grupo sudo."
            usermod -a -G sudo $1
        else
            echo "El segundo parámetro únicamente puede ser sudo. Utilice:"
            echo "sh create_user_with_publickey.sh usuario sudo"
            echo "para crear un usuario y añadirlo al grupo sudo."
            echo "\nUtilice:"
            echo "sh create_user_with_publickey.sh usuario"
            echo "para crear el usuario sin añadirlo al grupo sudo"
            exit
        fi
fi

mkdir -p /home/$1/.ssh/
mv $1.pub /home/$1/.ssh/
cat /home/$1/.ssh/$1.pub >> /home/$1/.ssh/authorized_keys
chown -R $1. /home/$1/

echo "Este es el contenido de /home/$1/.ssh/ y de /home/$1/.ssh/authorized_keys"
ls -l /home/$1/.ssh/
cat /home/$1/.ssh/authorized_keys
