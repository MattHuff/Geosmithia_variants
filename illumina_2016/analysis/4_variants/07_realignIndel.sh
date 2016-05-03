#!/bin/bash
# Realign around deduped indels using GATK
for f in `ls *_realigned_mDup.bam`
do
e=$(echo $f | cut -d '.' -f 1)
echo "#$ -q short*
#$ -o 07.e
#$ -e 07.o
#$ -cwd
#$ -l mem=4g
module load java/jdk8u5
java -jar /lustre/projects/staton/software/GenomeAnalysisTK-3.5-0/GenomeAnalysisTK.jar \
-T IndelRealigner \
-R g.morbida.scaffolds.fasta \
-I $f \
-targetIntervals $e.intervals \
-o ${e}_realigned.bam" > $e.ogs
qsub $e.ogs
rm -f $e.ogs
done
