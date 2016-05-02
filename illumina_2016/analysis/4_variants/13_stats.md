./bcftools stats -F g.morbida.scaffolds.fasta -s - g.morbida.vcf.gz > g.morbida.vcf.stats
mkdir plots
./plot-vcfstats -p plots/ g.morbida.vcf.stats 
#### need to use a different version of python to generate plots
```
/lustre/projects/staton/software/ActivePython-2.7.8/bin/python plots/plot.py
```
