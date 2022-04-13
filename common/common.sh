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

function parse_patch {
	local patchName=$1
	
	if [ "$patchName" = "POCE" ] || [ "$patchName" = "POCG" ]; then
		namesOut="C15 H15A H15B H15C C14 H14A H14B H14C C13 H13B H13A H13C N H12B C12 H12A H11B C11 H11A O12 P O14 O13 O11"
	elif [ "$patchName" = "POGE" ] || [ "$patchName" = "POGC" ]; then
		namesOut="O11 P O13 O14 O12 C11 H11B H11A H12A C12 OC2 HO2 C13 H13A H13B OC3 HO3"
	else
		echo "I don't know how to handle $2 yet."
		exit 1
	fi
	
	#return $namesOut
}

function buildTCL {
	local fout=$1
	local commonPath=$2
	local resid=$3
	local patchName=$4
	local prefin=$5
	local prefout=$6

	parse_patch $patchName
	
	#Make the tcl script
	echo "" > $fout
	echo "source $commonPath/patch_script.tcl" >> $fout
	echo "set res $resid" >> $fout
	echo "set patch $patchName" >> $fout
	echo "set prefin $prefixin" >> $fout
	echo "set prefout $prefout" >> $fout
	echo "set namesOut {$namesOut}" >> $fout
	echo "set commonPath $commonPath" >> $fout
	echo "main \$res \$patch \$prefin \$prefout \$namesOut \$commonPath" >> $fout
}
