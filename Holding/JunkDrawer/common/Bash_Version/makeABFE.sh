#!/bin/bash

#Arguments:
# 1:resid to mutate
# 2:prefix_out
# 3:name of the input prefix ("PCPG31")

#throw an error if a variable is undefined
set -ue

#Get the relative directory to the common folder
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

#function definitions:
. "$DIR/common.sh" 


commonPath="$DIR"
resid="$1"
patchName="$2"
affix="$2_$1"
prefixin="$3"
fout="$affix.tcl"

#Make the directory and accompanying files
mkdir $affix || echo "Warning: $affix already exists"
cd $affix
templateAll $affix $resid ../TEMPLATE
mkdir restraints || echo "Continuing"
cd ..

buildABFEtcl $fout $commonPath $resid $prefixin $affix 

#Execute the tcl script
#vmd -dispdev none -e $fout
vmd -e $fout

#Cleanup and organize
tail -n +2 ./$affix/zrestraint.$affix.colvars > ./$affix/temp.colvars
mv ./$affix/temp.colvars ./$affix/zrestraint.$affix.colvars
cp $prefixin.psf $affix.psf
cp $prefixin.pdb $affix.pdb

mv $affix* ./$affix
