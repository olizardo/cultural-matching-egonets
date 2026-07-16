## -----------------------------------------------------------------------------
#| label: setup
#| include: false
library(tidyverse)
library(lme4)
library(modelsummary)
library(here)
library(broom.mixed)
ego_race <- readRDS(here("data", "processed", "ego_race.rds")) %>% mutate(sender = as.character(sender))
alter_race <- readRDS(here("data", "processed", "alter_race.rds")) %>% mutate(receiver = as.character(receiver))
df_period <- readRDS(here("data", "processed", "adjacent_waves.rds")) %>%
  filter(kin == 0, campustie == 1, !is.na(alterid)) %>%
  left_join(ego_race, by = c("egoid" = "sender")) %>%
  left_join(alter_race, by = c("alterid" = "receiver")) %>%
  mutate(
    period = factor(period),
    persisted = as.numeric(tie_persist > 0),
    female_factor = factor(female, levels = c(0, 1), labels = c("Men", "Women")),
    alterfemale_factor = factor(alterfemale, levels = c(0, 1), labels = c("Men", "Women")),
    close_factor = factor(close, levels = c(3, 2, 1), labels = c("Not Close", "Somewhat Close", "Close")),
    same_dorm = as.numeric(reltype == 3 | reltype == 4),
    is_friend = as.numeric(reltype == 6),
    race_homophily = case_when(
      is.na(ego_race) | is.na(alter_race) ~ "Unknown",
      ego_race == alter_race ~ "Homophilous",
      TRUE ~ "Heterophilous"
    ),
    race_homophily = factor(race_homophily, levels = c("Heterophilous", "Homophilous", "Unknown")),
    freq_high = if_else(freq_factor %in% c("Weekly", "Daily"), 1, 0, missing = NA_real_),
    duration_sq = duration_^2
  ) %>%
  filter(!is.na(same_dorm), !is.na(freq_high))
glmer_ctrl <- glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 1e5))
ctrl_vars <- "same_dorm + is_friend + race_homophily + freq_high + female_factor + alterfemale_factor + close_factor + duration_ + duration_sq + period"
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


## -----------------------------------------------------------------------------
#| label: tbl-models
#| tbl-cap: "Odds Ratios for Tie Persistence (Main Effects Models)"
modelsummary(
  list("Model 1: Closed" = mod_closed, "Model 2: + Open" = mod_open, "Model 3: + Opacity" = mod_opac_base),
  stars = TRUE,
  exponentiate = TRUE,
  title = "Odds Ratios for Tie Persistence (Main Effects Models)\\label{tbl-models}",
  escape = FALSE,
  output = here::here("Tabs", "main_models.tex"),
  coef_map = c(
    "num_match_closed" = "Closed-Form Matches",
    "open_match_count" = "Open-Ended Matches",
    "num_unknown" = "Network Opacity",
    "close_factorSomewhat Close" = "Subjective Closeness: Somewhat",
    "close_factorClose" = "Subjective Closeness: Close",
    "same_dorm" = "Roommate/Dormmate",
    "is_friend" = "Friend",
    "freq_high" = "Frequency: Weekly/Daily",
    "race_homophilyHomophilous" = "Race Homophily: Same Race",
    "duration_" = "Tie Duration (Years)"
  ),
  gof_map = c("nobs", "aic", "bic"),
  notes = "Note: All models control for ego and alter gender, non-linear tie duration, and baseline hazard variations across all 7 wave transitions (coefficients omitted for space). Random intercepts for egos are included."
)


## -----------------------------------------------------------------------------
#| label: fig-combined
#| fig-cap: "Marginal Effects of Cultural Matches and Network Opacity (Min to Max)"
library(marginaleffects)

comp_closed <- comparisons(
  mod_open,
  variables = list(num_match_closed = range(df_period$num_match_closed, na.rm = TRUE)),
  newdata = datagrid(),
  re.form = NA
) %>% as_tibble() %>% mutate(Predictor = "Closed-Form Matches")

comp_open <- comparisons(
  mod_open,
  variables = list(open_match_count = range(df_period$open_match_count, na.rm = TRUE)),
  newdata = datagrid(),
  re.form = NA
) %>% as_tibble() %>% mutate(Predictor = "Open-Ended Matches")

comp_opacity <- comparisons(
  mod_opac_base,
  variables = list(num_unknown = range(df_period$num_unknown, na.rm = TRUE)),
  newdata = datagrid(),
  re.form = NA
) %>% as_tibble() %>% mutate(Predictor = "Network Opacity (Unknowns)")

comp_combined <- bind_rows(comp_closed, comp_open, comp_opacity) %>%
  mutate(Predictor = factor(Predictor, levels = rev(c("Closed-Form Matches", "Open-Ended Matches", "Network Opacity (Unknowns)")), ordered = TRUE))

p <- ggplot(comp_combined, aes(y = Predictor, x = estimate, fill = Predictor, color = Predictor)) +
  geom_col(width = 0.3, alpha = 0.8) +
  geom_errorbar(aes(xmin = conf.low, xmax = conf.high), width = 0.1, linewidth = 1) +
  scale_x_continuous(labels = scales::percent_format()) +
  scale_fill_manual(values = c("Closed-Form Matches" = "#1f78b4", "Open-Ended Matches" = "#33a02c", "Network Opacity (Unknowns)" = "#e31a1c")) +
  scale_color_manual(values = c("Closed-Form Matches" = "#12476b", "Open-Ended Matches" = "#1e5e1a", "Network Opacity (Unknowns)" = "#941113")) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
  labs(y = NULL, x = "Average Marginal Effect\n(Prob. of Persistence)") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none")

ggsave(here::here("Plots", "main_effects.png"), plot = p, width = 8, height = 6)
p


## -----------------------------------------------------------------------------
#| label: setup-closeness-interactions
#| include: false
ctrl_vars_int <- "same_dorm + is_friend + race_homophily + freq_high + female_factor * alterfemale_factor + duration_ + duration_sq + period"

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


## -----------------------------------------------------------------------------
#| label: fig-closeness-interactions
#| fig-cap: "Marginal Effects of Cultural Matching and Network Opacity by Subjective Closeness"
#| fig-width: 12
#| fig-height: 5
#| warning: false
library(patchwork)

comp_int_closed <- comparisons(mod_close_int_closed, variables = list(num_match_closed = c(0, 6)), newdata = datagrid(close_factor = c("Not Close", "Somewhat Close", "Close")), re.form = NA) %>% as_tibble() %>% mutate(Cultural_Variable = "Closed-Form Matches")
comp_int_open <- comparisons(mod_close_int_open, variables = list(open_match_count = c(0, 5)), newdata = datagrid(close_factor = c("Not Close", "Somewhat Close", "Close")), re.form = NA) %>% as_tibble() %>% mutate(Cultural_Variable = "Open-Ended Matches")
comp_int_opacity <- comparisons(mod_close_int_unknown, variables = list(num_unknown = c(0, 6)), newdata = datagrid(close_factor = c("Not Close", "Somewhat Close", "Close")), re.form = NA) %>% as_tibble() %>% mutate(Cultural_Variable = "Network Opacity (Unknowns)")

comp_int_combined <- bind_rows(comp_int_closed, comp_int_open, comp_int_opacity) %>%
  mutate(Cultural_Variable = factor(Cultural_Variable, levels = c("Closed-Form Matches", "Open-Ended Matches", "Network Opacity (Unknowns)"), ordered = TRUE),
         close_factor = factor(close_factor, levels = c("Close", "Somewhat Close", "Not Close"), ordered = TRUE))

p_int <- ggplot(comp_int_combined, aes(y = close_factor, x = estimate, fill = Cultural_Variable, color = Cultural_Variable)) +
  geom_col(width = 0.4, alpha = 0.8) +
  geom_errorbar(aes(xmin = conf.low, xmax = conf.high), width = 0.15, linewidth = 1) +
  scale_x_continuous(labels = scales::percent_format()) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
  facet_wrap(~Cultural_Variable) +
  labs(y = "Subjective Closeness", x = "Average Marginal Effect\n(Prob. of Persistence)") +
  scale_fill_manual(values = c("Closed-Form Matches" = "#1f78b4", "Open-Ended Matches" = "#33a02c", "Network Opacity (Unknowns)" = "#e31a1c")) +
  scale_color_manual(values = c("Closed-Form Matches" = "#12476b", "Open-Ended Matches" = "#1e5e1a", "Network Opacity (Unknowns)" = "#941113")) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none", strip.text = element_text(face = "bold"))

ggsave(here::here("Plots", "interaction_closeness.png"), plot = p_int, width = 12, height = 4.5)
p_int


## -----------------------------------------------------------------------------
#| label: tbl-descriptives
#| tbl-cap: "Descriptive Statistics"
library(modelsummary)
datasummary(
  (`Closed-Form Matches` = num_match_closed) +
  (`Open-Ended Matches` = open_match_count) + 
  (`Cultural Network Opacity` = num_unknown) + 
  (`Tie Duration (Years)` = duration_) ~ Mean + SD + Min + Max,
  data = df_period,
  title = "Descriptive Statistics (Continuous Variables)\\label{tbl-descriptives-cont}",
  escape = FALSE,
  output = here::here("Tabs", "desc_cont.tex")
)

datasummary(
  (`Tie Persisted` = factor(persisted)) +
  (`Ego Gender` = female_factor) + 
  (`Alter Gender` = alterfemale_factor) +
  (`Subjective Closeness` = close_factor) +
  (`Interaction Frequency` = factor(freq_factor)) +
  (`Race Homophily` = race_homophily) ~ N + Percent(),
  data = df_period,
  title = "Descriptive Statistics (Categorical Variables)\\label{tbl-descriptives-cat}",
  escape = FALSE,
  output = here::here("Tabs", "desc_cat.tex")
)


## -----------------------------------------------------------------------------
#| label: tbl-robustness-models
#| tbl-cap: "Odds Ratios for Tie Persistence (Ego Fixed-Effects Model)"
library(survival)

# Ego Fixed-Effects (Conditional Logit)
mod_fe <- clogit(
  persisted ~ num_match_closed + open_match_count + num_unknown + same_dorm + is_friend + 
    race_homophily + freq_high + alterfemale_factor + close_factor + duration_ + duration_sq + period + strata(egoid),
  data = df_period
)

modelsummary(
  list("Ego FE (clogit)" = mod_fe),
  stars = TRUE,
  exponentiate = TRUE,
  title = "Robustness Models (Ego Fixed-Effects)\\label{tbl-robustness-models}",
  escape = FALSE,
  output = here::here("Tabs", "robustness_models.tex"),
  coef_map = c(
    "num_match_closed" = "Closed-Form Matches",
    "open_match_count" = "Open-Ended Matches",
    "num_unknown" = "Network Opacity",
    "close_factorSomewhat Close" = "Subjective Closeness: Somewhat",
    "close_factorClose" = "Subjective Closeness: Close",
    "same_dorm" = "Roommate/Dormmate",
    "is_friend" = "Friend",
    "freq_high" = "Frequency: Weekly/Daily",
    "race_homophilyHomophilous" = "Race Homophily: Same Race",
    "duration_" = "Tie Duration (Years)"
  ),
  gof_map = c("nobs", "aic", "bic"),
  notes = "Note: Controls for ego and alter gender, non-linear tie duration, and period fixed effects."
)

