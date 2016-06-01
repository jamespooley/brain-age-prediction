library(dplyr)
library(readr)
library(stringr)
library(ggplot2)


pardoe_file <- "data/pardoe.motion.morphometry.20160416.csv"
pardoe_df <- read.csv(pardoe_file) %>% 
  filter(study == "adhd")

# TODO (DRY): Still a lot of replication to clean up here

rois <- names(pardoe_df[16:80])
roi_list <- as.list(rois)

fit_model_no_motion <- function(roi, df) {
  fmla <- as.formula(paste0(roi, " ~ diagnosis + sex + age + site + freesurfer.EstimatedTotalIntraCranialVol + age:diagnosis"))
  fit <-lm(fmla, data = df)
  fit_summary <- summary(fit)
  fit_summary
}

fit_model_motion <- function(roi, df, motion_estimate) {
  fmla <- as.formula(paste0(roi, " ~ diagnosis + sex + age + site + freesurfer.EstimatedTotalIntraCranialVol + age:diagnosis + ", 
                            motion_estimate))
  fit <-lm(fmla, data = df)
  fit_summary <- summary(fit)
  fit_summary
}

get_coefficient <- function(fit_summary, param) {
  beta <- fit_summary$coefficients["diagnosiscontrol", "Estimate"]
  beta
}

# Helper function to get p-value for regression coefficients
get_p_val <- function(fit_summary) {
  p <- fit_summary$coefficients["diagnosiscontrol", "Pr(>|t|)"]
  p
}


model_fits_no_motion <- lapply(roi_list, fit_model_no_motion, analysis_df)
model_fits_motion_rmsd <- lapply(roi_list, fit_model_motion, analysis_df, "mean.rms")
model_fits_motion_snr <- lapply(roi_list, fit_model_motion, analysis_df, "SNR")
model_fits_motion_qi1 <- lapply(roi_list, fit_model_motion, analysis_df, "Qi1")

beta_vals_no_motion <- sapply(model_fits_no_motion, get_coefficient)
p_vals_no_motion <- sapply(model_fits_no_motion, get_p_val)
beta_vals_motion_rmsd <- sapply(model_fits_motion_rmsd, get_coefficient)
p_vals_motion_rmsd <- sapply(model_fits_motion_rmsd, get_p_val)
beta_vals_motion_snr <- sapply(model_fits_motion_snr, get_coefficient)
p_vals_motion_snr <- sapply(model_fits_motion_snr, get_p_val)
beta_vals_motion_qi1 <- sapply(model_fits_motion_qi1, get_coefficient)
p_vals_motion_qi1 <- sapply(model_fits_motion_qi1, get_p_val)

results <- as.data.frame(rois) %>%
  mutate(beta_val_no_motion = beta_vals_no_motion,
         sig_no_motion = p_vals_no_motion < .05,
         beta_val_motion_rmsd = beta_vals_motion_rmsd,
         sig_motion_rmsd = p_vals_motion_rmsd < .05,
         rmsd_change = sig_motion_rmsd != sig_no_motion,
         beta_val_motion_snr = beta_vals_motion_snr,
         sig_motion_snr = p_vals_motion_snr <.05,
         snr_change = sig_motion_snr != sig_no_motion,
         beta_val_motion_qi1 = beta_vals_motion_qi1,
         sig_motion_qi1 = p_vals_motion_qi1 < .05,
         qi1_change = sig_motion_qi1 != sig_no_motion)

results %>% View

write.table(results, file = "group-analysis-results.csv", sep = ",", row.names = FALSE)
