#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=24gb
#SBATCH --time=96:00:00

cd $SLURM_SUBMIT_DIR
source ~/.bashrc
source activate commet

echo "howdy"

#Create read set list
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
    echo "${ID}: ${LINE}" >> $NEW_FILE_LIST
done < $FILE_LIST


date
echo "python commet/Commet.py $NEW_FILE_LIST -b commet/bin -o $OUT_DIR -k $KMER -m 10000"
python commet/Commet.py $NEW_FILE_LIST -b commet/bin -o $OUT_DIR -k $KMER -m 10000
date
