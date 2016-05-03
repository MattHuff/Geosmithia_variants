#!/bin/bash
# Realign around deduped SNPs using GATK
for f in `ls *_realigned_mDup.bam`
do
e=$(echo $f | cut -d '.' -f 1)
echo "
#$ -q short*
#$ -o 06.o
#$ -e 06.e
#$ -cwd
#$ -l mem=4g
module load java/jdk8u5
java -jar /lustre/projects/staton/software/GenomeAnalysisTK-3.5-0/GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-R g.morbida.scaffolds.fasta \
-I $f \
-o $e.intervals" > $e.ogs
qsub $e.ogs
rm -f $e.ogs
done
