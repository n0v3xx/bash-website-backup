#!/usr/bin/env bash

######################################################################################################
############## Configuration  ########################################################################
######################################################################################################

# Modify me #
# Full path to the backup directory
PATH_BACKUP="/path/to/bash-website-backup/backup"
# Full path to the target
PATH_TARGET="/path/to/www/mysite"
# Full path to excluded folder, you can use multiple folders
PATH_EXCLUDE=("/path/to/test/images" "/path/to/test/tmp")
# archive name
FILENAME="backup-website"
# enable the backup delete after x days
BACKUP_DELETE_ENABLE=1
# how many days you store a backup
BACKUP_DELETE_DAYS=10

# dropbox upload
# https://github.com/andreafabrizi/Dropbox-Uploader
DROPBOX_ENABLE=0                                   # 1 = On / 0 = Off
DROPBOX_PATH_CONFIG="/root/.dropbox_uploader"
DROPBOX_PATH_UPLOADER="/root/dropbox_uploader.sh"
DROPBOX_PATH_FOLDER="/backup"                      # backup folder on dropbox
DROPBOX_DELETE_DATE=$(date --date="-1 day" +"%Y-%m-%d")

# Dont touch me #
SCRIPT_NAME="+Website-Backup:"
PATH_SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DATE=$(date +"%Y-%m-%d")

######################################################################################################
############## Script Logic Starts here ##############################################################
######################################################################################################

# Set default file permissions
# https://www.cyberciti.biz/tips/understanding-linux-unix-umask-value-usage.html
# Owner: 0 = read, write and execute | Group: 7 = no permissions | Others: 7 = no permissions
umask 177

#######################################
# Check Paths #########################
#######################################

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
        exclude_string=''
        for i in ${PATH_EXCLUDE[@]}; do
            exclude_string="${exclude_string} --exclude='${i}'"
            echo "${SCRIPT_NAME} Exclude path: ${i}"
        done
        #echo "${SCRIPT_NAME} Exclude path: ${PATH_EXCLUDE}"
        exclude=1
fi

#######################################
# Backup Local ########################
#######################################

if test ${exclude} == 1
    echo "${SCRIPT_NAME} Start Backup"
    then
        # packen
        # https://wiki.ubuntuusers.de/Skripte/Backupscript/
        backup="tar ${exclude_string} -zcf ${PATH_BACKUP}/${FILENAME}-${DATE}.tar.gz ${PATH_TARGET}"
        eval ${backup} # execute with eval becasue bash sucks
    else
        tar -zcf ${PATH_BACKUP}/${FILENAME}-${DATE}.tar.gz ${PATH_TARGET}
fi
echo "${SCRIPT_NAME} Backup Finish"

if delete ${BACKUP_DELETE_ENABLE} == 1
    then
        # Delete files older than xy days (only .tar.gz files)
        echo "${SCRIPT_NAME} Delete old .tar.gz files"
        delete_command="find ${PATH_BACKUP}/* -name '*.tar.gz' -mtime +${BACKUP_DELETE_DAYS} -exec rm {} \;"
        eval ${delete_command}
    else
        echo "${SCRIPT_NAME} Delete is not active"
fi


#######################################
# Dropbox Upload ######################
#######################################

if test ${DROPBOX_ENABLE} == 1
    then
        # upload to dropbox
        bash ${DROPBOX_PATH_UPLOADER} -f ${DROPBOX_PATH_CONFIG} upload ${PATH_BACKUP}/${FILENAME}-${DATE}.tar.gz ${DROPBOX_PATH_FOLDER}
        # delete old uploads
        echo "${SCRIPT_NAME} Try to delete "
        bash ${DROPBOX_PATH_UPLOADER} -f ${DROPBOX_PATH_CONFIG} delete ${DROPBOX_PATH_FOLDER}/${FILENAME}-${DROPBOX_DELETE_DATE}.tar.gz
    else
        echo "${SCRIPT_NAME} Dropbox upload not enabled"
fi

echo "${SCRIPT_NAME} Done"