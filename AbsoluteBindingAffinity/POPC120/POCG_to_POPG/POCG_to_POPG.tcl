source ../../common//patch_script.tcl
cleanSlate POCG_1/POCG_1 ../../common/ POCG_to_POPG.rtf
depatch POCG CGPG POPG_1 POPG
mol new POPG_1.psf
mol addfile POPG_1.pdb
