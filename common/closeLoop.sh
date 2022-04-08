#!/bin/bash

#Arguments:
# 1:name of the input prefix (e.g. "POCE_X")
# 2:newRes (e.g. you've run POCE and POCG, now you need POGE or POEG)
# 3:path to common directory

commonPath="$3"
prefixin="$1"
newRes="$2"

dualName="$(echo $1 | head -c 4)"
prefixout="$newRes_$(echo $1 | tail -c 1)"
monoName="POP$( echo $dualName | tail -c 1 )"
depatch="$dualName_to_$monoName"
fout="$prefixout.tcl"
depatchName="$( echo $dualName | tail -c 2 )$( echo $monoName | tail -c 2 )"

#Make the directory and accompanying files
mkdir $depatch

echo "source $commonPath/patch_script.tcl" > $depatch.tcl
echo "cleanSlate $prefixin/$prefixin $commonPath $depatch.rtf" >> $depatch.tcl
echo "depatch $dualName $depatchName $prefixout" >> $depatch.tcl



