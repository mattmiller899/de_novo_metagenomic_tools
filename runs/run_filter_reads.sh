#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=24gb
#SBATCH --time=12:00:00

cd $SLURM_SUBMIT_DIR
source ~/.bashrc
source activate pyenv

echo "howdy"

BATCH=$((SLURM_ARRAY_TASK_ID * 10))
#BATCH="$SLURM_ARRAY_TASK_ID"

head -${BATCH} ${FILE_LIST} | tail -10 | while read -r LINE; do
    BN=$(basename $LINE)
    OUT="${OUT_DIR}/${BN::-6}_filtered.fq"
    vsearch --fastq_filter $LINE --fastq_minlen 40 --fastqout $OUT
done
