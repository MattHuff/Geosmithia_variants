#!/bin/bash
# link important files, make sure to module load samtools to run bam2cfg.pl
ln -s /lustre/projects/staton/software/breakdancer/breakdancer-1.2/build/bin/breakdancer-max ./
ln -s /lustre/projects/staton/software/breakdancer/breakdancer-1.2/perl/bam2cfg.pl ./
ln -s /lustre/projects/staton/software/breakdancer/breakdancer-1.2/perl/AlnParser.pm ./
ln -s ../3_map/*.bam ./
