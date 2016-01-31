#!/bin/bash

set -e

URL=$(svn info | awk '/^URL:/{print $2}')

if [ "$URL" = "${URL/\/experimental\//}" ]; then
	echo "Error: Remote svn url does not point to an experimental branch" >&2
	exit 1
fi

UNSTABLEURL="${URL/\/experimental\///unstable/}"

echo "The current experimental url is: $URL"
echo "The current unstable url is: $UNSTABLEURL"


echo ""

echo svn rm -m \"Remove unstable branch\" $UNSTABLEURL
echo svn mv -m \"Move experimental branch to unstable\" $URL $UNSTABLEURL
echo svn switch $UNSTABLEURL

read -p "About to execute above commands. Press any key to continue or ctrl-c to abort."

svn rm -m "Remove unstable branch" $UNSTABLEURL
svn mv -m "Move experimental branch to unstable" $URL $UNSTABLEURL
svn switch $UNSTABLEURL

svn up
