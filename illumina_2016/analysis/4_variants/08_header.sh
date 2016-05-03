#!/bin/bash
# Fix headers in the bam files and reindex them 
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
