#!/bin/bash
# create links to relevant files
ln -s ../../raw_data/g.morbida.scaffolds.fasta ./
ln -s ../../raw_data/g.morbida.scaffolds.fasta.fai ./
ln -s ../../raw_data/g.morbida.gff ./
ln -s ../3_map/*.bam ./
ln -s /lustre/projects/staton/software/bcftools-1.2/bcftools ./
ln -s /lustre/projects/staton/software/freebayes_1.0.2-15/bin/freebayes ./
ln -s /lustre/projects/staton/software/samtools-1.3/samtools ./
ln -s /lustre/projects/staton/software/bedtools-2.25/bin/intersectBed ./
# create a sequence dictionary for the reference
module load java/jdk8u5
java -jar /lustre/projects/staton/software/picard-tools-2.1.0/picard.jar \
CreateSequenceDictionary \
R=g.morbida.scaffolds.fasta \
O=g.morbida.scaffolds.dict
# add headers to the bam files
for f in `ls *.bam`
do
# store RGLB in $e variable
e=$(echo $f | cut -d '.' -f 1)
# store RGPU in $l variable
l=$(head -n1 ../../raw_data/${e}_S*_L001_R1_001.fastq | cut -f 1 -d ' ')
# run picard tools
java -jar /lustre/projects/staton/software/picard-tools-2.1.0/picard.jar \
AddOrReplaceReadGroups \
I=$f \
O=$f.fix \
RGSM=$e \
RGLB=$e \
RGPL=illumina \
RGPU=$l
done
# get rid of .bam links and rename the .fix to .bam
rm -f *.bam
rename .bam.fix .bam *.fix
# create an index for each of the new bam files
module load samtools
for f in `ls *.bam`
do
samtools index $f
done
