#!/usr/bin/python
#coding: utf-8
#Programa para ayudar a la gestión básica de un servidor DNS.

import sys, commands
fdns = open('/var/cache/bind/db.evaristogz', 'a')

print "====================================="
print "/ / /    G E S T I O N D N S    / / /"
print "====================================\n"

numargs = len(sys.argv)

if numargs > 0 and numargs <=5:
	if sys.argv[1] == '-a':
		tipo = sys.argv[2] #-dir o -alias#
		nombre = sys.argv[3] #nombre#
		alias = sys.argv[4] #alias#	

		print('Parametro -a para añadir')
		if nombre == '-dir':
			fflo = open('/var/cache/bind/db.172.22', 'a')
			fint = open('/var/cache/bind/db.10.0.0', 'a')
			fdns.write(nombre+'         IN      A       '+alias+'\n')
			fdns.write(alias+'       IN      PTR     '+nombre+'.evaristogz.gonzalonazareno.org\n')
			fflo.close()
			fint.close()
		elif tipo == '-alias':
			fdns.write(nombre+'         CNAME           '+alias+'\n')
			fdns.close()
		else:
			print('ERROR: Se esperaba como tercer parámetro -dir o -alias')
	elif sys.argv[1] == '-b':
		print('Parametro -b para borrar')
else:
	print('Utilice la ayuda')
