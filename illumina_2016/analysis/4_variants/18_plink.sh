#!/bin/bash
# Use plink to generate mds plots (output mds plots in R)
/lustre/projects/staton/software/plink-1.07-x86_64/plink \
--file 17_freebayes --genome --noweb
mv plink.genome 18_freebayes.genome
rm -f plink.log
/lustre/projects/staton/software/plink-1.07-x86_64/plink \
--file 17_freebayes --read-genome 18_freebayes.genome --mds-plot 4 --noweb
mv plink.mds 18_freebayes.mds
rm -f plink.nosex plink.log

#/lustre/projects/staton/software/plink-1.07-x86_64/plink \
#--file 17_pathogenic --genome --noweb
#mv plink.genome 18_pathogenic.genome
#mv plink.noxex 18_pathogenic.nosex
#rm -f plink.log
#/lustre/projects/staton/software/plink-1.07-x86_64/plink \
#--file 17_pathogenic --read-genome 18_pathogenic.genome --mds-plot 4 --noweb
