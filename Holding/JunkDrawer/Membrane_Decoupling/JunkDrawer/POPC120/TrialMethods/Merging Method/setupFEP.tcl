proc loadMols { from to } {
	mol delete all
	
	#Build the desired membrane on CHARMM-GUI making sure to leave space in one leaflet for the fep lipid.
	mol new existing.psf
	mol addfile existing.pdb
	set mem [atomselect top all]

	#Extract the fep lipid
	mol new prodpo${from}${to}.psf
	mol addfile prodpo${from}${to}.pdb
	set fep [atomselect top "same residue as name PM"] ;# current naming convention for mutating head groups.
	
	puts "Systems loaded. Position the fep lipid appropriately and run mergeMols"
}

proc mergeMols { from to } {
	#combine them into a single file
	set sellist {}
	lappend sellist $fep
	lappend sellist $mem
	::TopoTools::selections2mol $sellist

	animate write psf po${from}${to}_large.psf
	animate write pdb po${from}${to}_large.pdb
	
	mol new po${from}${to}_large.psf
	mol addfile po${from}${to}_large.pdb
}


