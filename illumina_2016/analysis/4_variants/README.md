#### create links to relevant files
```
ln -s ../../raw_data/g.morbida.scaffolds.fasta ./
ln -s ../../raw_data/g.morbida.scaffolds.fasta.fai ./
ln -s ../../raw_data/g.morbida.gff ./
ln -s ../3_map/*.bam ./
ln -s /lustre/projects/staton/software/bcftools-1.2/bcftools ./
ln -s /lustre/projects/staton/software/samtools-1.3/htslib-1.3/tabix ./
ln -s /lustre/projects/staton/software/bcftools-1.2/plot-vcfstats ./
ln -s /lustre/projects/staton/software/freebayes_1.0.2-15/bin/freebayes ./
ln -s /lustre/projects/staton/software/samtools-1.3/samtools ./
ln -s /lustre/projects/staton/software/bedtools-2.25/bin/intersectBed ./
ln -s /lustre/projects/staton/software/bedtools-2.25/bin/bedtools ./
```
#### create a sequence dictionary for the reference
```
module load java/jdk8u5
java -jar /lustre/projects/staton/software/picard-tools-2.1.0/picard.jar \
CreateSequenceDictionary \
R=g.morbida.scaffolds.fasta \
O=g.morbida.scaffolds.dict
```
#### add headers to the bam files
```
for f in `ls *.bam`
do
```
#### RGLB
```
e=$(echo $f | cut -d '.' -f 1)
```
#### RGPU
```
l=$(head -n1 ../../raw_data/${e}_S*_L001_R1_001.fastq | cut -f 1 -d ' ')
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
#### get rid of links and rename the .fix to .bam
```
rm -f *.bam
rename .bam.fix .bam *.fix
```
#### create an index for each bam file
```
module load samtools
for f in `ls *.bam`
do
samtools index $f
done
```
#### Realign SNPs using GATK
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
#### Realign around indels using GATK
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
#### Cannot recalibrate without having known SNPs, ie a VCF file.
```
echo "Cannot recalibrate without having known SNPs, ie a VCF file."
```
####for f in `ls *_realigned.bam`
```
```
####do
```
```
####e=$(echo $f | cut -d '.' -f 1)
```
```
####java -Xmx20g -jar /lustre/projects/staton/software/GenomeAnalysisTK-3.5-0/GenomeAnalysisTK.jar \
```
```
####-T BaseRecalibrator \
```
```
####-R g.morbida.scaffolds.fasta \
```
```
####-I $f \
```
```
####-o ${e}_recal.table &
```
```
####done
```
```
#### Mark duplicates using picard tools
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
#### Index using samtools
```
module load samtools
for f in `ls *_realigned_mDup.bam`
do
samtools index $f &
done
```
#### Realign around deduped SNPs using GATK
```
for f in `ls *_realigned_mDup.bam`
do
e=$(echo $f | cut -d '.' -f 1)
java -Xmx50g -jar /lustre/projects/staton/software/GenomeAnalysisTK-3.5-0/GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-R g.morbida.scaffolds.fasta \
-I $f \
-o $e.intervals &
done
```
#### Realign around deduped indels using GATK
```
for f in `ls *_realigned_mDup.bam`
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
#### Fix headers in the bam files and reindex them 
```
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
#### index again
```
module load samtools
for f in `ls *_realigned_mDup_realigned.bam`
do
samtools index $f &
done
```
#### Call variants using freebayes setting the ploidy level @ 1
```
./freebayes -f g.morbida.scaffolds.fasta -p 1 g.morbida.aligned.bam > g.morbida.freebayes.vcf
```
#### Call SNPs using mpileup
```
./samtools mpileup -t AD,DP -go g.morbida.bcf -f g.morbida.scaffolds.fasta 1.bam 2.bam 3.bam 4.bam 5.bam
```
#### shows genes that overlap with snps
```
./intersectBed -a g.morbida.genes.gff -b g.morbida.freebayes.vcf  
```
#### convert vcf to bcf
```
module load samtools
./bcftools call -vmO z -o g.morbida.vcf.gz g.morbida.bcf
```
#### shows snps that overlap with genes
```
./intersectBed -b g.morbida.genes.gff -a g.morbida.freebayes.vcf  
./intersectBed -b Znfx1.gff -a g.morbida.freebayes.vcf
./intersectBed -b GLI2.gff -a g.morbida.freebayes.vcf
./intersectBed -b casA.gff -a g.morbida.freebayes.vcf
```
#### index vcf file
```
module load samtools
./tabix -p vcf g.morbida.vcf.gz
```
#### calling stats using bcftools
```
./bcftools stats -F g.morbida.scaffolds.fasta -s - g.morbida.vcf.gz > g.morbida.vcf.stats
mkdir plots
./plot-vcfstats -p plots/ g.morbida.vcf.stats 
```
#### need to use a different version of python to generate plots
```
/lustre/projects/staton/software/ActivePython-2.7.8/bin/python plots/plot.py
```
#### use bcftools to filter LOWQUAL SNPs
```
./bcftools filter -O z -o g.morbida.freebayes.filtered.vcf.gz -s LOWQUAL -i'%QUAL>100' g.morbida.freebayes.vcf
gunzip g.morbida.freebayes.filtered.vcf.gz
```
./bcftools filter -O z -o g.morbida.filtered.vcf.gz -s LOWQUAL -i'%QUAL>100' g.morbida.vcf.gz
```
#### extract pathogenic SNPs using data from MacManes paper 
```
sed 's/-mRNA-1//g' g.morbida.phibase.e1E-6 | cut -f 1 > g.morbida.pathogenic.txt
grep -Fwf g.morbida.pathogenic.txt g.morbida.genes.gff > g.morbida.pathogenic.gff
cut -f 1,4,5,9 g.morbida.pathogenic.gff > g.morbida.pathogenic.bed
./intersectBed -b g.morbida.pathogenic.bed -a g.morbida.freebayes.filtered.vcf > g.morbida.pathogenic.vcf
```
#### Use SNPeff to classify SNPs into categories based on expected effect on reading frame
```
grep -v "LOWQUAL" g.morbida.pathogenic.vcf > g.morbida.pathogenic.filt.vcf
java -jar /lustre/projects/staton/software/snpEff/snpEff.jar eff -csvStats g.morbida.pathogenic.snpEff.csv -s g.morbida.pathogenic.snpEff.html g.morbida g.morbida.pathogenic.filt.vcf > g.morbida.pathogenic.snpEff.vcf
java -jar /lustre/projects/staton/software/snpEff/snpEff.jar eff -csvStats g.morbida.freebayes.snpEff.csv -s g.morbida.freebayes.snpEff.html g.morbida g.morbida.freebayes.filt.vcf > g.morbida.freebayes.snpEff.vcf
java -jar /lustre/projects/staton/software/snpEff/snpEff.jar eff -csvStats g.morbida.freebayes.genes.snpEff.csv -s g.morbida.freebayes.genes.snpEff.html g.morbida g.morbida.freebayes.filt.genes.vcf > g.morbida.freebayes.genes.snpEff.vcf
```
#### use vcf tools to create plink format
```
sed 's/scaffold_//g' g.morbida.pathogenic.snpEff.vcf > g.morbida.pathogenic.plink.vcf.tmp
cat vcf.header.txt g.morbida.pathogenic.plink.vcf.tmp > g.morbida.pathogenic.plink.vcf
/lustre/projects/staton/software/vcftools_0.1.12a/bin/vcftools \
--vcf g.morbida.pathogenic.plink.vcf \
--plink
sed 's/scaffold_//g' g.morbida.freebayes.vcf > g.morbida.freebayes.plink.vcf
/lustre/projects/staton/software/vcftools_0.1.12a/bin/vcftools \
--vcf g.morbida.freebayes.plink.vcf \
--plink
```
#### Use plink to generate mds plots (output mds plots in R)
```
/lustre/projects/staton/software/plink-1.07-x86_64/plink \
--file out --genome --noweb
/lustre/projects/staton/software/plink-1.07-x86_64/plink \
--file out --read-genome plink.genome --mds-plot 4 --noweb
```
#### Cleanup directory
```
rm -f *.intervals *_realigned.* *_metrics.txt *.sorted.bam*
```
