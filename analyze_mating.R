# Three-round classroom matching analysis. Base R only.
# Run: Rscript analyze_mating_three_rounds_updated.R round1.csv round2.csv round3.csv
# Or source this file with round1.csv, round2.csv, round3.csv in working directory.
# CSV: student1,student2. For unmatched students, leave student2 blank.
# Record final pairs only for rounds 2 and 3.

args <- commandArgs(trailingOnly = TRUE)
files <- if (length(args) >= 3) args[1:3] else paste0('round', 1:3, '.csv')
outdir <- 'mating_results'
if (!dir.exists(outdir)) dir.create(outdir, recursive = TRUE, showWarnings = FALSE)

read_round <- function(file) {
  if (!file.exists(file)) stop('Missing input file: ', file)
  d <- read.csv(file, colClasses = 'character', na.strings = c('', 'NA'),
                strip.white = TRUE, check.names = FALSE)
  if (ncol(d) != 2 || nrow(d) == 0) stop('Expected two columns and data in: ', file)
  names(d) <- c('student1', 'student2')
  parse <- function(z, missing_ok = FALSE) {
    z <- trimws(z)
    z[z == ''] <- NA_character_
    v <- suppressWarnings(as.numeric(z))
    if (any(!is.na(z) & (is.na(v) | !is.finite(v) | v != floor(v) | v < 1)))
      stop('Card values must be positive whole numbers in: ', file)
    if (!missing_ok && anyNA(v)) stop('student1 cannot be empty in: ', file)
    v
  }
  x <- parse(d$student1)
  y <- parse(d$student2, TRUE)
  paired <- !is.na(y)
  list(low = pmin(x[paired], y[paired]),
       high = pmax(x[paired], y[paired]),
       gap = abs(x[paired] - y[paired]),
       total = x + ifelse(paired, y, 0),
       paired = paired, x = x, y = y)
}
rounds <- lapply(files, read_round)
colors <- c('#34699A', '#E08D3C', '#2C9373')
all_cards <- unlist(lapply(rounds, function(r) c(r$x, r$y[!is.na(r$y)])))
card_limits <- range(all_cards) + c(-0.5, 0.5)
if (diff(card_limits) == 0) card_limits <- card_limits + c(-1, 1)
max_gap <- max(0, unlist(lapply(rounds, function(r) r$gap)))
gap_levels <- 0:max_gap

# 1. One point per pair, ordered low-to-high (no mirrored points).
png(file.path(outdir, '01_pairs.png'), width = 900, height = 750, res = 130)
r <- rounds[[1]]
plot(r$low, r$high, xlim = card_limits, ylim = card_limits,
     xlab = 'Lower card value', ylab = 'Higher card value',
     main = 'Round 1: matched pairs', pch = 19,
     col = adjustcolor(colors[1], alpha.f = 0.65), asp = 1)
abline(0, 1, lty = 2, col = 'gray45')
dev.off()

png(file.path(outdir, '01_pairs.png'), width = 1650, height = 650, res = 130)
par(mfrow = c(1, 3), mar = c(5, 4.5, 3.5, 1), oma = c(0, 0, 1, 0))
for (i in 1:3) {
  r <- rounds[[i]]
  plot(r$low, r$high, xlim = card_limits, ylim = card_limits,
       xlab = 'Lower card value', ylab = 'Higher card value',
       main = 'Round 1: matched pairs', pch = 19,
       col = adjustcolor(colors[1], alpha.f = 0.65), asp = 1)
  abline(0, 1, lty = 2, col = 'gray45')
}
mtext('Scatterplot by round', outer = TRUE, cex = 1.1)
dev.off()


# 2. Three panels by ROUND; within each panel, bars represent card-value gaps.
counts <- lapply(rounds, function(r)
  as.integer(table(factor(r$gap, levels = gap_levels))))
max_count <- max(1, unlist(counts))
png(file.path(outdir, '02_differences.png'), width = 1650, height = 650, res = 130)
par(mfrow = c(1, 3), mar = c(5, 4.5, 3.5, 1), oma = c(0, 0, 1, 0))
for (i in 1:3) {
  barplot(counts[[i]], names.arg = gap_levels, col = colors[i],
          ylim = c(0, max_count * 1.15),
          xlab = 'Absolute card-value difference', ylab = 'Number of pairs',
          main = paste('Round', i))
  if (length(rounds[[i]]$gap))
    mtext(sprintf('Mean difference: %.2f', mean(rounds[[i]]$gap)),
          side = 3, line = 0.2, cex = 0.8)
}
mtext('Differences between partners by round', outer = TRUE, cex = 1.1)
dev.off()

# 3. Total card scores for matched pairs and unmatched individuals.
# An unmatched participant contributes their own card value (not zero).
score_levels <- seq(min(unlist(lapply(rounds, function(r) r$total))),
                    max(unlist(lapply(rounds, function(r) r$total))))
score_counts <- lapply(rounds, function(r) rbind(
  Paired = as.integer(table(factor(r$total[r$paired], levels = score_levels))),
  Unmatched = as.integer(table(factor(r$total[!r$paired], levels = score_levels)))))
max_score_count <- max(1, unlist(lapply(score_counts, colSums)))
png(file.path(outdir, '03_total_scores.png'), width = 1650, height = 680, res = 130)
par(mfrow = c(1, 3), mar = c(5, 4.5, 4, 1), oma = c(0, 0, 1, 0))
for (i in 1:3) {
  barplot(score_counts[[i]], col = c(colors[i], 'gray65'),
          ylim = c(0, max_score_count * 1.15), names.arg = score_levels,
          las = 2, cex.names = 0.75,
          xlab = 'Total score (pair sum or unmatched card)',
          ylab = 'Number of pairs / unmatched students',
          main = paste('Round', i))
  legend('topright', legend = c('Paired', 'Unmatched'),
         fill = c(colors[i], 'gray65'), bty = 'n', cex = 0.8)
}
mtext('Total scores including unmatched students', outer = TRUE, cex = 1.1)
dev.off()
