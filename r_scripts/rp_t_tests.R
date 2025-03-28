### R script used to calculate the descriptive statistics for reporting practices of t-tests

# Load packages
library("readxl")
library("here")
library("magrittr")
library("dplyr")

# Load data
rp_t_tests <- read_xlsx(here("data", "reporting.xlsx"), 
                        sheet = "rp_t_tests", 
                        range = cell_cols(c(5:11)))

# Clean data 
rp_t_tests %<>% mutate_if(is.numeric, as.factor) 
colnames(rp_t_tests) <- c("mean_sd", "t_test", "df", "ES", "CI", "pvalue_exact", "pvalue_rel")
rp_t_tests

counts_t_tests <- apply(rp_t_tests, 2, table)     
counts_t_tests <- as.data.frame(t(counts_t_tests))
colnames(counts_t_tests) <- c("no","yes")

# calculate percentage parameters reported (yes)
counts_t_tests %<>% mutate(percentage_yes = round((yes*100)/nrow(rp_t_tests), 2)) 
