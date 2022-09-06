proc loadTrajectories { from to lastTraj } {
	set struct "prodpo$from$to"
	set prefix "p${from}top${to}"
	
	foreach rep { A B C D } {
		mol new ./$prefix/$struct.psf
		mol rename top "${prefix}_${rep}"
		for {set L 0} {$L <= $lastTraj} {incr L} {
			foreach resum { "" a b c } {
				catch { mol addfile ${prefix}/replica${rep}/${prefix}${rep}[format %03s $L]${resum}.dcd }
				catch { mol addfile ${prefix}/replica${rep}/${prefix}[format %03s $L]${resum}.dcd }
			}
		}
	}
}


