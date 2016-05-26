library(readr)
library(dplyr)
library(stringr)
library(MASS)
library(ggplot2)

pardoe_file <- "data/pardoe.motion.morphometry.20160416.csv"
pardoe_df <- read_csv(pardoe_file) %>% filter(study == "adhd")
pardoe_df

func_temp_df <- read_csv("data/qap-numbers/qap_ADHD200_functional_temporal.csv")
anat_spat_df <- read_csv("data/qap-numbers/qap_ADHD200_anatomical_spatial.csv")

# Ordered logistic regression analysis with qualitative motion artifact ratings 

combined_df <- merge(filter(anat_spat_df, Series == "anat_1", Session == "session_1"), 
                     filter(func_temp_df, Series == "rest_1", Session == "session_1"), 
                     by = c("Participant")) %>%
  mutate(Participant = as.character(Participant),
         Participant = str_pad(Participant, 7, pad = "0")) %>%
  rename(id = Participant) %>% 
  merge(pardoe_df, by = "id") %>%
  mutate(motion.artifact = factor(motion.artifact)) %>% 
  tbl_df

names(combined_df) <- make.names(names(combined_df))
names(combined_df)

qap_measures <- c("RMSD..Mean.", "EFC", "FWHM", "Qi1", "SNR", "FBER")

# Mean FD -----
glm_fit <- polr(motion.artifact ~ RMSD..Mean. + diagnosis + age + gender + site, 
                data = combined_df, Hess = TRUE)
summary(glm_fit)
(ctable <- coef(summary(glm_fit)))
p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
ctable <- cbind(ctable, "pval" = p)
ctable <- as.data.frame(ctable, row.names = rownames(ctable))
ctable$sig = ctable$pval < .05
ctable

# EFC -----
glm_fit <- polr(motion.artifact ~ EFC + diagnosis + age + gender + site, 
                data = combined_df, Hess = TRUE)
summary(glm_fit)
(ctable <- coef(summary(glm_fit)))
p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
ctable <- cbind(ctable, "pval" = p)
ctable <- as.data.frame(ctable, row.names = rownames(ctable))
ctable$sig = ctable$pval < .05
ctable

# FWHM -----
glm_fit <- polr(motion.artifact ~ FWHM + diagnosis + age + gender + site, 
                data = combined_df, Hess = TRUE)
summary(glm_fit)
(ctable <- coef(summary(glm_fit)))
p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
ctable <- cbind(ctable, "pval" = p)
ctable <- as.data.frame(ctable, row.names = rownames(ctable))
ctable$sig = ctable$pval < .05
ctable

# Qi1 -----
glm_fit <- polr(motion.artifact ~ Qi1 + diagnosis + age + gender + site, 
                data = combined_df, Hess = TRUE)
summary(glm_fit)
(ctable <- coef(summary(glm_fit)))
p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
ctable <- cbind(ctable, "pval" = p)
ctable <- as.data.frame(ctable, row.names = rownames(ctable))
ctable$sig = ctable$pval < .05
ctable

# SNR -----
glm_fit <- polr(motion.artifact ~ SNR + diagnosis + age + gender + site, 
                data = combined_df, Hess = TRUE)
summary(glm_fit)
(ctable <- coef(summary(glm_fit)))
p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
ctable <- cbind(ctable, "pval" = p)
ctable <- as.data.frame(ctable, row.names = rownames(ctable))
ctable$sig = ctable$pval < .05
ctable

# FBER -----
glm_fit <- polr(motion.artifact ~ FBER + diagnosis + age + gender + site, 
                data = combined_df, Hess = TRUE)
summary(glm_fit)
(ctable <- coef(summary(glm_fit)))
p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
ctable <- cbind(ctable, "pval" = p)
ctable <- as.data.frame(ctable, row.names = rownames(ctable))
ctable$sig = ctable$pval < .05
ctable


# Correlation between Pardoe et al.'s rs-fMRI motion proxy and QAP's mean RMSD

df <- func_temp_df %>%
  rename(id = Participant,
         session = Session,
         run = Series) %>%
  mutate(id = as.character(id),
         id = str_pad(id, 7, pad = "0")) %>%
  merge(pardoe_df, by = c("id", "session", "run"))


names(df) <- make.names(names(df), unique = TRUE)
names(df)

# Function to add correlation coefficient to plot
corr_eqn <- function(x, y, digits = 2) {
  corr_coef <- round(cor(x, y), digits = digits)
  paste("italic(r) == ", corr_coef)
}

labels = data.frame(x = 0.5, y = 7.5, 
                    label = corr_eqn(df[, "RMSD..Mean."], df[, "mean.rms"]))

# NB: annotate with geom = "text" avoids the need for labels data frame
ggplot(data = df) + 
  geom_point(aes(x = RMSD..Mean., y = mean.rms)) +
  geom_text(data = labels, 
            aes(x = x, y = y, label = label), 
            parse = TRUE)

# # What's up with not all of Pardoe et al.'s subjects being in the ADHD-200 QAP numbers?
# 
# qap_df <- func_temp_df %>%
#   rename(id = Participant,
#          session = Session,
#          run = Series) %>%
#   mutate(id = as.character(id),
#          id = str_pad(id, 7, pad = "0"))
# 
# length(unique(pardoe_df$id))
#   
# pardoe_subjs <- pardoe_df$id
# found <- c()
# for (subj in pardoe_subjs) {
#   found <- c(found, subj %in% qap_df$id)
# }
# sum(found)
# 
# length(setdiff(pardoe_df$id, qap_df$Participant))
# 
# # Helper functions to extract regression weight estimates and p-values
# 
# get_beta <- function(fit_summary, param) {
#   beta <- fit_summary$coefficients[param, "Estimate"]
#   beta
# }
# 
# get_p <- function(fit_summary, param) {
#   p <- fit_summary$coefficients[param, "Pr(>|t|)"]
#   p
# }