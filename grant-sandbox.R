library(readr)
library(dplyr)
library(stringr)
library(ggplot2)
library(purrr)

#####################################################################
# NB: This needs to be heavily refactoried fiven all the repetition #
#####################################################################

get_beta <- function(fit_summary, param) {
  beta <- fit_summary$coefficients[param, "Estimate"]
  beta
}

get_p <- function(fit_summary, param) {
  p <- fit_summary$coefficients[param, "Pr(>|t|)"]
  p
}

qap_measures <- c("EFC", "FWHM", "Qi1", "SNR", "FBER")
roi_names <- names(pardoe_df)[16:80]

##############################################################################
# ORGANIZE THE VARIOUS DATASETS ##############################################
##############################################################################
#
# TODO: Wrap all the code to organize the datasets into a function

func_temp_df <- read_csv("data/qap-numbers/qap_ADHD200_functional_temporal.csv") %>% 
  rename(id = Participant,
         session = Session,
         run = Series) %>% 
  mutate(id = as.character(id),
         id = str_pad(id, 7, pad = "0"))

anat_spat_df <- read_csv("data/qap-numbers/qap_ADHD200_anatomical_spatial.csv") %>% 
  rename(id = Participant,
         session = Session,
         run = Series) %>% 
  mutate(id = as.character(id),
         id = str_pad(id, 7, pad = "0"))

# Load the Pardoe et al. data
pardoe_file <- "data/pardoe.motion.morphometry.20160416.csv"
pardoe_df <- read_csv(pardoe_file) %>% 
  filter(study == "adhd")
pardoe_df

df <- func_temp_df %>%
  merge(pardoe_df, by = c("id", "session", "run"))

analysis_df <- inner_join(df[, c("id", "session", "run", "gender", "age", "site", "mean.rms", "motion.artifact", "RMSD (Mean)", 
                                 "freesurfer.EstimatedTotalIntraCranialVol", roi_names)], 
                    anat_spat_df[, c("id", "session", "run", qap_measures)], 
                    by = c("id", "session")) %>% 
  rename(sex = gender)

names(analysis_df)[9] <- "qap.mean.rms"

#########################################################################################
# FREESURFER VOLUMETRIC ANALYSES FOR EACH ROI AND VARIOUS QAP IMAGE "GOODNESS" MEASURES #
#########################################################################################
#
# TODO: Re-do with apply family? In any case, DRY

# QAP mean RMSD --------------------------------------------------------------

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

for (roi in 11:75) {
  struct_name <- names(analysis_df)[roi]
  
  temp_no <- summary(lm(analysis_df[, roi] ~ sex + age + site + freesurfer.EstimatedTotalIntraCranialVol, 
                        data = analysis_df))
  # beta_nomotion_val <- temp_no$coefficients[2, 1]
  # p_nomotion_val <- temp_no$coefficients[2, 4]
  # 
  beta_age_no <- temp_no$coefficients[3, 1]
  p_age_val_no <- temp_no$coefficients[3, 4]
  
  temp_mo <- summary(lm(analysis_df[, roi] ~ qap.mean.rms + sex + age + site + freesurfer.EstimatedTotalIntraCranialVol + age:qap.mean.rms, 
                        data = analysis_df))
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

freesurfer.vol.summary %>% 
  tbl_df %>%
  mutate(int_sig = p_val_interaction < .05,
         int_fdr = p.adjust(p_val_interaction, "fdr"),
         age_no_sig = p_age_val_no < .05,
         age_mo_sig = p_age_val_no < .05,
         age_diff = age_mo_sig != age_no_sig) %>% 
  View

results$diff_sig %>% sum(na.rm = TRUE)

# QAP EFC --------------------------------------------------------------------

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

for (roi in 11:75) {
  struct_name <- names(analysis_df)[roi]
  
  temp_no <- summary(lm(analysis_df[, roi] ~ sex + age + site + freesurfer.EstimatedTotalIntraCranialVol, 
                        data = analysis_df))
  # beta_nomotion_val <- temp_no$coefficients[2, 1]
  # p_nomotion_val <- temp_no$coefficients[2, 4]
  # 
  beta_age_no <- temp_no$coefficients[3, 1]
  p_age_val_no <- temp_no$coefficients[3, 4]
  
  temp_mo <- summary(lm(analysis_df[, roi] ~ EFC + sex + age + site + freesurfer.EstimatedTotalIntraCranialVol + age:EFC, 
                        data = analysis_df))
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

freesurfer.vol.summary %>% 
  tbl_df %>%
  mutate(int_sig = p_val_interaction < .05,
         int_fdr = p.adjust(p_val_interaction, "fdr"),
         age_no_sig = p_age_val_no < .05,
         age_mo_sig = p_age_val_no < .05,
         age_diff = age_mo_sig != age_no_sig) %>% 
  View

results$diff_sig %>% sum(na.rm = TRUE)

# QAP FWHM -------------------------------------------------------------------

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

for (roi in 11:75) {
  struct_name <- names(analysis_df)[roi]
  
  temp_no <- summary(lm(analysis_df[, roi] ~ sex + age + site + freesurfer.EstimatedTotalIntraCranialVol, 
                        data = analysis_df))
  # beta_nomotion_val <- temp_no$coefficients[2, 1]
  # p_nomotion_val <- temp_no$coefficients[2, 4]
  # 
  beta_age_no <- temp_no$coefficients[3, 1]
  p_age_val_no <- temp_no$coefficients[3, 4]
  
  temp_mo <- summary(lm(analysis_df[, roi] ~ FWHM + sex + age + site + freesurfer.EstimatedTotalIntraCranialVol + age:qap.mean.rms, 
                        data = analysis_df))
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

freesurfer.vol.summary %>% 
  tbl_df %>%
  mutate(int_sig = p_val_interaction < .05,
         int_fdr = p.adjust(p_val_interaction, "fdr"),
         age_no_sig = p_age_val_no < .05,
         age_mo_sig = p_age_val_no < .05,
         age_diff = age_mo_sig != age_no_sig) %>% 
  View

results$diff_sig %>% sum(na.rm = TRUE)

# QAP Qi1 --------------------------------------------------------------------

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

for (roi in 11:75) {
  struct_name <- names(analysis_df)[roi]
  
  temp_no <- summary(lm(analysis_df[, roi] ~ sex + age + site + freesurfer.EstimatedTotalIntraCranialVol, 
                        data = analysis_df))
  # beta_nomotion_val <- temp_no$coefficients[2, 1]
  # p_nomotion_val <- temp_no$coefficients[2, 4]
  # 
  beta_age_no <- temp_no$coefficients[3, 1]
  p_age_val_no <- temp_no$coefficients[3, 4]
  
  temp_mo <- summary(lm(analysis_df[, roi] ~ Qi1 + sex + age + site + freesurfer.EstimatedTotalIntraCranialVol + age:Qi1, 
                        data = analysis_df))
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

freesurfer.vol.summary %>% 
  tbl_df %>%
  mutate(int_sig = p_val_interaction < .05,
         int_fdr = p.adjust(p_val_interaction, "fdr"),
         age_no_sig = p_age_val_no < .05,
         age_mo_sig = p_age_val_no < .05,
         age_diff = age_mo_sig != age_no_sig) %>% 
  View

results$diff_sig %>% sum(na.rm = TRUE)

# QAP SNR --------------------------------------------------------------------

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

for (roi in 11:75) {
  struct_name <- names(analysis_df)[roi]
  
  temp_no <- summary(lm(analysis_df[, roi] ~ sex + age + site + freesurfer.EstimatedTotalIntraCranialVol, 
                        data = analysis_df))
  # beta_nomotion_val <- temp_no$coefficients[2, 1]
  # p_nomotion_val <- temp_no$coefficients[2, 4]
  # 
  beta_age_no <- temp_no$coefficients[3, 1]
  p_age_val_no <- temp_no$coefficients[3, 4]
  
  temp_mo <- summary(lm(analysis_df[, roi] ~ SNR + sex + age + site + freesurfer.EstimatedTotalIntraCranialVol + age:SNR, 
                        data = analysis_df))
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

freesurfer.vol.summary %>% 
  tbl_df %>%
  mutate(int_sig = p_val_interaction < .05,
         int_fdr = p.adjust(p_val_interaction, "fdr"),
         age_no_sig = p_age_val_no < .05,
         age_mo_sig = p_age_val_no < .05,
         age_diff = age_mo_sig != age_no_sig) %>% 
  View

results$diff_sig %>% sum(na.rm = TRUE)

# QAP FBER -------------------------------------------------------------------

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

for (roi in 11:75) {
  struct_name <- names(analysis_df)[roi]
  
  temp_no <- summary(lm(analysis_df[, roi] ~ sex + age + site + freesurfer.EstimatedTotalIntraCranialVol, 
                        data = analysis_df))
  # beta_nomotion_val <- temp_no$coefficients[2, 1]
  # p_nomotion_val <- temp_no$coefficients[2, 4]
  # 
  beta_age_no <- temp_no$coefficients[3, 1]
  p_age_val_no <- temp_no$coefficients[3, 4]
  
  temp_mo <- summary(lm(analysis_df[, roi] ~ FBER + sex + age + site + freesurfer.EstimatedTotalIntraCranialVol + age:FBER, 
                        data = analysis_df))
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

freesurfer.vol.summary %>% 
  tbl_df %>%
  mutate(int_sig = p_val_interaction < .05,
         int_fdr = p.adjust(p_val_interaction, "fdr"),
         age_no_sig = p_age_val_no < .05,
         age_mo_sig = p_age_val_no < .05,
         age_diff = age_mo_sig != age_no_sig) %>% 
  View

results$diff_sig %>% sum(na.rm = TRUE)