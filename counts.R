# Align reads to resistance gene DB and count genes

library(mbtools)

reads <- find_illumina("filtered")
alns <- align_bowtie2(reads, "ref/resistance_genes")
counts <- count_hits("alignments")
fwrite(counts, "counts.csv")
