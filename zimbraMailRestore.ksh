#/usr/bin/ksh

#Autor: Abian Hernandez Guedes
#Version: Zimbra 8.0.7
#Script encargado de realizar la restauración del último backup realizado
#Si se desea ejecutar el script para restaurar el correo al estado anterior al ultimo backup realizar "./zimbraMailRestore old"


FILE_PATH="/backup/mailbox/"
LOG_NAME="mailbox.log"
LOG_FILE=$FILE_PATH$LOG_NAME
EXT=".zip"
if [[ $# -eq 1 && $1 = old ]]; then
	EXT=".zip.old"
fi

ZMMBOX=/opt/zimbra/bin/zmmailbox
ZMPROV=/opt/zimbra/bin/zmprov

log(){
	echo $(date +"%d %b %T") "=>" $* >> $LOG_FILE 
}

if [ ! -d $FILE_PATH ]; then
	mkdir -p $FILE_PATH
fi

if [ ! -f $LOG_FILE ]; then
	touch $LOG_FILE
fi

echo "	COMIENZO DE LA RESTAURACION: $(date +%d-%m-%Y)" >> $LOG_FILE

# Recorrer todos las cuentas del servidor
for mbox in `$ZMPROV -l gaa`
do
	log "Restaurando los correos de $mbox"
	$ZMMBOX -z -m $mbox postRestURL "//?fmt=zip&resolve=reset" $FILE_PATH$mbox$EXT	
done

echo "	FINALIZADA RESTAURACION" >> $LOG_FILE
