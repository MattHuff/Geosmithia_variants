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
