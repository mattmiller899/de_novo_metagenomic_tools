#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=24gb
#SBATCH --time=12:00:00

cd $SLURM_SUBMIT_DIR
source ~/.bashrc
source activate pyenv

COMBINED_DIR="./combined_pairs"
#Combine paired-end reads

while read -r LINE; do
    BN=$(basename $LINE)
    PN=${BN::-13}
    DN=$(dirname $LINE)
    echo "$LINE $BN $PN"
    ID=$(echo $BN | tr '_' '\n' | head -4 | tr '\n' '_')
    echo "$LINE $BN $PN $ID"
    cat ${DN}/${PN}1_val_1.fq.gz ${DN}/${PN}2_val_2.fq.gz > ${COMBINED_DIR}/${PN}.fq.gz
done < $FILE_LIST

NEW_FILE_LIST="${FILE_LIST}.new"
find $COMBINED_DIR -name *.fq.gz > $NEW_FILE_LIST
SKETCH="${OUT_DIR}/sketch.msh"

date

if [ ! -f $SKETCH ]; then
    echo "sketching"
    mash sketch -l ${NEW_FILE_LIST} -o ${SKETCH} -p 4 -k ${KMER}
fi
DIST="${OUT_DIR}/new_dist.tab"
mash dist ${SKETCH} -l ${NEW_FILE_LIST} -p 4 -t > ${DIST}

date
