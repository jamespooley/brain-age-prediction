# Helper function to get order of best-fitting trajectory model
get_model_order <- function(fit_list) {
  
  fit_linear <- fit_list[[1]]
  fit_quadratic <- fit_list[[2]]
  fit_cubi <- fit_list[[3]]
  
  model_comparison <- AIC(fit_linear, fit_quadratic, fit_cubic)
  
  summaries <- lapply(fits, summary)
  p1 <- get_coefficient_p_value(summaries[[1]], "age_cent")
  p2 <- get_coefficient_p_value(summaries[[2]], "age_cent2")
  p3 <- get_coefficient_p_value(summaries[[3]], "age_cent3")
  
  if (p3 < .05 & model_comparison$AIC[3] < model_comparison$AIC[2] & model_comparison$AIC[3] < model_comparison$AIC[1]) {
    model_order <- 3
  } else if (p2 < .05 & model_comparison$AIC[2] < model_comparison$AIC[1]) {
    model_order <- 2
  } else
    model_order <- 1
  
  model_order
}

# Helper function to fit and return order of best-fitting trajectory model
get_best_model <- function(roi, df, motion_estimate = NULL) {
  
  # Construct the model formula
  if (is.null(motion_estimate)) {
    fmla_linear <- as.formula(paste0(roi," ~ age_cent + diagnosis + site + sex + age_cent:diagnosis"))
    fmla_quadratic <- as.formula(paste0(roi," ~ age_cent + age_cent2 + diagnosis + site + sex + age_cent:diagnosis"))
    fmla_cubic <- as.formula(paste0(roi," ~ age_cent + age_cent2 + age_cent3 + diagnosis + site + sex + age_cent:diagnosis"))
  } else {
    fmla_linear <- as.formula(paste0(roi," ~ age_cent + diagnosis + site + sex + age_cent:diagnosis +", motion_estimate))
    fmla_quadratic <- as.formula(paste0(roi," ~ age_cent + age_cent2 + diagnosis + site + sex + age_cent:diagnosis +", motion_estimate))
    fmla_cubic <- as.formula(paste0(roi," ~ age_cent + age_cent2 + age_cent3 + diagnosis + site + sex + age_cent:diagnosis +", motion_estimate))
  }
  
  # Fit the models
  fit_linear <- lm(fmla_linear, data = df)
  fit_quadratic <- lm(fmla_quadratic, data = df)
  fit_cubic <- lm(fmla_cubic, data = df)
  
  fits <- list(fit_linear, fit_quadratic, fit_cubic)
  
  # Return the order of the best-fitting model
  model_order <- get_model_order(fit_list)
  model_order
}