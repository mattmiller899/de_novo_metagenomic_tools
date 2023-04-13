#!/bin/bash

set -u
export STDERR_DIR="./err"
export STDOUT_DIR="./out"
#init_dir "$STDERR_DIR" "$STDOUT_DIR"
export JOB="metafast"
export KMER=31
export INPUT_DIR="/xdisk/bhurwitz/aponsero/temp"
export FILE_LIST="./filelists/${JOB}.txt"
#find $INPUT_DIR -name *1.fq.gz > $FILE_LIST
cat ./filelist_30.txt > $FILE_LIST

export OUT_DIR="./results/${JOB}"
if [ -d "$OUT_DIR" ]; then
    continue
else
    mkdir -p "$OUT_DIR"
fi
ARGS="--partition=standard --account=bhurwitz --mail-user=mattmiller899@email.arizona.edu --mail-type=FAIL"
JOB_ID=`sbatch $ARGS --export=INPUT_DIR,OUT_DIR,FILE_LIST,KMER --job-name=${JOB} -e $STDERR_DIR/${JOB}.err -o $STDOUT_DIR/${JOB}.out ./runs/run_${JOB}.sh`
if [ "${JOB_ID}x" != "x" ]; then
    echo Job: \"$JOB_ID\"
else
    echo Problem submitting job. Job terminated.
    exit 1
fi
echo "job successfully submitted"
