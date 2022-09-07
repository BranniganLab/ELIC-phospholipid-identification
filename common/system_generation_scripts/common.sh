#!/bin/bash


function templateAll {
	local affix=$1
	local resid=$2
	local source=$3
	sed "s/TEMPLATE/$resid/g" $source/zrestraint.TEMPLATE.colvars 	> zrestraint.$affix.colvars
	sed "s/TEMPLATE/$affix/g" $source/starting.TEMPLATE.namd 	> starting.$affix.namd
	sed "s/TEMPLATE/$affix/g" $source/runEQ.sh 			> runEQ.sh
	sed "s/TEMPLATE/$affix/g" $source/do_run_TEMPLATE.sh 		> do_run_$affix.sh
	sed "s/TEMPLATE/$affix/g" $source/config_TEMPLATE.yaml 		> config_$affix.yaml
	sed "s/TEMPLATE/$affix/g" $source/common_TEMPLATE.namd 		> common_$affix.namd
}

function buildABFEtcl {
	local fout=$1
	local commonPath=$2
	local resid=$3
	local prefin=$4
	local prefout=$5

	#Make the tcl script
	echo "" > $fout
	echo "source $commonPath/patch_script.tcl" >> $fout
	echo "set res $resid" >> $fout
	echo "set prefin $prefixin" >> $fout
	echo "set prefout $prefout" >> $fout
	echo "set commonPath $commonPath" >> $fout
	
	#deletes all, and opens prefin.psf and prefin.pdb
	echo "cleanSlate \$prefin \$commonPath nan" >> $fout
	echo 'set sel [atomselect top "segname MEMB and resid $res"]' >> $fout
	echo '$sel set beta "-1"' >> $fout
	echo "update CV 1" >> $fout
	echo "animate write psf \$prefout.fep.psf" >> $fout
	echo "animate write pdb \$prefout.fep.pdb" >> $fout
}

#Interpret the patch name for input/output names. NamesOut is global
function parse_patch {
	local patchName=$1
	
	if [ "$patchName" = "POCE" ] || [ "$patchName" = "POCG" ]; then
		namesOut="C15 H15A H15B H15C C14 H14A H14B H14C C13 H13B H13A H13C N H12B C12 H12A H11B C11 H11A O12 P O14 O13 O11"
	elif [ "$patchName" = "POGE" ] || [ "$patchName" = "POGC" ]; then
		namesOut="O11 P O13 O14 O12 C11 H11B H11A H12A C12 OC2 HO2 C13 H13A H13B OC3 HO3"
	elif [ "$patchName" = "POEC" ] || [ "$patchName" = "POEG" ]; then
		namesOut="C11 N C12 HN2 O12 O13 P HN1 O14 O11 H12W H12V HN3 H11V H11W H12A H12B H11A H11B"
	else
		echo "I don't know how to handle $1 yet."
		exit 1
	fi
	
	#return $namesOut
}

#Build the TCL for patching
function buildTCL {
	local fout=$1
	local commonPath=$2
	local seg=$3
	local resid=$4
	local patchName=$5
	local prefin=$6
	local prefout=$7

	parse_patch $patchName
	
	#Make the tcl script
	echo "" > $fout
	echo "source $commonPath/patch_script.tcl" >> $fout
	echo "set res $resid" >> $fout
	echo "set seg $seg" >> $fout
	echo "set patch $patchName" >> $fout
	echo "set prefin $prefixin" >> $fout
	echo "set prefout $prefout" >> $fout
	echo "set namesOut {$namesOut}" >> $fout
	echo "set commonPath $commonPath" >> $fout
	echo "main \$seg \$res \$patch \$prefin \$prefout \$namesOut \$commonPath" >> $fout
}
