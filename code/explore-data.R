library(readr)
library(ggplot2)
library(dplyr)
# library(stringr)
# library(tidyr)
# library(tibble)
# library(broom)

morphometry_file <- "data/abide/lh.a2009s.volume.txt"
phenotypes_file <- "data/abide/Phenotypic_V1_0b_preprocessed1.csv"

phenotypes_df <- read_csv(phenotypes_file)
morphometry_df <- read_tsv(morphometry_file)

morphometry_df %>% View

morphometry_df$lh.aparc.a2009s.volume <- gsub("/", "", morphometry_df$lh.aparc.a2009s.volume)

morphometry_df %>% View
  
df <- phenotypes_df[!duplicated(names(phenotypes_df))] %>% 
  select(FILE_ID, AGE_AT_SCAN) %>%
  rename(lh.aparc.a2009s.volume = FILE_ID) %>%
  inner_join(morphometry_df, by = "lh.aparc.a2009s.volume")

df %>% View

ggplot(data = df) +
  geom_point(aes(x = AGE_AT_SCAN, y = lh_G_and_S_paracentral_volume)) +
  geom_smooth(aes(x = AGE_AT_SCAN, y = lh_G_and_S_paracentral_volume))