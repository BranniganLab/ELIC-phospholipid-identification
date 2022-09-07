#!/bin/bash

#Arguments:
#1: segname of resid to mutate
#2: resid to mutate
#3: patch name as found in the topologies
#4: name of the input prefix (your starting psf and pdb)

#throw an error if a variable is undefined
set -ue

#re='^[0-9]+$'
#if [[ $1 =~ $re ]]; then
if [[ $1 = '-h' ]]; then
helptext="Arguments:
1: segname of resid to mutate
2: resid to mutate
3: patch name as found in the topologies
4: name of the input prefix (your starting psf and pdb)
-h: print this help text and quit"
echo "$helptext"
exit 1
fi


#Get the relative directory to the common folder
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

#function definitions:
. "$DIR/common.sh" 


commonPath="$DIR"
seg="$1"
resid="$2"
patchName="$3"
affix="$3_$2"
prefixin="$4"
fout="$affix.tcl"


#Make the directory and accompanying files
mkdir $affix || echo "Warning: $affix already exists"
cd $affix
templateAll $affix $resid $commonPath/sample_TEMPLATE
mkdir restraints || echo "Continuing"
cd ..

buildTCL $fout $commonPath $seg $resid $patchName $prefixin $affix 

#Execute the tcl script
#vmd -dispdev none -e $fout
vmd -e $fout

#Cleanup and organize
tail -n +2 ./$affix/zrestraint.$affix.colvars > ./$affix/temp.colvars
mv ./$affix/temp.colvars ./$affix/zrestraint.$affix.colvars
mv $affix* ./$affix

