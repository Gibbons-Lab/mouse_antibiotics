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

# Run metaspades to get the transcripts
if (!file.exists(config$align$reference)) {
  args <- c("--rna", "--dataset", "data/rnaseq/spades.yml", "-o", 
            "data/rnaseq/spades", "-t", config$align$threads)
  ret <- system2("spades.py", args = args)
  if (ret != 0) {
      stop("Failed running rnaspades.")
  }
} 

# Align to M5NR with diamond
if (!file.exists("data/rnaseq/m5nr.dmnd")) {
    args <- c("makedb", "--in", "data/rnaseq/refs/m5nr.gz",
              "-p", config$align$threads,
              "-d", "data/rnaseq/refs/m5nr")
    ret <- system2("diamond", args = args)
    if (ret != 0) {
      stop("Failed building diamond M5NR database.")
    }
}
if (!file.exists("data/rnaseq/spades2m5nr.m8")) {
    args <- c("blastx", "-d", "data/rnaseq/refs/m5nr", 
              "-q", "data/rnaseq/spades/transcripts.fasta",
              "-o", "data/rnaseq/spades2m5nr.m8", 
              "-p", config$align$threads)
    if (ret != 0) {
      stop("Failed aligning with diamond.")
    }
}

files <- find_read_files("data/rnaseq/filtered")
files[, sample := id]
files[, id := paste0(id, "_", lane)]
counts <- files %>% align_short_reads(config$align) %>% 
          count_transcripts(config$count)
fwrite(counts$alignments, "data/rnaseq/txalignments.csv")
fwrite(counts$counts, "data/rnaseq/txcounts.csv")
