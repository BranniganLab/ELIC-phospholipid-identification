proc extractPair {seltext1 seltext2 oName} {
	#set keep [atomselect top "(protein and resid 308 and segname PROA) or (resname POEG and beta 0 1)"]
	set keep [atomselect top "($seltext1) or ($seltext2)"]

	animate write dcd $oName.dcd sel $keep top

	set sellist {}
	lappend sellist $keep
	::TopoTools::selections2mol $sellist

	animate write psf $oName.psf

	mol new $oName.psf
	mol addfile $oName.dcd
}

proc getPairEnergies {seltext1 seltext2 oName} {
	set sel1 [atomselect top $seltext1]
	set sel2 [atomselect top $seltext2]
	
	namdenergy -sel $sel1 $sel2 -vdw -elec -nonb -ofile $oName -par ~/toppar/par_all36_carb.prm -par ~/toppar/par_all36_cgenff.prm -par ~/toppar/par_all36_lipid.prm -par ~/toppar/par_all36m_prot.prm

}
