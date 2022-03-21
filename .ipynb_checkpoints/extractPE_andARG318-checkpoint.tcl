set keep [atomselect top "(protein and resid 308 and segname PROA) or (resname POEG and name N HN1 HN2 HN3 C12 H12A H12B C11 H11A H11B P O13 O14 O11 O12)"]

animate write dcd PEandARG.dcd sel $keep top

set sellist {}
lappend sellist $keep
::TopoTools::selections2mol $sellist

animate write psf PEandARG.psf

mol new PEandARG.psf
mol addfile PEandARG.dcd
