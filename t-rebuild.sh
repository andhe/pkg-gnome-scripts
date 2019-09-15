#!/bin/bash
# This is a simple helper script useful for rebuilding packages
# in preparation for a transition.

SCRIPTDIR="$(dirname $0)"

if [ "$1" = "prep" ]; then
	reverse-depends -r sid -l "src:$2" > pkgs.txt
	echo "$2" > t.txt
	test -d build-logs || mkdir -p build-logs
	echo "Packages to rebuild: $(wc -l < pkgs.txt)"
	echo "Make sure '$2' binaries are available in /var/cache/pbuilder/mirror"
	exit 0
fi

if [ ! -e pkgs.txt ]; then
	echo "Error: You first need to prepare the rebuild." >&2
	echo "Usage: $0 prep <TRANSITION_SOURCE_PACKAGE>" >&2
	echo "Also make sure to put the new transition package in /var/cache/pbuilder/mirror (and only it)" >&2
	exit 1
fi

echo "# === $(date) === " >> failed.txt

echo "# --- downloading ---"
for PKG in $( grep -v "^#" pkgs.txt ) ; do
	if [ ! -e "${PKG}_*.dsc" ]; then
		echo "# --- DL: $PKG ---"
		apt-get source $PKG/unstable || exit 1
	else
		echo "# --- DL: cached $PKG ---"
	fi
done

for PKG in *.dsc ; do
	echo "########## Rebuilding $PKG"

	# build with local version
	( ENABLE_LOCAL=1 DISABLE_FAILSHELL=1 sudo -E pbuilder build --hookdir "$SCRIPTDIR/pbuilder-hooks" --bindmounts /var/cache/pbuilder/mirror ${PKG} || echo $PKG >> failed.txt ) 2>&1 | tee build-logs/$PKG.log
done

if grep -c -v "^#" failed.txt ; then
	echo "There are failed packages!! See failed.txt"
fi
