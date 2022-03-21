mol delete all
mol new prodpopc.psf
mol addfile rest_ref.popc_glycerol_10Av3.pdb

set segA [atomselect top "segid PROA"]
$segA set chain A
set segA [atomselect top "segid PROB"]
$segA set chain B
set segA [atomselect top "segid PROC"]
$segA set chain C
set segA [atomselect top "segid PROD"]
$segA set chain D
set segA [atomselect top "segid PROE"]
$segA set chain E


package require topotools
set sel [atomselect top protein]
set dry [::TopoTools::selections2mol $sel]
animate write psf 5mut_dry.psf $dry
animate write pdb 5mut_dry.pdb $dry
