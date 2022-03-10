#!/bin/bash
#SBATCH -J M211_mineq
#SBATCH -n 8

NAMD="$HOME/bin/namd3-cuda-20211020 +p$SLURM_NTASKS"

for i in `seq 1 6`
do
  PREFIX=step6.${i}_equilibration
  $NAMD $PREFIX.inp > $PREFIX.log
done
echo "$SLURM_JOB_NAME: Done with $PREFIX" | ~/bin/slack-ttjoseph
