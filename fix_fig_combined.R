library(dplyr)

txt <- readLines("analysis.qmd")

# Fix fig-combined
fig_idx <- grep("comp_combined <- bind_rows", txt)
end_idx <- grep("ggsave\\(here::here\\(\"Plots\", \"marginal_effects.png\"\\)", txt)

new_code <- c(
  'comp_combined <- bind_rows(comp_closed, comp_open, comp_opacity) %>%',
  '  mutate(Predictor = factor(Predictor, levels = rev(c("Closed-Form Matches", "Open-Ended Matches", "Network Opacity (Unknowns)")), ordered = TRUE))',
  '',
  'p <- ggplot(comp_combined, aes(y = Predictor, x = estimate, fill = Predictor, color = Predictor)) +',
  '  geom_col(width = 0.3, alpha = 0.8) +',
  '  geom_errorbar(aes(xmin = conf.low, xmax = conf.high), width = 0.1, linewidth = 1) +',
  '  scale_x_continuous(labels = scales::percent_format()) +',
  '  scale_fill_manual(values = c("Closed-Form Matches" = "#1f78b4", "Open-Ended Matches" = "#33a02c", "Network Opacity (Unknowns)" = "#e31a1c")) +',
  '  scale_color_manual(values = c("Closed-Form Matches" = "#12476b", "Open-Ended Matches" = "#1e5e1a", "Network Opacity (Unknowns)" = "#941113")) +',
  '  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +',
  '  labs(y = NULL, x = "Marginal Effect on Tie Persistence\\n(Min to Max)") +',
  '  theme_minimal(base_size = 14) +',
  '  theme(legend.position = "none")'
)

txt <- c(txt[1:(fig_idx-1)], new_code, txt[(end_idx):length(txt)])
writeLines(txt, "analysis.qmd")
