#!/bin/bash
#BSUB -J M211_pctopgD
#BSUB -o job-%J.out -e job-%J.err
#BSUB -n 12 -R "span[hosts=1]"

NCPU=12
module load gcc/5.2.0
module load cuda/9
module load python/3.9

NAMD="$HOME/bin/namd2-2.14 +p$NCPU"
SKEL=$(echo $LSB_JOBNAME | cut -d_ -f2)

START=0
END=40
for i in $(seq $START $END)
do
    THEN=$(date +%s)
    CONF=$(python3 $HOME/mmdevel/relentless_fep.py config_${SKEL}.yaml $i)
    PREFIX=$(basename $CONF .namd)
    ${NAMD} ${CONF} > ${PREFIX}.log
    THEN=$(date +%s)
    DURATION_MINS=$((($NOW - $THEN) / 60))
done

