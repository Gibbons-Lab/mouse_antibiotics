# Download files for RNA-Seq analysis

library(mbtools)

# Download references and databases
flog.info("Downloading databases and references.")
dl <- fread("data/database_files.csv") %>% download_files()

# Download sequencing files
flog.info("Downloading raw sequencing files.")
dl <- fread("data/rnaseq_files.csv") %>% download_files(threads = 8)