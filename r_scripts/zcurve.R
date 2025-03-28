### This file contains the R script for the primary z-curve which included p-values 
### obtained from studies that tested a hypothesis

# Load packages
library(here)
library(readxl)
library(zcurve)
library(tidyverse)

# Load data
raw_data <- read_excel(here("data", "zcurve_data.xlsx"), sheet = "zcurve_jss")


### Z-curve for studies that only tested a hypothesis
# Select p-values from studies testing a hypothesis
tidy_data_1 <- raw_data %>% select(hypothesis,"P recalculated") %>% # select the two columns of interest
                            filter(str_detect(hypothesis, "y")) # select p-values only from studies testing a hypothesis

zjss_1 <- as.numeric(as.character(unlist(tidy_data_1$`P recalculated`)))
length(zjss_1)

# Conduct z-curve analysis
primary_zcurve <- zcurve(p = zjss_1)

# Summary of the z-curve analysis
summary(primary_zcurve, all = TRUE) 

# z-curve plot
pdf(here("figures", "figure2.pdf"), height = 6, width = 6, useDingbats = F)
plot(primary_zcurve, CI = TRUE, annotation = TRUE, main = "")
dev.off()

#Note that in the summary that z-curve was fitted using 89 z-values. This is because 
#z-curve method sets aside z > 6 to avoid fitting a large number of normal distributions 
#to extremely small p-values.This step has no influence on the final result.
#For detailed explanation, see Brunner & Schimmack (2020) https://doi.org/10.15626/MP.2018.874






