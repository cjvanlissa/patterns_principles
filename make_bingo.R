
make_fallacy_bingo <- function(file = "file.txt",
                               grid_dim = c(3, 3),
                               num_cards = 10,
                               output = "fallacy_bingo.pdf",
                               seed = NULL) {

  # Validate arguments
  stopifnot(
    file.exists(file),
    length(grid_dim) == 2,
    all(is.finite(grid_dim)),
    all(grid_dim > 0),
    all(grid_dim == floor(grid_dim)),
    length(num_cards) == 1,
    is.finite(num_cards),
    num_cards > 0,
    num_cards == floor(num_cards)
  )

  if (!is.null(seed)) set.seed(seed)

  # Read entries, ignoring empty lines
  entries <- trimws(readLines(file, warn = FALSE))
  entries <- unique(entries[nzchar(entries)])

  nrows <- grid_dim[1]
  ncols <- grid_dim[2]
  n_cells <- nrows * ncols

  if (length(entries) < n_cells) {
    stop(sprintf(
      "Need at least %d distinct entries; found %d.",
      n_cells, length(entries)
    ))
  }

  # Check whether enough distinct arrangements exist
  log_possible <- lfactorial(length(entries)) -
    lfactorial(length(entries) - n_cells)

  if (log(num_cards) > log_possible + 1e-10) {
    stop("Not enough possible arrangements for unique cards.")
  }

  # Generate unique cards
  cards <- vector("list", num_cards)
  seen <- new.env(hash = TRUE, parent = emptyenv())

  for (i in seq_len(num_cards)) {
    repeat {
      selection <- sample.int(length(entries), n_cells)
      key <- paste(selection, collapse = ",")

      if (!exists(key, envir = seen, inherits = FALSE)) {
        assign(key, TRUE, envir = seen)
        cards[[i]] <- matrix(
          entries[selection],
          nrow = nrows,
          ncol = ncols,
          byrow = TRUE
        )
        break
      }
    }
  }

  # Open PDF: one page per card
  pdf(output, width = 8.5, height = 11,
      paper = "special", onefile = TRUE)

  on.exit(dev.off(), add = TRUE)

  for (card_num in seq_len(num_cards)) {

    grid.new <- FALSE  # Placeholder; base graphics only
    plot.new()
    par(usr = c(0, 1, 0, 1))

    # Title
    text(0.5, 0.94, "LOGICAL FALLACY BINGO",
         cex = 1.8, font = 2)

    text(0.5, 0.89,
         sprintf("Card %d of %d", card_num, num_cards),
         cex = 1)

    # Grid geometry
    left <- 0.08
    right <- 0.92
    bottom <- 0.15
    top <- 0.83

    cell_w <- (right - left) / ncols
    cell_h <- (top - bottom) / nrows

    card <- cards[[card_num]]

    # Draw cells and their contents
    for (r in seq_len(nrows)) {
      for (c in seq_len(ncols)) {

        x0 <- left + (c - 1) * cell_w
        x1 <- x0 + cell_w

        y1 <- top - (r - 1) * cell_h
        y0 <- y1 - cell_h

        rect(x0, y0, x1, y1, lwd = 1.5)

        label <- card[r, c]

        # Wrap text according to grid width
        wrap_width <- max(8, floor(18 * cell_w / 0.28))
        lines <- strwrap(label, width = wrap_width)

        # Scale font for number of lines and grid size
        cex <- min(
          1.1,
          0.85 * (3 / ncols),
          0.9 * (3 / nrows),
          2.5 / max(1, length(lines))
        )

        text(
          (x0 + x1) / 2,
          (y0 + y1) / 2,
          paste(lines, collapse = "\n"),
          cex = cex,
          adj = c(0.5, 0.5)
        )
      }
    }
  }

  message(sprintf(
    "Created %d unique bingo cards in '%s'.",
    num_cards, output
  ))

  invisible(cards)
}
