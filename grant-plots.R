library(readr)
library(dplyr)
library(stringr)
library(ggplot2)

qap_measures <- c("EFC", "FWHM", "Qi1", "SNR", "FBER")

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
  # mutate(id = as.character(id),
  #        id = str_pad(id, 7, pad = "0")) %>%
  merge(pardoe_df, by = c("id", "session", "run"))

gg_df <- inner_join(df[, c("id", "session", "run", "mean.rms", "motion.artifact", "RMSD (Mean)")], 
                   anat_spat_df[, c("id", "session", "run", qap_measures)], 
                   by = c("id", "session")) %>% 
  tbl_df

names(gg_df)[6] <- "qap.mean.rms"

ggplot(data = gg_df) +
  geom_boxplot(aes(x = as.factor(motion.artifact), y = mean.rms)) +
  xlab("Image Quality Rating (5 = Best)") +
  ylab("Pardoe et al. Mean RMSD") +
  ggtitle("Pardoe et al. Mean RMSD")

ggplot(data = gg_df) +
  geom_boxplot(aes(x = as.factor(motion.artifact), y = qap.mean.rms)) +
  xlab("Image Quality Rating (5 = Best)") +
  ylab("QAP Mean RMSD")

ggplot(data = gg_df) +
  geom_boxplot(aes(x = as.factor(motion.artifact), y = EFC)) +
  xlab("Image Quality Rating (5 = Best)") +
  ylab("EFC")

ggplot(data = gg_df) +
  geom_boxplot(aes(x = as.factor(motion.artifact), y = SNR)) +
  xlab("Image Quality Rating (5 = Best)") +
  ylab("SNR")

ggplot(data = gg_df) + 
  geom_boxplot(aes(x = as.factor(motion.artifact), y = FBER)) +
  xlab("Image Quality Rating (5 = Best)") +
  ylab("FBER")

ggplot(data = gg_df) + 
  geom_boxplot(aes(x = as.factor(motion.artifact), y = Qi1)) +
  xlab("Image Quality Rating (5 = Best)") +
  ylab("Qi1")