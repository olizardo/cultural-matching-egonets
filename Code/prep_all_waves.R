library(tidyverse)
library(here)

# 1. Load Raw Data
netsense_dir <- "/home/omarlizardo/projects/NETWORKS/NetSense"
egos <- read_csv(file.path(netsense_dir, "Surveys", "demographics_longitudinal_clean.csv"), show_col_types=FALSE) %>%
  distinct(sender, .keep_all = TRUE)
nets <- read_csv(file.path(netsense_dir, "Data", "network_surveys_longitudinal_clean.csv"), show_col_types=FALSE)
aat <- readRDS(file.path(netsense_dir, "Data", "alter_alter_ties_longitudinal.rds"))
enm <- readRDS(file.path(netsense_dir, "Data", "ego_network_metrics_longitudinal.rds"))

# 2. Extract Alter Ties
df_alters <- nets %>% 
  mutate(
    egoid = sub("\\.0+$", "", as.character(sender)),
    alterid = if_else(is.na(receiver), NA_character_, sub("\\.0+$", "", as.character(receiver)))
  ) %>%
  select(
    egoid, 
    alterid, 
    wave, 
    closeness, 
    duration_ = duration, 
    reltype,
    notredamerelation,
    socialcontextschool,
    socialcontextoffcampus = socialcontexthomeneighborhood,
    altermusic, altermovies, alterbooks, altersports, altergames, alteroutdoor,
    sameactivities1, sameactivities2, sameactivities3, sameactivities4, sameactivities5,
    freq_interaction, freqlastyear, freqlast3months,
    alter_gender = gender
  ) %>%
  filter(!is.na(alterid)) %>%
  mutate(
    # Keep original freq_interaction from wide data instead of coalescing which destroys it
    # freq_interaction = coalesce(freqlastyear, freqlast3months),
    freq_factor = case_when(
      freq_interaction %in% 1:2 ~ "Daily",
      freq_interaction %in% 3:4 ~ "Weekly",
      freq_interaction %in% 5:6 ~ "Monthly",
      freq_interaction %in% 7:9 ~ "Less often",
      TRUE ~ NA_character_
    ),
    close = closeness,
    campustie = ifelse(notredamerelation %in% c(1,2,3,4,6) & wave < 6, 1, 
                ifelse(notredamerelation %in% c(1,2,3,4,6) & wave >= 6, 1, 0)),
    kin = ifelse(reltype %in% c(7,8,9), 1, 0),
    alterfemale = ifelse(alter_gender == 2, 1, 0)
  ) %>%
  # For matching numeric structure
  mutate(across(c(altermusic, altermovies, alterbooks, altersports, altergames, alteroutdoor), as.numeric)) %>%
  rename(
    altermusic_ = altermusic,
    altermovies_ = altermovies,
    alterbooks_ = alterbooks,
    altersports_ = altersports,
    altergames_ = altergames,
    alteroutdoor_ = alteroutdoor
  )

# 3. Create "All Adjacent Waves" logic (t to t+1)
df_t <- df_alters %>% filter(wave < 8)
df_t1 <- df_alters %>% 
  select(egoid, alterid, wave) %>% 
  mutate(wave = wave - 1, tie_persist = 1) %>%
  distinct()

df_all_waves <- df_t %>%
  left_join(df_t1, by = c("egoid", "alterid", "wave")) %>%
  mutate(
    tie_persist = replace_na(tie_persist, 0),
    period = paste0("Wave ", wave, " to ", wave + 1)
  )

# 4. Reshape Ego Cultural and Demographic Data
ego_long <- egos %>%
  mutate(egoid = sub("\\.0+$", "", as.character(sender))) %>%
  select(egoid, gender_1, matches("^interestitems[1-6]_[1-7]$")) %>%
  pivot_longer(
    cols = matches("^interestitems[1-6]_[1-7]$"),
    names_to = c("domain_num", "wave"),
    names_pattern = "interestitems([1-6])_([1-7])",
    values_to = "interest"
  ) %>%
  mutate(
    wave = as.numeric(wave),
    interest_num = case_when(
      interest == "Very much" ~ 1,
      interest == "Somewhat" ~ 2,
      interest %in% c("Not that much", "Not at all") ~ 3,
      interest == "Not Sure" ~ 4,
      TRUE ~ NA_real_
    ),
    domain = case_when(
      domain_num == "1" ~ "egomusic_",
      domain_num == "2" ~ "egomovies_",
      domain_num == "3" ~ "egobooks_",
      domain_num == "4" ~ "egosports_",
      domain_num == "5" ~ "egogames_",
      domain_num == "6" ~ "egooutdoor_"
    )
  ) %>%
  select(-domain_num, -interest) %>%
  pivot_wider(names_from = domain, values_from = interest_num) %>%
  mutate(female = ifelse(gender_1 == "Female", 1, 0)) %>%
  select(-gender_1)

# 5. Extract Structural Embeddedness Metrics from Alter-Alter Network
pos_ties <- bind_rows(
  aat %>% select(sender, wave, pos = alter1_pos, other_pos = alter2_pos),
  aat %>% select(sender, wave, pos = alter2_pos, other_pos = alter1_pos)
) %>%
  distinct(sender, wave, pos, other_pos)

pos_degree <- pos_ties %>%
  group_by(sender, wave, pos) %>%
  summarise(alter_pos_degree = n(), .groups = "drop")

pos_map <- nets %>%
  filter(!is.na(position), !is.na(receiver)) %>%
  mutate(
    sender = sub("\\.0+$", "", as.character(sender)),
    receiver = sub("\\.0+$", "", as.character(receiver)),
    wave = as.integer(wave),
    position = as.integer(position)
  ) %>%
  select(sender, wave, position, receiver) %>%
  distinct()

enm_clean <- enm %>%
  mutate(
    sender = sub("\\.0+$", "", as.character(sender)),
    wave = as.integer(wave)
  )

alter_embedded_pos <- pos_map %>%
  left_join(pos_degree, by = c("sender", "wave", "position" = "pos")) %>%
  mutate(alter_pos_degree = replace_na(alter_pos_degree, 0)) %>%
  left_join(enm_clean %>% select(sender, wave, alters_nominated, density), by = c("sender", "wave")) %>%
  mutate(
    alter_closure_ratio = if_else(alters_nominated > 1, alter_pos_degree / (alters_nominated - 1), 0)
  )

alter_metrics_by_receiver <- alter_embedded_pos %>%
  group_by(sender, wave, receiver) %>%
  summarise(
    common_alters = max(alter_pos_degree),
    triadic_closure = max(alter_closure_ratio),
    ego_density = suppressWarnings(max(density, na.rm = TRUE)),
    .groups = "drop"
  ) %>%
  mutate(ego_density = if_else(is.infinite(ego_density), NA_real_, ego_density))

# 6. Merge Together
df_final <- df_all_waves %>%
  left_join(ego_long, by = c("egoid", "wave")) %>%
  left_join(alter_metrics_by_receiver, by = c("egoid" = "sender", "wave" = "wave", "alterid" = "receiver")) %>%
  mutate(
    # Matches
    match_music = as.numeric(egomusic_ == altermusic_ & !is.na(egomusic_) & !is.na(altermusic_) & egomusic_ < 5 & altermusic_ < 5),
    match_movies = as.numeric(egomovies_ == altermovies_ & !is.na(egomovies_) & !is.na(altermovies_) & egomovies_ < 5 & altermovies_ < 5),
    match_books = as.numeric(egobooks_ == alterbooks_ & !is.na(egobooks_) & !is.na(alterbooks_) & egobooks_ < 5 & alterbooks_ < 5),
    match_sports = as.numeric(egosports_ == altersports_ & !is.na(egosports_) & !is.na(altersports_) & egosports_ < 5 & altersports_ < 5),
    match_games = as.numeric(egogames_ == altergames_ & !is.na(egogames_) & !is.na(altergames_) & egogames_ < 5 & altergames_ < 5),
    match_outdoor = as.numeric(egooutdoor_ == alteroutdoor_ & !is.na(egooutdoor_) & !is.na(alteroutdoor_) & egooutdoor_ < 5 & alteroutdoor_ < 5),
    
    num_match_closed = rowSums(across(starts_with("match_")), na.rm = TRUE),
    
    # Opacity
    num_unknown = coalesce((altermusic_ == 5) + (altermovies_ == 5) + (alterbooks_ == 5) + 
                           (altersports_ == 5) + (altergames_ == 5) + (alteroutdoor_ == 5), 0),
    
    # Open ended
    sameactivities1 = ifelse(is.na(sameactivities1), 0, sameactivities1),
    sameactivities2 = ifelse(is.na(sameactivities2), 0, sameactivities2),
    sameactivities3 = ifelse(is.na(sameactivities3), 0, sameactivities3),
    sameactivities4 = ifelse(is.na(sameactivities4), 0, sameactivities4),
    sameactivities5 = ifelse(is.na(sameactivities5), 0, sameactivities5),
    open_match_count = sameactivities1 + sameactivities2 + sameactivities3 + sameactivities4 + sameactivities5
  )

# Fix the grouping factor issue for lme4 by ensuring IDs are characters/factors
df_final <- df_final %>%
  mutate(
    egoid = as.character(egoid),
    alterid = as.character(alterid)
  )

saveRDS(df_final, here("data", "processed", "adjacent_waves.rds"))
cat("Full dataset successfully created with all adjacent waves and replaced original adjacent_waves.rds.\n")