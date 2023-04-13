#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=28
#SBATCH --mem=168gb
#SBATCH --time=72:00:00

cd $SLURM_SUBMIT_DIR
source ~/.bashrc
source activate pyenv

echo "howdy"



date
echo "./metafast.sh -i `cat ${FILE_LIST}` -k $KMER -m 160G -p 4 -w ./results/metafast"
./metafast.sh -i `cat ${FILE_LIST}` -k $KMER -m 160G -p 4 -w ./results/metafast
date
