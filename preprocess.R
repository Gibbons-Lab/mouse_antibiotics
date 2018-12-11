# Preprocess reads

library(mbtools)

reads <- find_illumina("raw")
out <- file.path("filtered", basename(reads$forward))
quals <- plotQualityProfile(sample(reads$forward, 3), aggregate = TRUE)
ggsave("figures/qualities.png")
if (!dir.exists("filtered")) {
    passed <- filterAndTrim(reads$forward, out,
                            trimLeft = 5, maxEE = 1, multithread = TRUE)
    passed$fraction <- passed$reads.out / passed$reads.in
    fwrite(passed, "preprocess.csv")
}


# Remove mouse and ribosomal reads
if (!dir.exists("no_host_ribosomal")) {
refs <- "/proj/gibbons/refs"
    reads <- find_illumina("filtered")
    mouse_hits <- filter_reference(reads, "no_mouse",
                                file.path(refs, "mus_musculus_rna.fna.gz"),
                                threads = 20)
    fwrite(mouse_hits, "mouse_counts.csv")
    reads <- find_illumina("no_mouse")
    ribo_hits <- filter_reference(reads, "no_host_ribosomal",
                                  file.path(refs, "silva_dna_132.fna.gz"),
                                  threads = 20)
    fwrite(ribo_hits, "ribo_hits.csv")
    unlink("no_mouse", TRUE)
}
