### R script used to calculate the descriptive statistics for reporting practices of F-tests 

# Load packages
library("readxl")
library("here")
library("magrittr")
library("dplyr")


# Load data for F-tests
p_f_tests <- read_xlsx(here("data", "reporting.xlsx"), 
                       sheet = "rp_f_tests", 
                       range = cell_cols(c(5:11)))


# Clean data 
rp_f_tests %<>% mutate_if(is.numeric, as.factor) 
colnames(rp_f_tests) <- c("mean_sd", "F_ratio", "df", "n2_np2", "CI", "pvalue_exact", "pvalue_rel")

# Count factors for each column
counts_f_tests <- apply(rp_f_tests, 2, table)     

counts_f_tests <- as.data.frame(do.call(rbind, counts_f_tests)) # transform into a data frame
colnames(counts_f_tests) <- c("no","yes")

# Calculate percentage parameters reported (yes)
counts_f_tests %<>% mutate(percentage_yes = round((yes*100)/nrow(rp_f_tests), 2)) 

# Calculate percentage of p values not reported
freq_no_pvalue <- rp_f_tests %>% filter(pvalue_exact == 0 & pvalue_rel == 0) %>% count()
freq_no_pvalue 
percentage_no_pvalue <- freq_no_pvalue *100 / nrow(rp_f_tests)
percentage_no_pvalue
