library(mbtools)
options(mc.cores = 20)

config <- list(
    align = config_align(
        reference = "data/rnaseq/spades/transcripts.fasta",
        alignment_dir = "data/rnaseq/txalign"),
    count = config_count(
        reference = "data/rnaseq/spades/transcripts.fasta"),
	threads = 4
)

pattern <- "(.+)\\.fastq"
anns = c("id")

# Run metaspades to get the transcripts
if (!file.exists(config$align$reference)) {
  args <- c("--rna", "--dataset", "spades.yml", "-o",
            "data/rnaseq/spades", "-t", getOption("mc.cores", 1))
  ret <- system2("spades.py", args = args)
  if (ret != 0) {
      stop("Failed running rnaspades.")
  }
}

# Align to M5NR with diamond
if (!file.exists("data/rnaseq/refs/md5nr.dmnd")) {
    args <- c("makedb", "--in", "data/rnaseq/refs/md5nr.gz",
              "-p", config$align$threads,
              "-d", "data/rnaseq/refs/md5nr")
    ret <- system2("diamond", args = args)
    if (ret != 0) {
      stop("Failed building diamond M5NR database.")
    }
}
if (!file.exists("data/rnaseq/spades2m5nr.m8")) {
    args <- c("blastx", "-d", "data/rnaseq/refs/md5nr",
              "-q", "data/rnaseq/spades/transcripts.fasta",
              "-o", "data/rnaseq/spades2m5nr.m8",
              "-p", config$align$threads)
    ret <- system2("diamond", args = args)
    if (ret != 0) {
      stop("Failed aligning with diamond.")
    }
}

files <- find_read_files("data/rnaseq/filtered", pattern, anns)
files[, sample := id]
files[, lane := 1]
files[, id := paste0(id, "_", lane)]
counts <- files %>% align_short_reads(config$align) %>%
          count_references(config$count)
fwrite(counts$alignments, "data/rnaseq/txalignments.csv")
fwrite(counts$counts, "data/rnaseq/txcounts.csv")
