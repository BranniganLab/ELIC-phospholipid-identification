#!/bin/bash
#BSUB -J M211_pctopgA
#SBATCH -n 12

NAMD="$HOME/bin/namd2-2.14 +p$SLURM_NTASKS"
SKEL=$(echo $SLURM_JOB_NAME | cut -d_ -f2)
START=0
END=40
for i in $(seq $START $END)
do
    THEN=$(date +%s)
    CONF=$(python $HOME/mmdevel/relentless_fep.py config_${SKEL}.yaml $i)
    PREFIX=$(basename $CONF .namd)
    ${NAMD} ${CONF} > ${PREFIX}.log
    THEN=$(date +%s)
    DURATION_MINS=$((($NOW - $THEN) / 60))
    echo "$SLURM_JOB_NAME: Done with window $i in $DURATION_MINS mins" | ~/bin/slack-ttjoseph  
done

