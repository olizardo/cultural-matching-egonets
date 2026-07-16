library(lme4)
library(marginaleffects)
library(dplyr)
library(ggplot2)

df_period <- readRDS("data/processed/adjacent_waves.rds")
ego_race <- readRDS("data/processed/ego_race.rds")
alter_race <- readRDS("data/processed/alter_race.rds")

# Convert sender/receiver to character so join works
ego_race <- ego_race %>% mutate(sender = as.character(sender))
alter_race <- alter_race %>% mutate(receiver = as.character(receiver))

df_period <- df_period %>%
  mutate(egoid = as.character(egoid), alterid = as.character(alterid)) %>%
  filter(kin == 0, campustie == 1, !is.na(alterid)) %>%
  left_join(ego_race, by = c("egoid" = "sender")) %>%
  left_join(alter_race, by = c("alterid" = "receiver")) %>%
  mutate(
    period = factor(period),
    persisted = as.numeric(tie_persist > 0),
    duration_sq = duration_^2,
    race_homophily = factor(ifelse(race.x == race.y, "Homophilous", "Heterophilous")),
    female_factor = factor(female, labels = c("Male", "Female")),
    alterfemale_factor = factor(alterfemale, labels = c("Male", "Female")),
    close_factor = factor(close, levels = 1:3, labels = c("Not Close", "Somewhat Close", "Close")),
    same_dorm = as.numeric(socialcontextschool == 1),
    freq_high = as.numeric(freq_factor %in% c("Weekly", "Daily")),
    is_friend = as.numeric(reltype == "Friend")
  ) %>%
  filter(!is.na(same_dorm), !is.na(freq_high))

glmer_ctrl <- glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 1e5))
ctrl_vars_int <- "same_dorm + is_friend + race_homophily + freq_high + female_factor * alterfemale_factor + duration_ + duration_sq + period"

# Interaction Plot
mod_close_int_closed <- glmer(as.formula(paste("persisted ~ num_match_closed * close_factor +", ctrl_vars_int, "+ (1 | egoid)")), data = df_period, family = binomial(link = "logit"), control = glmer_ctrl, nAGQ = 0)
mod_close_int_open <- glmer(as.formula(paste("persisted ~ open_match_count * close_factor +", ctrl_vars_int, "+ (1 | egoid)")), data = df_period, family = binomial(link = "logit"), control = glmer_ctrl, nAGQ = 0)
mod_close_int_unknown <- glmer(as.formula(paste("persisted ~ num_unknown * close_factor +", ctrl_vars_int, "+ (1 | egoid)")), data = df_period, family = binomial(link = "logit"), control = glmer_ctrl, nAGQ = 0)

comp_int_closed <- comparisons(mod_close_int_closed, variables = list(num_match_closed = c(0, 6)), newdata = datagrid(close_factor = c("Not Close", "Somewhat Close", "Close")), re.form = NA) %>% as_tibble() %>% mutate(Cultural_Variable = "Closed-Form Matches")
comp_int_open <- comparisons(mod_close_int_open, variables = list(open_match_count = c(0, 5)), newdata = datagrid(close_factor = c("Not Close", "Somewhat Close", "Close")), re.form = NA) %>% as_tibble() %>% mutate(Cultural_Variable = "Open-Ended Matches")
comp_int_opacity <- comparisons(mod_close_int_unknown, variables = list(num_unknown = c(0, 6)), newdata = datagrid(close_factor = c("Not Close", "Somewhat Close", "Close")), re.form = NA) %>% as_tibble() %>% mutate(Cultural_Variable = "Network Opacity (Unknowns)")

comp_int_combined <- bind_rows(comp_int_closed, comp_int_open, comp_int_opacity) %>%
  mutate(Cultural_Variable = factor(Cultural_Variable, levels = c("Closed-Form Matches", "Open-Ended Matches", "Network Opacity (Unknowns)"), ordered = TRUE),
         close_factor = factor(close_factor, levels = c("Not Close", "Somewhat Close", "Close"), ordered = TRUE))

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

ggsave("Plots/interaction_closeness.png", plot = p_int, width = 12, height = 4.5)
