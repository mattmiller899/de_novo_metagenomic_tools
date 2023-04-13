#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=24gb
#SBATCH --time=48:00:00

cd $SLURM_SUBMIT_DIR
source ~/.bashrc
source activate simka

echo "howdy"
NEW_FILE_LIST="${FILE_LIST}.new"
> $NEW_FILE_LIST

#Make special filelist for SIMKA
while read -r LINE; do
    BN=$(basename $LINE)
    PN=${BN::-13}
    DN=$(dirname $LINE)
    echo "$LINE $BN $PN"
    ID=$(echo $BN | tr '_' '\n' | head -4 | tr '\n' '_')
    echo "$LINE $BN $PN $ID"
    echo "${ID}: ${DN}/${PN}1_val_1.fq.gz ; ${DN}/${PN}2_val_2.fq.gz" >> $NEW_FILE_LIST
done < $FILE_LIST

SIMKA_OUT="$OUT_DIR/results"
if [ -d "$SIMKA_OUT" ]; then
    echo "already made out"
else
    mkdir -p "$SIMKA_OUT"
fi

SIMKA_TMP="$OUT_DIR/tmp"
if [ -d "$SIMKA_TMP" ]; then
    echo "already make tmp"
else
    mkdir -p "$SIMKA_TMP"
fi
echo "simka -kmer-size ${KMER} -in ${NEW_FILE_LIST} -out ${SIMKA_OUT} -out-tmp ${SIMKA_TMP} -nb-cores 128 -max-memory 768000 -count-file ./simka_count.sh -merge-file ./simka_merge.sh -count-cmd 'sbatch --partition=standard --account=bhurwitz --mail-user=mattmiller899@email.arizona.edu --mail-type=FAIL' -merge-cmd 'sbatch --partition=standard --account=bhurwitz --mail-user=mattmiller899@email.arizona.edu --mail-type=FAIL' -max-count 32 -max-merge 32"
date
simka -kmer-size ${KMER} -in ${NEW_FILE_LIST} -out ${SIMKA_OUT} -out-tmp ${SIMKA_TMP} -nb-cores 128 -max-memory 768000 -count-file ./simka_count.sh -merge-file ./simka_merge.sh -count-cmd 'sbatch --partition=standard --account=bhurwitz --mail-user=mattmiller899@email.arizona.edu --mail-type=FAIL' -merge-cmd 'sbatch --partition=standard --account=bhurwitz --mail-user=mattmiller899@email.arizona.edu --mail-type=FAIL' -max-count 32 -max-merge 32
date
