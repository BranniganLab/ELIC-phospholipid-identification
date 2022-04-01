
#Call: depatch prefixin prefixout commonPath dualName depatchName
proc depatch {prefixin prefixout commonPath dualName depatchName rtf} {
	source $commonPath/patch_script.tcl
	cleanSlate $prefixin $commonPath $rtf
	depatch $dualName $depatchName $prefixout
}
