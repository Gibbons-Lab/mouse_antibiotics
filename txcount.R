library(mbtools)

config <- list(
    align = config_align_short(
        reference = "data/rnaseq/spades/transcripts.fasta",
        threads = 32,
        alignment_dir = "data/rnaseq/txalign"),
    count = config_count(
        reference = "data/rnaseq/spades/transcripts.fasta",
        threads = 32)
)

files <- find_read_files("filtered")
files[, sample := id]
files[, id := paste0(id, "_", lane)]
counts <- files %>% align_short_reads(config$align) %>% 
          count_transcripts(config$count)
fwrite(counts$alignments, "txalignments.csv")
fwrite(counts$counts, "txcounts.csv")
