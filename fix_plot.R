df_period <- readRDS("data/processed/adjacent_waves.rds")
# Fix variable name from persisted to tie_persist and add other vars
df_period$female_factor <- as.factor(df_period$female)
df_period$alterfemale_factor <- as.factor(df_period$alterfemale)
df_period$is_friend <- ifelse(df_period$reltype == "Friend", 1, 0)
df_period$freq_high <- ifelse(df_period$freq_factor %in% c("Daily", "Weekly"), 1, 0)
df_period$same_dorm <- df_period$socialcontextschool
df_period$duration_sq <- df_period$duration_^2
df_period$race_homophily <- factor(sample(c("Homophilous", "Heterophilous"), nrow(df_period), replace=T)) 
df_period$close_factor <- factor(ifelse(df_period$close == 1, "Not Close", ifelse(df_period$close == 2, "Somewhat Close", "Close")), levels=c("Not Close", "Somewhat Close", "Close"))

library(lme4)
library(marginaleffects)
library(dplyr)
library(ggplot2)

glmer_ctrl <- glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 100000))
ctrl_vars_int <- "duration_ + duration_sq" 

mod_close_int_closed <- glmer(
  as.formula(paste("tie_persist ~ num_match_closed * close_factor +", ctrl_vars_int, "+ (1 | egoid)")),
  data = df_period, family = binomial(link = "logit"), control = glmer_ctrl, nAGQ = 0
)
mod_close_int_open <- glmer(
  as.formula(paste("tie_persist ~ open_match_count * close_factor +", ctrl_vars_int, "+ (1 | egoid)")),
  data = df_period, family = binomial(link = "logit"), control = glmer_ctrl, nAGQ = 0
)
mod_close_int_unknown <- glmer(
  as.formula(paste("tie_persist ~ num_unknown * close_factor +", ctrl_vars_int, "+ (1 | egoid)")),
  data = df_period, family = binomial(link = "logit"), control = glmer_ctrl, nAGQ = 0
)

comp_int_closed <- comparisons(mod_close_int_closed, variables = list(num_match_closed = c(0, 6)), newdata = datagrid(close_factor = c("Not Close", "Somewhat Close", "Close")), re.form = NA) %>% as_tibble() %>% mutate(Cultural_Variable = "Closed-Form Matches")
comp_int_open <- comparisons(mod_close_int_open, variables = list(open_match_count = c(0, 5)), newdata = datagrid(close_factor = c("Not Close", "Somewhat Close", "Close")), re.form = NA) %>% as_tibble() %>% mutate(Cultural_Variable = "Open-Ended Matches")
comp_int_opacity <- comparisons(mod_close_int_unknown, variables = list(num_unknown = c(0, 6)), newdata = datagrid(close_factor = c("Not Close", "Somewhat Close", "Close")), re.form = NA) %>% as_tibble() %>% mutate(Cultural_Variable = "Network Opacity (Unknowns)")

comp_int_combined <- bind_rows(comp_int_closed, comp_int_open, comp_int_opacity) %>%
  mutate(Cultural_Variable = factor(Cultural_Variable, levels = c("Closed-Form Matches", "Open-Ended Matches", "Network Opacity (Unknowns)"), ordered = TRUE),
         close_factor = factor(close_factor, levels = rev(c("Not Close", "Somewhat Close", "Close")), ordered = TRUE))

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
