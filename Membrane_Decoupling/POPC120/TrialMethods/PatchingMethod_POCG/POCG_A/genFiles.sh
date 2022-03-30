#!/bin/bash

prefix="POCG_A"
SN="CGA"
templatePath="../../InputsTemplate/TEMPLATE"
cp $templatePath/zrestraint.TEMPLATE.colvars ./zrestraint.$prefix.colvars

sed "s/TEMPLATE/$prefix/g" $templatePath/starting.TEMPLATE.namd > starting.$prefix.namd

sed "s/TEMPLATE/$prefix/g" $templatePath/runEQ.sh > runEQ.sh
sed "s/SHORTNAME/$SN/g"	  ./runEQ.sh > tmp.sh
mv tmp.sh runEQ.sh

sed "s/TEMPLATE/$prefix/g" $templatePath/do_run_TEMPLATE.sh > do_run_$prefix.sh
sed "s/SHORTNAME/$SN/g"	  ./do_run_$prefix.sh > tmp.sh
mv tmp.sh do_run_$prefix.sh

sed "s/TEMPLATE/$prefix/g" $templatePath/config_TEMPLATE.yaml > config_$prefix.yaml

sed "s/TEMPLATE/$prefix/g" $templatePath/common_TEMPLATE.namd > common_$prefix.namd
