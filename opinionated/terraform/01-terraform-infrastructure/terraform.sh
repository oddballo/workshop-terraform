#!/bin/bash

# Nothing to configure

###############################################################

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$DIR/../common/function.sh"

{
	cd "$DIR"

	ENVIRONMENT="$(current_value "$DIR" "environment")"

	ENVIRONMENT_FILE="environments/$ENVIRONMENT.tfvars"

	check_file "$ENVIRONMENT_FILE"

	if [ -z "$1" ]; then
		echo "Missing terraform command. Enter apply, destroy, refresh ..."
		exit 1
	fi

	terraform $1 -var-file "$ENVIRONMENT_FILE" ${@:2}
}
