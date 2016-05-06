#!/bin/bash
# some annoying steps taken to create VEP database
/lustre/projects/staton/software/cufflinks-2.2.1.Linux_x86_64/gffread g.morbida.gff -T -o g.morbida.gtf
# 
perl /lustre/projects/staton/software/ensembl-tools-release-84/scripts/variant_effect_predictor/gtf2vep.pl -i g.morbida.gtf -f g.morbida.scaffolds.fasta -d 84 -s gmorbida --dir ./gmorbida
