
source ../../../common/patch_script.tcl
set res 104
set patch POEG
set prefin PCPGPE
set prefout POEG_104
set namesOut {C11 N C12 HN2 O12 O13 P HN1 O14 O11 H12W H12V HN3 H11V H11W}
set commonPath ../../../common
main $res $patch $prefin $prefout $namesOut $commonPath
