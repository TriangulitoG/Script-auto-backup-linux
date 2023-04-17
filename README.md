# Script-auto-backup-ubuntu
Script auto backup ubuntu

# Que hace?

Este script en bash crea una copia de seguridad de una carpeta o directorio especificado y la comprime en un archivo ZIP. Luego, se carga la copia de seguridad comprimida en un servidor FTP y se eliminan las copias de seguridad antiguas de la ubicación local y del servidor FTP. Además, el script está configurado para ejecutarse automáticamente todas las noches a las 00:00 y al inicio de la máquina. El script también envía notificaciones a un webhook de Discord si todo sale bien o si ocurre un error durante la copia de seguridad. Las variables de configuración en la parte superior del script se pueden ajustar para adaptarse a diferentes ubicaciones de carpeta o directorio, servidores FTP y webhooks de Discord.


# Instalacion
```text
git clone https://github.com/TriangulitoG/Discord-counter-voice-channel.git
```

# Para que el script se ejecute cuando la maquina se enciende y diariamente a las 0 0

```text
chmod +x backup_script.sh
```
```text
sudo nano /etc/systemd/system/backup.service
```
Remplaza '/path/to/backup_script.sh' por donde esta tu 'backup_script.sh'
```text
[Unit]
Description=Daily Backup Service

[Service]
Type=simple
ExecStart=/path/to/backup_script.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
```
```text
sudo systemctl enable backup.service
sudo systemctl start backup.service
```
```text
crontab -e
```
Añade la siguiente línea al final del archivo (Esto ara que el archivo se ejecuta a las 0 0 el archivo)

Remplaza '/path/to/backup_script.sh' por donde esta tu 'backup_script.sh'
```text
0 0 * * * /path/to/backup_script.sh
```
```text
sudo service cron reload
```

