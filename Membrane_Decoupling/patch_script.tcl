package require topotools
package require psfgen
package require alchemify 

mol delete all
resetpsf

topology test.rtf
topology ../toppar/top_all36_lipid.rtf

mol load psf POPC120.psf pdb POPC120.pdb
set sel [atomselect top "lipid and resid 5"]
$sel set resname "POCE"

animate write psf new.psf
animate write pdb new.pdb

readpsf new.psf
coordpdb new.pdb

patch POCE MEMB:5
#guesscoord

writepsf new.psf
writepdb new.pdb

mol delete all
mol new new.psf
mol addfile new.pdb


#Alchemify
set reset [atomselect top all]
$reset set beta 0
set alchin [atomselect top "resname POCE and name HN1M HN2M HN3M NM H12V C12M H12W H11W C11M H11V O12M PM O14M O13M O11M"]
$alchin set beta 1
set alchout [atomselect top "resname POCE and name C15 H15A H15B H15C C14 H14A H14B H14C C13 H13B H13A H13C N H12B C12 H12A H11B C11 H11A O12 P O14 O13 O11"]
$alchout set beta -1
animate write pdb new.fep.pdb

alchemify new.psf new.fep.psf new.fep.pdb

mol delete all
resetpsf

readpsf new.fep.psf
coordpdb new.fep.pdb
mol new new.fep.psf
mol addfile new.fep.pdb
guesscoord

return

writepsf new.guessed.psf
writepdb new.guessed.pdb
mol new new.guessed.psf
mol addfile new.guessed.pdb
