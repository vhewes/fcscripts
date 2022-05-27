#!/bin/bash -l
#SBATCH -L SCRATCH
#SBATCH --image=vhewes/nova:production
#SBATCH --module=mpich
#SBATCH -A m3990
#SBATCH -q regular
##SBATCH -C cpu
#SBATCH --constraint=cpu
#SBATCH -N 200
#SBATCH -n 12800
#SBATCH -t 10:00:30
##SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH -J "Nus22_th34"
#SBATCH -o "Nus22_th34-%j.out" 

# remember to check the following paths before each job submission
export FCInput_NuX=/data
export FCOutputDir=/scratch1/Big_th34
export FCConfig=/scratch1/Big_th34/sn_th34vsdm41_01.xml


#export OMP_NUM_THREADS=1

srun --kill-on-bad-exit=0 shifter --volume=$PSCRATCH/Nus22:/scratch1 --volume=$FCOutputDir:/output /scratch1/run-saul.sh 600 600 fc2022-nus $FCConfig
