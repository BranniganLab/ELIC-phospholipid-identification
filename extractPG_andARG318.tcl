set keep [atomselect top "(protein and resid 308 and segname PROA) or (resname POEG and name H3AM H3BM C13M OC3M HO3M H2AM C12M OC2M HO2M H1AM C11M H1BM O13M O12M PM O14M O11M)"]

animate write dcd PGandARG.dcd sel $keep top

set sellist {}
lappend sellist $keep
::TopoTools::selections2mol $sellist

animate write psf PGandARG.psf

mol new PGandARG.psf
mol addfile PGandARG.dcd
