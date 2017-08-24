## ----geom_gene_arrow, fig.width = 8, fig.height = 8----------------------
library(ggplot2)
library(gggenes)

ggplot2::ggplot(example_genes, ggplot2::aes(xmin = start, xmax = end, y =
                                            molecule, fill = gene)) +
  geom_gene_arrow() +
  ggplot2::facet_wrap(~ molecule, scales = "free", ncol = 1) +
  ggplot2::scale_fill_brewer(palette = "Set3")

## ----theme_genes, fig.width = 8, fig.height = 8--------------------------
ggplot2::ggplot(example_genes, ggplot2::aes(xmin = start, xmax = end, y =
                                            molecule, fill = gene)) +
  geom_gene_arrow() +
  ggplot2::facet_wrap(~ molecule, scales = "free", ncol = 1) +
  ggplot2::scale_fill_brewer(palette = "Set3") +
  theme_genes()

## ----make_alignment_dummies, fig.width = 8, fig.height = 8---------------
dummies <- make_alignment_dummies(
  example_genes,
  ggplot2::aes(xmin = start, xmax = end, y = molecule, id = gene),
  on = "genE"
)

ggplot2::ggplot(example_genes, ggplot2::aes(xmin = start, xmax = end, y =
                                            molecule, fill = gene)) +
  geom_gene_arrow() +
  ggplot2::geom_blank(data = dummies) +
  ggplot2::facet_wrap(~ molecule, scales = "free", ncol = 1) +
  ggplot2::scale_fill_brewer(palette = "Set3") +
  theme_genes()

