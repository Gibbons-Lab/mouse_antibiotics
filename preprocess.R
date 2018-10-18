# Preprocess reads

library(mbtools)

reads <- find_illumina("raw")
out <- file.path("filtered", basename(reads$forward))
passed <- filterAndTrim(reads$forward, out, trimLeft=2, maxEE=2, multithread=T)
fwrite(passed, "preprocess.csv")
