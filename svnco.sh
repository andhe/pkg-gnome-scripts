#!/bin/sh

# ./svnco.sh [desktop|packages] [unstable|experimental] <package>

gnomesuite=desktop
distribution=unstable

if [ $# != 1 ]
then
	if [ "$1" = "packages" ] || [ "$1" = "desktop" ]; then
		gnomesuite=$1
		shift
	fi

	if [ "$1" = "experimental" ] || [ "$1" = "unstable" ]; then
		distribution=$1
		shift
	fi
fi

if [ $# != 1 ]; then
	echo "Usage: $0 [desktop|packages] [unstable|experimental] <package>" >&2
	exit 1
fi

package=$1

svn co svn+ssh://svn.debian.org/svn/pkg-gnome/$gnomesuite/$distribution/$package
