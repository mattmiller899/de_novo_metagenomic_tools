#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=24gb
#SBATCH --time=72:00:00

cd $SLURM_SUBMIT_DIR
source ~/.bashrc
source activate hulk

echo "howdy"

date
SKETCH_DIR="${OUT_DIR}/hulk_sketch/"
if [ ! -d "$OUT_DIR" ]; then
    mkdir -p "$SKETCH_DIR"
fi

while read -r LINE; do
    BN=$(basename $LINE)
    PN=${BN::-3}
    #PN=${BN::-3}
    echo "$PN $LINE"
    #gunzip -c $LINE | head
    #gunzip -c $LINE | hulk sketch -p 4 -k ${KMER} -o ${SKETCH_DIR}/${PN}
    hulk sketch -p 4 -k ${KMER} -o ${SKETCH_DIR}/${PN} -f $LINE
done < $FILE_LIST
SMASH="${OUT_DIR}/hulk_smash"
hulk smash -p 4 -k ${KMER} -o $SMASH -d ${SKETCH_DIR}

date
