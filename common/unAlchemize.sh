#!/bin/bash

#Arguments:
# 1:name of the input prefix (e.g. "POCE_X")
# 2:newRes (e.g. you've run POCE and POCG, now you need POGE or POEG)
# 3:path to common directory

commonPath=$3
prefixin=$1
newRes=$2

dualName=$(echo $1 | head -c 4)
index=$(echo $1 | tail -c 2)
prefixout="${newRes}_$index"
depatch="${dualName}_to_$newRes"
fout="$prefixout.tcl"
depatchName="$( echo $dualName | tail -c 3 )$( echo $newRes | tail -c 3 )"
echo $newRes
echo $dualName
echo $prefixout
echo $depatch
echo $fout
echo $depatchName
#exit 1

#Make the directory and accompanying files
mkdir $depatch

#Load the procs that we'll need
echo "source $commonPath/patch_script.tcl" > $depatch.tcl

#Delete all molecules, reset psfgen, and load the needed topologies, then load the molecule
echo "cleanSlate $prefixin/$prefixin $commonPath $depatch.rtf" >> $depatch.tcl

#Apply the deletion patch rename the residue and write the new psf and pdb
echo "depatch $dualName $depatchName $prefixout $newRes $commonPath $depatch.rtf" >> $depatch.tcl

#Load the new molecule
echo "mol new $prefixout.psf" >> $depatch.tcl
echo "mol addfile $prefixout.pdb" >> $depatch.tcl
vmd -e $depatch.tcl

mv $prefixout* $depatch
mv $depatch.* $depatch

