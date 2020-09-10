# Get coefficients from a model
get_coef <- function(model) {
  coef <- data.frame(t(rep(NA, 5)))
  if ("coefficients" %in% names(model)) {
    coef <- model$coefficients
    coef <- cbind(as.data.frame(coef), rownames(coef), stringsAsFactors = FALSE)
    coef <- coef[2, ]
  }
  return(coef)
}

# convert corncob results to a table
results_table <- function(res) {
  table <- data.table(
    taxon = names(res$p),
    pvalue = res$p,
    padj = res$p_fdr,
    coef = sapply(res$all_models, . %>% get_coef %>% `[`(1, 1)),
    se = sapply(res$all_models, . %>% get_coef  %>% `[`(1, 2)),
    variable = sapply(res$all_models, . %>% get_coef  %>% `[`(1, 5))
  )
  return(table)
}

# collapse ASV tables on a chosen rank 
# and filter low abundance or low presence taxa
collapse <- function(ps, rank, min_abundance = 1e-3, presence = 0.9) {
  col <- speedyseq::tax_glom(ps, rank)
  taxa_names(col) <- tax_table(col)[, rank]
  ab <- as(otu_table(col), "matrix")
  ab <- ab[rowSums(ab) > 0 , colSums(ab) > 0]
  if (taxa_are_rows(col)) ab <- t(ab)
  means <- apply(ab, 1, function(x) x / sum(x)) %>% rowMeans()
  present <- colSums(ab > 0.5)
  good <- colnames(ab)[means > min_abundance & present > presence]
  return(prune_taxa(good, col))
}
