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
	
	terraform apply -var-file "$ENVIRONMENT_FILE" -lock=false $@
}
