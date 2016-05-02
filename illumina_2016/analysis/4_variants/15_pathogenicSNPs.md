sed 's/-mRNA-1//g' g.morbida.phibase.e1E-6 | cut -f 1 > g.morbida.pathogenic.txt
grep -Fwf g.morbida.pathogenic.txt g.morbida.genes.gff > g.morbida.pathogenic.gff
cut -f 1,4,5,9 g.morbida.pathogenic.gff > g.morbida.pathogenic.bed
./intersectBed -b g.morbida.pathogenic.bed -a g.morbida.freebayes.filtered.vcf > g.morbida.pathogenic.vcf
```
