# ZimbraBackup
Scripts to do backup and restore in Zimbra, mail server

These scripts have been tested in Zimbra 8.0.6 and 8.0.7 on Centos 7. You must have installed the Korn shell (ksh).

  - **zimbraMailBackup.ksh**: Script Manager to backup accounts mail server. The last two backups made are saved, being the oldest (name).zip.old. Upon completion notification is sent by eMail.
  - **zimbraMailRestore.ksh**: Script Manager are restoring the last backup made.If you want to run the script to restore the previous state mail to the last backup performed "./zimbraMailRestore old".
