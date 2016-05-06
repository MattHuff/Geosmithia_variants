#!/bin/bash
# Use SNPeff to classify variants into categories based on expected effect on reading frame
# GM108	GM17	GM188	GM205	GM20
cut -f 1-10 g.morbida.freebayes.filt.vcf > GM108.freebayes.vcf
cut -f 1-9,11 g.morbida.freebayes.filt.vcf > GM17.freebayes.vcf
cut -f 1-9,12 g.morbida.freebayes.filt.vcf > GM188.freebayes.vcf
cut -f 1-9,13 g.morbida.freebayes.filt.vcf > GM205.freebayes.vcf
cut -f 1-9,14 g.morbida.freebayes.filt.vcf > GM20.freebayes.vcf
# SNPeff on all variants
for f in GM108 GM17 GM188 GM205 GM20
do
echo "
#$ -q short*
#$ -o 20.o
#$ -e 20.e
#$ -cwd
#$ -l mem=4g
module load java/jdk8u5
java -jar /lustre/projects/staton/software/snpEff/snpEff.jar eff \
-csvStats $f.freebayes.snpEff.csv \
-s $f.snpEff.html \
g.morbida $f.freebayes.vcf > $f.freebayes.snpEff.vcf" > tmp.ogs
qsub tmp.ogs
rm -f tmp.ogs
done
