#Double dollars are the escape sequence in the template file.
source foo/bar/patch_script.tcl
set res 69
set prefin POPC
set prefout POPC_69
set commonPath foo/bar

#deletes all, and opens prefin.psf and prefin.pdb
cleanSlate $prefin $commonPath nan
set sel [atomselect top "segname MEMB and resid $res"]
$sel set beta "-1"
update CV 1
animate write psf $prefout.fep.psf
animate write pdb $prefout.fep.pdb