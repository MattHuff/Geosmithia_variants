#!/bin/bash
# Call variants using freebayes setting the ploidy level @ 1
#./freebayes -f g.morbida.scaffolds.fasta -p 1 g.morbida.aligned.bam > g.morbida.freebayes.vcf
#./freebayes -f g.morbida.scaffolds.fasta -p 1 g.morbida.aligned.bam > g.morbida.10.freebayes.vcf
./freebayes -f g.morbida.scaffolds.fasta -p 1 09_TEST3.bam > 10_TEST.vcf >& OTHER
