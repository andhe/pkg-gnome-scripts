# pkg-gnome-scripts

A random collection of scripts that has proven useful while
working on Debian pkg-gnome team.

## svnbp

This is a helper script to run svn-buildpackage under pbuilder/cowbuilder
with a set of hooks to simplify some tasks.

You'll need to edit the script:
 - Replace "/path/to/pbuilder-hooks/" with correct path to the included
   "pbuilder-hooks" directory.
 - drop the "--pbuilder cowbuilder" if you prefer plain pbuilder
   over cowbuilder.

This script and the included pbuilder-hooks was originally
received from "pochu" and has seen some changes since.

## svnco.sh

A simple helper script to check things out from pkg-gnome.
Run it for help output for arguments.

Normally you'd use 'debcheckout [-a] ...' which is a better
and more generic tool, but this script can be useful eg.
when Vcs-Svn field is not up to date in the package
currently in the Debian archive, etc.

## svnbr2e.sh

Copies the unstable svn branch into an experimental branch.
Run it for help output for arguments.

## svnrmunstable.sh

Removes the unstable branch and moves the experimental branch
in place of the (previously removed) unstable branch.

Please make sure you've manually merged all potential changes
done on the unstable branch into the experimental branch
(which might have happened since the experimental one was
branched from unstable).

This script is supposed to be run while your current working
directory is a checkout of the experimental branch. It takes
no arguments but looks the information up from the existing
working copy.

# gitbp

A helper script to run git-buildpackage under pbuilder/cowbuilder
hooked up to the included "pbuilder-hooks" (see svnbp).
Either symlink ~/.pbuilder-hooks to where you keep the included
"pbuilder-hooks", or change the script to use correct path.

This script will do some name-based guessing to try to figure
out which branch is the debian branch, which one is the upstream
and if we should enable pristine-tar support.
Normally your package would have a debian/gbp.conf which specifies
all of this explicitly, but if one is lacking this script can help.


