source /home/ems363/Documents/ELIC/common/patch_script.tcl
cleanSlate POEG_1/POEG_1 /home/ems363/Documents/ELIC/common /home/ems363/Documents/ELIC/common/_to_POPG.rtf
depatch /home/ems363/Documents/ELIC/common/ n/PG POPG_1 POPG /home/ems363/Documents/ELIC/common /home/ems363/Documents/ELIC/common/_to_POPG.rtf 1
mol new POPG_1.psf
mol addfile POPG_1.pdb
