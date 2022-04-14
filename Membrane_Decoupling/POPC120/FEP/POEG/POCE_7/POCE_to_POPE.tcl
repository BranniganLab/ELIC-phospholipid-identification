source ../../../../../common/patch_script.tcl
cleanSlate POCE_7/POCE_7 ../../../../../common POCE_to_POPE.rtf
depatch POCE CEPE POPE_7 POPE ../../../../../common POCE_to_POPE.rtf 1
mol new POPE_7.psf
mol addfile POPE_7.pdb
