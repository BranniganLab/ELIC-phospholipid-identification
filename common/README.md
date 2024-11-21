# Common Files

## To recreate the panels for figure 5 of the NatComms paper:
1. Install the latest version of safep: `pip install git+https://github.com/BranniganLab/safep.git@52-afep-parse-is-outdated`
2. Clone this repository
3. Navigate to the analysis directory: `cd common/analysis_scripts_and_notebooks`
4. Run the provided bash script `make_figure5_panels.sh`
5. The panels will be saved to the Figures directory

## Contents
```
├── analysis_scripts_and_notebooks
│   ├── AFEP_parse.py
│   ├── ConformationModulationAnalysis.ipynb
│   ├── GenMembraneFigures.ipynb
│   ├── GenProteinFigures.ipynb
│   ├── splitGroups.sh
│   └── splitReplicas.sh
├── CHARMM_Parameters
│   ├── c36_lipid_alchemy.rtf
│   ├── chipot_cation_pi_2020_expanded_20211112.prm
│   └── Other CHARMM36m files
├── README.md
├── system_generation_scripts
│   ├── common.sh
│   ├── depatch_script.tcl
│   ├── makeAlchemy.sh
│   ├── patches #CHARMM topology files for generating dual topology lipids (c36_lipid_alchemy) from CHARMM36m lipids
│   │   ├── POCE_to_POPE.rtf
│   │   ├── POCG_to_POPG.rtf
│   │   ├── POEG_to_POPE.rtf
│   │   ├── POEG_to_POPG.rtf
│   │   ├── POPC_to_POCE.rtf
│   │   ├── POPC_to_POCG.rtf
│   │   ├── POPE_to_POEC.rtf
│   │   ├── POPE_to_POEG.rtf
│   │   ├── POPG_to_POCG.rtf
│   │   └── POPG_to_POGE.rtf
│   ├── patch_script.tcl
│   ├── procedure.md
│   ├── sample_TEMPLATE
│   │   ├── common_TEMPLATE.namd
│   │   ├── config_TEMPLATE.yaml
│   │   ├── do_run_TEMPLATE.sh
│   │   ├── runEQ.sh
│   │   ├── starting.POCE.namd~
│   │   ├── starting.TEMPLATE.namd
│   │   └── zrestraint.TEMPLATE.colvars
│   └── unAlchemize.sh
└── system_running_scripts
    └── relentless_fep.py #A script to easily restart interrupted or crashed FEP runs

6 directories, 96 files
```
