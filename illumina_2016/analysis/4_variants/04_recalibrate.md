echo "Cannot recalibrate without having known SNPs, ie a VCF file."
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
