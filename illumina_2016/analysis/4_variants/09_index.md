#### index again
```
module load samtools
for f in `ls *_realigned_mDup_realigned.bam`
do
samtools index $f &
done
```
