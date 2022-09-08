# ELIC-phospholipid-identification
Data and Analyses related to "Structural mechanism of leaflet-specific phospholipid modulation of a pentameric ligand-gated ion channel". 
Results in preprint (bioRxiv) 2022. 
doi: https://doi.org/10.1101/2022.06.07.494883

## This repository contains:
- System generation scripts
- Run scripts for NAMD (Note: we made use of relentlessfep.py to generate config files)
- Analysis scripts
- Initial conditions for each system
- Parameter and topology files
- NAMD FEP outputs for each system (not shown below for brevity)

# File Structure:
In directories with names of the form "POCE_34": "POCE" means the transformation is from PC to PE, "34" refers to the resid of the lipid being transformed.
```
.
├── common
│   ├── analysis_scripts_and_notebooks
│   │   ├── AFEP_parse.py
│   │   ├── binding in a ternary mixture.pdf
│   │   ├── ELIC5_PG_Titration_Ternary.png
│   │   ├── ELIC conformational modulation by lipid binding.ipynb
│   │   ├── Figures
│   │   │   ├── ELIC5_PG_Titration_Ternary.png
│   │   │   ├── logloglog_pE5.png
│   │   │   ├── log_pE5.png
│   │   │   ├── OccupancyFraction.png
│   │   │   ├── PG_titration.png
│   │   │   └── WT_PG_Titration_Ternary.png
│   │   ├── GenMembraneFigures.ipynb
│   │   ├── GenProteinFigures.ipynb
│   │   ├── helpers.py
│   │   ├── logloglog_pE5.png
│   │   ├── log_pE5.png
│   │   ├── OccupancyFraction.png
│   │   ├── PG_titration.png
│   │   ├── splitGroups.sh
│   │   ├── splitReplicas.sh
│   │   └── WT_PG_Titration_Ternary.png
│   ├── CHARMM_Parameters
│   │   ├── c36_lipid_alchemy.rtf
│   │   ├── chipot_cation_pi_2020_expanded_20211112.prm
│   │   └── [Other CHARMM36m parameters]
│   ├── README.md
│   ├── system_generation_scripts
│   │   ├── common.sh
│   │   ├── depatch_script.tcl
│   │   ├── makeAlchemy.sh
│   │   ├── patches
│   │   │   ├── POCE_to_POPE.rtf
│   │   │   ├── POCG_to_POPG.rtf
│   │   │   ├── POEG_to_POPE.rtf
│   │   │   ├── POEG_to_POPG.rtf
│   │   │   ├── POPC_to_POCE.rtf
│   │   │   ├── POPC_to_POCG.rtf
│   │   │   ├── POPE_to_POEC.rtf
│   │   │   ├── POPE_to_POEG.rtf
│   │   │   ├── POPG_to_POCG.rtf
│   │   │   └── POPG_to_POGE.rtf
│   │   ├── patch_script.tcl
│   │   ├── procedure.md
│   │   ├── sample_TEMPLATE
│   │   │   ├── common_TEMPLATE.namd
│   │   │   ├── config_TEMPLATE.yaml
│   │   │   ├── do_run_TEMPLATE.sh
│   │   │   ├── runEQ.sh
│   │   │   ├── starting.POCE.namd~
│   │   │   ├── starting.TEMPLATE.namd
│   │   │   └── zrestraint.TEMPLATE.colvars
│   │   └── unAlchemize.sh
│   └── system_running_scripts
│       └── relentless_fep.py
├── membrane_systems
│   ├── 2PC_1PG_1PE
│   │   ├── convergence.csv
│   │   ├── cumulatives.csv
│   │   ├── keyColors.csv
│   │   ├── metadata.txt
│   │   ├── PC_to_PE
│   │   │   ├── PC_to_PE_111
│   │   │   ├── PC_to_PE_32
│   │   │   ├── PC_to_PE_69
│   │   │   ├── PC_to_PE_84
│   │   │   ├── PC_to_PE_9
│   │   │   ├── POCE_111
│   │   │   ├── POCE_32
│   │   │   ├── POCE_69
│   │   │   ├── POCE_84
│   │   │   └── POCE_9
│   │   ├── PC_to_PG
│   │   │   ├── PC_to_PG_115
│   │   │   ├── PC_to_PG_22
│   │   │   ├── PC_to_PG_5
│   │   │   ├── PC_to_PG_62
│   │   │   ├── PC_to_PG_95
│   │   │   ├── POCG_115
│   │   │   ├── POCG_22
│   │   │   ├── POCG_5
│   │   │   ├── POCG_62
│   │   │   └── POCG_95
│   │   ├── perWindow.csv
│   │   └── PE_to_PG
│   │       ├── PE_to_PG_1
│   │       ├── PE_to_PG_104
│   │       ├── PE_to_PG_18
│   │       ├── PE_to_PG_47
│   │       ├── PE_to_PG_71
│   │       ├── POEG_1
│   │       ├── POEG_104
│   │       ├── POEG_18
│   │       ├── POEG_47
│   │       └── POEG_71
│   ├── 3PC_1PG
│   │   ├── convergence.csv
│   │   ├── cumulatives.csv
│   │   ├── keyColors.csv
│   │   ├── metadata.txt
│   │   ├── PC_to_PE
│   │   │   ├── POCE_1
│   │   │   ├── POCE_18
│   │   │   ├── POCE_40
│   │   │   ├── POCE_56
│   │   │   └── POCE_90
│   │   ├── PC_to_PG
│   │   │   ├── POCG_26
│   │   │   ├── POCG_48
│   │   │   ├── POCG_5
│   │   │   ├── POCG_64
│   │   │   └── POCG_99
│   │   ├── perWindow.csv
│   │   └── PG_to_PE
│   │       ├── POGE_10
│   │       ├── POGE_102
│   │       ├── POGE_117
│   │       ├── POGE_32
│   │       └── POGE_72
│   ├── DRAFT_S1.pdf
│   ├── DRAFT_S2.pdf
│   ├── DRAFT_S3.pdf
│   ├── DRAFT_S4.pdf
│   └── POPC
│       ├── convergence.csv
│       ├── cumulatives.csv
│       ├── keyColors.csv
│       ├── metadata.txt
│       ├── PC_to_PE
│       │   ├── POCE_120
│       │   │   ├── common_POCE_120.namd
│       │   │   ├── config_POCE_120.yaml
│       │   │   ├── do_run_POCE_120.sh
│       │   │   ├── POCE_120.fep.pdb
│       │   │   ├── POCE_120.fep.psf
│       │   │   ├── POCE_120.pdb
│       │   │   ├── POCE_120.psf
│       │   │   ├── POCE_120.tcl
│       │   │   ├── runEQ.sh
│       │   │   ├── starting.POCE_120.namd
│       │   │   └── zrestraint.POCE_120.colvars
│       │   ├── POCE_24
│       │   │   ├── common_POCE_24.namd
│       │   │   ├── config_POCE_24.yaml
│       │   │   ├── do_run_POCE_24.sh
│       │   │   ├── POCE_24.fep.pdb
│       │   │   ├── POCE_24.fep.psf
│       │   │   ├── POCE_24.pdb
│       │   │   ├── POCE_24.psf
│       │   │   ├── POCE_24.tcl
│       │   │   ├── runEQ.sh
│       │   │   ├── starting.POCE_24.namd
│       │   │   └── zrestraint.POCE_24.colvars
│       │   ├── POCE_48
│       │   │   ├── common_POCE_48.namd
│       │   │   ├── config_POCE_48.yaml
│       │   │   ├── do_run_POCE_48.sh
│       │   │   ├── POCE_48.fep.pdb
│       │   │   ├── POCE_48.fep.psf
│       │   │   ├── POCE_48.pdb
│       │   │   ├── POCE_48.psf
│       │   │   ├── POCE_48.tcl
│       │   │   ├── runEQ.sh
│       │   │   ├── starting.POCE_48.namd
│       │   │   └── zrestraint.POCE_48.colvars
│       │   ├── POCE_72
│       │   │   ├── common_POCE_72.namd
│       │   │   ├── config_POCE_72.yaml
│       │   │   ├── do_run_POCE_72.sh
│       │   │   ├── POCE_72.fep.pdb
│       │   │   ├── POCE_72.fep.psf
│       │   │   ├── POCE_72.pdb
│       │   │   ├── POCE_72.psf
│       │   │   ├── POCE_72.tcl
│       │   │   ├── runEQ.sh
│       │   │   ├── starting.POCE_72.namd
│       │   │   └── zrestraint.POCE_72.colvars
│       │   └── POCE_84
│       │       ├── common_POCE_84.namd
│       │       ├── config_POCE_84.yaml
│       │       ├── do_run_POCE_84.sh
│       │       ├── POCE_84.fep.pdb
│       │       ├── POCE_84.fep.psf
│       │       ├── POCE_84.pdb
│       │       ├── POCE_84.psf
│       │       ├── POCE_84.tcl
│       │       ├── runEQ.sh
│       │       ├── starting.POCE_84.namd
│       │       └── zrestraint.POCE_84.colvars
│       ├── PC_to_PG
│       │   ├── POCG_108
│       │   │   ├── common_POCG_108.namd
│       │   │   ├── config_POCG_108.yaml
│       │   │   ├── do_run_POCG_108.sh
│       │   │   ├── POCG_108.fep.pdb
│       │   │   ├── POCG_108.fep.psf
│       │   │   ├── POCG_108.pdb
│       │   │   ├── POCG_108.psf
│       │   │   ├── POCG_108.tcl
│       │   │   ├── runEQ.sh
│       │   │   ├── starting.POCG_108.namd
│       │   │   └── zrestraint.POCG_108.colvars
│       │   ├── POCG_12
│       │   │   ├── common_POCG_12.namd
│       │   │   ├── config_POCG_12.yaml
│       │   │   ├── do_run_POCG_12.sh
│       │   │   ├── POCG_12.fep.pdb
│       │   │   ├── POCG_12.fep.psf
│       │   │   ├── POCG_12.pdb
│       │   │   ├── POCG_12.psf
│       │   │   ├── POCG_12.tcl
│       │   │   ├── runEQ.sh
│       │   │   ├── starting.POCG_12.namd
│       │   │   └── zrestraint.POCG_12.colvars
│       │   ├── POCG_36
│       │   │   ├── common_POCG_36.namd
│       │   │   ├── config_POCG_36.yaml
│       │   │   ├── do_run_POCG_36.sh
│       │   │   ├── POCG_36.fep.pdb
│       │   │   ├── POCG_36.fep.psf
│       │   │   ├── POCG_36.pdb
│       │   │   ├── POCG_36.psf
│       │   │   ├── POCG_36.tcl
│       │   │   ├── runEQ.sh
│       │   │   ├── starting.POCG_36.namd
│       │   │   └── zrestraint.POCG_36.colvars
│       │   ├── POCG_60
│       │   │   ├── common_POCG_60.namd
│       │   │   ├── config_POCG_60.yaml
│       │   │   ├── do_run_POCG_60.sh
│       │   │   ├── POCG_60.fep.pdb
│       │   │   ├── POCG_60.fep.psf
│       │   │   ├── POCG_60.pdb
│       │   │   ├── POCG_60.psf
│       │   │   ├── POCG_60.tcl
│       │   │   ├── runEQ.sh
│       │   │   ├── starting.POCG_60.namd
│       │   │   └── zrestraint.POCG_60.colvars
│       │   └── POCG_96
│       │       ├── common_POCG_96.namd
│       │       ├── config_POCG_96.yaml
│       │       ├── do_run_POCG_96.sh
│       │       ├── POCG_96.fep.pdb
│       │       ├── POCG_96.fep.psf
│       │       ├── POCG_96.pdb
│       │       ├── POCG_96.psf
│       │       ├── POCG_96.tcl
│       │       ├── runEQ.sh
│       │       ├── starting.POCG_96.namd
│       │       └── zrestraint.POCG_96.colvars
│       ├── perWindow.csv
│       ├── PE_to_PG
│       │   ├── POEG_19
│       │   │   ├── common_POEG_19.namd
│       │   │   ├── config_POEG_19.yaml
│       │   │   ├── do_run_POEG_19.sh
│       │   │   ├── POEG_19.fep.pdb
│       │   │   ├── POEG_19.fep.psf
│       │   │   ├── POEG_19.pdb
│       │   │   ├── POEG_19.psf
│       │   │   ├── POEG_19.tcl
│       │   │   ├── runEQ.sh
│       │   │   ├── starting.POEG_19.namd
│       │   │   └── zrestraint.POEG_19.colvars
│       │   ├── POEG_23
│       │   │   ├── common_POEG_23.namd
│       │   │   ├── config_POEG_23.yaml
│       │   │   ├── do_run_POEG_23.sh
│       │   │   ├── POEG_23.fep.pdb
│       │   │   ├── POEG_23.fep.psf
│       │   │   ├── POEG_23.pdb
│       │   │   ├── POEG_23.psf
│       │   │   ├── POEG_23.tcl
│       │   │   ├── runEQ.sh
│       │   │   ├── starting.POEG_23.namd
│       │   │   └── zrestraint.POEG_23.colvars
│       │   ├── POEG_49
│       │   │   ├── common_POEG_49.namd
│       │   │   ├── config_POEG_49.yaml
│       │   │   ├── do_run_POEG_49.sh
│       │   │   ├── POEG_49.fep.pdb
│       │   │   ├── POEG_49.fep.psf
│       │   │   ├── POEG_49.pdb
│       │   │   ├── POEG_49.psf
│       │   │   ├── POEG_49.tcl
│       │   │   ├── runEQ.sh
│       │   │   ├── starting.POEG_49.namd
│       │   │   └── zrestraint.POEG_49.colvars
│       │   ├── POEG_55
│       │   │   ├── common_POEG_55.namd
│       │   │   ├── config_POEG_55.yaml
│       │   │   ├── do_run_POEG_55.sh
│       │   │   ├── POEG_55.fep.pdb
│       │   │   ├── POEG_55.fep.psf
│       │   │   ├── POEG_55.pdb
│       │   │   ├── POEG_55.psf
│       │   │   ├── POEG_55.tcl
│       │   │   ├── runEQ.sh
│       │   │   ├── starting.POEG_55.namd
│       │   │   └── zrestraint.POEG_55.colvars
│       │   └── POEG_7
│       │       ├── common_POEG_7.namd
│       │       ├── config_POEG_7.yaml
│       │       ├── do_run_POEG_7.sh
│       │       ├── POEG_7.fep.pdb
│       │       ├── POEG_7.fep.psf
│       │       ├── POEG_7.pdb
│       │       ├── POEG_7.psf
│       │       ├── POEG_7.tcl
│       │       ├── runEQ.sh
│       │       ├── starting.POEG_7.namd
│       │       └── zrestraint.POEG_7.colvars
│       ├── POPC120.pdb
│       ├── POPC120.psf
│       └── TEMPLATE
│           ├── common_TEMPLATE.namd
│           ├── config_TEMPLATE.yaml
│           ├── do_run_TEMPLATE.sh
│           ├── runEQ.sh
│           ├── starting.POCE.namd~
│           ├── starting.TEMPLATE.namd
│           └── zrestraint.TEMPLATE.colvars
└── protein_systems
    ├── ELIC5
    │   ├── convergence.csv
    │   ├── cumulatives.csv
    │   ├── keyColors.csv
    │   ├── metadata.txt
    │   ├── PC_to_PG
    │   ├── perWindow.csv
    │   ├── PE_to_PC
    │   └── PE_to_PG
    ├── Protein_DRAFT_altYLabel_S2.pdf
    ├── Protein_DRAFT_colorKey.pdf
    ├── Protein_DRAFT_trimmed_S1.pdf
    ├── Protein_DRAFT_trimmed_S3.pdf
    ├── Protein_DRAFT_trimmed_S4.pdf
    ├── Protein_DRAFT_trimmed_sameAx_S4.pdf
    └── WT
        ├── convergence.csv
        ├── cumulatives.csv
        ├── keyColors.csv
        ├── metadata.txt
        ├── PC_to_PG
        ├── perWindow.csv
        ├── PE_to_PC
        └── PE_to_PG

93 directories, 4098 files
```
