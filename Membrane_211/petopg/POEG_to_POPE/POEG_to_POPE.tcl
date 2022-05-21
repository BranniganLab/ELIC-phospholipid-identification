source ../../common/patch_script.tcl
cleanSlate prodpoeg/prodpoeg ../../common POEG_to_POPE.rtf
depatch POEG EGPE POPE_g POPE ../../common POEG_to_POPE.rtf 1
mol new POPE_g.psf
mol addfile POPE_g.pdb
