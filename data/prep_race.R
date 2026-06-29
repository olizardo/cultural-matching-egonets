library(dplyr)
library(readr)

dem_csv <- read_csv("/home/omarlizardo/ACADEMIC AND COURSE MATERIALS/NetSense/Surveys/demographics_longitudinal_clean.csv", show_col_types=FALSE)
net_csv <- read_csv("/home/omarlizardo/ACADEMIC AND COURSE MATERIALS/NetSense/Data/network_surveys_longitudinal_clean.csv", show_col_types=FALSE)

ego_race_lookup <- dem_csv %>%
  select(sender, ethnicity_1) %>%
  filter(!is.na(sender)) %>%
  distinct() %>%
  mutate(
    ego_race = case_when(
      ethnicity_1 == "White/Caucasian" ~ "White",
      ethnicity_1 == "African American/Black" ~ "Black",
      ethnicity_1 == "Asian American/Asian" ~ "Asian",
      ethnicity_1 %in% c("Mexican American/Chicano", "Puerto Rican", "Other Latino") ~ "Hispanic",
      TRUE ~ "Other"
    )
  ) %>% select(sender, ego_race)

race_cols <- grep("^race", colnames(net_csv), value=TRUE)
alter_race_lookup <- net_csv %>%
  select(receiver, all_of(race_cols)) %>%
  tidyr::pivot_longer(cols = all_of(race_cols), values_to = "race_val") %>%
  filter(!is.na(race_val)) %>%
  group_by(receiver) %>%
  summarize(alter_race_raw = first(race_val), .groups = 'drop') %>%
  mutate(
    alter_race = case_when(
      alter_race_raw == 1 ~ "White",
      alter_race_raw == 2 ~ "Black",
      alter_race_raw == 4 ~ "Asian",
      alter_race_raw %in% c(5, 6, 7, 8) ~ "Hispanic",
      TRUE ~ "Other"
    )
  ) %>% select(receiver, alter_race)

saveRDS(ego_race_lookup, "data/processed/ego_race.rds")
saveRDS(alter_race_lookup, "data/processed/alter_race.rds")
