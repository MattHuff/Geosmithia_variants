grep -v "LOWQUAL" g.morbida.pathogenic.vcf > g.morbida.pathogenic.filt.vcf
java -jar /lustre/projects/staton/software/snpEff/snpEff.jar eff -csvStats g.morbida.pathogenic.snpEff.csv -s g.morbida.pathogenic.snpEff.html g.morbida g.morbida.pathogenic.filt.vcf > g.morbida.pathogenic.snpEff.vcf
java -jar /lustre/projects/staton/software/snpEff/snpEff.jar eff -csvStats g.morbida.freebayes.snpEff.csv -s g.morbida.freebayes.snpEff.html g.morbida g.morbida.freebayes.filt.vcf > g.morbida.freebayes.snpEff.vcf
java -jar /lustre/projects/staton/software/snpEff/snpEff.jar eff -csvStats g.morbida.freebayes.genes.snpEff.csv -s g.morbida.freebayes.genes.snpEff.html g.morbida g.morbida.freebayes.filt.genes.vcf > g.morbida.freebayes.genes.snpEff.vcf
```
