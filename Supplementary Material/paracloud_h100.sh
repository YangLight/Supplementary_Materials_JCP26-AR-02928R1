#!/bin/bash
#SBATCH -p gpu_h200
#SBATCH -J MACE_train
#SBATCH --gpus=1

module purge
module load miniforge3/25.11.0-1
source activate py312
#export LD_LIBRARY_PATH=/data/home/scwb425/run/lib:$LD_LIBRARY_PATH
export PYTHONUNBUFFERED=1


date
python -u mace_convert_virial_to_stress.py

mace_run_train \
    --name="MACE_MPA_ft_C_N_Cu" \
    --foundation_model="./mace-mpa-0-medium.model" \
    --multiheads_finetuning=False \
    --valid_fraction=0.05 \
    --train_file="train_mace.extxyz" \
    --test_file="test_mace.extxyz" \
    --energy_key="REF_energy" \
    --forces_key="REF_forces" \
    --stress_key="REF_stress" \
    --compute_stress=True \
    --loss="universal" \
    --energy_weight=1.0 \
    --forces_weight=10.0 \
    --stress_weight=1.0 \
    --E0s="average" \
    --lr=0.001 \
    --scaling="rms_forces_scaling" \
    --batch_size=20 \
    --max_num_epochs=400 \
    --ema \
    --ema_decay=0.999 \
    --amsgrad \
    --default_dtype="float64" \
    --device=cuda \
    --seed=3 \
    --enable_cueq=True \
    --error_table="PerAtomRMSEstressvirials"
date
