#!/bin/sh
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    start_host.sh
#%
#% DESCRIPTION
#%     Script para levantar jboss de HOST'S A,B,C,D
#% PARAMETERS: 
#%      In:
#%			PARAM $1:
#%				A: procesa HOST A		
#%				B: procesa HOST B
#%				C: procesa HOST C
#%				D: procesa HOST D
#%    	Out:
#%			0: Exito
#%		   	1: Error
#================================================================
#- IMPLEMENTATION
#-    version         start_host.sh  0.0.0
#-    author          Ricardo Diaz Reyes
#-    copyright       Copyright (c) BMV
#-
#================================================================
#  HISTORY
#     2020/06/10 : dirr@praxis.com.mx : Script creation 
# 

HOST="$1"
 
#================================================================
# Validacion de parametro de entrada
#================================================================

if [ -z  "${HOST}" ]; then
	echo "Falta proporcionar un parametro dede de ser  A o B o C o D" 
	echo "Ejemplo: start_host.sh A " 
	exit 1
fi


#================================================================
# Inicializacion de variables de entorno
#================================================================
#if [ "$HOST" != "$HOST_A" ]; then
	
	BASEDIR=$(dirname $(readlink -f $0))
	RUTAINICIAL=$BASEDIR
	. $BASEDIR/../common/setenv.sh		
#fi


if 	[ "$HOST" != "$HOST_A" ] && 
	[ "$HOST" != "$HOST_B" ] && 
	[ "$HOST" != "$HOST_C" ] && 
	[ "$HOST" != "$HOST_D" ];then
	echo "El parametro de entra es invalido debe de ser  A o B o C o D"
	echo "Ejemplo: start_host.sh A "
	exit 1
fi


valida_procesos()
{
	P_PRINCIPAL=`ps -fea | grep $PROCESOHOST |  grep -v 'grep'  | awk '{ print $2 }'`
	V_PC=`ps -ef | grep  "$PROCESOHOST" | grep  "$CONTROLPROCESO" | grep 'java' | grep -v 'grep' | awk '{ print $2 }'`
	V_HC=`ps -ef | grep  "$PROCESOHOST" | grep  "$CONTROLHOST" | grep 'java' | grep -v 'grep' | awk '{ print $2 }'`
	PROCESOS=`ps -fea | grep $NOMPROC | grep 'java' | grep -v 'grep' | awk '{ print $2 }'`	
	
	if [ -n "$V_PC" ] || [ -n "$V_HC" ] || [ -n "$PROCESOS" ] || [ -n "$P_PRINCIPAL" ]
		then
			# no vacios Exito
			echo 0
		else
			# Vacios = Fracaso
			echo 1
	fi
}



#Valida que los procesos no existan.
valida_proceso_jbosseap()
{	
	P_PRINCIPAL=`ps -fea | grep $PROCESOHOST |  grep -v 'grep'  | awk '{ print $2 }'`
	if [ -z "$P_PRINCIPAL" ]; then	
		"$COMANDOSTART"
		echo "Comando a ejecutar: " $COMANDOSTART 
		echo "Se ejecuta comando start" 		
		sleep 40
	else
		echo "===================================================" 
		echo "EL PROCESO $PROCESOHOST ESTA EN EJECUCION" 
		date 													   
		echo "==================================================="	
	fi
	SALIDA=0
	NOMBREPROCESO=$1
	for NOMPROC in $NOMBREPROCESO
	do 	
		echo ""
		echo ""
		echo "===================================================" 
		echo "INICIANDO MONITOREO DE PROCESO $PROCESOHOST SUBPROCESO SECUNDARIOS $NOMPROC" 
		date 													   
		echo "==================================================="	 
		
		PS=1
		ATTEMPTS=0
		MAX_ATTEMPTS=20
		while [ $PS -eq 1 ]
		do
			sleep 5
			PS=$(valida_procesos)
			ATTEMPTS=$(( $ATTEMPTS + 1 ))
			echo "WAITING $ATTEMPTS SEC"
			if [ $ATTEMPTS -gt $MAX_ATTEMPTS ]
				then
				echo "===================================================" 
				echo "ERROR: TIEMPO EXCEDIDO DE MONITOREO DEL PROCESO $PROCESOHOST SUBPROCESO SECUNDARIO $NOMPROC" 
				date 													   
				echo "==================================================="
				PS=2
				SALIDA=1
				exit 1
			fi
		done
		if [ $PS -eq 0 ]; then 
			
			echo "===================================================" 
			echo "EL PROCESO $PROCESOHOST SUBPROCESO SECUNDARIO $NOMPROC YA SE ENCUENTRA EN EJECUCION" 
			date 													   
			echo "==================================================="	 
		fi
	done
	
	echo ""
	echo ""
	echo "===================================================" 
	echo "TODOS LOS PROCESOS $PROCESOHOST SE ENCUENTRA EN EJECUCION" 
	date 													   
	echo "==================================================="	
}


#================================================================
# Se inicia monitoreo de sub procesos secundarios jboss
#================================================================

if [ "$HOST" = "$HOST_A" ];then	
	valida_proceso_jbosseap "$PROCESOSA"
elif [ "$HOST" = "$HOST_B" ];then
	valida_proceso_jbosseap "$PROCESOSB"
elif [ "$HOST" = "$HOST_C" ];then
	valida_proceso_jbosseap "$PROCESOSC"
elif [ "$HOST" = "$HOST_D" ];then
	valida_proceso_jbosseap "$PROCESOSD"
fi

#================================================================
# Se termina monitoreo de sub procesos secundarios jboss
#================================================================

 
exit $SALIDA 
