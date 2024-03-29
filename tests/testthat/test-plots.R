context("visual tests of plots")
library(ggplot2)

test_that("plots with features look the way they should", {
  expect_doppelganger("Basic plot with features", {
    ggplot(example_genes, aes(xmin = start, xmax = end, y = molecule, fill = gene)) +
      geom_feature(data = example_features, aes(x = position, y = molecule, 
                                                forward = forward)) +
      geom_gene_arrow() +
      facet_wrap(~ molecule, scales = "free", ncol = 1) +
      scale_fill_brewer(palette = "Set3") +
      theme_genes()
  } )

  expect_doppelganger("Basic plot with labelled features", {
    ggplot(example_genes, aes(xmin = start, xmax = end, y = molecule, fill = gene)) +
      geom_feature(data = example_features, aes(x = position, y = molecule, forward = forward, linetype = type, colour = type)) +
      geom_feature_label(data = example_features, aes(x = position, y = molecule, label = name, forward = forward)) +
      geom_gene_arrow() +
      geom_blank(data = example_dummies) +
      facet_wrap(~ molecule, scales = "free", ncol = 1) +
      scale_fill_brewer(palette = "Set3") +
      theme_genes()
  } )

  expect_doppelganger("Plot with features and non-logical 'forward'", {

    ef2 <- example_features
    ef2$forward <- as.numeric(example_features$forward)
    ggplot(example_genes, aes(xmin = start, xmax = end, y = molecule, fill = gene)) +
      geom_feature(data = ef2, aes(x = position, y = molecule, forward = forward)) +
      geom_feature_label(data = ef2, aes(x = position, y = molecule, label = name, 
                                         forward = forward)) +
      geom_gene_arrow() +
      facet_wrap(~ molecule, scales = "free", ncol = 1) +
      scale_fill_brewer(palette = "Set3") +
      theme_genes()
  } )
})

test_that("plots look the way they should", {

  expect_doppelganger("Basic plot", {
    ggplot(example_genes, aes(xmin = start, xmax = end, y = molecule, fill = gene)) +
      geom_gene_arrow() +
      facet_wrap(~ molecule, scales = "free", ncol = 1) +
      scale_fill_brewer(palette = "Set3")
  } )

  expect_doppelganger("Plot with theme_genes", {
    ggplot(example_genes, aes(xmin = start, xmax = end, y = molecule, fill = gene)) +
      geom_gene_arrow() +
      facet_wrap(~ molecule, scales = "free", ncol = 1) +
      scale_fill_brewer(palette = "Set3") +
      theme_genes()
  } )

  expect_doppelganger("Plot with make_alignment_dummies", {
    dummies <- make_alignment_dummies(
      example_genes,
      aes(xmin = start, xmax = end, y = molecule, id = gene),
      on = "genE"
    )

    ggplot(example_genes, aes(xmin = start, xmax = end, y = molecule, fill = gene)) +
      geom_gene_arrow() +
      geom_blank(data = dummies) +
      facet_wrap(~ molecule, scales = "free", ncol = 1) +
      scale_fill_brewer(palette = "Set3") +
      theme_genes()
  } )

  expect_doppelganger("Plot with geom_gene_label", {
    ggplot(
        example_genes,
        aes(xmin = start, xmax = end, y = molecule, fill = gene, label = gene)
      ) +
      geom_gene_arrow(arrowhead_height = unit(3, "mm"), arrowhead_width = unit(1, "mm")) +
      geom_gene_label(align = "left") +
      geom_blank(data = dummies) +
      facet_wrap(~ molecule, scales = "free", ncol = 1) +
      scale_fill_brewer(palette = "Set3") +
      theme_genes()
  } )

  expect_doppelganger("Plot using forward aesthetic", {
    example_genes$direction <- ifelse(example_genes$strand == "forward", 1, 0)
    ggplot(subset(example_genes, molecule == "Genome1"),
                    aes(xmin = start, xmax = end, y = strand, fill = gene,
                        forward = direction)) +
      geom_gene_arrow() +
      theme_genes()
  } )

  expect_doppelganger("Plot with subgenes", {
    ggplot(example_genes, aes(xmin = start, xmax = end, y = molecule)) +
      facet_wrap(~ molecule, scales = "free", ncol = 1) +
      geom_gene_arrow(fill = "white") +
      geom_subgene_arrow(data = example_subgenes,
        aes(xmin = start, xmax = end, y = molecule, fill = gene,
            xsubmin = from, xsubmax = to), color="black", alpha=.7) +
      theme_genes()
  } )

  expect_doppelganger("Plot with labelled subgenes", {
    ggplot(subset(example_genes, molecule == "Genome4" & gene == "genA"),
           aes(xmin = start, xmax = end, y = strand)
      ) +
      geom_gene_arrow() +
      geom_gene_label(aes(label = gene)) +
      geom_subgene_arrow(
        data = subset(example_subgenes, molecule == "Genome4" & gene == "genA"),
        aes(xsubmin = from, xsubmax = to, fill = subgene)
      ) +
      geom_subgene_label(
        data = subset(example_subgenes, molecule == "Genome4" & gene == "genA"),
        aes(xsubmin = from, xsubmax = to, label = subgene),
        min.size = 0
      )
  } )

} )

test_that("plots in flipped coordinates look correct", {

  expect_doppelganger("Plot in flipped coordinates", {
    ggplot(example_genes, aes(xmin = start, xmax = end, y = molecule, fill = gene, label = gene)) +
      geom_feature(
        data = example_features,
        aes(x = position, y = molecule, forward = forward)
      ) +
      geom_feature_label(
        data = example_features,
        aes(x = position, y = molecule, label = name, forward = forward)
      ) +
      geom_gene_arrow() +
      geom_gene_label(min.size = 0) +
      geom_blank(data = example_dummies) +
      facet_wrap(~ molecule, scales = "free", nrow = 1) +
      scale_fill_brewer(palette = "Set3") +
      theme_genes_flipped() +
      coord_flip()

  } )

  expect_doppelganger("Subgene plot in flipped coords", {
    es <- example_subgenes
    es$subgene <- substr(
      es$subgene,
      nchar(es$subgene),
      nchar(es$subgene)
    )
    ggplot(example_genes, aes(xmin = start, xmax = end, y = molecule)) +
      geom_gene_arrow() +
      facet_wrap(~ molecule, scales = "free", nrow = 1) +
      geom_subgene_arrow(
        data = es,
        aes(xsubmin = from, xsubmax = to, fill = subgene)
      ) +
      geom_subgene_label(
        data = es,
        aes(xsubmin = from, xsubmax = to, label = subgene),
        min.size = 0
      ) +
      coord_flip() + theme_genes_flipped()
  } )

} )
