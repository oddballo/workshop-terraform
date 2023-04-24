#!/bin/bash

VERSION="2022092803"

PROJECT="${PROJECT:-workshop}"
ENVIRONMENT="${ENVIRONMENT:-development}"
PROFILE="${PROFILE:-}"
BUCKET="$PROJECT-$ENVIRONMENT-$PROFILE-tools"
FILENAME="demo.$VERSION.zip"

###################

set -euo pipefail

if [ -z "$PROFILE" ]; then
	echo "PROFILE environment variable needs to be set. Aborting."
	exit 1
fi

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

{
	if aws s3 ls "s3://$BUCKET/$FILENAME" &> /dev/null; then
		echo "$FILENAME already built. Short circuiting."
		exit 0
	fi

	mkdir -p "$DIR/dist"
	cd "$DIR/src"
	zip -r "$DIR/dist/$FILENAME" .
	cd "$DIR/dist"
	aws s3 cp "$FILENAME" \
		"s3://$BUCKET/$FILENAME"
}
