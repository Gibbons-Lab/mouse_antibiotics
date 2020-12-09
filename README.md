This repository contains computational protocols and additional data
for the manuscript

*Non-responder phenotype reveals apparent microbiome-wide antibiotic tolerance in the murine gut.*<br>
by Christian Diener#, Anna H. Hoge#, Sean M. Kearney, Ulrike Kusebauch, Sushmita Patwardhan, Robert L. Moritz, Susan E. Erdman, and Sean M. Gibbons.
[Link to Preprint](https://www.biorxiv.org/content/10.1101/566190v1.abstract)
## Installation and setup

Most of the analysis is run in R and some external tools. In general you need:

- R
- [mbtools](https://github.com/gibbons-lab/mbtools)
- samtools
- bowtie2
- minimap2
- spades

We provide a conda environment file that will get you 95% there in [mouse_antibiotics.yml]. If you don't have
conda installed you will first need to download and install [Anaconda](https://www.anaconda.com/distribution/) or [miniconda](https://docs.conda.io/en/latest/miniconda.html). After installing you can run the following in a Terminal
or the conda prompt to install all dependencies in a conda environment and activate the environment.

```bash
conda create -n mouse_antibiotics -f mouse_antibiotics.yml
source activate mouse_antibiotics
```

You can now run all commands in that environment. Alternatively you can install all of the dependencies 
any other way. 

Finally install mbtools:

```bash
Rscript -e "devtools::install_github('gibbons-lab/mbtools')"
```

## Workflow steps

Workflow steps are either Rnotebooks or R scripts. All should be run from the top of this repository 
(where you see the scripts). To run any of the scripts in your environment you can use:

```bash
Rscript script.R
```

The notebooks can be used by opening the repository in [Rstudio](https://www.rstudio.com/)
or by rendering them directly with

```bash
Rscript -e "rmarkdown::render('notebook.Rmd')"
```

### 16S amplicon sequencing

The steps are separated into R notebooks and the output can be inspected online here without running them.
If you do run them please make sure to go through them in order.

1. Infer sequence variants and abundances for the duration experiment - [notebook](asvs_duration.Rmd)  [output](https://gibbons-lab.github.io/mouse_antibiotics/asvs_duration.nb.html)
2. Infer sequence variants and abundances for the seaweed experiment - [notebook](asvs_seaweed.Rmd)  [output](https://gibbons-lab.github.io/mouse_antibiotics/asvs_seaweed.nb.html)
3. Annotate the data with additional metadata - [notebook](preprocessing.Rmd) [output](https://gibbons-lab.github.io/mouse_antibiotics/preprocessing.nb.html)
4. Run all analyses for the duration experiment - [notebook](duration.Rmd) [output](https://gibbons-lab.github.io/mouse_antibiotics/duration.nb.html)
5. Run all analyses for the seaweed experiment - [notebook](seaweed.Rmd) [output](https://gibbons-lab.github.io/mouse_antibiotics/seaweed.nb.html) 

As a side effect this will recreate all the figures in the figures sub-folder.

### Metatranscriptome analysis

Some of the heavier steps are provided as scripts to facilitate use on servers or cluster
systems (steps 1-3). All downstream analysis steps after *de novo* assembly and alignments are provided as notebooks 
again. The following steps were performed:

1. Download raw data, databases and references - [script](download_rnaseq.R)
2. Apply quality filtering to the reads and remove mouse and ribosomal RNA - [script](preprocess_rnaseq.R)
3. Assemble transcripts, map them to M5NR, align the filtered reads to the transcripts and count transcript abundances - [script](txcount.R)
5. Join the transcripts with M5NR-based SEED subsystem annotations - [notebook](annotations.Rmd)  [output](https://gibbons-lab.github.io/mouse_antibiotics/annotations.nb.html)
6. Perform basic quality assessment and association analyses for the transcripts - [notebook](transcripts.Rmd) [output](https://gibbons-lab.github.io/mouse_antibiotics/transcripts.nb.html)
7. Perform functional association analyses based on SEED annotations - [notebook](functional.Rmd) [output](https://gibbons-lab.github.io/mouse_antibiotics/functional.nb.html)
