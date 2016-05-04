### Analysis of the variants in Geosmithia morbida
The following analysis uses bowtie2 aligned .bam files to determine variants across 5 populations of g. morbida: GM108, GM17, GM188, GM20, and GM205.
####create links to relevant files
```
ln -s ../../raw_data/g.morbida.scaffolds.fasta ./
ln -s ../../raw_data/g.morbida.scaffolds.fasta.fai ./
ln -s ../../raw_data/g.morbida.gff ./
ln -s ../3_map/*.bam ./
ln -s /lustre/projects/staton/software/bcftools-1.2/bcftools ./
ln -s /lustre/projects/staton/software/freebayes_1.0.2-15/bin/freebayes ./
ln -s /lustre/projects/staton/software/samtools-1.3/samtools ./
ln -s /lustre/projects/staton/software/bedtools-2.25/bin/intersectBed ./
```
####create a sequence dictionary for the reference
```
module load java/jdk8u5
java -jar /lustre/projects/staton/software/picard-tools-2.1.0/picard.jar \
CreateSequenceDictionary \
R=g.morbida.scaffolds.fasta \
O=g.morbida.scaffolds.dict
```
####add headers to the bam files
```
for f in `ls *.bam`
do
```
####store RGLB in $e variable
```
e=$(echo $f | cut -d '.' -f 1)
```
####store RGPU in $l variable
```
l=$(head -n1 ../../raw_data/${e}_S*_L001_R1_001.fastq | cut -f 1 -d ' ')
```
####run picard tools
```
java -jar /lustre/projects/staton/software/picard-tools-2.1.0/picard.jar \
AddOrReplaceReadGroups \
I=$f \
O=$f.fix \
RGSM=$e \
RGLB=$e \
RGPL=illumina \
RGPU=$l
done
```
####get rid of .bam links and rename the .fix to .bam
```
rm -f *.bam
rename .bam.fix .bam *.fix
```
####create an index for each of the new bam files
```
module load samtools
for f in `ls *.bam`
do
samtools index $f
done
```
---
####Realign SNPs using GATK
```
for f in `ls *.bam`
do
e=$(echo $f | cut -d '.' -f 1)
java -Xmx50g -jar /lustre/projects/staton/software/GenomeAnalysisTK-3.5-0/GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-R g.morbida.scaffolds.fasta \
-I $f \
-o $e.intervals &
done
```
---
####Realign around indels using GATK
```
for f in `ls *.bam`
do
e=$(echo $f | cut -d '.' -f 1)
java -Xmx20g -jar /lustre/projects/staton/software/GenomeAnalysisTK-3.5-0/GenomeAnalysisTK.jar \
-T IndelRealigner \
-R g.morbida.scaffolds.fasta \
-I $f \
-targetIntervals $e.intervals \
-o ${e}_realigned.bam &
done
```
---
####Mark duplicates using picard tools
```
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
```
---
####Index using samtools
```
module load samtools
for f in `ls *_realigned_mDup.bam`
do
samtools index $f &
done
```
---
####Realign around deduped SNPs using GATK
```
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
```
---
####Realign around deduped indels using GATK
```
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
```
---
####Fix headers in the bam files and reindex them 
```
module load samtools
samtools view -H GM108_realigned_mDup_realigned.bam > header.sam
sed 's/ID:1/ID:2/g' header.sam > header_fix.sam
samtools reheader header_fix.sam GM108_realigned_mDup_realigned.bam > 2.bam
samtools index 2.bam
samtools view -H GM188_realigned_mDup_realigned.bam > header.sam
sed 's/ID:1/ID:3/g' header.sam > header_fix.sam
samtools reheader header_fix.sam GM188_realigned_mDup_realigned.bam > 3.bam
samtools index 3.bam
samtools view -H GM17_realigned_mDup_realigned.bam > header.sam
sed 's/ID:1/ID:4/g' header.sam > header_fix.sam
samtools reheader header_fix.sam GM17_realigned_mDup_realigned.bam > 4.bam
samtools index 4.bam
samtools view -H GM205_realigned_mDup_realigned.bam > header.sam
sed 's/ID:1/ID:5/g' header.sam > header_fix.sam
samtools reheader header_fix.sam GM205_realigned_mDup_realigned.bam > 5.bam
samtools index 5.bam
cp GM20_realigned_mDup_realigned.bam 1.bam
samtools index 1.bam
rm -f header.sam header_fix.sam tmp.bam
```
---
####merge bam files
```
module load samtools
samtools merge 09_TEST3.bam *realigned_mDup_realigned.bam
```
---
####Call variants using freebayes setting the ploidy level @ 1
```
#./freebayes -f g.morbida.scaffolds.fasta -p 1 g.morbida.aligned.bam > g.morbida.freebayes.vcf
#./freebayes -f g.morbida.scaffolds.fasta -p 1 g.morbida.aligned.bam > g.morbida.10.freebayes.vcf
./freebayes -f g.morbida.scaffolds.fasta -p 1 09_TEST3.bam > 10_TEST.vcf >& OTHER
```
---
####shows genes that overlap with snps
```
./intersectBed -a g.morbida.genes.gff -b g.morbida.freebayes.vcf  
```
---
####shows snps that overlap with genes
```
./intersectBed -b g.morbida.genes.gff -a g.morbida.freebayes.vcf  
```
####shows snps that overlap with these specific genes
```
grep "Znfx1" g.morbida.genes.gff > Znfx1.gff
./intersectBed -b Znfx1.gff -a g.morbida.freebayes.vcf
grep "GLI2" g.morbida.genes.gff > GLI2.gff
./intersectBed -b GLI2.gff -a g.morbida.freebayes.vcf
grep "casA" g.morbida.genes.gff > casA.gff
./intersectBed -b casA.gff -a g.morbida.freebayes.vcf
```
---
####calling stats using bcftools
```
./bcftools stats -F g.morbida.scaffolds.fasta -s - g.morbida.vcf.gz > g.morbida.vcf.stats
mkdir plots
./plot-vcfstats -p plots/ g.morbida.vcf.stats 
```
####need to use a different version of python to generate plots
```
/lustre/projects/staton/software/ActivePython-2.7.8/bin/python plots/plot.py
```
---
####use bcftools to filter LOWQUAL SNPs
```
./bcftools filter -O z -o g.morbida.freebayes.filtered.vcf.gz -s LOWQUAL -i'%QUAL>100' g.morbida.freebayes.vcf
gunzip g.morbida.freebayes.filtered.vcf.gz
```
---
####extract pathogenic SNPs using data from MacManes paper, http://biorxiv.org/content/early/2016/01/08/036285.full-text.pdf+html, (see line 222)
```
wget https://goo.gl/SZA4Kd
mv SZA4Kd g.morbida.phibase.e1E-6
sed 's/-mRNA-1//g' g.morbida.phibase.e1E-6 | cut -f 1 > g.morbida.pathogenic.txt
grep -Fwf g.morbida.pathogenic.txt g.morbida.genes.gff > g.morbida.pathogenic.gff
cut -f 1,4,5,9 g.morbida.pathogenic.gff > g.morbida.pathogenic.bed
```
####run intersect bed to pull out relevant SNPs
```
./intersectBed -b g.morbida.pathogenic.bed -a g.morbida.freebayes.filtered.vcf > g.morbida.pathogenic.vcf
```
####cleanup
```
rm -f g.morbida.pathogenic.txt g.morbida.phibase.e1E-6
```
---
####Use SNPeff to classify variants into categories based on expected effect on reading frame
```
```
####start by removing entries that have the LOWQUAL mark
```
grep -v "LOWQUAL" g.morbida.pathogenic.vcf > g.morbida.pathogenic.filt.vcf
grep -v "LOWQUAL" g.morbida.freebayes.vcf > g.morbida.freebayes.filt.vcf
grep -v "LOWQUAL" g.morbida.freebayes.genes.vcf > g.morbida.freebayes.genes.filt.vcf
```
####SNPeff on just pathogenic variants
```
java -jar /lustre/projects/staton/software/snpEff/snpEff.jar eff -csvStats g.morbida.pathogenic.snpEff.csv -s g.morbida.pathogenic.snpEff.html g.morbida g.morbida.pathogenic.filt.vcf > g.morbida.pathogenic.snpEff.vcf
```
####SNPeff on all variants
```
java -jar /lustre/projects/staton/software/snpEff/snpEff.jar eff -csvStats g.morbida.freebayes.snpEff.csv -s g.morbida.freebayes.snpEff.html g.morbida g.morbida.freebayes.filt.vcf > g.morbida.freebayes.snpEff.vcf
```
####SNPeff on variants that overlap with genes
```
java -jar /lustre/projects/staton/software/snpEff/snpEff.jar eff -csvStats g.morbida.freebayes.genes.snpEff.csv -s g.morbida.freebayes.genes.snpEff.html g.morbida g.morbida.freebayes.genes.filt.vcf > g.morbida.freebayes.genes.snpEff.vcf
```
---
####use vcf tools to create plink format
```
#sed 's/scaffold_//g' g.morbida.pathogenic.snpEff.vcf > g.morbida.pathogenic.plink.vcf.tmp
```
####was missing a vcfheader let's add that back in
```
#cat vcf.header.txt g.morbida.pathogenic.plink.vcf.tmp > g.morbida.pathogenic.plink.vcf
#/lustre/projects/staton/software/vcftools_0.1.12a/bin/vcftools \
#--vcf g.morbida.pathogenic.plink.vcf \
#--out 17_pathogenic \
#--plink
sed 's/scaffold_//g' g.morbida.freebayes.vcf > g.morbida.freebayes.plink.vcf
/lustre/projects/staton/software/vcftools_0.1.12a/bin/vcftools \
--vcf g.morbida.freebayes.plink.vcf \
--out 17_freebayes \
--plink
```
---
####Use plink to generate mds plots (output mds plots in R)
```
/lustre/projects/staton/software/plink-1.07-x86_64/plink \
--file 17_freebayes --genome --noweb
mv plink.genome 18_freebayes.genome
rm -f plink.log
/lustre/projects/staton/software/plink-1.07-x86_64/plink \
--file 17_freebayes --read-genome 18_freebayes.genome --mds-plot 4 --noweb
mv plink.mds 18_freebayes.mds
rm -f plink.nosex plink.log
#/lustre/projects/staton/software/plink-1.07-x86_64/plink \
#--file 17_pathogenic --genome --noweb
#mv plink.genome 18_pathogenic.genome
#mv plink.noxex 18_pathogenic.nosex
#rm -f plink.log
#/lustre/projects/staton/software/plink-1.07-x86_64/plink \
#--file 17_pathogenic --read-genome 18_pathogenic.genome --mds-plot 4 --noweb
```
---
####Cleanup directory
```
rm -f *.intervals *_realigned.* *_metrics.txt *.sorted.bam*
```
---
####Use SNPeff to classify variants into categories based on expected effect on reading frame
```
```
####GM108	GM17	GM188	GM205	GM20
```
cut -f 1-10 g.morbida.freebayes.filt.vcf > GM108.freebayes.vcf
cut -f 1-9,11 g.morbida.freebayes.filt.vcf > GM17.freebayes.vcf
cut -f 1-9,12 g.morbida.freebayes.filt.vcf > GM188.freebayes.vcf
cut -f 1-9,13 g.morbida.freebayes.filt.vcf > GM205.freebayes.vcf
cut -f 1-9,14 g.morbida.freebayes.filt.vcf > GM20.freebayes.vcf
```
####SNPeff on all variants
```
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
```
---
