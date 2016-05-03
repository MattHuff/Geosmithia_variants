This R script was run locally.
![Alt text](./Rplot.png?raw=true "Plots")
![Alt text](./GM108seg.png?raw=true "GM108")
![Alt text](./GM17seg.png?raw=true "GM17")
![Alt text](./GM188seg.png?raw=true "GM188")
![Alt text](./GM205seg.png?raw=true "GM205")
![Alt text](./GM20seg.png?raw=true "GM20")
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
