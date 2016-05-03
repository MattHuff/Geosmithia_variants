#!/bin/bash
# extract pathogenic SNPs using data from MacManes paper, http://biorxiv.org/content/early/2016/01/08/036285.full-text.pdf+html, (see line 222)
wget https://goo.gl/SZA4Kd
mv SZA4Kd g.morbida.phibase.e1E-6
sed 's/-mRNA-1//g' g.morbida.phibase.e1E-6 | cut -f 1 > g.morbida.pathogenic.txt
grep -Fwf g.morbida.pathogenic.txt g.morbida.genes.gff > g.morbida.pathogenic.gff
cut -f 1,4,5,9 g.morbida.pathogenic.gff > g.morbida.pathogenic.bed
# run intersect bed to pull out relevant SNPs
./intersectBed -b g.morbida.pathogenic.bed -a g.morbida.freebayes.filtered.vcf > g.morbida.pathogenic.vcf
# cleanup
rm -f g.morbida.pathogenic.txt g.morbida.phibase.e1E-6
