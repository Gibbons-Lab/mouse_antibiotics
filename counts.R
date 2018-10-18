# Align reads to resistance gene DB and count genes

library(mbtools)
library(stringr)

reads <- find_illumina("filtered")
reads$id <- paste0(reads$id, "_", reads$lane)
alns <- align_bowtie2(reads, "ref/resistance_genes", threads=30)
counts <- count_hits(alns$alignment)
counts <- counts[, sum(counts), by=c("seqnames", "sample")]
ids <- as.character(id(ShortRead::readFasta("../resistance_genes.csv")))
ids <- as.data.table(str_split(ids, " ", n=2, simplify=T))
names(ids) <- c("seqnames", "description")
counts <- split[counts, on="seqnames"]
fwrite(counts, "counts.csv")
