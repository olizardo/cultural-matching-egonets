library(stringr)

txt <- readLines("analysis.qmd")

# 1. Update data preparation chunk
idx_mutate <- grep("race_homophily = factor\\(race_homophily", txt)
txt[idx_mutate] <- paste0(txt[idx_mutate], ",\n    freq_high = as.numeric(freq_factor %in% c(\"Weekly\", \"Daily\")),\n    duration_sq = duration_^2")

idx_filter <- grep("filter\\(!is.na\\(same_dorm\\), !is.na\\(freq_factor\\)\\)", txt)
txt[idx_filter] <- str_replace(txt[idx_filter], "freq_factor", "freq_high")

# 2. Update Model Definitions
mod_idx_start <- grep("mod_closed <- glmer\\(", txt)
mod_idx_end <- grep("mod_opac_base <- glmer\\(", txt) + 4 # 4 lines per model

new_mods <- c(
  'ctrl_vars <- "same_dorm + is_friend + race_homophily + freq_high + female_factor * alterfemale_factor + close_factor + duration_ + duration_sq + period"',
  '',
  'mod_closed <- glmer(',
  '  as.formula(paste("persisted ~ num_match_closed +", ctrl_vars, "+ (1 | egoid)")),',
  '  data = df_period, family = binomial(link = "logit"), control = glmer_ctrl, nAGQ = 0',
  ')',
  '',
  'mod_open <- glmer(',
  '  as.formula(paste("persisted ~ num_match_closed + open_match_count +", ctrl_vars, "+ (1 | egoid)")),',
  '  data = df_period, family = binomial(link = "logit"), control = glmer_ctrl, nAGQ = 0',
  ')',
  '',
  'mod_opac_base <- glmer(',
  '  as.formula(paste("persisted ~ open_match_count + num_unknown +", ctrl_vars, "+ (1 | egoid)")),',
  '  data = df_period, family = binomial(link = "logit"), control = glmer_ctrl, nAGQ = 0',
  ')'
)

txt <- c(txt[1:(mod_idx_start-1)], new_mods, txt[(mod_idx_end+1):length(txt)])

# 3. Update Table Coef_map
# We need to replace the coef_map for modelsummary
# First, remove the old frequency and add duration_sq and freq_high
txt <- str_replace_all(txt, '"duration_" = "Tie Duration \\(Years\\)",', '"duration_" = "Tie Duration (Years)",\n    "duration_sq" = "Tie Duration Squared",')
txt <- str_replace_all(txt, '"freq_factorMonthly" = "Frequency: Monthly",', '"freq_high" = "Frequency: Weekly/Daily",')
txt <- str_replace_all(txt, '"freq_factorWeekly" = "Frequency: Weekly",', '')
txt <- str_replace_all(txt, '"freq_factorDaily" = "Frequency: Daily",', '')

# Remove extra empty lines generated
txt <- txt[txt != ""]

# Apply tinytable sizing to modelsummary
# Find both modelsummary calls
ms_idx1 <- grep("modelsummary\\(", txt)[1]
ms_idx2 <- grep("modelsummary\\(", txt)[2]
# We'll use tinytable to resize: `modelsummary(...) |> tinytable::theme_tt("resize")` or similar. Wait, actually we can just add `options(modelsummary_factory_latex = "tinytable")` and `|> tinytable::style_tt(fontsize=0.7)`
# But first let's just do `|> tinytable::theme_tt("compact")` on the output
for (i in seq_along(txt)) {
  if (grepl('gof_map = c\\("nobs", "aic", "bic"\\)\\)', txt[i])) {
    txt[i] <- '  gof_map = c("nobs", "aic", "bic")\n) |> tinytable::style_tt(fontsize=0.85)'
  }
}

# 4. Update Interactions chunk
int_idx_start <- grep("mod_close_int_closed <- glmer\\(", txt)
int_idx_end <- grep("mod_close_int_unknown <- glmer\\(", txt) + 4

new_ints <- c(
  'ctrl_vars_int <- "same_dorm + is_friend + race_homophily + freq_high + female_factor * alterfemale_factor + duration_ + duration_sq + period"',
  '',
  'mod_close_int_closed <- glmer(',
  '  as.formula(paste("persisted ~ num_match_closed * close_factor +", ctrl_vars_int, "+ (1 | egoid)")),',
  '  data = df_period, family = binomial(link = "logit"), control = glmer_ctrl, nAGQ = 0',
  ')',
  '',
  'mod_close_int_open <- glmer(',
  '  as.formula(paste("persisted ~ open_match_count * close_factor +", ctrl_vars_int, "+ (1 | egoid)")),',
  '  data = df_period, family = binomial(link = "logit"), control = glmer_ctrl, nAGQ = 0',
  ')',
  '',
  'mod_close_int_unknown <- glmer(',
  '  as.formula(paste("persisted ~ num_unknown * close_factor +", ctrl_vars_int, "+ (1 | egoid)")),',
  '  data = df_period, family = binomial(link = "logit"), control = glmer_ctrl, nAGQ = 0',
  ')'
)

txt <- c(txt[1:(int_idx_start-1)], new_ints, txt[(int_idx_end+1):length(txt)])

writeLines(txt, "analysis.qmd")
