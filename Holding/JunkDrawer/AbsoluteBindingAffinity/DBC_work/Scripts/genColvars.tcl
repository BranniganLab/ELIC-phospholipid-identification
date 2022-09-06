proc genAllColvars {iname oname seltext mol} {
	set lips [atomselect $mol $seltext]
	set resids [$lips get resid]

	set fp [open $oname a+]
	set template [open $iname r]
	set tempVar [read $template]
	foreach res $resids {
		set newVar [regsub -all {TEMPLATE} $tempVar $res]
		puts $fp "\n\n"
		puts $fp $newVar
	}

	close $fp
	close $template

	$lips delete
}


