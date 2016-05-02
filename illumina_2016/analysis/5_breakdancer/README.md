01_setup.sh
####link important files, make sure to module load samtools to run bam2cfg.pl
```
ln -s /lustre/projects/staton/software/breakdancer/breakdancer-1.2/build/bin/breakdancer-max ./
ln -s /lustre/projects/staton/software/breakdancer/breakdancer-1.2/perl/bam2cfg.pl ./
ln -s /lustre/projects/staton/software/breakdancer/breakdancer-1.2/perl/AlnParser.pm ./
ln -s ../3_map/*.bam ./
```
---
02_bam2cfg.sh
####create a configuration file
```
perl bam2cfg.pl *.bam > g.morbida.cfg
```
---
03_breakdance.sh
####let's run breakdancer
```
./breakdancer-max -t -q 10 g.morbida.cfg > g.morbida2.out
```
---
04_notes.sh
### Notes
Output still looks a bit wonky, need to reheader the bam files for this to work
```
---
