./samtools mpileup -t AD,DP -go g.morbida.bcf -f g.morbida.scaffolds.fasta 1.bam 2.bam 3.bam 4.bam 5.bam
####samtools mpileup -go g.morbida.bcf -f g.morbida.scaffolds.fasta *realigned_mDup_realigned.bam
```
```
####samtools mpileup -ugf g.morbida.scaffolds.fasta *realigned_mDup_realigned.bam |\
```
```
####./bcftools call -vmO z -o g.morbida.vcf.gz
```
```
