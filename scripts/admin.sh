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

if [[ "$#" -ne 1 ]];then
	echo "usage: ./scripts/admin.sh <health|backup>"
	exit 1
fi

if [[ "$1" == "health" ]];then
	echo "health operation selected"
elif [[ "$1" == "backup" ]];then
	echo "backup operation selected"
else
	echo "invalid argument"
	exit 1
fi


