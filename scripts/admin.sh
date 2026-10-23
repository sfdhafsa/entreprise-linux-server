#!/bin/bash
set -euo pipefail
configuration="./configs/admin.conf"
functions="./scripts/functions.sh"
if [[ ! -f "$configuration" ]];then
	echo "configuration file doesn't exist">&2
	exit 1
fi
if [[ ! -f "$functions" ]];then
	echo "functions file doesn't exist">&2
	exit 1
fi
source "$configuration"
source "$functions"
if [[ ! -d "$SOURCE_DIR" ]];then
        log "ERROR"  "source directory $SOURCE_DIR  doesn't exist"
	exit 1
fi
if [[ ! -d "$BACKUP_DIR" ]];then
        log "ERROR" "backup directory $BACKUP_DIR  doesn't exist"
	exit 1
fi



if [[ "$#" -ne 1 ]];then
	echo "usage: ./scripts/admin.sh <health|backup>"
	exit 1
fi

if [[ "$1" == "health" ]];then
	log "INFO" "health operation selected"
	check_disk_usage
elif [[ "$1" == "backup" ]];then
	log "INFO" "backup operation selected"
	backup_applications
else
	log "ERROR" "invalid argument"
	exit 1
fi

