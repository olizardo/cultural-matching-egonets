library(tidyverse)
library(here)

# 1. Load Raw Data
egos <- read_csv("/home/omarlizardo/ACADEMIC AND COURSE MATERIALS/NetSense/Surveys/demographics_longitudinal_clean.csv", show_col_types=FALSE) %>%
  distinct(sender, .keep_all = TRUE)
nets <- read_csv("/home/omarlizardo/ACADEMIC AND COURSE MATERIALS/NetSense/Data/network_surveys_longitudinal_clean.csv", show_col_types=FALSE)

# 2. Extract Alter Ties
df_alters <- nets %>% 
  select(
    egoid = sender, 
    alterid = receiver, 
    wave, 
    closeness, 
    duration_ = duration, 
    reltype = notredamerelation,
    socialcontextschool,
    socialcontextoffcampus = socialcontexthomeneighborhood,
    altermusic, altermovies, alterbooks, altersports, altergames, alteroutdoor,
    sameactivities1, sameactivities2, sameactivities3, sameactivities4, sameactivities5,
    freqlastyear, freqlast3months,
    alter_gender = gender
  ) %>%
  filter(!is.na(alterid)) %>%
  mutate(
    # Recode frequency as it was before
    freq_interaction = coalesce(freqlastyear, freqlast3months),
    freq_factor = case_when(
      freq_interaction %in% 1:2 ~ "Daily",
      freq_interaction %in% 3:4 ~ "Weekly",
      freq_interaction %in% 5:6 ~ "Monthly",
      TRUE ~ "Less often"
    ),
    close = closeness,
    campustie = ifelse(reltype %in% c(1,2,3,4,6) & wave < 6, 1, 
                ifelse(reltype %in% c(1,2,3,4,6) & wave >= 6, 1, 0)),
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
  select(egoid = sender, gender_1, matches("^interestitems[1-6]_[1-7]$")) %>%
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

# 5. Merge Together
df_final <- df_all_waves %>%
  left_join(ego_long, by = c("egoid", "wave")) %>%
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