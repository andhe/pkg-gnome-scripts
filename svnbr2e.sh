#!/bin/sh

# ./svnbr2e.sh [desktop|packages] <package>

gnomesuite=desktop
distribution=unstable

if [ $# != 1 ]
then
	if [ "$1" = "packages" ] || [ "$1" = "desktop" ]; then
		gnomesuite=$1
		shift
	fi

	#if [ "$1" = "experimental" ] || [ "$1" = "unstable" ]; then
	#	distribution=$1
	#	shift
	#fi
fi

if [ $# != 1 ]
then
	echo "Usage: $0 [desktop|packages] <package>" >&2
	exit 1
fi

package=$1

unstableurl="svn+ssh://svn.debian.org/svn/pkg-gnome/$gnomesuite/unstable/$package"
experimentalurl="svn+ssh://svn.debian.org/svn/pkg-gnome/$gnomesuite/experimental/$package"

if svn ls $experimentalurl > /dev/null 2>&1 ; then
	echo "Hey! experimental branch already exists!" >&2
	exit 1
fi


echo "About to do:"
echo "
svn cp \\
	$unstableurl \\
	$experimentalurl
"

read -p "Press any key to continue...." FOOBAR

svn cp $unstableurl $experimentalurl
