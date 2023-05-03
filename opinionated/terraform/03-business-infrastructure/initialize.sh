#!/bin/bash

#
#	This script initalises the state bucket,
#	the Dynamo DB state lock table, and the tool bucket.
#	It addresses the chicken before the egg problem for
#	locking and provisioning Lambdas before the bucket
#	containing the source code exists
#

ENVIRONMENT="${ENVIRONMENT:-development}"
PROFILE="${PROFILE:-}"

###############################################################

if [ -z "$PROFILE" ]; then
	echo "Please define the environment variable PROFILE. Aborting."
	exit 1
fi

trap ctrl_c INT
ctrl_c() {
	echo "Ctrl-C detected. Aborting."
	exit 1
}

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$DIR/../common/function.sh"

{
	cd "$DIR"

	ENVIRONMENT_BACKEND_FILE="environments/$ENVIRONMENT.$PROFILE.backend.conf"

	check_file "$ENVIRONMENT_BACKEND_FILE"

	terraform init -backend-config="$ENVIRONMENT_BACKEND_FILE" $@ \
		|| { echo "Terraform initilization failed. Aborting."; exit 1; }

	echo "$ENVIRONMENT" > "$DIR/environment.current"
	echo "$PROFILE" > "$DIR/profile.current"

	echo "Successfully initialized"
	exit 0
}
