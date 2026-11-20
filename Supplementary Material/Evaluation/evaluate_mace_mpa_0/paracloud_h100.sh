#!/bin/bash
#SBATCH -p gpu_a800
#SBATCH -J MACE_evaluation
#SBATCH --gpus=1

module purge
module load miniforge3/25.11.0-1
source activate py312
#export LD_LIBRARY_PATH=/data/home/scwb425/run/lib:$LD_LIBRARY_PATH
export PYTHONUNBUFFERED=1

date
python -u evaluation_train.py > evaluation_train.out
python -u evaluation_test.py > evaluation_test.out
date
