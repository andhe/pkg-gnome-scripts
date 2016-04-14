#!/bin/sh

# first check if we're running from a current checkout.

if [ -d .svn ] && [ $# = 0 ]; then
	URL=$(svn info | awk  '/^URL: /{print $2}')
	if echo $URL | grep -q '/unstable/' ; then
		BRANCHU="$URL"
		BRANCHEXP=$(echo $URL | sed -e 's#/unstable/#/experimental/#')
		DOSWITCH=1
	fi
fi

# ./svnbr2e.sh [desktop|packages] <package>

gnomesuite=desktop

if [ $# -gt 1 ]
then
	if [ "$1" = "packages" ] || [ "$1" = "desktop" ]; then
		gnomesuite=$1
		shift
	fi
fi

if [ $# != 1 ]
then
	if [ -z $BRANCHU ] || [ -z $BRANCHEXP ]; then
		echo "Usage: $0 [desktop|packages] <package>" >&2
		exit 1
	fi
fi

package=${1:-current}

BRANCHU=${BRANCHU:-"svn+ssh://svn.debian.org/svn/pkg-gnome/$gnomesuite/unstable/$package"}
BRANCHEXP=${BRANCHEXP:-"svn+ssh://svn.debian.org/svn/pkg-gnome/$gnomesuite/experimental/$package"}

if svn ls "$BRANCHEXP" --depth empty > /dev/null 2>&1 ; then
	echo "ERROR: experimental branch already exists!" >&2
	exit 1
fi

svn cp -m "Branch $package to experimental" \
	$BRANCHU \
	$BRANCHEXP

if [ -n $DOSWITCH ]; then
	svn switch $BRANCHEXP
fi
