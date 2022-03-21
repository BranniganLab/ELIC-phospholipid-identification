package require topotools
package require psfgen
package require alchemify 

#Clean slate
mol delete all
resetpsf
psfcontext reset

topology ../toppar/top_all36_lipid.rtf
topology test.rtf


proc mutateResidue {the_resid patchName prefixin prefixout} {
	#Rename the target lipid
	mol load psf $prefixin.psf pdb $prefixin.pdb
	set sel [atomselect top "lipid and resid $the_resid"]
	$sel set resname $patchName
	mol delrep 0 top

	animate write psf $prefixout.psf
	animate write pdb $prefixout.pdb

	#Read in the renamed structure
	readpsf $prefixout.psf
	coordpdb $prefixout.pdb

	#do patch
	patch $patchName MEMB:$the_resid
	guesscoord
	writepsf $prefixout.psf
	writepdb $prefixout.pdb

	mol new $prefixout.psf
	mol addfile $prefixout.pdb
	mol delrep 0 top 
	mol selection "resname $patchName"
	mol addrep top
}

#Alchemify
proc doAlch {patchName prefixout} {
	set alchin [atomselect top "occupancy 0"] ;#Take advantage of the fact that guessed coordinates have occ=0
	$alchin set beta 1
	set alchout [atomselect top "resname $patchName and name C15 H15A H15B H15C C14 H14A H14B H14C C13 H13B H13A H13C N H12B C12 H12A H11B C11 H11A O12 P O14 O13 O11"]
	$alchout set beta -1

	animate write pdb $prefixout.fep.pdb
	alchemify $prefixout.psf $prefixout.fep.psf $prefixout.fep.pdb
}

