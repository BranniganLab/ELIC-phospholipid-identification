#!/bin/bash

#Arguments:
# 1:resid to mutate
# 2:patch name (as found in the topology file)
# 3:name of the input prefix ("PCPG31")
# 4:path to common directory

commonPath="$4"
affix="$2_$1"
pref="$affix"

fout="$affix.tcl"

if [ "$2" = "POCE" ] || [ "$2" = "POCG" ]; then
	namesOut="C15 H15A H15B H15C C14 H14A H14B H14C C13 H13B H13A H13C N H12B C12 H12A H11B C11 H11A O12 P O14 O13 O11"
else
	echo "I don't know how to handle $2 yet."
	exit 1
fi

#Make the directory and accompanying files
mkdir $affix


sed "s/TEMPLATE/$1/g" ./TEMPLATE/zrestraint.TEMPLATE.colvars > ./$affix/zrestraint.$affix.colvars
sed "s/TEMPLATE/$affix/g" ./TEMPLATE/starting.TEMPLATE.namd > ./$affix/starting.$affix.namd
sed "s/TEMPLATE/$affix/g" ./TEMPLATE/runEQ.sh > ./$affix/runEQ.sh
sed "s/TEMPLATE/$affix/g" ./TEMPLATE/do_run_TEMPLATE.sh > ./$affix/do_run_$affix.sh
sed "s/TEMPLATE/$affix/g" ./TEMPLATE/config_TEMPLATE.yaml > ./$affix/config_$affix.yaml
sed "s/TEMPLATE/$affix/g" ./TEMPLATE/common_TEMPLATE.namd > ./$affix/common_$affix.namd

cd $affix
mkdir restraints
cd ..

#Make the tcl script
echo "" > $fout
echo "source $commonPath/patch_script.tcl" >> $fout
echo "set res $1" >> $fout
echo "set patch $2" >> $fout
echo "set prefin $3" >> $fout
echo "set prefout $pref" >> $fout
echo "set namesOut {$namesOut}" >> $fout
echo "set commonPath $commonPath" >> $fout
echo "main \$res \$patch \$prefin \$prefout \$namesOut \$commonPath" >> $fout
#echo "package require cv_dashboard" >> $fout

#It would be nice to do this programmatically, but reading from the command line doesn't update autoselections
#echo "cv configfile ./$affix/zrestraint.$affix.colvars" >> $fout
#echo "cv_dashboard" >> $fout
#echo "set cfg [::cv_dashboard::substitute_atomselects ./$affix/zrestraint.$affix.colvars]" >> $fout
#echo "::cv_dashboard::save" >> $fout
#echo "exit" >> $fout

#Execute the tcl script
#vmd -dispdev none -e $fout
vmd -e $fout

#Cleanup and organize
tail -n +2 ./$affix/zrestraint.$affix.colvars > ./$affix/temp.colvars
mv ./$affix/temp.colvars ./$affix/zrestraint.$affix.colvars
mv $pref* ./$affix

