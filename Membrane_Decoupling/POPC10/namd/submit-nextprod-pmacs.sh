#!/bin/bash
#BSUB -J POPC10_prodpopc
#BSUB -o job-%J.out -e job-%J.err
#BSUB -n 12 -R "span[hosts=1]" -gpu num=2

NCPU=12
module load gcc/5.2.0
module load cuda/8
module load python/3.9

NAMD="$HOME/bin/namd2-cuda-2.13 +p$NCPU"
SKEL=$(echo $LSB_JOBNAME | cut -d_ -f2)
PREFIX=$(python $HOME/mmdevel/next_namd_prod.py -i step6.6_equilibration.coor --prefix=$SKEL)

${NAMD} ${PREFIX}.namd > ${PREFIX}.log
