package require topotools
package require psfgen
package require alchemify 

proc cleanSlate {prefix commonPath keyRTF} {
	mol delete all
	resetpsf
	psfcontext reset

	topology $commonPath/toppar/top_all36_lipid.rtf
	topology $commonPath/POPC_to_POCE.rtf
	topology $commonPath/POPC_to_POCG.rtf
	topology $commonPath/POPG_to_POGE.rtf
	catch {topology $commonPath/$keyRTF} 	
	mol load psf $prefix.psf pdb $prefix.pdb
	
	readpsf $prefix.psf
	coordpdb $prefix.pdb
}

proc depatch {dualName depatchName prefixout monoName} {
	set debug 1
	puts "Depatching top molecule resname $dualName..."
	set sel [atomselect top "resname $dualName"]
	if {$debug == 1 } {puts [$sel num]}
	set sn [lindex [$sel get segname] 0]
	if {$debug == 1 } {puts "Segname: $sn"}
	set rid [lindex [$sel get resid] 0]
	if {$debug == 1 } {puts "Resid: $rid"}
	$sel set resname $monoName
	
	patch $depatchName $sn:$rid
	regenerate angles dihedrals
	writepsf $prefixout.psf
	writepdb $prefixout.pdb
	puts "Files saved"
}

proc mutateResidue {the_resid patchName prefixout} {
	set debug 1
	
	#Rename the target lipid
	if {$debug == 1 } {puts "Rename..."}
	set sel [atomselect top "segname MEMB and resid $the_resid"]
	$sel set resname $patchName
	mol delrep 0 top
	
	if {$debug == 1 } {puts "Animate write..."}
	animate write psf $prefixout.psf
	animate write pdb $prefixout.pdb

	#Read in the renamed structure
	readpsf $prefixout.psf
	coordpdb $prefixout.pdb

	#do patch
	if {$debug == 1 } {puts "do patch..."}
	patch $patchName MEMB:$the_resid
	if {$debug == 1 } {puts "Guess coords..."}
	guesscoord
	if {$debug == 1 } {puts "regenerate angles dihedrals..."}
	regenerate angles dihedrals
	
	if {$debug == 1 } {puts "write patched files..."}
	writepsf $prefixout.psf
	writepdb $prefixout.pdb
}

#Alchemify
#C namesOut: C15 H15A H15B H15C C14 H14A H14B H14C C13 H13B H13A H13C N H12B C12 H12A H11B C11 H11A O12 P O14 O13 O11
#G namesOut:
#E namesOut:
proc doAlch {patchName prefixout namesOut} {
	set debug 1
	if { $debug == 1 } { puts "line 32" }
 	set alchin [atomselect top "resname $patchName and occupancy 0 '-1'"] ;#Take advantage of the fact that guessed coordinates have occ=0
	$alchin set beta 1
	set alchout [atomselect top "resname $patchName and name $namesOut"]
	$alchout set beta -1
	if { $debug == 1 } { puts "line 37" }
	animate write pdb $prefixout.fep.pdb
	alchemify $prefixout.psf $prefixout.fep.psf $prefixout.fep.pdb
	if { $debug == 1 } { puts "line 40" }
}

proc main {res patch prefixin prefixout namesOut commonPath} {
	set debug 1
	cleanSlate $prefixin $commonPath nan
	
	if {$debug == 1 } {puts "Mutate residue..."}
	mutateResidue $res $patch $prefixout
	if {$debug == 1 } {puts "Mutated\n Open files"}
	mol new $prefixout.psf
	mol addfile $prefixout.pdb
	mol delrep 0 top 
	mol selection "resname $patch"
	mol addrep top
	
	mol representation vdw
	mol color ColorID 0
	mol selection "resname $patch and beta=-1"
	mol addrep top
	
	mol color ColorID 1
	mol selection "resname $patch and beta 1"
	mol addrep top
	
	if {$debug == 1 } {puts "doAlch..."}
	doAlch $patch $prefixout $namesOut
	if {$debug == 1 } {puts "Alch done.\nUpdate colvars"}
	
	package require cv_dashboard
	set confFile "./${patch}_${res}/zrestraint.${patch}_${res}.colvars"
	set in [open $confFile r]
	set cfg [read -nonewline $in]
	close $in
	set ::cv_dashboard::mol top
	set newcfg [::cv_dashboard::substitute_atomselects $cfg]
	set out [open $confFile w]
	puts $out $newcfg
	close $out
	if {$debug == 1 } {puts "Colvars updated"}
}



