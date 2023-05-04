#!/bin/bash

# Nothing to configure

###############################################################

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$DIR/../common/function.sh"

{
	cd "$DIR"

	ENVIRONMENT="$(current_value "$DIR" "environment")"
	PROFILE="$(current_value "$DIR" "profile")"

	ENVIRONMENT_FILE="environments/$ENVIRONMENT.tfvars"
	ENVIRONMENT_PROFILE_FILE="environments/$ENVIRONMENT.$PROFILE.tfvars"

	check_file "$ENVIRONMENT_FILE"
	check_file "$ENVIRONMENT_PROFILE_FILE"

	if [ -z "$1" ]; then
		echo "Missing terraform command. Enter apply, destroy, refresh ..."
		exit 1
	fi

	terraform $1 -var-file "$ENVIRONMENT_FILE" -var-file "$ENVIRONMENT_PROFILE_FILE" ${@:2}
}
