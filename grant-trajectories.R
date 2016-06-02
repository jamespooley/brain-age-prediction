# library(nlme)
library(dplyr)
library(ggplot2)

pardoe_file <- "data/pardoe.motion.morphometry.20160416.csv"
motion_df <- read.csv(pardoe_file) %>% 
  filter(study == "adhd") %>% 
  mutate(age_cent = age - mean(age, na.rm = TRUE),
         age_cent2 = age_cent^2,
         age_cent3 = age_cent^3)
# motion.artifact %in% c(1, 2),

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


#############################################################
# ORDER OF BEST-FITTING NEURODEVELOPMENTAL TRAJECTORY MODEL #
#############################################################


rois <- names(motion_df[16:80])  # Get FreeSurfer ROI names from Pardoe et al.'s data
roi_list <- as.list(rois)  # Convert to list for easy programming

# Helper function to get p-value for regression coefficients
get_coefficient_p_value <- function(fit_summary, param, df) {
  p <- fit_summary$coefficients[param, "Pr(>|t|)"]
  p
}

# Helper function to get model's R^2 value 
get_r2 <- function(fit_summary) {
  r2 <- fit_summary$r.squared
  r2
}

# Helper function to get model's F-statistic
get_f_statistic <- function(fit_summary) {
  f <- fit_summary$fstatistic
  f
}

# TODO (DRY): Combine the following two functions into one function

# Function to get order of best model when no motion covariate used
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


# Function to get order of best model when motion covariate used
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


# Get vector of model orders using various motion estimates
best_model_without_motion <- sapply(roi_list, get_best_without_motion, analysis_df)
best_model_with_motion_snr <- sapply(roi_list, get_best_with_motion, "SNR", analysis_df)
best_model_with_motion_qi1 <- sapply(roi_list, get_best_with_motion, "Qi1", analysis_df)

# Make a nice data frame of results
roi_trajectory_results <- as.data.frame(rois) %>% 
  mutate(best_model_without_motion = best_model_without_motion,
         best_model_with_motion_snr = best_model_with_motion_snr,
         best_model_with_motion_qi1 = best_model_with_motion_qi1,
         different_snr = best_model_without_motion != best_model_with_motion_snr,
         different_qi1 = best_model_without_motion != best_model_with_motion_qi1)

# Inspect the data frame
roi_trajectory_results %>% View


#########################################
# AGE OF PEAK CORTICAL THICKNESS/VOLUME #
#########################################

# Helper function to get the age of peak cortical thickness for a single ROI
get_peak_age <- function(roi, get_best_model, df, diagnosis, site, sex, motion_estimate = NULL) {
  
  df <- df %>% 
    filter(diagnosis == diagnosis, site == site, sex == sex)
  
  if (!is.null(motion_estimate)) {
    fmla_linear <- as.formula(paste0(roi," ~ poly(age, degree = 1, raw = TRUE) +", motion_estimate))
    fmla_quadratic <- as.formula(paste0(roi," ~ poly(age, degree = 2, raw = TRUE) +", motion_estimate))
    fmla_cubic <- as.formula(paste0(roi," ~ poly(age, degree = 3, raw = TRUE) +", motion_estimate))
  } else {
    fmla_linear <- as.formula(paste0(roi," ~ poly(age, degree = 1, raw = TRUE)"))
    fmla_quadratic <- as.formula(paste0(roi," ~ poly(age, degree = 2, raw = TRUE)"))
    fmla_cubic <- as.formula(paste0(roi," ~ poly(age, degree = 3, raw = TRUE)"))
  }
  
  fit_linear <- lm(fmla_linear, data = df)
  fit_quadratic <- lm(fmla_quadratic, data = df)
  fit_cubic <- lm(fmla_cubic, data = df)
  
  fits <- list(fit_linear, fit_quadratic, fit_cubic)

  summaries <- lapply(fits, summary)
  p1 <- get_coefficient_p_value(summaries[[1]], "poly(age, degree = 1, raw = TRUE)")
  p2 <- get_coefficient_p_value(summaries[[2]], "poly(age, degree = 2, raw = TRUE)2")
  p3 <- get_coefficient_p_value(summaries[[3]], "poly(age, degree = 3, raw = TRUE)3")
  
  
  model_comparison <- AIC(fit_linear, fit_quadratic, fit_cubic)
  
  if (p3 < .05 & model_comparison$AIC[3] < model_comparison$AIC[2] & model_comparison$AIC[3] < model_comparison$AIC[1]) {
    best_model <- 3
  } else if (p2 < .05 & model_comparison$AIC[2] < model_comparison$AIC[1]) {
    best_model <- 2
  } else
    best_model <- 1
  
  # If the best-fitting model is first-order linear, then just output a sentinel value ...
  if (best_model == 1) {
    peak_age <- -999
  # ... otherwise construct the appropriate model formula
  } else if (best_model == 2) {
    fmla <- as.formula(paste0(roi," ~ poly(age, degree = 2, raw = TRUE) +", motion_estimate))
  } else
    fmla <- as.formula(paste0(roi," ~ poly(age, degree = 3, raw = TRUE) +", motion_estimate))
  
  # Fit the appropriate model
  fit <- lm(fmla, data = df)
  
  age_range <- range(df$age)
  age <- seq(age_range[1], age_range[2], by = 0.01)
  n_ages <- length(age)
  sex <- rep(sex, length = n_ages)
  site <- rep(site, length = n_ages)
  diagnosis <- rep(diagnosis, length = n_ages)
  
  new_df <- data.frame(age = age,
                       sex = sex,
                       diagnosis = diagnosis,
                       site = site)
  
  model_preds <- predict(best_model, new_df)
  
  peak_age_idx <- which.max(best_model_preds)
  peak_age <- new_df$ages[peak_age_idx]
  peak_age
}

peak_ages_tdc_no_motion <- sapply(roi_list, get_peak_age, get_best_without_motion_mnml)
peak_ages_adhd_no_motion <- sapply(roi_list, get_peak_age, get_best_without_motion_mnml)
