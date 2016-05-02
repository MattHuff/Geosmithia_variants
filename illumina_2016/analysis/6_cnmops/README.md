01_cnmops.sh
####install software
```
source("http://bioconductor.org/biocLite.R")
biocLite("cn.mops")
```
####load needed libraries
```
library(cn.mops)
```
####switch to correct directory
```
setwd("~/26_gMorbidaSNPs/CNV_cnmops")
sampleNames <-c("GM108.sorted.bam","GM17.sorted.bam","GM188.sorted.bam","GM20.sorted.bam","GM205.sorted.bam")
seqNames<-c("scaffold_0","scaffold_1")
```
####get input from BAM files
```
BAMFiles <- list.files(pattern=".bam$")
bamDataRanges <- getReadCountsFromBAM(BAMFiles,mode="paired",refSeqName=seqNames,sampleNames=sampleNames)
```
####run algorithm
```
res <- cn.mops(bamDataRanges, norm = 1)
```
####visualize results
```
plot(res,which=1)
```
---
