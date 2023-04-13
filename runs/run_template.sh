#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --mem=12gb
#SBATCH --time=12:00:00

cd $SLURM_SUBMIT_DIR
source ~/.bashrc
source activate pyenv

echo "howdy"
