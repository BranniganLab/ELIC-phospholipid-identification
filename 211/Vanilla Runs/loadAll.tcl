proc loadOne {prefix} {
	mol new $prefix.psf
	mol delrep 0 top
	mol addfile ${prefix}1.dcd
	
	mol representation NewCartoon
	mol selection protein
	mol addrep top
}

loadOne prodpopc
loadOne prodpopg
loadOne prodpope

