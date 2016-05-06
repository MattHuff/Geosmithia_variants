#!/bin/bash
# this script is used to build T5
cut -f 1,2 ../../raw_data/g.morbida.phibase.e1E-6 > ./phibaseRef.txt
grep "stop_gained" g.morbida.pathogenic.snpEff.vcf | cut -f 1,2,4,5,10- | sed 's/1:[^\t]*/1/g' | sed 's/0:[^\t]*/0/g' | sed 's/\.:[^\t]*/\./g' > tmp1
grep "stop_gained" g.morbida.pathogenic.snpEff.vcf | cut -f 8 | cut -d '|' -f 2-4 | sed 's/|/\t/g' > tmp2
cut -f 3 tmp2 > tmp3
cut -f 1 tmp2 > tmp4
grep -Fwf tmp3 phibaseRef.txt > tmp5
paste tmp5 tmp4 tmp1
rm -f tmp1 tmp2 tmp3 tmp4 tmp5
grep "stop_lost" g.morbida.pathogenic.snpEff.vcf | cut -f 1,2,4,5,10- | sed 's/1:[^\t]*/1/g' | sed 's/0:[^\t]*/0/g' | sed 's/\.:[^\t]*/\./g' > tmp1
grep "stop_lost" g.morbida.pathogenic.snpEff.vcf | cut -f 8 | cut -d '|' -f 2-4 | sed 's/|/\t/g' > tmp2
cut -f 3 tmp2 > tmp3
cut -f 1 tmp2 > tmp4
grep -Fwf tmp3 phibaseRef.txt > tmp5
paste tmp5 tmp4 tmp1
rm -f tmp1 tmp2 tmp3 tmp4 tmp5
