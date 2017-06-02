# proyecto27.sh
Script que implementa la creación de usuarios de manera masiva.

Se indica una base de nombre de usuario usu y un número N. Se crearán los usuarios usu1, usuN...
anotando en un fichero de log los usuarios que no se han podido crear en el caso de que ya existiesen en el sistema.

# infodhcp.sh
Script que muestra la lista de concesión de un servidor DHCP consultando el fichero /var/lib/dhcp/dhcpd.leases.

También muestra las direcciones IP reservadas a través del fichero /etc/dhcp/dhcpd.conf.

Igualmente permite consultar si una dirección IP ha sido concedida a una dirección MAC.

# lastmodified.sh
Script que lista los últimos diez ficheros modificados de un directorio y sus correspondientes subdirectorios.
Funciona ejecutando el script dentro del directorio a listar o pasándole la ruta como parámetro.

Utilizado para migrar una instalación de Subversion de unos 100GB, manteniéndose la instalación de producción activa y migrando de nuevo únicamente los repositorios modificados.
