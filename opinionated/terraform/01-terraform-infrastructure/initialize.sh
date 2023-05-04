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

	source "$ENVIRONMENT_BACKEND_FILE"
	if [ -z "$bucket" ] \
		|| [ -z "$region" ]; then
		echo "Please configure \"$ENVIRONMENT_BACKEND_FILE\" with \"bucket\" and \"region\""
		exit 1
	fi

	# Remap for script usage (we were reusing the HCL file) and I want to
	# use standard bash formatting
	BUCKET="$bucket"
	REGION="$region"

	echo "Check if bucket \"$BUCKET\" exists"
	if aws s3api head-bucket --bucket "$BUCKET" 2>/dev/null; then
		echo "Bucket \"$BUCKET\" exists."
	else
		echo "Bucket \"$BUCKET\" missing. Creating."
		aws s3api create-bucket \
			--bucket $BUCKET \
			--acl private \
			--region $REGION \
			--create-bucket-configuration LocationConstraint=$REGION \
		|| { echo "Creating bucket failed. Aborting."; exit 1; }
	fi

	timeout 120 \
		aws s3api wait bucket-exists --bucket $BUCKET > /dev/null \
		|| { echo "Waiting for bucket failed. Aborting."; exit 1; }

	terraform init -backend-config="$ENVIRONMENT_BACKEND_FILE" $@ \
		|| { echo "Terraform initilization failed. Aborting."; exit 1; }

	echo "$ENVIRONMENT" > "$DIR/environment.current"
	echo "$PROFILE" > "$DIR/profile.current"

	echo "Successfully initialized"
	exit 0
}
