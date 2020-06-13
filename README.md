# unrepositorio
https://docs.microsoft.com/en-us/learn/modules/get-started-with-windows-subsystem-for-linux/2-enable-and-install

http://dirr@10.100.236.102/configuration-management/automation.git

1qaz2wsx


echo "$TABLAS_EN_PROCESO" |while read LINEA_TABLAS; 
		do
		
http://10.100.224.38:19080/sco-valores/index.jsf	


numeroproceso="$1"


#================================================================
# Validamos que no haya servicios colgados en el server
#================================================================

if [ -z  "${numeroproceso}" ]; then
	echo "Falta proporcionar un parametro que sea 1 o 2 o 3" 
	echo "Ejemplo: start_dali.sh 1 " 
	exit 1
fi

if [ "${numeroproceso}" -gt 4 ];then
	echo "Parametro invalido solo debe ser valor de  1 o 2 o 3 " 
	exit 1
fi


if [ $numeroproceso -gt 1 ]; then
	rutainicial=`dirname ../` 
	cd $rutainicial
	cd ..	
fi


rutainicial=`pwd`
. common/setenv.sh


