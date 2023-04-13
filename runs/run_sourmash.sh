#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=24gb
#SBATCH --time=24:00:00

cd $SLURM_SUBMIT_DIR
source ~/.bashrc
source activate sourmash

echo "howdy"

date

SKETCH_DIR="${OUT_DIR}/sketches"
if [ ! -d "$SKETCH_DIR" ]; then
    mkdir -p $SKETCH_DIR
fi
#sourmash sketch dna $INPUT_DIR/*1.fq.gz --outdir $SKETCH_DIR -p k=${KMER}
sourmash sketch dna `cat $FILE_LIST` --outdir $SKETCH_DIR -p k=${KMER}
sourmash compare $SKETCH_DIR/*.sig -o $OUT_DIR/cmp.dist -p 4 --csv $OUT_DIR/cmp.dist.csv

date
