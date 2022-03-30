
source patch_script.tcl
set res 14
set patch POCG
set prefin PCPG31
set prefout POCG_14
set namesOut {C15 H15A H15B H15C C14 H14A H14B H14C C13 H13B H13A H13C N H12B C12 H12A H11B C11 H11A O12 P O14 O13 O11}
main $res $patch $prefin $prefout $namesOut
package require cv_dashboard
cv_dashboard
