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
	topology $commonPath/POPE_to_POEG.rtf
	topology $commonPath/POEG_to_POPE.rtf
	topology $commonPath/POEG_to_POPG.rtf
	topology $commonPath/POPG_to_POCG.rtf
	catch {topology $commonPath/$keyRTF} 	
	mol load psf $prefix.psf pdb $prefix.pdb
	
	resetpsf
	readpsf $prefix.psf
	coordpdb $prefix.pdb
}

proc depatch {dualName depatchName prefixout monoName commonPath keyRTF debug} {
	puts "Depatching top molecule resname $dualName..."
	set sel [atomselect top "resname $dualName"]
	if {$debug == 1 } {puts [$sel num]}
	set sn [lindex [$sel get segname] 0]
	if {$debug == 1 } {puts "Segname: $sn"}
	set rid [lindex [$sel get resid] 0]
	if {$debug == 1 } {puts "Resid: $rid"}
	
	patch $depatchName $sn:$rid
	regenerate angles dihedrals
	writepsf $prefixout.psf
	writepdb $prefixout.pdb
	puts "Files saved"
	
	mol delete all
	mol new $prefixout.psf
	mol addfile $prefixout.pdb
	
	RENAme $commonPath $keyRTF $dualName
	set sel [atomselect top "resname $dualName"]
	$sel set resname $monoName
	
	animate write psf $prefixout.psf
	animate write pdb $prefixout.pdb
	mol delete all
}

proc RENAme {commonPath keyRTF resname} { 
	set fp [open "$commonPath/$keyRTF" r]
	set file_data [read $fp]
	close $fp

	#  Process data file
	set data [split $file_data "\n"]
	foreach line $data {
	     set splitLine [regexp -all -inline {\S+} $line]
	     if {[lindex $splitLine 0]=="RENA"} {
	     	set to [lindex $splitLine 2]
	     	set from [lindex $splitLine 3]
	     	
	     	puts "renaming $from to $to"
	     	set sel [atomselect top "resname $resname and name $from"]
	     	puts [$sel num]
	     	$sel set name $to
	     	$sel delete
	     }
	}
}

proc mutateResidue {the_seg the_resid patchName prefixout debug} {
	#Rename the target lipid
	if {$debug == 1 } {puts "Rename..."}
	set sel [atomselect top "segname $the_seg and resid $the_resid"]
	$sel set resname $patchName
	mol delrep 0 top
	
	if {$debug == 1 } {puts "Animate write..."}
	animate write psf $prefixout.psf
	animate write pdb $prefixout.pdb
	
	resetpsf
	#Read in the renamed structure
	readpsf $prefixout.psf
	coordpdb $prefixout.pdb

	#do patch
	if {$debug == 1 } {puts "do patch..."}
	patch $patchName $the_seg:$the_resid
	
	#Force the incoming O11 to overlap the outgoing O11
	set O12 [atomselect top "segname $the_seg and resid $the_resid and name O12"]
	set XYZ "[$O12 get x] [$O12 get y] [$O12 get z]"
	psfset coord $the_seg $the_resid O12M $XYZ
	$O12 delete
	
	set O11 [atomselect top "segname $the_seg and resid $the_resid and name O11"]
	set XYZ "[$O11 get x] [$O11 get y] [$O11 get z]"
	psfset coord $the_seg $the_resid O11M $XYZ
	$O11 delete
	
	#set C11 [atomselect top "segname MEMB and resid $the_resid and name C11"]
	#set XYZ "[$C11 get x] [$C11 get y] [$C11 get z]"
	#psfset coord MEMB $the_resid C11M $XYZ
	#$C11 delete
	
	#animate write pdb temp.pdb
	#writepsf temp.psf
	
	#resetpsf
	#readpsf temp.psf
	#coordpdb temp.pdb
	
	
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
proc doAlch {patchName prefixout namesOut debug} {
	if { $debug == 1 } { puts "line 32" }
 	set alchin [atomselect top "resname $patchName and (occupancy 0 '-1' or name O11M O12M)"] ;#Take advantage of the fact that guessed coordinates have occ=0
	$alchin set beta 1
	set alchout [atomselect top "resname $patchName and name $namesOut"]
	$alchout set beta -1
	if { $debug == 1 } { puts "line 37" }
	animate write pdb $prefixout.fep.pdb
	alchemify $prefixout.psf $prefixout.fep.psf $prefixout.fep.pdb
	if { $debug == 1 } { puts "line 40" }
}

proc updateCV {debug} {
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

proc main {seg res patch prefixin prefixout namesOut commonPath} {
	set debug 1
	cleanSlate $prefixin $commonPath nan
	
	if {$debug == 1 } {puts "Mutate residue..."}
	mutateResidue $seg $res $patch $prefixout $debug
	if {$debug == 1 } {puts "Mutated\n Open files"}
	mol new $prefixout.psf
	mol addfile $prefixout.pdb
	mol delrep 0 top 
	
	mol representation licorice
	mol selection "resname $patch"
	mol addrep top
	
	mol color ColorID 0
	mol selection "resname $patch and beta=-1"
	mol addrep top
	
	mol color ColorID 1
	mol selection "resname $patch and beta 1"
	mol addrep top
	
	if {$debug == 1 } {puts "doAlch..."}
	doAlch $patch $prefixout $namesOut $debug
	if {$debug == 1 } {puts "Alch done.\nUpdate colvars"}
	
	updateCV $debug
	
}



