#!/bin/bash
# use bcftools to filter LOWQUAL SNPs
./bcftools filter -O z -o g.morbida.freebayes.filtered.vcf.gz -s LOWQUAL -i'%QUAL>100' g.morbida.freebayes.vcf
gunzip g.morbida.freebayes.filtered.vcf.gz
