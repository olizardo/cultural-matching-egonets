library(dplyr)
library(tidyr)

df_period <- readRDS("data/processed/adjacent_waves.rds")
# Add persisted back in
df_period <- df_period %>%
  mutate(
    persisted = as.numeric(tie_persist > 0),
    freq_high = as.numeric(freq_factor %in% c("Weekly", "Daily")),
    duration_sq = duration_^2
  ) %>%
  filter(!is.na(freq_high))

cat_df <- df_period |>
  select(
    `Tie Persisted` = persisted, 
    `Subjective Closeness` = close_factor, 
    `Ego Gender` = female_factor, 
    `Alter Gender` = alterfemale_factor, 
    `Roommate/Dormmate` = same_dorm, 
    `Friend` = is_friend, 
    `Race Homophily` = race_homophily, 
    `Time Period` = period,
    `Frequency: Weekly/Daily` = freq_high
  ) |>
  mutate(
    `Tie Persisted` = ifelse(`Tie Persisted` == 1, "Yes", "No"),
    `Roommate/Dormmate` = ifelse(`Roommate/Dormmate` == 1, "Yes", "No"),
    `Friend` = ifelse(`Friend` == 1, "Yes", "No"),
    `Frequency: Weekly/Daily` = ifelse(`Frequency: Weekly/Daily` == 1, "Yes", "No")
  ) |>
  mutate(across(everything(), as.character)) |>
  mutate(
    `Ego Gender` = ifelse(`Ego Gender` == "Female", "Woman", `Ego Gender`),
    `Ego Gender` = ifelse(`Ego Gender` == "Male", "Man", `Ego Gender`),
    `Alter Gender` = ifelse(`Alter Gender` == "Female", "Woman", `Alter Gender`),
    `Alter Gender` = ifelse(`Alter Gender` == "Male", "Man", `Alter Gender`)
  ) |>
  pivot_longer(everything(), names_to = "Variable", values_to = "Category") |>
  filter(!is.na(Category)) |>
  count(Variable, Category) |>
  group_by(Variable) |>
  mutate(Percent = n / sum(n) * 100) |>
  ungroup() |>
  select(Variable, Category, N = n, Percent)

cont_df <- df_period |> 
  select(
    `Closed-Form Matches` = num_match_closed, 
    `Open-Ended Matches` = open_match_count, 
    `Network Opacity` = num_unknown, 
    `Tie Duration (Years)` = duration_,
    `Tie Duration Squared` = duration_sq
  ) |>
  summarise(across(everything(), list(
    Mean = ~mean(., na.rm = TRUE),
    SD = ~sd(., na.rm = TRUE),
    Min = ~min(., na.rm = TRUE),
    Max = ~max(., na.rm = TRUE)
  ))) |>
  pivot_longer(everything(), names_to = c("Variable", ".value"), names_sep = "_(?=[^_]+$)")

saveRDS(list(cont = cont_df, cat = cat_df), "data/processed/descriptives.rds")
