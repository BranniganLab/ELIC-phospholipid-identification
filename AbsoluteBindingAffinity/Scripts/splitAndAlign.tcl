package require topotools
source ~/Documents/Utilities/NAMD_Trajectories/namd_extract.tcl

proc extractChainAndLipids {sname cutoff} {
	set seltext "(segname $sname) or (lipid and same residue as within $cutoff of segname $sname)"
	namd_extract top $seltext ./Splits/$sname
}

extractChainAndLipids PROA 5
extractChainAndLipids PROB 5
extractChainAndLipids PROC 5
extractChainAndLipids PROD 5
extractChainAndLipids PROE 5

mol new ./Splits/PROA.psf
mol addfile ./Splits/PROA.dcd waitfor all

mol new ./Splits/PROB.psf
mol addfile ./Splits/PROB.dcd waitfor all

mol new ./Splits/PROC.psf
mol addfile ./Splits/PROC.dcd waitfor all

mol new ./Splits/PROD.psf
mol addfile ./Splits/PROD.dcd waitfor all

mol new ./Splits/PROE.psf
mol addfile ./Splits/PROE.dcd waitfor all
