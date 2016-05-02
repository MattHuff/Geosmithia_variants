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
