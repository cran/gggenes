#' A 'ggplot2' geom to add text labels to gene arrows
#'
#' `geom_gene_label()` can be used to add a text label to genes drawn with
#' `geom_gene_arrow()`.
#'
#' `geom_gene_label()` uses the 'ggfittext' package to fit text to genes. All
#' text drawing options available in `ggfittext::geom_fit_text()` (growing,
#' reflowing, etc.) are also available here. For full details on how these
#' options work, see the documentation for `ggfittext::geom_fit_text()`.
#'
#' Standard 'ggplot2' aesthetics for text are supported (see Aesthetics).
#'
#' @param padding.x,padding.y `grid::unit()` object, giving horizontal or vertical
#' padding around the text. Defaults to 1 mm and 0.1 lines respectively.
#' @param align Where inside the gene to place the text label. Default is
#' 'centre'; other options are 'left' and 'right'.
#' @param min.size Minimum font size, in points. If provided, text that would
#' need to be shrunk below this size to fit inside the gene arrow will not be
#' drawn. Defaults to 4 pt.
#' @param grow If `TRUE`, text will be grown as well as shrunk to fill the
#' arrow.
#' @param reflow If `TRUE`, text will be reflowed (wrapped) to better fit the
#' arrow.
#' @param height `grid::unit()` object giving the maximum height of the text.
#' Defaults to 3 mm, which is the default height of gene arrows drawn with
#' `geom_gene_arrow()`.
#' @param mapping,data,stat,position,na.rm,show.legend,inherit.aes,... Standard
#' geom arguments as for `ggplot2::geom_text()`.
#'
#' @seealso geom_gene_arrow
#'
#' @section Aesthetics:
#'
#' - xmin,xmax (start and end of the gene; required)
#' - y (molecule; required)
#' - label (the label text; required)
#' - colour
#' - size
#' - alpha
#' - family
#' - fontface
#' - angle
#'
#' @examples
#'
#' ggplot2::ggplot(example_genes, ggplot2::aes(xmin = start, xmax = end,
#'   y = molecule, fill = gene, label = gene)) +
#'   geom_gene_arrow() +
#'   geom_gene_label() +
#'   ggplot2::facet_wrap(~ molecule, ncol = 1, scales = "free") +
#'   theme_genes()
#' @export
geom_gene_label <- function(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  na.rm = FALSE,
  show.legend = FALSE,
  inherit.aes = TRUE,
  padding.x = grid::unit(1, "mm"),
  padding.y = grid::unit(0.1, "lines"),
  align = "centre",
  min.size = 4,
  grow = F,
  reflow = F,
  height = grid::unit(3, "mm"),
  ...
) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomGeneLabel,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      padding.x = padding.x,
      padding.y = padding.y,
      align = align,
      min.size = min.size,
      grow = grow,
      reflow = reflow,
      height = height,
      ...
    )
  )
}

#' GeomGeneLabel
#' @noRd
#' @import grid
#' @import ggfittext
GeomGeneLabel <- ggplot2::ggproto(
  "GeomGeneLabel",
  ggplot2::Geom,
  required_aes = c("xmin", "xmax", "y", "label"),
  default_aes = ggplot2::aes(
    colour = "black",
    size = 18,
    alpha = 1,
    family = "",
    fontface = 1,
    angle = 0,
    fill = "white",
    lineheight = 0.9
  ),
  draw_key = ggplot2::draw_key_text,

  draw_panel = function(
    data,
    panel_scales,
    coord,
    padding.x = grid::unit(1, "mm"),
    padding.y = grid::unit(1, "mm"),
    min.size = 4,
    grow = FALSE,
    reflow = FALSE,
    align = "centre",
    height = grid::unit(3, "mm"),
    subgroup = NA
  ) {

    # Detect flipped coordinates
    coord_flip <- inherits(coord, "CoordFlip")
    if (coord_flip) {
      data$angle <- data$angle + 90
    }

    # Transform data to panel scales
    data <- coord$transform(data, panel_scales)

    # Check value of 'align'
    if (! align %in% c("left", "centre", "center", "middle", "right")) {
      stop("`align` must be one of `left`, `centre`, `center`, `middle` or `right`")
    }

    # Use ggfittext's fittexttree to draw text
    if (coord_flip) {
      gt <- grid::gTree(
        data = data,
        padding.x = padding.x,
        padding.y = padding.y,
        place = align,
        min.size = min.size,
        grow = grow,
        reflow = reflow,
        cl = "fittexttree",
        width = height,
        fullheight = TRUE
      )
    } else {
      gt <- grid::gTree(
        data = data,
        padding.x = padding.x,
        padding.y = padding.y,
        place = align,
        min.size = min.size,
        grow = grow,
        reflow = reflow,
        cl = "fittexttree",
        height = height,
        fullheight = TRUE
      )
    }
    gt$name <- grid::grobName(gt, "geom_gene_label")
    gt
  }
)
