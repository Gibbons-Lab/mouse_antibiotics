# Preprocess reads

library(mbtools)

SILVA_DB <- paste0("https://www.arb-silva.de/fileadmin/silva_databases/",
                   "current/Exports/SILVA_132_SSURef_tax_silva_trunc.fasta.gz")
MOUSE_DB <- paste0("ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/635/",
                   "GCF_000001635.26_GRCm38.p6/",
                   "GCF_000001635.26_GRCm38.p6_rna.fna.gz")

if (!dir.exists("data/rnaseq/refs")) {
    dir.create("data/rnaseq/refs", recursive = TRUE)
    flog.info("Downloading SILVA ribosomal reference database.")
    download.file(SILVA_DB, "data/rnaseq/refs/silva_dna_132.fna.gz")
    flog.info("Downloading mouse transcript db.")
    download.file(MOUSE_DB, "data/rnaseq/refs/mus_musculus_rna.fna.gz")
}
    
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

reads <- find_read_files("raw")
quals <- quality_control(reads)
ggplot2::ggsave("figures/rnaseq_qualities.png", plot = quals$quality_plot)
if (!dir.exists("filtered")) {
    filtered <- preprocess(quals, config$preprocess)
    fwrite(filtered$passed, "preprocess.csv")
} else {
  filtered <- find_read_files("data/rnaseq/filtered")
}


# Remove mouse and ribosomal reads
filtered <- filtered %>% filter_reference(config$filter_mouse) %>% 
            filter_reference(config$filter_ribosomal)
unlink(config$filter_mouse$out_dir)
