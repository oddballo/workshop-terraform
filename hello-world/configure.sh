#!/bin/bash

set -eou pipefail

command -v aws &> /dev/null || { echo "Missing AWS. Aborting."; exit 1; }
command -v openssl &> /dev/null || { echo "Missing openssl. Aborting."; exit 1; }

# Fetch AWS account ID
ACCOUNT=$(aws sts get-caller-identity | jq -r '.Account') ||
	{ echo "AWS get account failed. Are you logged in? Aborting."; exit 1; }

# Generate (likely) unique profile name
PROFILE=$(openssl rand -hex 10)

# Request policy name
DEFAULT_POLICY="PermissionsBoundaryRestricted"
read -p "Permissions Boundary [Default: ${DEFAULT_POLICY}]:" POLICY
if [ -z "$POLICY" ]; then
	POLICY="$DEFAULT_POLICY"
fi

# Generate config file
cat <<EOF > config.txt
project=workshop
environment=development
profile=${PROFILE}
owner=jsmith
region=eu-west-1
account_id=${ACCOUNT}
permissions_boundary=arn:aws:iam::${ACCOUNT}:policy/${POLICY}
name=world
EOF
