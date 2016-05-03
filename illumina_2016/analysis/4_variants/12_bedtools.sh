#!/bin/bash
# shows snps that overlap with genes
./intersectBed -b g.morbida.genes.gff -a g.morbida.freebayes.vcf  
# shows snps that overlap with these specific genes
grep "Znfx1" g.morbida.genes.gff > Znfx1.gff
./intersectBed -b Znfx1.gff -a g.morbida.freebayes.vcf
grep "GLI2" g.morbida.genes.gff > GLI2.gff
./intersectBed -b GLI2.gff -a g.morbida.freebayes.vcf
grep "casA" g.morbida.genes.gff > casA.gff
./intersectBed -b casA.gff -a g.morbida.freebayes.vcf
