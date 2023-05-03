#!/bin/bash

set -eou pipefail

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$DIR/../common/function.sh"

{
    cd "$DIR"

    TERRAFORM="$(terraform output -json)"

    PREFIX="$(echo "$TERRAFORM" | jq -r '.prefix.value // empty')"
    if [ -z "$PREFIX" ]; then
	echo "Couldn't fetch PREFIX; likely in an undeployed state. Skipping dynamic delete."
	exit 0
    fi

    SKIP_WARNING="${SKIP_WARNING:-false}"
    if [ -z "$SKIP_WARNING" ] || [[ "$SKIP_WARNING" != "true" ]]; then
    	read -p "REMOVING ALL DYNAMIC ASSETS!!!!!!!!. Continue? (enter 'yes')" RESPONSE
    	[[ "$RESPONSE" != "yes" ]] && { echo "Non-yes answer given. Aborting."; exit 1; }
    fi

    # Remove the contents of the buckets
    if aws s3api head-bucket --bucket "$PREFIX-tools" 2>/dev/null; then
    	aws s3 rm "s3://$PREFIX-tools" --recursive
    fi

    # # Remove all log groups
    aws logs describe-log-groups --log-group-name-prefix "/aws/lambda/$PREFIX" |
		jq -r '.logGroups[].logGroupName' |
		xargs -I {} aws logs delete-log-group --log-group-name "{}"

}
