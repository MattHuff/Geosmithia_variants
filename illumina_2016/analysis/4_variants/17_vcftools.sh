#!/bin/bash
# use vcf tools to create plink format
#sed 's/scaffold_//g' g.morbida.pathogenic.snpEff.vcf > g.morbida.pathogenic.plink.vcf.tmp
# was missing a vcfheader let's add that back in
#cat vcf.header.txt g.morbida.pathogenic.plink.vcf.tmp > g.morbida.pathogenic.plink.vcf
#/lustre/projects/staton/software/vcftools_0.1.12a/bin/vcftools \
#--vcf g.morbida.pathogenic.plink.vcf \
#--out 17_pathogenic \
#--plink
sed 's/scaffold_//g' g.morbida.freebayes.vcf > g.morbida.freebayes.plink.vcf
/lustre/projects/staton/software/vcftools_0.1.12a/bin/vcftools \
--vcf g.morbida.freebayes.plink.vcf \
--out 17_freebayes \
--plink

