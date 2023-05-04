#!/bin/bash

current_value (){
	DIR="$1"
	FLAG="$2"
	if [ ! -f "$DIR/$FLAG.current" ]; then
		echo "$FLAG not configured. Please run initialize.sh first."
		exit 1
	fi
	VALUE="$(<"$DIR/$FLAG.current")"
	if [ -z "$VALUE" ]; then
		echo "$FLAG file present, but no value. Aborting."
		exit 1
	fi
	echo "$VALUE"
}

check_file(){
	FILE="$1"
	if [ ! -f "$FILE" ]; then
		echo "Please define $FILE. Aborting."
		exit 1
	fi
}

