#!/bin/bash

set -euo pipefail

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
{
	cd "$DIR"
    
	TERRAFORM="$(terraform output -json)"

	BUCKET_TOOLS="$(echo "$TERRAFORM" | jq -r '.["bucket-tools"].value // empty')"
	if [ -z "$BUCKET_TOOLS" ]; then
		echo "BUCKET_TOOLS empty. Aborting."
	fi
	
	FILENAMES=(
		"test.txt"
	)
	for FILENAME in "${FILENAMES[@]}"; do
		if aws s3 ls "s3://$BUCKET_TOOLS/$FILENAME" &> /dev/null; then
			echo "$FILENAME already copied. Skipping."
			continue
		fi
		aws s3 cp "$DIR/static/$FILENAME" "s3://$BUCKET_TOOLS/$FILENAME"
	done
}

