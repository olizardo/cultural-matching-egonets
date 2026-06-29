txt <- readLines("analysis.qmd")

start_idx <- grep("library\\(patchwork\\)", txt)
end_idx <- grep("ggsave\\(here::here\\(\"Plots\", \"interaction_closeness.png\"\\)", txt)

new_code <- c(
  'library(patchwork)',
  'comp_int_closed <- comparisons(mod_close_int_closed, variables = list(num_match_closed = c(0, 6)), newdata = datagrid(close_factor = c("Not Close", "Somewhat Close", "Close")), re.form = NA) %>% as_tibble() %>% mutate(Cultural_Variable = "Closed-Form Matches")',
  'comp_int_open <- comparisons(mod_close_int_open, variables = list(open_match_count = c(0, 5)), newdata = datagrid(close_factor = c("Not Close", "Somewhat Close", "Close")), re.form = NA) %>% as_tibble() %>% mutate(Cultural_Variable = "Open-Ended Matches")',
  'comp_int_opacity <- comparisons(mod_close_int_unknown, variables = list(num_unknown = c(0, 6)), newdata = datagrid(close_factor = c("Not Close", "Somewhat Close", "Close")), re.form = NA) %>% as_tibble() %>% mutate(Cultural_Variable = "Network Opacity (Unknowns)")',
  '',
  'comp_int_combined <- bind_rows(comp_int_closed, comp_int_open, comp_int_opacity) %>%',
  '  mutate(Cultural_Variable = factor(Cultural_Variable, levels = c("Closed-Form Matches", "Open-Ended Matches", "Network Opacity (Unknowns)"), ordered = TRUE),',
  '         close_factor = factor(close_factor, levels = rev(c("Not Close", "Somewhat Close", "Close")), ordered = TRUE))',
  '',
  'p_int <- ggplot(comp_int_combined, aes(y = close_factor, x = estimate, fill = Cultural_Variable, color = Cultural_Variable)) +',
  '  geom_col(width = 0.4, alpha = 0.8) +',
  '  geom_errorbar(aes(xmin = conf.low, xmax = conf.high), width = 0.15, linewidth = 1) +',
  '  scale_x_continuous(labels = scales::percent_format()) +',
  '  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +',
  '  facet_wrap(~Cultural_Variable) +',
  '  labs(y = "Subjective Closeness", x = "Marginal Effect on Tie Persistence\\n(Min to Max)") +',
  '  scale_fill_manual(values = c("Closed-Form Matches" = "#1f78b4", "Open-Ended Matches" = "#33a02c", "Network Opacity (Unknowns)" = "#e31a1c")) +',
  '  scale_color_manual(values = c("Closed-Form Matches" = "#12476b", "Open-Ended Matches" = "#1e5e1a", "Network Opacity (Unknowns)" = "#941113")) +',
  '  theme_minimal(base_size = 14) +',
  '  theme(legend.position = "none", strip.text = element_text(face = "bold"))',
  ''
)

txt <- c(txt[1:(start_idx-1)], new_code, 'ggsave(here::here("Plots", "interaction_closeness.png"), plot = p_int, width = 12, height = 4.5)', 'p_int', txt[(end_idx+2):length(txt)])
writeLines(txt, "analysis.qmd")
