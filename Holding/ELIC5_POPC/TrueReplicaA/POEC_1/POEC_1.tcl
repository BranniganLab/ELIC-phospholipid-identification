
source /home/ems363/Documents/ELIC/common/patch_script.tcl
set res 1
set seg HETA
set patch POEC
set prefin POPE
set prefout POEC_1
set namesOut {C11 N C12 HN2 O12 O13 P HN1 O14 O11 H12W H12V HN3 H11V H11W H12A H12B H11A H11B}
set commonPath /home/ems363/Documents/ELIC/common
main $seg $res $patch $prefin $prefout $namesOut $commonPath
