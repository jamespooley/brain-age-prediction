# library(nlme)
library(ggplot2)

pardoe_file <- "data/pardoe.motion.morphometry.20160416.csv"
motion_df <- read.csv(pardoe_file) %>% 
  filter(study == "adhd",
         motion.artifact %in% c(1, 2),
         diagnosis == "adhd") %>% 
  mutate(age_cent = age - mean(age, na.rm = TRUE),
         age_cent2 = age_cent^2,
         age_cent3 = age_cent^3)

# NOTE: USING ANALYSIS_DF AND NOT MOTION_DF


##############################################
# FreeSurfer Cortical Thickness Trajectories #
##############################################

# Without motion covoriate

linear_fit <- lm(freesurfer.TotalGrayVol ~ age_cent + diagnosis + site + gender, data = motion_df)
quadratic_fit <- lm(freesurfer.TotalGrayVol ~ poly(age_cent, 2) + diagnosis + site + gender, data = motion_df)
cubic_fit <- lm(freesurfer.TotalGrayVol ~ poly(age_cent, 3) + diagnosis + site + gender, data = motion_df)

AIC(linear_fit, quadratic_fit, cubic_fit)

# With motion covariate

linear_fit <- lm(freesurfer.TotalGrayVol ~ age_cent + diagnosis + site + gender + mean.rms, data = motion_df)
quadratic_fit <- lm(freesurfer.TotalGrayVol ~ poly(age_cent, 2) + diagnosis + site + gender + mean.rms, data = motion_df)
cubic_fit <- lm(freesurfer.TotalGrayVol ~ poly(age_cent, 3) + diagnosis + site + gender + mean.rms, data = motion_df)

global_fits <- list(linear_fit, quadratic_fit, cubic_fit)
lapply(global_fits, summary)

AIC(linear_fit, quadratic_fit, cubic_fit)

# for (roi in rois) {
#   
#   # Linear model
#   fmla_linear_without <- as.formula(paste0(roi," ~ age_cent + diagnosis + site + gender"))
#   fmla_linear_with <- as.formula(paste0(roi," ~ age_cent + diagnosis + site + gender + mean.rms"))
#   fit_linear_without <- lm(fmla_linear_without, data = motion_df)
#   fit_linear_with <- lm(fmla_linear_with, data = motion_df)
#   
#   fmla_linear_without <- as.formula(paste0(roi," ~ age_cent + diagnosis + site + gender"))
#   fmla_linear_with <- as.formula(paste0(roi," ~ age_cent + diagnosis + site + gender + mean.rms"))
#   fit_linear_without <- lm(fmla_linear_without, data = motion_df)
#   fit_linear_with <- lm(fmla_linear_with, data = motion_df)
#   
#   # Quadratic model
#   fmla_quadratic_without <- as.formula(paste0(roi," ~ age_cent + age_cent2 + diagnosis + site + gender"))
#   fmla_quadratic_with <- as.formula(paste0(roi," ~ age_cent + age_cent2 + diagnosis + site + gender + mean.rms"))
#   fit_quadratic_without <- lm(fmla_quadratic_without, data = motion_df)
#   fit_quadratic_with <- lm(fmla_quadratic_with, data = motion_df)
#   
#   fmla_quadratic_without <- as.formula(paste0(roi," ~ poly(age_cent, 2) + diagnosis + site + gender"))
#   fmla_quadratic_with <- as.formula(paste0(roi," ~ poly(age_cent, 2) + diagnosis + site + gender + mean.rms"))
#   fit_quadratic_without <- lm(fmla_quadratic_without, data = motion_df)
#   fit_quadratic_with <- lm(fmla_quadratic_with, data = motion_df)
#   
#   # Cubic model
#   fmla_cubic_without <- as.formula(paste0(roi," ~ age_cent + diagnosis + site + gender"))
#   fmla_cubic_with <- as.formula(paste0(roi," ~ age_cent + diagnosis + site + gender + mean.rms"))
#   fit_cubic_without <- lm(fmla_cubic_without, data = motion_df)
#   fit_cubic_with <- lm(fmla_cubic_with, data = motion_df)
#   
#   fmla_cubic_without <- as.formula(paste0(roi," ~ poly(age_cent, 3) + diagnosis + site + gender"))
#   fmla_cubic_with <- as.formula(paste0(roi," ~ poly(age_cent, 3) + diagnosis + site + gender + mean.rms"))
#   fit_cubic_without <- lm(fmla_cubic_without, data = motion_df)
#   fit_cubic_with <- lm(fmla_cubic_with, data = motion_df)
#   
#   print(roi)
#   print("WITHOUT motion covariate")
#   print(AIC(fit_linear_without, fit_quadratic_without, fit_cubic_without))
#   print("WITH motion covariate")
#   print(AIC(fit_linear_with, fit_quadratic_with, fit_cubic_with))
#   
# }

rois <- names(motion_df[16:80])
rois

get_coefficient_p_value <- function(fit_summary, param, df) {
  p <- fit_summary$coefficients[param, "Pr(>|t|)"]
  p
}

# TODO (DRY): Combine the following two functions into one function

get_best_without_motion <- function(roi, df) {
  
  fmla_linear <- as.formula(paste0(roi," ~ age_cent + diagnosis + site + sex + age_cent:diagnosis"))
  fmla_quadratic <- as.formula(paste0(roi," ~ age_cent + age_cent2 + diagnosis + site + sex + age_cent:diagnosis"))
  fmla_cubic <- as.formula(paste0(roi," ~ age_cent + age_cent2 + age_cent3 + diagnosis + site + sex + age_cent:diagnosis"))
  
  fit_linear <- lm(fmla_linear, data = df)
  fit_quadratic <- lm(fmla_quadratic, data = df)
  fit_cubic <- lm(fmla_cubic, data = df)
  
  fits <- list(fit_linear, fit_quadratic, fit_cubic)
  # fits
  
  summaries <- lapply(fits, summary)
  p1 <- get_coefficient_p_value(summaries[[1]], "age_cent")
  p2 <- get_coefficient_p_value(summaries[[2]], "age_cent2")
  p3 <- get_coefficient_p_value(summaries[[3]], "age_cent3")
  
  
  model_comparison <- AIC(fit_linear, fit_quadratic, fit_cubic)

  if (p3 < .05 & model_comparison$AIC[3] < model_comparison$AIC[2] & model_comparison$AIC[3] < model_comparison$AIC[1]) {
    model_order <- 3
  } else if (p2 < .05 & model_comparison$AIC[2] < model_comparison$AIC[1]) {
    model_order <- 2
  } else
    model_order <- 1

  model_order
}


# TODO: pass in motion estimate as a parameter for Pardoe vs. QAP comparisons
get_best_with_motion <- function(roi, motion_estimate, df) {
  
  fmla_linear <- as.formula(paste0(roi," ~ age_cent + diagnosis + site + sex + age_cent:diagnosis +", motion_estimate))
  fmla_quadratic <- as.formula(paste0(roi," ~ age_cent + age_cent2 + diagnosis + site + sex + age_cent:diagnosis +", motion_estimate))
  fmla_cubic <- as.formula(paste0(roi," ~ age_cent + age_cent2 + age_cent3 + diagnosis + site + sex + age_cent:diagnosis +", motion_estimate))
  
  fit_linear <- lm(fmla_linear, data = df)
  fit_quadratic <- lm(fmla_quadratic, data = df)
  fit_cubic <- lm(fmla_cubic, data = df)
  
  fits <- list(fit_linear, fit_quadratic, fit_cubic)
  # fits
  
  summaries <- lapply(fits, summary)
  p1 <- get_coefficient_p_value(summaries[[1]], "age_cent")
  p2 <- get_coefficient_p_value(summaries[[2]], "age_cent2")
  p3 <- get_coefficient_p_value(summaries[[3]], "age_cent3")
  
  
  model_comparison <- AIC(fit_linear, fit_quadratic, fit_cubic)
  
  if (p3 < .05 & model_comparison$AIC[3] < model_comparison$AIC[2] & model_comparison$AIC[3] < model_comparison$AIC[1]) {
    model_order <- 3
  } else if (p2 < .05 & model_comparison$AIC[2] < model_comparison$AIC[1]) {
    model_order <- 2
  } else
    model_order <- 1
  
  model_order
}


roi_list <- as.list(rois)
best_model_without_motion <- sapply(roi_list, get_best_without_motion, analysis_df)
best_model_with_motion_snr <- sapply(roi_list, get_best_with_motion, "SNR", analysis_df)
best_model_with_motion_qi1 <- sapply(roi_list, get_best_with_motion, "Qi1", analysis_df)

roi_trajectory_results <- as.data.frame(rois) %>% 
  mutate(best_model_without_motion = best_model_without_motion,
         best_model_with_motion_snr = best_model_with_motion_snr,
         best_model_with_motion_qi1 = best_model_with_motion_qi1,
         different_snr = best_model_without_motion != best_model_with_motion_snr,
         different_qi1 = best_model_without_motion != best_model_with_motion_qi1)

roi_trajectory_results %>% View
