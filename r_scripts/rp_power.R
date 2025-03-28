### R script used to calculate descriptive statistics for the usage and 
### reporting practices of a-priori power analyses

# Load packages
library("readxl")
library("here")
library("magrittr")
library("dplyr")

# Load data
studies_power <- read_xlsx(here("data", "reporting.xlsx"), 
                           sheet = "full_sample", 
                           range =  cell_cols(7))


# Percentage of studies according to the type of power analysis: a priori power analysis (y), 
# sensitivity power analysis,post-hoc power analysis (post) or no power calculation (n)
counts_power <- as.data.frame(sapply(studies_power, table)) # sort data in a table

counts_power %<>% mutate(percentage = pre_power*100 / nrow(studies_power))
print(counts_power)


# reporting practices of a-priori power analyses
data <- read_xlsx("reporting.xlsx", sheet = "rp_power", range = "C1:M48") # load file

data %<>% select(everything()) %>% mutate_all(as.factor) # data clean

counts <- apply(data, 2 , table) # count frequencies

# frequency for types of ES justifications (number of studies with pre-study power calculation = 44)
counts_justifications <- as.data.frame(counts$`type of justification`) # transform into a data frame

counts_justifications %<>% mutate(percentage = round((Freq*100)/44, 2)) # calculate percentage of usage
print(counts_justifications)                       

# frequency for the other parameters (software, statistical test, dependent variable, etc)
counts[[9]] <- NULL # remove type of justifications from the list

counts_others <- as.data.frame(do.call(rbind, counts)) # transform into a data frame

counts_others %<>% mutate(percentage = round(y*100 / 44, 2)) # calculate percentage of usage
print(counts_others)

