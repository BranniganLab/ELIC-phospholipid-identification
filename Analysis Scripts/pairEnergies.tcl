proc extractPair {seltext1 seltext2 oName} {
	#set keep [atomselect top "(protein and resid 308 and segname PROA) or (resname POEG and beta 0 1)"]
	set keep [atomselect top "($seltext1) or ($seltext2)"]

	animate write dcd $oName.dcd sel $keep top

	set sellist {}
	lappend sellist $keep
	::TopoTools::selections2mol $sellist

	animate write psf $oName.psf
}

proc getPairEnergies {seltext1 seltext2 oName} {
	set sel1 [atomselect top $seltext1]
	set sel2 [atomselect top $seltext2]
	set parpath /home/ems363/toppar
	namdenergy -sel $sel1 $sel2 -vdw -elec -nonb -ofile $oName -par $parpath/par_all36_carb.prm -par $parpath/par_all36_cgenff.prm -par $parpath/par_all36_lipid.prm -par $parpath/par_all36m_prot.prm -par $parpath/par_all36_na.prm $parpath/toppar_water_ions.str

}

proc doProcess {POXY PXtoPY midfix postfix seg id PX alch} {
	set rname [string toupper $POXY]
	mol load psf prod$POXY.psf pdb starting.$POXY.fep
	mol addfile $PXtoPY$midfix$postfix.dcd waitfor all
	animate delete beg 0 end 0 skip 0 top
	mol rename top "$rname.$PX"
	
	set oName "$rname.$PX.$id"
	extractPair "resname $rname and beta 0 $alch" "segname $seg and resid $id" $oName
	mol new $oName.psf
	mol addfile $oName.dcd waitfor all
	
	getPairEnergies "resname $rname" "segname $seg and resid $id" $rname.$PX.$id.dat
}


