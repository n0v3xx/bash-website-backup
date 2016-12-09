#!/usr/bin/env bash

######################################################################################################
############## Configuration  ########################################################################
######################################################################################################

# Modify me #
BACKUP_MODE=1                                                   # 1 = local | 2 = local & dropbox | 3 = dropbox
PATH_BACKUP="/root/backup" # Full path to the backup directory
PATH_TARGET="/var/www/mysite"   # Full path to the target
PATH_EXCLUDE="/var/www/mysite/images" # Full path to excluded folder
FILENAME="backup-website"                                       # archive name
DATE=$(date +"%d-%m-%Y")                                        # example 08-12-2016

# dropbox upload
# https://github.com/andreafabrizi/Dropbox-Uploader
DROPBOX_ENABLE=1                                   # 1 = On / 0 = Off
DROPBOX_PATH_CONFIG="/root/.dropbox_uploader"
DROPBOX_PATH_UPLOADER="/root/dropbox_uploader.sh"
DROPBOX_PATH_FOLDER="/backup"                      # backup folder on dropbox
DROPBOX_DELETE_DATE=$(date --date="-1 day" +"%Y-%m-%d")

# Dont touch me #
SCRIPT_NAME="Website-Backup:"
PATH_SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

######################################################################################################
############## Script Logic Starts here ##############################################################
######################################################################################################

# Set default file permissions
# https://www.cyberciti.biz/tips/understanding-linux-unix-umask-value-usage.html
# Owner: 0 = read, write and execute | Group: 7 = no permissions | Others: 7 = no permissions
umask 177

if ! [ -d "$PATH_BACKUP" ]
    then
        echo "${SCRIPT_NAME} Backup path not exist"
        exit
fi

if ! [ -d "$PATH_TARGET" ]
    then
        echo "${SCRIPT_NAME} Target path not exist"
        exit
fi

if ! [ -d "$PATH_EXCLUDE" ]
    then
        echo "${SCRIPT_NAME} No exclude path"
        exclude=0
    else
        echo "${SCRIPT_NAME} Exclude path: ${PATH_EXCLUDE}"
        exclude=1
fi

if test ${exclude} == 1
    echo "${SCRIPT_NAME} Start Backup"
    then
        # packen
        # https://wiki.ubuntuusers.de/Skripte/Backupscript/
        tar --exclude="${PATH_EXCLUDE}" -zcf ${PATH_BACKUP}/${FILENAME}-${DATE}.tar.gz ${PATH_TARGET}
    else
        tar -zcf ${PATH_BACKUP}/${FILENAME}-${DATE}.tar.gz ${PATH_TARGET}
fi
echo "${SCRIPT_NAME} Backup Finish"

# Delete files older than 10 days (only .tar.gz files)
echo "${SCRIPT_NAME} Delete old .tar.gz files"
find ${PATH_BACKUP}/* -name '*.sql.gz' -mtime +10 -exec rm {} \;

# check dropbox upload
if test ${DROPBOX_ENABLE} == 1
    then
        # upload to dropbox
        bash ${DROPBOX_PATH_UPLOADER} -f ${DROPBOX_PATH_CONFIG} upload ${PATH_BACKUP}/${FILENAME}-${DATE}.tar.gz ${DROPBOX_PATH_FOLDER}
        # delete old uploads
        echo "Try to delete "
        bash ${DROPBOX_PATH_UPLOADER} -f ${DROPBOX_PATH_CONFIG} delete ${DROPBOX_PATH_FOLDER}/${FILENAME}-${DROPBOX_DELETE_DATE}.sql.gz
    else
        echo "Dropbox upload not enabled"
fi

echo "${SCRIPT_NAME} Done"


# entpacken
#tar -zxvf archiv.tar.gz