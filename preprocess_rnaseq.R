# Preprocess reads

library(mbtools)
    
config <- list(
    preprocess = config_preprocess(
        threads = TRUE,  # use all cores
        out_dir = "data/rnaseq/filtered",
        trimLeft = 10,
        maxEE = 1),
    filter_mouse = config_reference(
        reference = "data/rnaseq/refs/mus_musculus_rna.fna.gz",
        out_dir = "data/rnaseq/no_mouse"
    ),
    filter_ribosome = config_reference(
      reference = "data/rnaseq/refs/silva_dna_132.fna.gz",
      out_dir = "data/rnaseq/filtered"
    )
)

# Download sequencing files
if (!dir.exists("data/rnaseq/raw")) {
  flog.info("Downloading raw sequencing files.")
  dl <- fread("data/rnaseq_files.csv") %>% download_files(threads = 8)
}

reads <- find_read_files("data/rnaseq/raw")
quals <- quality_control(reads)
ggplot2::ggsave("figures/rnaseq_qualities.png", plot = quals$quality_plot)
if (!dir.exists("filtered")) {
    filtered <- preprocess(quals, config$preprocess)
    fwrite(filtered$passed, "data/rnaseq/preprocess.csv")
} else {
  filtered <- find_read_files("data/rnaseq/filtered")
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
yaml::write_yaml(list(metaspades), "data/rnaseq/spades.yml")