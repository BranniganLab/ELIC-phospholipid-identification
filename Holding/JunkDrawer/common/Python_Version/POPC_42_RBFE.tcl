source foo/bar/patch_script.tcl
set res 42
set seg MEMB
set patch POCE
set prefin POPC120
set prefout POPC_42_RBFE
set namesOut {C15 H15A H15B H15C C14 H14A H14B H14C C13 H13B H13A H13C N H12B C12 H12A H11B C11 H11A O12 P O14 O13 O11}
set commonPath foo/bar
main $seg $res $patch $prefin $prefout $namesOut $commonPath