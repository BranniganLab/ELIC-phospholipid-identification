
source ../../common/patch_script.tcl
set res 51
set prefin membrane
set prefout POPG_51
set commonPath ../../common
cleanSlate $prefin $commonPath nan
set sel [atomselect top "segname MEMB and resid $res"]
$sel set beta "-1"
update CV 1
animate write psf $prefout.fep.psf
animate write pdb $prefout.fep.pdb
