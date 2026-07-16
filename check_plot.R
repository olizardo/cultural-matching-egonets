df_period <- readRDS("data/processed/adjacent_waves.rds")
# Fix variable name from persisted to tie_persist and add other vars
df_period$female_factor <- as.factor(df_period$female)
df_period$alterfemale_factor <- as.factor(df_period$alterfemale)
df_period$is_friend <- ifelse(df_period$reltype == "Friend", 1, 0)
df_period$freq_high <- ifelse(df_period$freq_factor %in% c("Daily", "Weekly"), 1, 0)
df_period$same_dorm <- df_period$socialcontextschool
df_period$duration_sq <- df_period$duration_^2
df_period$race_homophily <- factor(sample(c("Homophilous", "Heterophilous"), nrow(df_period), replace=T)) # mock since we don't have the full script prep
df_period$close_factor <- factor(ifelse(df_period$close == 1, "Not Close", ifelse(df_period$close == 2, "Somewhat Close", "Close")), levels=c("Not Close", "Somewhat Close", "Close"))

library(lme4)
library(marginaleffects)
library(dplyr)

glmer_ctrl <- glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 100000))
ctrl_vars_int <- "duration_ + duration_sq" # keep it simple for testing slopes

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

comp_int_closed <- comparisons(mod_close_int_closed, variables = list(num_match_closed = c(0, 6)), newdata = datagrid(close_factor = c("Not Close", "Somewhat Close", "Close")), re.form = NA) %>% as_tibble()
comp_int_open <- comparisons(mod_close_int_open, variables = list(open_match_count = c(0, 5)), newdata = datagrid(close_factor = c("Not Close", "Somewhat Close", "Close")), re.form = NA) %>% as_tibble()
comp_int_opacity <- comparisons(mod_close_int_unknown, variables = list(num_unknown = c(0, 6)), newdata = datagrid(close_factor = c("Not Close", "Somewhat Close", "Close")), re.form = NA) %>% as_tibble()

print("Closed Matches Slopes:")
print(comp_int_closed %>% select(close_factor, estimate))

print("Open Matches Slopes:")
print(comp_int_open %>% select(close_factor, estimate))

print("Unknown Slopes:")
print(comp_int_opacity %>% select(close_factor, estimate))
