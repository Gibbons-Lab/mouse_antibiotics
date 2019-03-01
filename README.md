This repository contains computational protocols and additional data
for the manuscript

*Non-responder phenotype reveals microbiome-wide antibiotic resistance in the murine gut.*<br>
by Christian Diener#, Anna H. Hoge#, Sean M. Kearney, Susan E. Erdman, and Sean M. Gibbons

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

### 16S amplicon sequencing

The steps are separated into R notebooks and the output can be inspected online here without running them.
If you do run them please make sure to go through them in order.

1. Infer sequence variants and abundances for the duration experiment - [output](https://gibbons-lab.github.io/mouse_antibioticsasvs_duration.nb.html)
2. Infer sequence variants and abundances for the seaweed experiment - [output](https://gibbons-lab.github.io/mouse_antibioticsasvs_seaweed.nb.html)
3. Annotate the data with additional metadata - [output](https://gibbons-lab.github.io/mouse_antibioticspreprocessing.nb.html)
4. Run all analyses for the duration experiment - [output](https://gibbons-lab.github.io/mouse_antibioticsduration.nb.html)
5. Annotate the data with additional metadata - [output](https://gibbons-lab.github.io/mouse_antibioticsseaweed.nb.html) 

As a side effect this will recreate all the figures in the figures sub-folder.

### Metatranscriptome analysis

*under construction* :construction:

Some of the heavier steps are provided as scripts to facilitate use on servers or cluster
systems. All downstream analysis steps after *de novo* asselbly are provided as notebooks 
again. The following steps were performed:

1. Apply quality filtering to the reads and remove mouse and ribosomal RNA - [script](preprocess_rnaseq.R)
2. Build *de novo* transcript assemblies with metaspades
3. Align the filtered reads to the transcripts and count transcript abundances - [script](txcount.R)
4. Map the transcripts to the M5NR database with diamond
5. Join the transcripts with M5NR-based SEED subsystem annotations - [output](https://gibbons-lab.github.io/mouse_antibioticsannotations.nb.html)
6. Perform basic quality assessment and association analyses for the transcripts - [output](https://gibbons-lab.github.io/mouse_antibioticstranscripts.nb.html)
7. Perform functional association analyses based on SEED annotations - [output](https://gibbons-lab.github.io/mouse_antibioticsfunctional.nb.html)