
source ../../common/patch_script.tcl
set res 10
set patch POGE
set prefin PCPG31
set prefout POGE_10
set namesOut {O11 P O13 O14 O12 C11 H11B H11A H12A C12 OC2 HO2 C13 H13A H13B OC3 HO3}
set commonPath ../../common
main $res $patch $prefin $prefout $namesOut $commonPath
