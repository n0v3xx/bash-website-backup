#!/usr/bin/env bash

######################################################################################################
############## Configuration  ########################################################################
######################################################################################################

# Modify me #
BACKUP_MODE=1 # 1 = local | 2 = local & dropbox | 3 = dropbox
PATH_BACKUP="/data/m.reschke/Github/bash-website-backup/backup" # Full path to the backup directory
PATH_TARGET="/data/m.reschke/Github/bash-website-backup/test"   # Full path to the target
FILENAME="backup-website"
DATE=$(date +"%d-%m-%Y") # example 08-12-2016

# Dont touch me #



######################################################################################################
############## Script Logic Starts here ##############################################################
######################################################################################################

# Set default file permissions
# https://www.cyberciti.biz/tips/understanding-linux-unix-umask-value-usage.html
# Owner: 0 = read, write and execute | Group: no permissions | Others: no permissions
umask 177

# packen
#tar -zcvf ${FILENAME}-${DATE}.tar.gz ${PATH_TARGET}

# entpacken
#tar -zxvf prog-1-jan-2005.tar.gz