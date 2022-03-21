package require topotools
package require psfgen

mol delete all
resetpsf

topology test.rtf
topology toppar/top_all36_lipid.rtf

mol load psf POPC120.psf pdb POPC120.pdb
set sel [atomselect top "lipid and resid 5"]
$sel set resname "POCE"

animate write psf new.psf
animate write pdb new.pdb

readpsf new.psf
coordpdb new.pdb

patch POCE MEMB:5
guesscoord

writepsf new.psf
writepdb new.pdb

#mol delete all
mol new new.psf
mol addfile new.pdb
