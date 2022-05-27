#!/bin/bash

function check_live
{
	# echo "INFO: checking if there are fc2020 processes running."
	#nfc=`ps aux | grep "fc2022-nus"| grep -v "grep"| grep -v "srun"|grep -v "bash"| wc -l `
  nfc=`pgrep "fc2022-nus"| grep -v "grep"| grep -v "srun"|grep -v "bash"| wc -l `
	if [ $nfc == 0 ]; then
		echo "INFO: No fc2022-nus processes running, cleaning up /dev/shm."
		rm -f /dev/shm/fcout*.root
		rm -f /dev/shm/checkpoint*.root
		exit 0
	fi
	# echo "INFO: found processes running, continue to make checkpints"
}

function make_checkpoint
{
	check_live
	checkpoint_file="checkpoint_${JID}_${NID}.root"
	blockout_file="fcout_J-${JID}_N-${NID}_B-*.root"
        echo "INFO: Checking /dev/shm for files of type: ${blockout_file}"
	echo "INFO: doing hadd if there's output root files from fc processes."
	for f in /dev/shm/${blockout_file}; do
		if [ -e "$f" ]; then
      echo "doing hadd", ${NID}
			#hadd -f /dev/shm/${checkpoint_file} /dev/shm/${blockout_file} >/dev/null 2>&1
			hadd -f /dev/shm/${checkpoint_file} /dev/shm/${blockout_file}
			#mkdir -p /output/${JID}
			cp -f /dev/shm/${checkpoint_file} /output/${JID}/
			cp -f /dev/shm/${blockout_file} /output/${JID}/
		fi
		break
	done
}


if [ "$#" != "2" ]; then
        exit 1
fi

JID=${SLURM_JOB_ID}
NID=${SLURM_NODEID}

echo "INFO: checkpoint daemon starts running. Going to sleep for $1 seconds before making the first checkpoint."
sleep $1
mkdir -p /output/${JID}
make_checkpoint

INTERVAL=$2

while true
do
  echo "INFO: making checkpoints every $2 seconds."
	for i in `seq 0 9`; do
		sleep $(( INTERVAL/10 ))
		check_live
	done
	make_checkpoint
done
