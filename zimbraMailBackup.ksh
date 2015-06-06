#/usr/bin/ksh

#Autor: Abian Hernandez Guedes
#Last Version Tested: Zimbra 8.0.7

#Script encargado de realizar un backup de las cuentas del servidor de correo. 
#Se guardan los dos últimos backups realizados, siendo el más antiguo (nombre).zip.old. 
#Al finalizar se envia una notificacion mediante un eMail.


FILE_PATH="/backup/mailbox/"
LOG_NAME="mailbox.log"
LOG_FILE=$FILE_PATH$LOG_NAME

ZMMBOX=/opt/zimbra/bin/zmmailbox
ZMPROV=/opt/zimbra/bin/zmprov
SENDMAIL=/opt/zimbra/postfix/sbin/sendmail

log(){
	echo $(date +"%d %b %T") "=>" $* >> $LOG_FILE 
}

if [ ! -d $FILE_PATH ]; then
	mkdir -m 640 -p $FILE_PATH
fi

if [ ! -f $LOG_FILE ]; then
	touch $LOG_FILE
fi

echo "-------- COMIENZO DEL BACKUP: $(date +%d-%m-%Y) --------" >> $LOG_FILE

# Recorrer todos las cuentas del servidor
for mbox in `$ZMPROV -l gaa`
do
	log "Generando el backup de los correos de $mbox"
	if [ -f $FILE_PATH"$mbox.zip" ]; then
		mv -f $FILE_PATH"$mbox.zip" $FILE_PATH"$mbox.zip.old"
	fi
	$ZMMBOX -z -m $mbox gru "?fmt=zip&meta=1" > $FILE_PATH"$mbox.zip"
done

echo "-------- FINALIZADO BACKUP --------" >> $LOG_FILE

#Enviando el correo al administrador
$SENDMAIL -t << EOF
From: noreply@midominio.es
To: admin@midominio.es
Subject: Respaldo Zimbra $(date +%d/%m/%y)
Se ha realizado hoy, $(date +%d\ de\ %B\ %Y), un backup de los correos. Actualizado log, Véase $LOG_FILE
EOF
