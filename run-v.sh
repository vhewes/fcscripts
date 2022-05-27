#!/bin/bash

if [ "$#" == "0" ]; then
  exit 1
fi

Check_Wait=$1
Check_Interval=$2

shift; shift

LDTMP=$LD_LIBRARY_PATH
source /etc/profile.d/env.sh
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LDTMP

if [ $SLURM_LOCALID == 0 ]; then
  /scratch1/fcscripts/checkpoint.sh $Check_Wait $Check_Interval &
fi

CMD=""
while (( "$#" )); do
  if [[ "$1" != "" ]]; then
    CMD="$CMD $1"
  fi
  shift
done

export FCInput_NuX=/data
export FCOutput=/scratch1/FCOutput

export LC_ALL=C
unset LANGUAGE

echo "SLURM: ${SLURM_JOB_ID} ${SLURM_PROCID} ${SLURM_NODEID} -- Started running CMD: ${CMD}"
eval "LD_LIBRARY_PATH=/opt/glibc/lib:/opt/udiImage/modules/mpich:/opt/udiImage/modules/mpich/dep/lib:${LD_LIBRARY_PATH/'/mpich/lib'/}:/lib64 ${CMD}"
echo "--------------------------------------------"

