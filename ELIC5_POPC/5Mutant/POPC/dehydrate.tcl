mol delete all
mol new prodpopc.psf
mol addfile rest_ref.popc_glycerol_10Av3.pdb

package require topotools
set prot [atomselect top protein]
set dryprot [::TopoTools::selections2mol $prot]
animate write psf dryELIC.psf $dryprot
animate write pdb dryELIC.pdb $dryprot

source rechain.tcl