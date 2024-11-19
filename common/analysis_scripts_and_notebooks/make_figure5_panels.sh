#!/bin/bash

python -m safep.AFEP_parse --replicare "POCE*" --fepoutre "POCE*fepout" --path "../../membrane_systems/2PC_1PG_1PE/PC_to_PE" &> bulk_PCPE.info &
python -m safep.AFEP_parse --replicare "POEG*" --fepoutre "POEG*fepout" --path "../../membrane_systems/2PC_1PG_1PE/PE_to_PG" &> bulk_PEPG.info &

python -m safep.AFEP_parse --replicare "PE_to_PC" --fepoutre "petopc*fepout" --path "../../protein_systems/WT" &> WT_PEPC.info &
python -m safep.AFEP_parse --replicare "PE_to_PG*" --fepoutre "petopg*fepout" --path "../../protein_systems/WT" &> WT_PEPG.info &

python -m safep.AFEP_parse --replicare "PE_to_PC*" --fepoutre "petopc*fepout" --path "../../protein_systems/ELIC5" &> E5_PEPC.info &
python -m safep.AFEP_parse --replicare "PE_to_PG*" --fepoutre "petopg*fepout" --path "../../protein_systems/ELIC5" &> E5_PEPG.info &

wait
echo "Done processing fepouts"
rm means.info
grep -r ^mean *info > means.info

python Figure_5_Predicted_Occupancy_and_Modulation.py

