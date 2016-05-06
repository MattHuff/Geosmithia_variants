#!/bin/bash
# create parsed gtf
grep -v '^#' g.morbida.gtf > g.morbida.filtered.gtf
/lustre/projects/staton/software/vat/gencode2interval < g.morbida.filtered.gtf > g.morbida.interval
#| awk '/\t(HAVANA|ENSEMBL)\t(CDS|start_codon|stop_codon)\t/ {print}' 
#| grep -v mRNA_end_NF | grep -v mRNA_start_NF > g.morbida.filtered.gtf
