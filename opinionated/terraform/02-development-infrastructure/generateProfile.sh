#!/bin/bash

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

while true; do
	read -p "Profile (example: odavies): " PROFILE

	PROFILE=$(echo "$PROFILE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]*//g')
	echo "Profile after filtering: $PROFILE"

	FILE_ENVIRONMENT_PROFILE="$DIR/environments/development.$PROFILE.tfvars"
	FILE_ENVIRONMENT_BACKEND="$DIR/environments/development.$PROFILE.backend.conf"

	if [ -z "$PROFILE" ]; then
		echo -n "Profile cannot be empty."
	elif [ -f "$FILE_ENVIRONMENT_PROFILE" ] || [ -f "$FILE_ENVIRONMENT_BACKEND" ]; then
		echo "Profile \"$PROFILE\" already exists."
	else
		break
	fi
	echo " Ctrl-c to exit, or enter another profile name"
done

cat "$DIR/environments/development.main.tfvars" \
	| sed "s/^profile = \"main\"$/profile = \"$PROFILE\"/g" \
	> "$FILE_ENVIRONMENT_PROFILE" \
	|| echo "Failed to write \"$FILE_ENVIRONMENT_PROFILE\""

cat "$DIR/environments/development.main.backend.conf" \
	| sed "s/^key=\"workshop-development-main.tfstate\"$/key=\"workshop-development-$PROFILE.tfstate\"/g" \
	> "$FILE_ENVIRONMENT_BACKEND" \
	|| echo "Failed to write \"$FILE_ENVIRONMENT_PROFILE\""


