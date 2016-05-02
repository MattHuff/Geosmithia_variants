#### Index using samtools
```
module load samtools
for f in `ls *_realigned_mDup.bam`
do
samtools index $f &
done
```
