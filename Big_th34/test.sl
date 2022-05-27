#!/bin/bash -l
#SBATCH -L SCRATCH
#SBATCH --image=vhewes/nova:release
#SBATCH --module=cvmfs,mpich
#SBATCH -A m3249
#SBATCH -q regular
##SBATCH -C cpu
#SBATCH --constraint=cpu
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -t 01:30:00
##SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH -J "test_pm"
#SBATCH -o "test_pm-%j.out"

# remember to check the following paths before each job submission
export FCInput_NuX=/scratch1/FCInput_NuX/
export FCOutputDir=/scratch1/jobs
export FCConfig=/scratch1/jobs/test_64.xml


#export OMP_NUM_THREADS=1

srun --kill-on-bad-exit=0 shifter --volume=$PSCRATCH/Nus22:/scratch1 --volume=$FCOutputDir:/output /scratch1/run-saul.sh 600 600 fc2022-nus $FCConfig
