#Double dollars are the escape sequence in the template file.
source $common_path/patch_script.tcl
set res $resid
set prefin $prefix_in
set prefout $prefix_out
set commonPath $common_path

#deletes all, and opens prefin.psf and prefin.pdb
cleanSlate $$prefin $$commonPath nan
set sel [atomselect top "segname MEMB and resid $$res"]
$$sel set beta "-1"
update CV 1
animate write psf $$prefout.fep.psf
animate write pdb $$prefout.fep.pdb