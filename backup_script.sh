#!/bin/bash

# Configuración
BACKUP_SRC="/../../../../"
BACKUP_DEST="/../../../../"
FTP_HOST=""
FTP_USER=""
FTP_PASS=""
FTP_DIR="/../../../../s"
LOG_FILE="${BACKUP_SRC}/backup.log"
# Discord webhook para enviar cuando se crea el backup diario
DISCORD_WEBHOOK=""

# Función para enviar una notificación de Discord
function send_discord_notification() {
    local message="$1"
    curl -H "Content-Type: application/json" -X POST -d "{\"content\":\"@everyone $message\"}" "${DISCORD_WEBHOOK}"
}

# Redirigir la salida estándar y de error del script al archivo de registro
exec > >(tee -i ${LOG_FILE})
exec 2>&1

# Crear directorio de copias de seguridad si no existe
mkdir -p "${BACKUP_DEST}"

# Crear copia de seguridad y comprimir
DATE=$(date +"%Y-%m-%d")
FILENAME="backup-${DATE}.zip"
zip -r "${BACKUP_DEST}/${FILENAME}" "${BACKUP_SRC}" >> ${LOG_FILE} 2>&1
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    # Subir copia de seguridad al servidor FTP
    ftp -n -p "${FTP_HOST}" <<END_SCRIPT
quote USER ${FTP_USER}
quote PASS ${FTP_PASS}
cd ${FTP_DIR}
put ${BACKUP_DEST}/${FILENAME}
quit
END_SCRIPT

    # Eliminar copias de seguridad antiguas (6 días) en la ubicación local
    find "${BACKUP_DEST}" -name "backup-*.zip" -mtime +6 -exec rm {} \;

    # Eliminar copias de seguridad antiguas (6 días) en el servidor FTP
    ftp -n -p "${FTP_HOST}" <<END_SCRIPT
quote USER ${FTP_USER}
quote PASS ${FTP_PASS}
cd ${FTP_DIR}
mdelete $(echo "backup-"$(date --date='6 days ago' +"%Y-%m-%d")".zip")
quit
END_SCRIPT

    # Enviar una notificación de Discord si todo sale bien
    send_discord_notification "Copia de seguridad completada el ${DATE}"
    echo "Copia de seguridad completada el ${DATE}"
    # Mostrar el contenido del archivo ZIP
    zipinfo "${BACKUP_DEST}/${FILENAME}"
else
    # Enviar una notificación de Discord si ocurre un error
    send_discord_notification "Ocurrió un error durante la copia de seguridad. Revisa el archivo de registro para más información."
    echo "Ocurrió un error durante la copia de seguridad. Revisa el archivo de registro para más información."
    exit 1
fi

# De TriangulitoG
