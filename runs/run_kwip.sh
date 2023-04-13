#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=28
#SBATCH --mem=168gb
#SBATCH --time=72:00:00

cd $SLURM_SUBMIT_DIR
source ~/.bashrc
source activate kwip

echo "howdy"

INPUT_FILES="${INPUT_DIR}/*1.fq.gz"

KERN="${OUT_DIR}/kernel.txt"
DIST="${OUT_DIR}/dist.txt"

date

#Generate countgraphs
while read -r LINE; do
    TMP_OUT="${OUT_DIR}/$(basename $LINE).ct"
    echo "python khmer/scripts/load-into-counting.py $TMP_OUT $LINE -k $KMER -N 1 -x 1e10 -T 4 -f" 
    python khmer/scripts/load-into-counting.py $TMP_OUT $LINE -k $KMER -T 4 -f -N 1 -x 1e10
done < $FILE_LIST

echo "kwip -t 4 -k $KERN -d $DIST $OUT_DIR/*.ct"
kwip -t 4 -k $KERN -d $DIST $OUT_DIR/*.ct

date
