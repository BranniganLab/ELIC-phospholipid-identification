#!/bin/bash
#BSUB -J POPC10_mineq
#BSUB -o job-%J.out -e job-%J.err
#BSUB -n 12 -R "span[hosts=1]" -gpu num=2

NCPU=12
module load gcc/5.2.0
module load cuda/8
NAMD="$HOME/bin/namd2-cuda-2.13 +p$NCPU"

for i in 1 2 3 4 5 6
do
    $NAMD step6.${i}_equilibration.inp > step6.${i}_equilibration.log
done
