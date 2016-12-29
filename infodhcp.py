#!/usr/bin/python
#coding: utf-8
#Programa para listar parametros de un servidor DHCP.

import sys, re
import commands
print "======================================"
print "/ / /   I  N  F  O  D  H  C  P   / / /"
print "======================================\n"

if len(sys.argv) > 1:
        if sys.argv[1] == '-l':
                concedidas = commands.getoutput("cat /var/lib/dhcp/dhcpd.leases | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort -u")
                numconcedidas = commands.getoutput("cat /var/lib/dhcp/dhcpd.leases | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort -u | wc -l")
                reservadas = commands.getoutput("cat /etc/dhcp/dhcpd.conf | grep 'fixed-address' | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort -u")
                numreservadas = commands.getoutput("cat /etc/dhcp/dhcpd.conf | grep 'fixed-address' | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort -u | wc -l")
                total=int(numconcedidas) + int(numreservadas)

                print "Hay un total de " + str(total) + " direcciones IP concedidas por el servidor DHCP.\n"

                print numconcedidas + " direcciones IP concedidas:"
                print concedidas + "\n"

                if int(numreservadas) > 0:
                        print numreservadas + " direcciones IP reservadas:"
                        print reservadas
                else:
                        print "Y ninguna dirección IP reservada por el servidor DHCP."

        elif sys.argv[1] > 1:
                found = re.search('[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}',sys.argv[1])
                if found:
                        MACconcedida = commands.getoutput("cat /var/lib/dhcp/dhcpd.leases | grep -A9 '%s' | grep -o '..:..:..:..:..:..' | sort -u" % sys.argv[1])

                        if len(MACconcedida) > 0:
                                print "La dirección IP %s ha sido concedida a la dirección MAC:" % sys.argv[1]
                                print MACconcedida
                        else:
                                print "No hay ninguna concesión con la dirección IP %s por parte de este servidor DHCP" % sys.argv[1]
                else:
                        print "Parece ser que el parámetro introducido no es una dirección IP válida. Por favor, comprueba que tiene formato correspondiente a una dirección IPv4."
else:
        print "Argumento invalido."
        print "Utilice infodhcp -l para listar la lista de concesiones del servidor DHCP local."
        print "Utilice infodhcp DireccionIP para obtener información sobre si esa dirección IP ha sido concedida por el servidor DHCP local."
