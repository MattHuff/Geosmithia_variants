#!/bin/bash
# Use SNPeff to classify variants into categories based on expected effect on reading frame
# start by removing entries that have the LOWQUAL mark
grep -v "LOWQUAL" g.morbida.pathogenic.vcf > g.morbida.pathogenic.filt.vcf
grep -v "LOWQUAL" g.morbida.freebayes.vcf > g.morbida.freebayes.filt.vcf
grep -v "LOWQUAL" g.morbida.freebayes.genes.vcf > g.morbida.freebayes.genes.filt.vcf
# SNPeff on just pathogenic variants
java -jar /lustre/projects/staton/software/snpEff/snpEff.jar eff -csvStats g.morbida.pathogenic.snpEff.csv -s g.morbida.pathogenic.snpEff.html g.morbida g.morbida.pathogenic.filt.vcf > g.morbida.pathogenic.snpEff.vcf
# SNPeff on all variants
java -jar /lustre/projects/staton/software/snpEff/snpEff.jar eff -csvStats g.morbida.freebayes.snpEff.csv -s g.morbida.freebayes.snpEff.html g.morbida g.morbida.freebayes.filt.vcf > g.morbida.freebayes.snpEff.vcf
# SNPeff on variants that overlap with genes
java -jar /lustre/projects/staton/software/snpEff/snpEff.jar eff -csvStats g.morbida.freebayes.genes.snpEff.csv -s g.morbida.freebayes.genes.snpEff.html g.morbida g.morbida.freebayes.genes.filt.vcf > g.morbida.freebayes.genes.snpEff.vcf
