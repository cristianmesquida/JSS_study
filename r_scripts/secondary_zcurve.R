### This file contains the R script for the primary z-curve which included p-values 
### obtained from either studies that tested a hypothesis (n = 89) or studies that had a
### a descriptive or estimation goal (n = 30).

# Load libraries
library(readxl)
library(zcurve)
library(tidyverse)
library(here)

# Load data 
data <- read_excel(here("data", "zcurve_data.xlsx"), sheet = "zcurve_jss")

# Select data 
data <- data %>% select("P recalculated") 

# Prepare data
data_zcurve <- as.numeric(as.character(unlist(data$`P recalculated`)))

# Conduct z-curve analysis with zcurve package
secondary_zcurve <- zcurve(p = data_zcurve)

# Summary of the z-curve analysis
summary(secondary_zcurve, all = TRUE) 

pdf(here("figures", "secondary_zcurve.pdf"), height = 6, width = 6, useDingbats = F)
plot(secondary_zcurve, CI = TRUE, annotation = TRUE, main = "")
dev.off()
