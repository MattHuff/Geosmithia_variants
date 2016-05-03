#!/bin/bash
# Mark duplicates using picard tools
module load java/jdk8u5
for f in `ls *_realigned.bam`
do
e=$(echo $f | cut -d '.' -f 1)
java -Xmx20g -jar /lustre/projects/staton/software/picard-tools-2.1.0/picard.jar \
MarkDuplicates \
VALIDATION_STRINGENCY=LENIENT \
INPUT=$f \
OUTPUT=${e}_mDup.bam \
METRICS_FILE=${e}_mDup_metrics.txt &
done
