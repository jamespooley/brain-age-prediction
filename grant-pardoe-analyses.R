library(dplyr)
library(readr)
library(stringr)
library(ggplot2)


pardoe_file <- "data/pardoe.motion.morphometry.20160416.csv"
pardoe_df <- read_csv(pardoe_file)
motion_df <- pardoe_df  # Just rename things to get rid of this nonsense

# Cortical thickness across all studies

# Only focus on data qualitatively rated as "good" (i.e., free of motion artifact)
adhd200_good <- motion_df %>% 
  filter(study == "adhd", diagnosis == "control") %>% 
  rename(sex = gender) %>% 
  as.data.frame

# Fit without controlling for motio
fit_w_motion <- lm(freesurfer.mean.thickness ~ sex + mean.rms + age + site,
                   data = subset(adhd200_good, diagnosis == "control"))

# Fit controlling for motion
fit_w_motion <- lm(freesurfer.mean.thickness ~ mean.rms + diagnosis + sex + age + site + age:mean.rms + diagnosis:mean.rms, 
                   data = adhd200_good)

summary(fit_wo_motion)
summary(fit_w_motion)


# ROI ANALYSES ---------------------------------------------------------------

# Freesurfer volumetric analyses for each ROI
struct_name_vector <- c()
beta_motion_val_vector <- c()
p_motion_val_vector <- c()
beta_nomotion_val_vector <- c()
p_nomotion_val_vector <- c()

p_int_val_vector <- c()
p_age_motion_vector <- c()
p_age_nomotion_vector <- c()

beta_age_no_vector <- c()
beta_age_mo_vector <- c()

# TODO: Re-do with apply family?
for (roi in 16:80) {
  struct_name <- names(motion_df)[roi]
  
  temp_no <- summary(lm(adhd200_good[, roi] ~ sex + age + site + freesurfer.EstimatedTotalIntraCranialVol, 
                        data = adhd200_good))
  # beta_nomotion_val <- temp_no$coefficients[2, 1]
  # p_nomotion_val <- temp_no$coefficients[2, 4]
  # 
  beta_age_no <- temp_no$coefficients[3, 1]
  p_age_val_no <- temp_no$coefficients[3, 4]
  
  temp_mo <- summary(lm(adhd200_good[, roi] ~ mean.rms + sex + age + site + freesurfer.EstimatedTotalIntraCranialVol + age:mean.rms, 
                        data = adhd200_good))
  # beta_motion_val <- temp_mo$coefficients[2, 1]
  # p_motion_val <- temp_mo$coefficients[2, 4]
  
  
  # Age-Motion Interaction
  p_int_val <- temp_mo$coefficients[7, 4]
  
  beta_age_mo <- temp_mo$coefficients[4, 1]
  p_age_val_mo <- temp_mo$coefficients[4, 4] 
  
  struct_name_vector <- c(struct_name_vector, struct_name)
  # beta_motion_val_vector <- c(beta_motion_val_vector, beta_motion_val)
  # p_motion_val_vector <- c(p_motion_val_vector, p_motion_val)
  # beta_nomotion_val_vector <- c(beta_nomotion_val_vector, beta_nomotion_val)
  # p_nomotion_val_vector <- c(p_nomotion_val_vector, p_nomotion_val)
  p_int_val_vector <- c(p_int_val_vector, p_int_val)
  
  p_age_motion_vector <- c(p_age_motion_vector, p_age_val_mo) 
  p_age_nomotion_vector <- c(p_age_nomotion_vector, p_age_val_no)
  
  beta_age_no_vector <- c(beta_age_no_vector, beta_age_no)
  beta_age_mo_vector <- c(beta_age_mo_vector, beta_age_mo)
}

freesurfer.vol.summary <- data.frame(structure = struct_name_vector, 
                                     p_val_interaction = p_int_val_vector,
                                     beta_age_no = beta_age_no_vector,
                                     p_age_val_mo = p_age_motion_vector,
                                     beta_age_mo = beta_age_mo_vector,
                                     p_age_val_no = p_age_nomotion_vector)

# freesurfer.vol.summary <- data.frame(structure = struct_name_vector, 
#                                      effect_size_motion = beta_motion_val_vector, 
#                                      p_val_motion = p_motion_val_vector, 
#                                      effect_size_nomotion = beta_nomotion_val_vector, 
#                                      p_val_nomotion = p_nomotion_val_vector,
#                                      p_val_interaction = p_int_val_vector,
#                                      beta_age_no = beta_age_no_vector,
#                                      p_age_val_mo = p_age_motion_vector,
#                                      beta_age_mo = beta_age_mo_vector,
#                                      p_age_val_no = p_age_nomotion_vector)

# freesurfer.vol.summary %>% 
#   tbl_df %>%
#   mutate(nomo_sig = p_val_motion < .05, 
#          mo_sig = p_val_nomotion < .05,
#          diff_sig = nomo_sig != mo_sig,
#          int_sig = p_val_interaction < .05,
#          age_no_sig = p_age_val_no < .05,
#          age_mo_sig = p_age_val_no < .05,
#          age_diff = age_mo_sig != age_no_sig) %>% 
#   View

freesurfer.vol.summary %>% 
  tbl_df %>%
  mutate(int_sig = p_val_interaction < .05,
         int_fdr = p.adjust(p_val_interaction, "fdr"),
         age_no_sig = p_age_val_no < .05,
         age_mo_sig = p_age_val_no < .05,
         age_diff = age_mo_sig != age_no_sig) %>% 
  View

results$diff_sig %>% sum(na.rm = TRUE)

# freesurfer.vol.summary %>% tail
# freesurfer.vol.summary %>% arrange(p_val_motion)

# How are correlations with age affected by head motion for each of the regions

adhd200_good %>% View
