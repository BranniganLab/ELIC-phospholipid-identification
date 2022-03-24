mol delete all
mol new dryELIC.psf
mol addfile dryELIC.pdb

set chainA [atomselect top "segid PROA"]
$chainA set chain A 
set chainA [atomselect top "segid PROB"]
$chainA set chain B 
set chainA [atomselect top "segid PROC"]
$chainA set chain C
set chainA [atomselect top "segid PROD"]
$chainA set chain D
set chainA [atomselect top "segid PROE"]
$chainA set chain E

set sel [atomselect top all]
$sel writepsf dryELIC.psf
$sel writepdb dryELIC.pdb 