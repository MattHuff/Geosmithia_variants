#!/bin/bash
module load samtools
samtools merge 09_TEST3.bam *realigned_mDup_realigned.bam
