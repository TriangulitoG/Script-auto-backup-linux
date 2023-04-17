# Scrpit-auto-backup-ubuntu
Scrpit auto backup ubuntu

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

