# Preprocess reads

library(mbtools)
options(mc.cores = 20)

config <- list(
    preprocess = config_preprocess(
        out_dir = "data/rnaseq/filtered",
        trimLeft = 5,
        trunLen = 75,
        maxEE = 1),
    filter_mouse = config_reference(
        reference = "data/rnaseq/refs/mus_musculus_rna.fna.gz",
        out_dir = "data/rnaseq/no_mouse"
    ),
    filter_ribosomal = config_reference(
      reference = "data/rnaseq/refs/silva_132_dna_nr99.fa.gz",
      out_dir = "data/rnaseq/filtered"
    )
)

# Download sequencing files
if (!dir.exists("data/rnaseq/raw")) {
  flog.info("Downloading raw sequencing files.")
  dl <- fread("data/rnaseq_files.csv") %>% download_files(threads = 8)
}

pattern <- "(.+)\\.fastq"
anns <- c("id")
reads <- find_read_files("data/rnaseq/raw", pattern, anns)
if (!file.exists("figures/rnaseq_qualities.png")) {
    quals <- quality_control(reads)
    ggplot2::ggsave("figures/rnaseq_qualities.png", plot = quals$quality_plot)
}
if (!dir.exists("data/rnaseq/filtered")) {
    filtered <- preprocess(reads, config$preprocess)
    fwrite(filtered$passed, "data/rnaseq/preprocess.csv")
} else {
  filtered <- find_read_files("data/rnaseq/filtered", pattern, anns)
}


# Remove mouse and ribosomal reads
filtered <- filtered %>% filter_reference(config$filter_mouse) %>%
            filter_reference(config$filter_ribosomal)
unlink(config$filter_mouse$out_dir)

# Write file list for metaspades
metaspades <- list(
  type = "single",
  `single reads` = filtered$files$forward
)
yaml::write_yaml(list(metaspades), "spades.yml")
