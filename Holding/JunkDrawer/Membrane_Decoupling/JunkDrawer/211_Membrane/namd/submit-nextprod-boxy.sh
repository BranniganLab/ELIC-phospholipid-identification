#!/bin/bash
#BSUB -J M211_prod
#SBATCH -n 8

NAMD="$HOME/bin/namd3-cuda-20211020 +p$SLURM_NTASKS"
SKEL=$(echo $SLURM_JOB_NAME | cut -d_ -f2)
PREFIX=$(python $HOME/mmdevel/next_namd_prod.py --prefix=$SKEL)

${NAMD} ${PREFIX}.namd > ${PREFIX}.log
