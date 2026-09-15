#!/usr/bin/env Rscript
# ==============================================================================
# Script: Code/generate_deliverables.R
# Purpose: Standalone reproducible pipeline generating all manuscript tables
#          (Tabs/*.tex) and publication figures (Plots/*.png) for the Cultural
#          Matching Egonets project.
# ==============================================================================

suppressPackageStartupMessages({
  library(tidyverse)
  library(lme4)
  library(survival)
  library(marginaleffects)
  library(here)
})

message("[1/5] Ingesting and preparing analytical data...")

ego_race <- readRDS(here("data", "processed", "ego_race.rds")) %>% 
  mutate(sender = as.character(sender))

alter_race <- readRDS(here("data", "processed", "alter_race.rds")) %>% 
  mutate(receiver = as.character(receiver))

df_period <- readRDS(here("data", "processed", "adjacent_waves.rds")) %>%
  filter(kin == 0, campustie == 1, !is.na(alterid)) %>%
  left_join(ego_race, by = c("egoid" = "sender")) %>%
  left_join(alter_race, by = c("alterid" = "receiver")) %>%
  mutate(
    period = factor(period),
    persisted = as.numeric(tie_persist > 0),
    female_factor = factor(female, levels = c(0, 1), labels = c("Men", "Women")),
    alterfemale_factor = factor(alterfemale, levels = c(0, 1), labels = c("Men", "Women")),
    close_factor = factor(ifelse(close == 4, 3, close), levels = c(3, 2, 1), labels = c("Not Close", "Somewhat Close", "Close")),
    same_dorm = as.numeric(reltype == 3 | reltype == 4),
    is_friend = as.numeric(reltype == 6),
    race_homophily = case_when(
      is.na(ego_race) | is.na(alter_race) ~ "Unknown",
      ego_race == alter_race ~ "Homophilous",
      TRUE ~ "Heterophilous"
    ),
    race_homophily = factor(race_homophily, levels = c("Heterophilous", "Homophilous", "Unknown")),
    freq_daily = if_else(is.na(freq_factor), NA_real_, if_else(freq_factor == "Daily", 1, 0)),
    duration_c = scale(duration_)[, 1],
    duration_sq_c = scale(duration_^2)[, 1],
    common_alters_std = if_else(wave == 6 | is.na(common_alters), 0, 
                                (common_alters - mean(common_alters[wave != 6], na.rm = TRUE)) / sd(common_alters[wave != 6], na.rm = TRUE))
  ) %>%
  filter(!is.na(same_dorm), !is.na(freq_daily))

dir.create(here("Tabs"), showWarnings = FALSE, recursive = TRUE)
dir.create(here("Plots"), showWarnings = FALSE, recursive = TRUE)

# ==============================================================================
# SECTION 1: DESCRIPTIVE STATISTICS (TABLES 1 & 2)
# ==============================================================================
message("[2/5] Generating descriptive tables (Tabs/desc_cont.tex, Tabs/desc_cat.tex)...")

# Table 1: Continuous Variables
cont_vars <- list(
  "Closed-Form Cultural Matching" = df_period$num_match_closed,
  "Open-Ended Activity Matching" = df_period$open_match_count,
  "Cultural Network Opacity" = df_period$num_unknown,
  "Structural Embeddedness (Common Alters)" = df_period$common_alters,
  "Tie Duration (Years)" = df_period$duration_
)

cont_stats <- map_dfr(names(cont_vars), function(var_name) {
  v <- na.omit(cont_vars[[var_name]])
  tibble(
    Variable = var_name,
    Mean = sprintf("%.2f", mean(v)),
    SD = sprintf("%.2f", sd(v)),
    Min = sprintf("%.2f", min(v)),
    Max = sprintf("%.2f", max(v))
  )
})

desc_cont_lines <- c(
  "\\begin{table}[htbp]",
  "\\centering",
  "\\begin{talltblr}[         %% tabularray outer open",
  "caption={Descriptive Statistics (Continuous Variables)\\label{tbl-descriptives-cont}},",
  "]                     %% tabularray outer close",
  "{                     %% tabularray inner open",
  "colspec={Q[]Q[]Q[]Q[]Q[]},",
  "hline{2}={1-5}{solid, black, 0.05em},",
  "hline{1}={1-5}{solid, black, 0.08em},",
  paste0("hline{", nrow(cont_stats) + 2, "}={1-5}{solid, black, 0.08em},"),
  "column{1}={}{halign=l},",
  "column{2-5}={}{halign=r},",
  "}                     %% tabularray inner close",
  "& Mean & SD & Min & Max \\\\"
)

for (i in seq_len(nrow(cont_stats))) {
  r <- cont_stats[i, ]
  desc_cont_lines <- c(desc_cont_lines, sprintf("%s & \\num{%s} & \\num{%s} & \\num{%s} & \\num{%s} \\\\",
                                                r$Variable, r$Mean, r$SD, r$Min, r$Max))
}
desc_cont_lines <- c(desc_cont_lines, "\\end{talltblr}", "\\end{table}")
writeLines(desc_cont_lines, here("Tabs", "desc_cont.tex"))

# Table 2: Categorical Variables
n_tot <- nrow(df_period)
cat_rows <- tribble(
  ~Category, ~Level, ~N, ~Pct,
  "Tie Persisted (Protection from Tie Decay)", "0 (Decayed)", sum(df_period$persisted == 0), mean(df_period$persisted == 0) * 100,
  "Tie Persisted (Protection from Tie Decay)", "1 (Persisted)", sum(df_period$persisted == 1), mean(df_period$persisted == 1) * 100,
  "Ego Gender Identity", "Men", sum(df_period$female_factor == "Men", na.rm = TRUE), mean(df_period$female_factor == "Men", na.rm = TRUE) * 100,
  "Ego Gender Identity", "Women", sum(df_period$female_factor == "Women", na.rm = TRUE), mean(df_period$female_factor == "Women", na.rm = TRUE) * 100,
  "Alter Gender Identity", "Men", sum(df_period$alterfemale_factor == "Men", na.rm = TRUE), mean(df_period$alterfemale_factor == "Men", na.rm = TRUE) * 100,
  "Alter Gender Identity", "Women", sum(df_period$alterfemale_factor == "Women", na.rm = TRUE), mean(df_period$alterfemale_factor == "Women", na.rm = TRUE) * 100,
  "Subjective Closeness", "Not Close", sum(df_period$close_factor == "Not Close", na.rm = TRUE), mean(df_period$close_factor == "Not Close", na.rm = TRUE) * 100,
  "Subjective Closeness", "Somewhat Close", sum(df_period$close_factor == "Somewhat Close", na.rm = TRUE), mean(df_period$close_factor == "Somewhat Close", na.rm = TRUE) * 100,
  "Subjective Closeness", "Close", sum(df_period$close_factor == "Close", na.rm = TRUE), mean(df_period$close_factor == "Close", na.rm = TRUE) * 100,
  "Interaction Frequency", "Weekly", sum(df_period$freq_daily == 0, na.rm = TRUE), mean(df_period$freq_daily == 0, na.rm = TRUE) * 100,
  "Interaction Frequency", "Daily", sum(df_period$freq_daily == 1, na.rm = TRUE), mean(df_period$freq_daily == 1, na.rm = TRUE) * 100,
  "Race Homophily", "Heterophilous", sum(df_period$race_homophily == "Heterophilous", na.rm = TRUE), mean(df_period$race_homophily == "Heterophilous", na.rm = TRUE) * 100,
  "Race Homophily", "Homophilous", sum(df_period$race_homophily == "Homophilous", na.rm = TRUE), mean(df_period$race_homophily == "Homophilous", na.rm = TRUE) * 100,
  "Race Homophily", "Unknown", sum(df_period$race_homophily == "Unknown", na.rm = TRUE), mean(df_period$race_homophily == "Unknown", na.rm = TRUE) * 100
)

desc_cat_lines <- c(
  "\\begin{table}[htbp]",
  "\\centering",
  "\\begin{talltblr}[         %% tabularray outer open",
  "caption={Descriptive Statistics (Categorical Variables)\\label{tbl-descriptives-cat}},",
  "]                     %% tabularray outer close",
  "{                     %% tabularray inner open",
  "colspec={Q[]Q[]Q[]Q[]},",
  "hline{2}={1-4}{solid, black, 0.05em},",
  "hline{1}={1-4}{solid, black, 0.08em},",
  paste0("hline{", nrow(cat_rows) + 2, "}={1-4}{solid, black, 0.08em},"),
  "column{1,2}={}{halign=l},",
  "column{3,4}={}{halign=r},",
  "}                     %% tabularray inner close",
  "Variable & Category & N & Percent \\\\"
)

curr_cat <- ""
for (i in seq_len(nrow(cat_rows))) {
  r <- cat_rows[i, ]
  var_label <- if (r$Category != curr_cat) { curr_cat <- r$Category; r$Category } else { "" }
  desc_cat_lines <- c(desc_cat_lines, sprintf("%s & %s & \\num{%d} & \\num{%.1f}\\%% \\\\",
                                              var_label, r$Level, r$N, r$Pct))
}
desc_cat_lines <- c(desc_cat_lines, "\\end{talltblr}", "\\end{table}")
writeLines(desc_cat_lines, here("Tabs", "desc_cat.tex"))

# ------------------------------------------------------------------------------
# Table: Longitudinal Taste Stability & Consistency (Tabs/taste_stability.tex)
# ------------------------------------------------------------------------------
message("      Generating taste stability table (Tabs/taste_stability.tex)...")

demo_rds_path <- "/home/omarlizardo/projects/NETWORKS/NetSense/Surveys/demographics_longitudinal_clean.rds"
if (file.exists(demo_rds_path)) {
  demo_rds <- readRDS(demo_rds_path)
  
  ego_taste_long <- demo_rds %>%
    mutate(egoid = sub("\\.0+$", "", as.character(sender))) %>%
    filter(!is.na(sender)) %>%
    select(egoid, matches("^interestitems[1-6]_[1-3]$")) %>%
    pivot_longer(
      cols = matches("^interestitems[1-6]_[1-3]$"),
      names_to = c("domain_num", "wave"),
      names_pattern = "interestitems([1-6])_([1-3])",
      values_to = "interest"
    ) %>%
    mutate(
      wave = as.numeric(wave),
      domain = case_when(
        domain_num == "1" ~ "Music",
        domain_num == "2" ~ "Movies",
        domain_num == "3" ~ "Books",
        domain_num == "4" ~ "Sports",
        domain_num == "5" ~ "Games",
        domain_num == "6" ~ "Outdoor"
      ),
      interest_num = case_when(
        interest == "Very much" ~ 3,
        interest == "Somewhat" ~ 2,
        interest %in% c("Not that much", "Not at all") ~ 1,
        TRUE ~ NA_real_
      )
    )
  
  icc_df <- ego_taste_long %>%
    filter(!is.na(interest_num)) %>%
    group_by(domain) %>%
    group_modify(~ {
      fit <- lmer(interest_num ~ 1 + (1 | egoid), data = .x)
      vc <- as.data.frame(VarCorr(fit))
      var_ego <- vc$vcov[vc$grp == "egoid"]
      var_res <- vc$vcov[vc$grp == "Residual"]
      icc <- var_ego / (var_ego + var_res)
      tibble(ICC = icc)
    })
  
  stability_list <- list()
  for (d in c("Sports", "Books", "Outdoor", "Movies", "Games", "Music")) {
    d_data <- ego_taste_long %>% filter(domain == d) %>% select(egoid, wave, interest_num) %>%
      pivot_wider(names_from = wave, values_from = interest_num, names_prefix = "W")
    
    sub_12 <- d_data %>% select(W1, W2) %>% drop_na()
    r_12 <- cor(sub_12$W1, sub_12$W2)
    ex_12 <- mean(sub_12$W1 == sub_12$W2) * 100
    w1_12 <- mean(abs(sub_12$W1 - sub_12$W2) <= 1) * 100
    
    sub_23 <- d_data %>% select(W2, W3) %>% drop_na()
    r_23 <- cor(sub_23$W2, sub_23$W3)
    ex_23 <- mean(sub_23$W2 == sub_23$W3) * 100
    w1_23 <- mean(abs(sub_23$W2 - sub_23$W3) <= 1) * 100
    
    sub_13 <- d_data %>% select(W1, W3) %>% drop_na()
    r_13 <- cor(sub_13$W1, sub_13$W3)
    ex_13 <- mean(sub_13$W1 == sub_13$W3) * 100
    w1_13 <- mean(abs(sub_13$W1 - sub_13$W3) <= 1) * 100
    
    avg_r_adj <- mean(c(r_12, r_23))
    avg_ex_adj <- mean(c(ex_12, ex_23))
    avg_w1_adj <- mean(c(w1_12, w1_23))
    
    stability_list[[d]] <- tibble(
      domain = d,
      r_adj = avg_r_adj,
      exact_adj = avg_ex_adj,
      within1_adj = avg_w1_adj,
      r_w1w3 = r_13,
      exact_w1w3 = ex_13,
      within1_w1w3 = w1_13
    )
  }
  ego_stab <- bind_rows(stability_list) %>% left_join(icc_df, by = "domain")
  
  alter_t_t1 <- readRDS(here("data", "processed", "adjacent_waves.rds")) %>%
    distinct(egoid, alterid, wave, .keep_all = TRUE) %>%
    filter(tie_persist == 1) %>%
    select(egoid, alterid, wave, altermusic_, altermovies_, alterbooks_, altersports_, altergames_, alteroutdoor_) %>%
    inner_join(
      readRDS(here("data", "processed", "adjacent_waves.rds")) %>%
        distinct(egoid, alterid, wave, .keep_all = TRUE) %>%
        select(egoid, alterid, wave, 
               t1_altermusic = altermusic_,
               t1_altermovies = altermovies_,
               t1_alterbooks = alterbooks_,
               t1_altersports = altersports_,
               t1_altergames = altergames_,
               t1_alteroutdoor = alteroutdoor_) %>%
        mutate(wave = wave - 1),
      by = c("egoid", "alterid", "wave")
    )
  
  alter_stab_list <- list()
  for (domain_name in c("Sports", "Books", "Outdoor", "Movies", "Games", "Music")) {
    d_lower <- tolower(domain_name)
    v_t <- alter_t_t1[[paste0("alter", d_lower, "_")]]
    v_t1 <- alter_t_t1[[paste0("t1_alter", d_lower)]]
    valid <- !is.na(v_t) & !is.na(v_t1) & v_t < 5 & v_t1 < 5
    r_alt <- cor(v_t[valid], v_t1[valid])
    exact_alt <- mean(v_t[valid] == v_t1[valid]) * 100
    within1_alt <- mean(abs(v_t[valid] - v_t1[valid]) <= 1) * 100
    alter_stab_list[[domain_name]] <- tibble(
      domain = domain_name,
      r_alter = r_alt,
      exact_alter = exact_alt,
      within1_alter = within1_alt
    )
  }
  alter_stab <- bind_rows(alter_stab_list)
  full_stab_table <- ego_stab %>% left_join(alter_stab, by = "domain")
  
  stab_table_lines <- c(
    "\\begin{table}[htbp]",
    "\\centering",
    "\\begin{talltblr}[         %% tabularray outer open",
    "caption={Longitudinal Stability and Test-Retest Consistency of Cultural Tastes across Waves\\label{tbl-taste-stability}},",
    "note{a}={ICC (Intraclass Correlation Coefficient) estimated from two-level random intercept models decomposing between-ego versus within-ego variance across Waves 1--3. $r_{\\text{adj}}$, Exact, and $\\pm 1$ report mean adjacent wave-to-wave test-retest correlations and agreement percentages. $r_{\\text{W1}\\to\\text{W3}}$ reports multi-year stability across a 1.5-year span. Alter stability metrics are computed across consecutive waves for persisting dyads ($N = 2,546$).}",
    "]                     %% tabularray outer close",
    "{                     %% tabularray inner open",
    "colspec={Q[l,1.8cm]Q[r,1.1cm]Q[r,1.2cm]Q[r,1.2cm]Q[r,1.2cm]Q[r,1.4cm]Q[r,1.2cm]Q[r,1.2cm]},",
    "hline{2}={1-8}{solid, black, 0.05em},",
    "hline{1}={1-8}{solid, black, 0.08em},",
    "hline{8}={1-8}{solid, black, 0.08em},",
    "column{1}={}{halign=l},",
    "column{2-8}={}{halign=r},",
    "}                     %% tabularray inner close",
    "& \\SetCell[c=5]{c} Ego Self-Reported Tastes & & & & & \\SetCell[c=2]{c} Alter Perceived Tastes & \\\\",
    "Domain & ICC & $r_{\\text{adj}}$ & Exact (\\%) & $\\pm 1$ (\\%) & $r_{\\text{W1}\\to\\text{W3}}$ & $r_{\\text{alter}}$ & $\\pm 1$ (\\%) \\\\"
  )
  for (i in seq_len(nrow(full_stab_table))) {
    r <- full_stab_table[i, ]
    stab_table_lines <- c(stab_table_lines, sprintf(
      "%s & \\num{%.2f} & \\num{%.2f} & \\num{%.1f} & \\num{%.1f} & \\num{%.2f} & \\num{%.2f} & \\num{%.1f} \\\\",
      r$domain, r$ICC, r$r_adj, r$exact_adj, r$within1_adj, r$r_w1w3, r$r_alter, r$within1_alter
    ))
  }
  stab_table_lines <- c(stab_table_lines, "\\end{talltblr}", "\\end{table}")
  writeLines(stab_table_lines, here("Tabs", "taste_stability.tex"))
}

# ==============================================================================
# SECTION 2: MAIN EFFECTS MODELS (TABLE 3) & FIGURE 1 (MAIN EFFECTS PLOT)
# ==============================================================================
message("[3/5] Estimating main mixed-effects models and generating Figure 1...")

glmer_ctrl <- glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 1e5))
ctrl_vars <- "same_dorm + is_friend + race_homophily + freq_daily + female_factor + alterfemale_factor + close_factor + duration_c + duration_sq_c + period"

mod_closed <- glmer(
  as.formula(paste("persisted ~ num_match_closed +", ctrl_vars, "+ (1 | egoid)")),
  data = df_period, family = binomial(link = "logit"), control = glmer_ctrl, nAGQ = 0
)

mod_open <- glmer(
  as.formula(paste("persisted ~ num_match_closed + open_match_count +", ctrl_vars, "+ (1 | egoid)")),
  data = df_period, family = binomial(link = "logit"), control = glmer_ctrl, nAGQ = 0
)

mod_opac_base <- glmer(
  as.formula(paste("persisted ~ num_match_closed + open_match_count + num_unknown +", ctrl_vars, "+ (1 | egoid)")),
  data = df_period, family = binomial(link = "logit"), control = glmer_ctrl, nAGQ = 0
)

mod_embed <- glmer(
  as.formula(paste("persisted ~ num_match_closed + open_match_count + num_unknown + common_alters_std +", ctrl_vars, "+ (1 | egoid)")),
  data = df_period, family = binomial(link = "logit"), control = glmer_ctrl, nAGQ = 0
)

# Helper function to extract odds ratios, SEs, and formatting
get_coefs <- function(mod) {
  s <- summary(mod)$coefficients
  est <- s[, "Estimate"]
  se <- s[, "Std. Error"]
  pval <- s[, "Pr(>|z|)"]
  or <- exp(est)
  or_se <- or * se
  stars <- case_when(
    pval < 0.001 ~ "***",
    pval < 0.01  ~ "**",
    pval < 0.05  ~ "*",
    pval < 0.1   ~ "+",
    TRUE         ~ ""
  )
  tibble(
    term = rownames(s),
    est = est,
    se = se,
    or = or,
    or_se = or_se,
    pval = pval,
    stars = stars,
    nobs = nobs(mod),
    aic = AIC(mod),
    bic = BIC(mod)
  )
}

mods <- list(mod_closed, mod_open, mod_opac_base, mod_embed)
res_list <- map(mods, get_coefs)

terms_order <- c(
  "num_match_closed" = "Closed-Form Matches",
  "open_match_count" = "Open-Ended Matches",
  "num_unknown" = "Network Opacity",
  "common_alters_std" = "Structural Embeddedness (Common Alters)",
  "close_factorSomewhat Close" = "Subjective Closeness: Somewhat",
  "close_factorClose" = "Subjective Closeness: Close",
  "same_dorm" = "Roommate/Dormmate",
  "is_friend" = "Friend",
  "freq_daily" = "Frequency: Daily (vs Weekly)",
  "race_homophilyHomophilous" = "Race Homophily: Same Race",
  "duration_c" = "Tie Duration (Scaled)",
  "duration_sq_c" = "Tie Duration Sq (Scaled)"
)

table_lines <- c(
  "\\begin{table}[htbp]",
  "\\centering",
  "\\begin{talltblr}[         %% tabularray outer open",
  "caption={Odds Ratios for Protection from Tie Decay (Main Effects Models)\\label{tbl-models}},",
  "note{}={+ p \\num{< 0.1}, * p \\num{< 0.05}, ** p \\num{< 0.01}, *** p \\num{< 0.001}},",
  "note{ }={Note: All models control for ego and alter gender, non-linear tie duration, and baseline hazard variations across all 7 wave transitions (coefficients omitted for space). Random intercepts for egos are included.},",
  "]                     %% tabularray outer close",
  "{                     %% tabularray inner open",
  "width=\\linewidth,",
  "colspec={X[2.5,l] X[1,c] X[1,c] X[1,c] X[1.1,c]},",
  "row{odd}={rowsep=0.5pt},",
  "row{even}={rowsep=0.5pt},",
  "hline{2}={1-5}{solid, black, 0.05em},",
  paste0("hline{", 2 * length(terms_order) + 2, "}={1-5}{solid, black, 0.05em},"),
  "hline{1}={1-5}{solid, black, 0.08em},",
  paste0("hline{", 2 * length(terms_order) + 5, "}={1-5}{solid, black, 0.08em},"),
  "}                     %% tabularray inner close",
  " & {Model 1\\\\Closed} & {Model 2\\\\+ Open} & {Model 3\\\\+ Opacity} & {Model 4\\\\+ Embed.} \\\\"
)

for (t_name in names(terms_order)) {
  label <- terms_order[t_name]
  or_strs <- map_chr(res_list, function(df) {
    row <- df %>% filter(term == t_name)
    if (nrow(row) == 0) return("")
    sprintf("\\num{%.3f}%s", row$or, row$stars)
  })
  se_strs <- map_chr(res_list, function(df) {
    row <- df %>% filter(term == t_name)
    if (nrow(row) == 0) return("")
    sprintf("(\\num{%.3f})", row$or_se)
  })
  table_lines <- c(table_lines, paste(c(label, or_strs), collapse = " & ") %>% paste0(" \\\\"))
  table_lines <- c(table_lines, paste(c("", se_strs), collapse = " & ") %>% paste0(" \\\\"))
}

# Add model fit statistics
nobs_str <- paste(c("Num.Obs.", map_chr(res_list, ~ sprintf("\\num{%d}", .x$nobs[1]))), collapse = " & ") %>% paste0(" \\\\")
aic_str  <- paste(c("AIC", map_chr(res_list, ~ sprintf("\\num{%.1f}", .x$aic[1]))), collapse = " & ") %>% paste0(" \\\\")
bic_str  <- paste(c("BIC", map_chr(res_list, ~ sprintf("\\num{%.1f}", .x$bic[1]))), collapse = " & ") %>% paste0(" \\\\")

table_lines <- c(table_lines, nobs_str, aic_str, bic_str, "\\end{talltblr}", "\\end{table}")
writeLines(table_lines, here("Tabs", "main_models.tex"))

# Figure 1: Main Effects Marginal Probability Plot (Model 4)
comp_closed <- comparisons(
  mod_embed,
  variables = list(num_match_closed = range(df_period$num_match_closed, na.rm = TRUE)),
  newdata = datagrid(),
  re.form = NA
) %>% as_tibble() %>% mutate(Predictor = "Closed-Form Cultural Matching (0–6)")

comp_open <- comparisons(
  mod_embed,
  variables = list(open_match_count = range(df_period$open_match_count, na.rm = TRUE)),
  newdata = datagrid(),
  re.form = NA
) %>% as_tibble() %>% mutate(Predictor = "Open-Ended Activity Matching (0–5)")

comp_opacity <- comparisons(
  mod_embed,
  variables = list(num_unknown = range(df_period$num_unknown, na.rm = TRUE)),
  newdata = datagrid(),
  re.form = NA
) %>% as_tibble() %>% mutate(Predictor = "Cultural Network Opacity (0–6)")

comp_embed_comp <- comparisons(
  mod_embed,
  variables = list(common_alters_std = c(0, 1)),
  newdata = datagrid(),
  re.form = NA
) %>% as_tibble() %>% mutate(Predictor = "Structural Embeddedness (+1 SD)")

comp_combined <- bind_rows(comp_closed, comp_open, comp_opacity, comp_embed_comp) %>%
  mutate(Predictor = factor(Predictor, 
                            levels = rev(c("Closed-Form Cultural Matching (0–6)", 
                                           "Open-Ended Activity Matching (0–5)", 
                                           "Cultural Network Opacity (0–6)",
                                           "Structural Embeddedness (+1 SD)")), 
                            ordered = TRUE))

p1 <- ggplot(comp_combined, aes(y = Predictor, x = estimate, fill = Predictor, color = Predictor)) +
  geom_col(width = 0.35, alpha = 0.85) +
  geom_errorbar(aes(xmin = conf.low, xmax = conf.high), width = 0.12, linewidth = 0.8) +
  scale_x_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_fill_manual(values = c(
    "Closed-Form Cultural Matching (0–6)" = "#1f78b4", 
    "Open-Ended Activity Matching (0–5)" = "#33a02c", 
    "Cultural Network Opacity (0–6)" = "#e31a1c",
    "Structural Embeddedness (+1 SD)" = "#ff7f00"
  )) +
  scale_color_manual(values = c(
    "Closed-Form Cultural Matching (0–6)" = "#12476b", 
    "Open-Ended Activity Matching (0–5)" = "#1e5e1a", 
    "Cultural Network Opacity (0–6)" = "#941113",
    "Structural Embeddedness (+1 SD)" = "#a65200"
  )) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
  labs(y = NULL, x = "Average Marginal Effect on\nProbability of Protection from Tie Decay") +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "none",
    axis.text.y = element_text(face = "bold", color = "black"),
    panel.grid.minor = element_blank()
  )

ggsave(here("Plots", "main_effects.png"), plot = p1, width = 6.5, height = 4.2, dpi = 300)

# ==============================================================================
# SECTION 3: SUBJECTIVE CLOSENESS INTERACTIONS (FIGURE 2)
# ==============================================================================
message("[4/5] Estimating closeness interactions and generating Figure 2...")

ctrl_vars_int <- "common_alters_std + same_dorm + is_friend + race_homophily + freq_daily + female_factor * alterfemale_factor + duration_c + duration_sq_c + period"

mod_close_int_closed <- glmer(
  as.formula(paste("persisted ~ num_match_closed * close_factor +", ctrl_vars_int, "+ (1 | egoid)")),
  data = df_period, family = binomial(link = "logit"), control = glmer_ctrl, nAGQ = 0
)

mod_close_int_open <- glmer(
  as.formula(paste("persisted ~ open_match_count * close_factor +", ctrl_vars_int, "+ (1 | egoid)")),
  data = df_period, family = binomial(link = "logit"), control = glmer_ctrl, nAGQ = 0
)

mod_close_int_unknown <- glmer(
  as.formula(paste("persisted ~ num_unknown * close_factor +", ctrl_vars_int, "+ (1 | egoid)")),
  data = df_period, family = binomial(link = "logit"), control = glmer_ctrl, nAGQ = 0
)

comp_int_closed <- comparisons(
  mod_close_int_closed, 
  variables = list(num_match_closed = c(0, 6)), 
  newdata = datagrid(close_factor = c("Not Close", "Somewhat Close", "Close")), 
  re.form = NA
) %>% as_tibble() %>% mutate(Cultural_Variable = "Closed-Form Cultural Matching (0–6)")

comp_int_open <- comparisons(
  mod_close_int_open, 
  variables = list(open_match_count = c(0, 5)), 
  newdata = datagrid(close_factor = c("Not Close", "Somewhat Close", "Close")), 
  re.form = NA
) %>% as_tibble() %>% mutate(Cultural_Variable = "Open-Ended Activity Matching (0–5)")

comp_int_opacity <- comparisons(
  mod_close_int_unknown, 
  variables = list(num_unknown = c(0, 6)), 
  newdata = datagrid(close_factor = c("Not Close", "Somewhat Close", "Close")), 
  re.form = NA
) %>% as_tibble() %>% mutate(Cultural_Variable = "Cultural Network Opacity (0–6)")

comp_int_combined <- bind_rows(comp_int_closed, comp_int_open, comp_int_opacity) %>%
  mutate(
    Cultural_Variable = factor(Cultural_Variable, 
                                levels = c("Closed-Form Cultural Matching (0–6)", 
                                           "Open-Ended Activity Matching (0–5)", 
                                           "Cultural Network Opacity (0–6)"), 
                                ordered = TRUE),
    close_factor = factor(close_factor, levels = c("Close", "Somewhat Close", "Not Close"), ordered = TRUE)
  )

p_int <- ggplot(comp_int_combined, aes(y = close_factor, x = estimate, fill = Cultural_Variable, color = Cultural_Variable)) +
  geom_col(width = 0.4, alpha = 0.85) +
  geom_errorbar(aes(xmin = conf.low, xmax = conf.high), width = 0.15, linewidth = 0.8) +
  scale_x_continuous(labels = scales::percent_format(accuracy = 1)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
  facet_wrap(~Cultural_Variable, ncol = 3) +
  labs(y = "Subjective Closeness", x = "Average Marginal Effect on\nProbability of Protection from Tie Decay") +
  scale_fill_manual(values = c(
    "Closed-Form Cultural Matching (0–6)" = "#1f78b4", 
    "Open-Ended Activity Matching (0–5)" = "#33a02c", 
    "Cultural Network Opacity (0–6)" = "#e31a1c"
  )) +
  scale_color_manual(values = c(
    "Closed-Form Cultural Matching (0–6)" = "#12476b", 
    "Open-Ended Activity Matching (0–5)" = "#1e5e1a", 
    "Cultural Network Opacity (0–6)" = "#941113"
  )) +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "none", 
    strip.text = element_text(face = "bold", size = 10.5),
    axis.text.y = element_text(face = "bold", color = "black"),
    panel.spacing = unit(1.2, "lines")
  )

ggsave(here("Plots", "interaction_closeness.png"), plot = p_int, width = 6.5, height = 3.6, dpi = 300)

# ==============================================================================
# SECTION 4: SENSITIVITY MODELS (TABLE 4) & FIGURE 3 (FE PREDICTIONS)
# ==============================================================================
message("[5/5] Estimating sensitivity models (first dissolution & ego FE), Table 4, and Figure 3...")

# Sensitivity Model 1: Absorbing First Dissolution (First continuous spell only)
df_period_spells <- df_period %>%
  arrange(egoid, alterid, wave) %>%
  group_by(egoid, alterid) %>%
  mutate(
    lag_wave = lag(wave),
    lag_persisted = lag(persisted),
    is_new_spell = row_number() == 1 | (!is.na(lag_persisted) & lag_persisted == 0) | (!is.na(lag_wave) & wave > lag_wave + 1),
    spell_id = cumsum(is_new_spell),
    is_first_spell = (spell_id == 1)
  ) %>%
  ungroup()

df_first <- df_period_spells %>% filter(is_first_spell)

mod_first <- glmer(
  persisted ~ num_match_closed + open_match_count + num_unknown +
    close_factor + female_factor + alterfemale_factor + same_dorm +
    is_friend + race_homophily + freq_daily + duration_c +
    duration_sq_c + period + common_alters_std + (1 | egoid),
  data = df_first,
  family = binomial,
  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 2e5))
)

# Sensitivity Model 2: Ego Fixed-Effects (Conditional Logit)
mod_fe <- clogit(
  persisted ~ num_match_closed + open_match_count + num_unknown + common_alters_std + same_dorm + is_friend + 
    race_homophily + freq_daily + alterfemale_factor + close_factor + duration_c + duration_sq_c + period + strata(egoid),
  data = df_period,
  method = "efron"
)

# Table 4: Sensitivity Models (Absorbing First Dissolution and Ego Fixed-Effects)
s_first <- summary(mod_first)$coefficients
s_fe <- summary(mod_fe)$coefficients

terms_fe <- c(
  "num_match_closed" = "Closed-Form Matches",
  "open_match_count" = "Open-Ended Matches",
  "num_unknown" = "Network Opacity",
  "common_alters_std" = "Structural Embeddedness (Common Alters)",
  "close_factorSomewhat Close" = "Subjective Closeness: Somewhat",
  "close_factorClose" = "Subjective Closeness: Close",
  "same_dorm" = "Roommate/Dormmate",
  "is_friend" = "Friend",
  "freq_daily" = "Frequency: Daily (vs Weekly)",
  "race_homophilyHomophilous" = "Race Homophily: Same Race",
  "duration_c" = "Tie Duration (Scaled)",
  "duration_sq_c" = "Tie Duration Sq (Scaled)"
)

rob_lines <- c(
  "\\begin{table}[htbp]",
  "\\centering",
  "\\begin{talltblr}[         %% tabularray outer open",
  "caption={Sensitivity Models: Absorbing First Dissolution and Ego Fixed-Effects\\label{tbl-robustness-models}},",
  "note{}={+ p \\num{< 0.1}, * p \\num{< 0.05}, ** p \\num{< 0.01}, *** p \\num{< 0.001}},",
  "note{ }={Note: Model 1 restricts follow-up strictly to the initial continuous tie spell until first tie decay or censoring, excluding all subsequent recurrent/rekindled spells. Model 2 stratifies the likelihood by ego (conditional logit), isolating within-ego variation. Both models adjust for alter gender and wave transition fixed effects; Model 1 also includes ego gender and an ego random intercept.},",
  "]                     %% tabularray outer close",
  "{                     %% tabularray inner open",
  "width=\\linewidth,",
  "colspec={X[2.5,l] X[1.2,c] X[1.2,c]},",
  "row{odd}={rowsep=0.5pt},",
  "row{even}={rowsep=0.5pt},",
  "hline{2}={1-3}{solid, black, 0.05em},",
  paste0("hline{", 2 * length(terms_fe) + 2, "}={1-3}{solid, black, 0.05em},"),
  "hline{1}={1-3}{solid, black, 0.08em},",
  paste0("hline{", 2 * length(terms_fe) + 5, "}={1-3}{solid, black, 0.08em},"),
  "column{2-3}={}{halign=c},",
  "column{1}={}{halign=l},",
  "}                     %% tabularray inner close",
  " & Absorbing First Decay & Ego FE (clogit) \\\\"
)

for (t_name in names(terms_fe)) {
  label <- terms_fe[t_name]
  
  # Model 1 (First Dissolution)
  if (t_name %in% rownames(s_first)) {
    est1 <- exp(s_first[t_name, 1])
    se1  <- est1 * s_first[t_name, 2]
    p1   <- s_first[t_name, 4]
    star1 <- case_when(
      p1 < 0.001 ~ "***",
      p1 < 0.01  ~ "**",
      p1 < 0.05  ~ "*",
      p1 < 0.1   ~ "+",
      TRUE       ~ ""
    )
    col1_est <- sprintf("\\num{%.3f}%s", est1, star1)
    col1_se  <- sprintf("(\\num{%.3f})", se1)
  } else {
    col1_est <- ""
    col1_se  <- ""
  }
  
  # Model 2 (Ego FE)
  if (t_name %in% rownames(s_fe)) {
    est2 <- s_fe[t_name, "exp(coef)"]
    se2  <- est2 * s_fe[t_name, "se(coef)"]
    p2   <- s_fe[t_name, "Pr(>|z|)"]
    star2 <- case_when(
      p2 < 0.001 ~ "***",
      p2 < 0.01  ~ "**",
      p2 < 0.05  ~ "*",
      p2 < 0.1   ~ "+",
      TRUE       ~ ""
    )
    col2_est <- sprintf("\\num{%.3f}%s", est2, star2)
    col2_se  <- sprintf("(\\num{%.3f})", se2)
  } else {
    col2_est <- ""
    col2_se  <- ""
  }
  
  rob_lines <- c(rob_lines, sprintf("%s & %s & %s \\\\", label, col1_est, col2_est))
  rob_lines <- c(rob_lines, sprintf(" & %s & %s \\\\", col1_se, col2_se))
}

rob_lines <- c(
  rob_lines,
  sprintf("Num.Obs. & \\num{%d} & \\num{%d} \\\\", nobs(mod_first), mod_fe$nevent),
  sprintf("AIC & \\num{%.1f} & \\num{%.1f} \\\\", AIC(mod_first), AIC(mod_fe)),
  sprintf("BIC & \\num{%.1f} & \\num{%.1f} \\\\", BIC(mod_first), BIC(mod_fe)),
  "\\end{talltblr}",
  "\\end{table}"
)
writeLines(rob_lines, here("Tabs", "robustness_models.tex"))

# Figure 3: Counterfactual Predicted Probability Curves from Ego Fixed-Effects
vars_in_fe <- all.vars(formula(mod_fe))
df_fe_cc <- df_period[complete.cases(df_period[, vars_in_fe]), ]

rhs_formula <- ~ num_match_closed + open_match_count + num_unknown + common_alters_std + same_dorm + is_friend + 
  race_homophily + freq_daily + alterfemale_factor + close_factor + duration_c + duration_sq_c + period

beta_fe <- coef(mod_fe)
x_mat <- model.matrix(rhs_formula, data = df_fe_cc)
common_cols <- intersect(colnames(x_mat), names(beta_fe))
eta_no_alpha <- as.vector(x_mat[, common_cols] %*% beta_fe[common_cols])
df_fe_cc$eta_no_alpha <- eta_no_alpha

df_varying <- df_fe_cc %>%
  group_by(egoid) %>%
  mutate(m_i = sum(persisted), n_i = n()) %>%
  ungroup() %>%
  filter(m_i > 0, m_i < n_i)

alpha_map <- df_varying %>%
  group_by(egoid) %>%
  summarise(
    m_i = first(m_i),
    n_i = first(n_i),
    alpha = uniroot(
      function(a) sum(plogis(a + eta_no_alpha)) - m_i,
      interval = c(-20, 20)
    )$root,
    .groups = "drop"
  )

df_varying <- df_varying %>% left_join(alpha_map %>% select(egoid, alpha), by = "egoid")

get_counterfactual_me <- function(var_name, x_vals, beta_val, se_val) {
  x_actual <- df_varying[[var_name]]
  eta_other <- df_varying$alpha + df_varying$eta_no_alpha - beta_val * x_actual
  p0 <- mean(plogis(eta_other + beta_val * 0))
  
  map_dfr(x_vals, function(x) {
    eta_x <- eta_other + beta_val * x
    probs <- plogis(eta_x)
    avg_p <- mean(probs)
    me <- avg_p - p0
    grad <- mean(probs * (1 - probs) * x)
    se_me <- abs(grad) * se_val
    tibble(
      x = x,
      marginal_effect = me,
      conf_low = me - 1.96 * se_me,
      conf_high = me + 1.96 * se_me
    )
  })
}

curve_closed <- get_counterfactual_me("num_match_closed", 0:6, beta_fe["num_match_closed"], sqrt(vcov(mod_fe)["num_match_closed", "num_match_closed"])) %>%
  mutate(Predictor = "Closed-Form\nCultural Matching")

curve_open <- get_counterfactual_me("open_match_count", 0:5, beta_fe["open_match_count"], sqrt(vcov(mod_fe)["open_match_count", "open_match_count"])) %>%
  mutate(Predictor = "Open-Ended\nActivity Matching")

curve_opac <- get_counterfactual_me("num_unknown", 0:6, beta_fe["num_unknown"], sqrt(vcov(mod_fe)["num_unknown", "num_unknown"])) %>%
  mutate(Predictor = "Cultural Network\nOpacity")

df_fe_me <- bind_rows(curve_closed, curve_open, curve_opac) %>%
  mutate(Predictor = factor(Predictor, levels = c("Closed-Form\nCultural Matching", "Open-Ended\nActivity Matching", "Cultural Network\nOpacity")))

p_fe <- ggplot(df_fe_me, aes(y = factor(x), x = marginal_effect, fill = Predictor, color = Predictor)) +
  geom_col(width = 0.65, alpha = 0.85) +
  geom_errorbar(aes(xmin = conf_low, xmax = conf_high), width = 0.25, linewidth = 0.7) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
  facet_wrap(~Predictor, scales = "free_y", ncol = 3) +
  scale_x_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_fill_manual(values = c(
    "Closed-Form\nCultural Matching" = "#1f78b4", 
    "Open-Ended\nActivity Matching" = "#33a02c", 
    "Cultural Network\nOpacity" = "#e31a1c"
  )) +
  scale_color_manual(values = c(
    "Closed-Form\nCultural Matching" = "#12476b", 
    "Open-Ended\nActivity Matching" = "#1e5e1a", 
    "Cultural Network\nOpacity" = "#941113"
  )) +
  labs(
    y = "Predictor Value (Count)",
    x = "Marginal Effect on Probability of Protection from Tie Decay (vs. 0)"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    legend.position = "none",
    strip.text = element_text(face = "bold", size = 10),
    axis.text.y = element_text(face = "bold", color = "black"),
    axis.title.y = element_text(margin = margin(r = 6)),
    axis.title.x = element_text(margin = margin(t = 6)),
    panel.spacing = unit(1.2, "lines"),
    panel.grid.minor = element_blank()
  )

ggsave(here("Plots", "fe_predicted_probabilities.png"), plot = p_fe, width = 6.5, height = 3.6, dpi = 300)

# ==============================================================================
# SECTION 5: CROSS-CLASSIFIED & DYADIC CLUSTERING MODELS (TABLE 5 / APPENDIX)
# ==============================================================================
message("      Estimating cross-classified & dyadic clustering models (Tabs/cross_classified_models.tex)...")

df_period_cc <- df_period %>%
  mutate(
    dyad_id = if_else(egoid < alterid, paste(egoid, alterid, sep = "_"), paste(alterid, egoid, sep = "_")),
    alter_is_ego = alterid %in% unique(df_period$egoid)
  )

form_crossed <- as.formula(paste("persisted ~ num_match_closed + open_match_count + num_unknown +", ctrl_vars, "+ (1 | egoid) + (1 | alterid)"))
fit_crossed <- glmer(form_crossed, data = df_period_cc, family = binomial, control = glmer_ctrl, nAGQ = 0)

form_dyad <- as.formula(paste("persisted ~ num_match_closed + open_match_count + num_unknown +", ctrl_vars, "+ (1 | egoid) + (1 | dyad_id)"))
fit_dyad <- glmer(form_dyad, data = df_period_cc, family = binomial, control = glmer_ctrl, nAGQ = 0)

df_no_alter_ego <- df_period_cc %>% filter(!alter_is_ego)
form_no_ae <- as.formula(paste("persisted ~ num_match_closed + open_match_count + num_unknown +", ctrl_vars, "+ (1 | egoid)"))
fit_no_alter_ego <- glmer(form_no_ae, data = df_no_alter_ego, family = binomial, control = glmer_ctrl, nAGQ = 0)

get_full_coefs <- function(mod, name) {
  co <- summary(mod)$coefficients
  var_names <- rownames(co)
  tibble(
    Model = name,
    term = var_names,
    estimate = co[, "Estimate"],
    std_error = co[, "Std. Error"],
    p_value = co[, "Pr(>|z|)"],
    or = exp(co[, "Estimate"])
  )
}

all_mod_coefs <- bind_rows(
  get_full_coefs(mod_embed, "M1_Ego"),
  get_full_coefs(fit_crossed, "M2_Crossed"),
  get_full_coefs(fit_dyad, "M3_Dyad"),
  get_full_coefs(fit_no_alter_ego, "M4_Excl")
)

display_terms_cc <- c(
  "num_match_closed" = "Closed-Form Cultural Matching",
  "open_match_count" = "Open-Ended Activity Matching",
  "num_unknown" = "Cultural Network Opacity",
  "common_alters_std" = "Structural Embeddedness (Common Alters)",
  "close_factorSomewhat Close" = "Subjective Closeness: Somewhat",
  "close_factorClose" = "Subjective Closeness: Close",
  "same_dorm" = "Roommate/Dormmate",
  "is_friend" = "Friend",
  "freq_daily" = "Frequency: Daily (vs Weekly)",
  "duration_c" = "Tie Duration (Scaled)",
  "duration_sq_c" = "Tie Duration Sq (Scaled)"
)

cc_lines <- c(
  "\\begin{table}[htbp]",
  "\\centering",
  "\\small",
  "\\begin{talltblr}[         %% tabularray outer open",
  "caption={Sensitivity Analysis: Cross-Classified Random Effects and Dyadic Clustering Models\\label{tbl-cross-classified}},",
  "note{}={+ p \\num{< 0.1}, * p \\num{< 0.05}, ** p \\num{< 0.01}, *** p \\num{< 0.001}},",
  "note{ }={Note: All models control for ego and alter gender identity, gender interaction, race homophily, and wave transition fixed effects. Model 1 is the primary hierarchical random-intercept model. Model 2 estimates crossed random intercepts for both egos and alters. Model 3 specifies random intercepts for egos and unique undirected dyads. Model 4 excludes the 389 dyad-periods where alter is also a survey ego.},",
  "]                     %% tabularray outer close",
  "{                     %% tabularray inner open",
  "width=\\linewidth,",
  "colspec={X[2.5,l] X[1,c] X[1,c] X[1,c] X[1.1,c]},",
  "row{odd}={rowsep=0.2pt},",
  "row{even}={rowsep=0.2pt},",
  "hline{2}={1-5}{solid, black, 0.05em},",
  paste0("hline{", 2 * length(display_terms_cc) + 2, "}={1-5}{solid, black, 0.05em},"),
  "hline{1}={1-5}{solid, black, 0.08em},",
  paste0("hline{", 2 * length(display_terms_cc) + 6, "}={1-5}{solid, black, 0.08em},"),
  "column{1}={}{halign=l},",
  "column{2-5}={}{halign=c},",
  "}                     %% tabularray inner close",
  "& {Model 1\\\\Standard} & {Model 2\\\\Crossed} & {Model 3\\\\Dyad} & {Model 4\\\\Excl. Ego-Alters} \\\\"
)

for (t in names(display_terms_cc)) {
  label <- display_terms_cc[t]
  row_ors <- c()
  row_ses <- c()
  for (m in c("M1_Ego", "M2_Crossed", "M3_Dyad", "M4_Excl")) {
    sub <- all_mod_coefs %>% filter(Model == m, term == t)
    if (nrow(sub) == 0) {
      row_ors <- c(row_ors, "")
      row_ses <- c(row_ses, "")
    } else {
      p_val <- sub$p_value
      star <- if (p_val < 0.001) "***" else if (p_val < 0.01) "**" else if (p_val < 0.05) "*" else if (p_val < 0.10) "+" else ""
      row_ors <- c(row_ors, sprintf("\\num{%.3f}%s", sub$or, star))
      row_ses <- c(row_ses, sprintf("(\\num{%.3f})", sub$std_error))
    }
  }
  cc_lines <- c(cc_lines, sprintf("%s & %s \\\\", label, paste(row_ors, collapse = " & ")))
  cc_lines <- c(cc_lines, sprintf(" & %s \\\\", paste(row_ses, collapse = " & ")))
}

n_obs <- c(nrow(df_period_cc), nrow(df_period_cc), nrow(df_period_cc), nrow(df_no_alter_ego))
n_egos <- c(length(unique(df_period_cc$egoid)), length(unique(df_period_cc$egoid)), length(unique(df_period_cc$egoid)), length(unique(df_no_alter_ego$egoid)))
var_ego_str <- sapply(list(mod_embed, fit_crossed, fit_dyad, fit_no_alter_ego), function(mod) {
  vc <- as.data.frame(VarCorr(mod))
  sprintf("%.3f", vc$sdcor[vc$grp == "egoid"])
})
var_alter_str <- c("", sprintf("\\num{%.3f}", as.data.frame(VarCorr(fit_crossed))$sdcor[as.data.frame(VarCorr(fit_crossed))$grp == "alterid"]),
                   sprintf("\\num{%.3f}", as.data.frame(VarCorr(fit_dyad))$sdcor[as.data.frame(VarCorr(fit_dyad))$grp == "dyad_id"]), "")

cc_lines <- c(
  cc_lines,
  sprintf("Ego Random Intercept SD ($\\sigma_u$) & \\num{%s} & \\num{%s} & \\num{%s} & \\num{%s} \\\\", var_ego_str[1], var_ego_str[2], var_ego_str[3], var_ego_str[4]),
  sprintf("Alter/Dyad Random Intercept SD & %s & %s & %s & %s \\\\", var_alter_str[1], var_alter_str[2], var_alter_str[3], var_alter_str[4]),
  sprintf("Dyad-Periods ($N$) & \\num{%d} & \\num{%d} & \\num{%d} & \\num{%d} \\\\", n_obs[1], n_obs[2], n_obs[3], n_obs[4]),
  sprintf("Unique Egos & \\num{%d} & \\num{%d} & \\num{%d} & \\num{%d} \\\\", n_egos[1], n_egos[2], n_egos[3], n_egos[4]),
  "\\end{talltblr}",
  "\\end{table}"
)

writeLines(cc_lines, here("Tabs", "cross_classified_models.tex"))

message("All manuscript deliverables (Tabs/ and Plots/) generated successfully!")
