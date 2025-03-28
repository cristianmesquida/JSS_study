### R script used to:
### Test for a sample size difference between studies that used an a-priori power 
### analysis and those which did not. We also test for the same difference when 
### studies tested an hypothesis.


# Load packages install
library("magrittr")
library("dplyr")
library("readxl")
library("stringr")
library("tidyverse") 
library("here")


# Load data
data <- read_xlsx(here("data", "reporting.xlsx"), sheet = "full_sample")


# Create a function to calculate descriptive data
descriptive_stats <- function(x) {
  # Calculate the mean
  mean_value <- mean(x)
  
  # Calculate the median
  median_value <- median(x)
  
  # Calculate the standard deviation
  sd_value <- sd(x)
  
  # Calculate the standard deviation
  n <- length(x)
  
  # Return the results as a list
  return(list(mean = mean_value, median = median_value, sd = sd_value, n = n))
}


# Data prepraration
sample_studies_wp <- data %>% filter(pre_power == "y") %>% select(sample) %>% 
                               pull() # select the sample of the studies which used a-priori power analyses

sample_studies_np <- data %>% filter(pre_power %in% c("sensitivity", "n", "post")) %>% 
                               select(sample) %>%
                               pull() # select the sample of the studies without a-priori power analyses


# Data exploration
barplot(sample_studies_wp, ylab = "sample size", xlab = "studies")
barplot(sample_studies_np, ylab = "sample size", xlab = "studies") # note there are two studies with 2871 and 714 subjects

# Descriptive statistics
descriptive_stats(sample_studies_wp) # for studies with a-priori power analysis
descriptive_stats(sample_studies_np) # for studies without a-priori power analysis

# Checking assumption of normality
shapiro.test(sample_studies_wp)
shapiro.test(sample_studies_np)

# Hypothesis test
wilcox.test(sample_studies_wp, sample_studies_np)


# As observed in data exploration, there are two studies in the sample of studies 
# without an a-priori power analysis that have a sample size of 2871 and 714. 
# Because these large two studies represent outliers if we consider the sample size 
# of all other studies, we regard as good practice to remove these two studies.

# Remove two large studies
sample_studies_np_2 <- sample_studies_np[sample_studies_np!= 2871 & sample_studies_np!= 714] 
barplot(sample_studies_np_2, ylab = "sample size", xlab = "studies")

# Descriptive statistics 
descriptive_stats(sample_studies_np_2) 

# Assessing assumption of normality
shapiro.test(sample_studies_np_2) 

# Hypothesis test
wilcox.test(sample_studies_wp,sample_studies_np_2) 


#-----------------------------------------------------------------------------#

## Testing for sample size differences with a Poisson regression 
data2 <- data %>% filter(sample != 2871 & sample != 714) %>% # select all studies but two outliers 
                   select(hypothesis, sample, pre_power) %>%
                   mutate(pre_power = ifelse(pre_power %in% c("post", "sensitivity"), "n", pre_power)) %>%
                   mutate_at(c('hypothesis', 'pre_power'), as.factor)
                   
descriptive_stats_data2 <- data2 %>% group_by(hypothesis, pre_power) %>% summarise(mean = mean(sample), sd = sd(sample))

ggplot(data2, aes(x = sample, colour = pre_power)) + # plot distribution of sample sizes
  geom_density() +
  guides(fill=guide_legend(title= "A-priori power analysis"))

# Assumption of variance = mean for Poisson regression
mean(data2$sample)
var(data2$sample) # mean and variance do not match

# The variance is larger than the mean what indicates that there is overdispersion
# Because under a Poisson model we would expect the means and variances of the response to be about 
# the same in various groups, we need to adjust for overdispersion. 

# Poisson regression with power analysis (a priori (y) or not power analysis (n)) as a predictor
model1 <- glm(sample ~ pre_power, family = quasipoisson, data = data2) 

summary(model1) # summary statistics of the glm model
exp(confint(model1)) # exponentiate 95% CI intercept & predictor for interpretation
exp(coef(model1)) # exponentiate coefficients for interpretation


# Same as above but only selecting studies that tested a hypothesis
data3 <- data2 %>% filter(hypothesis == "y") # select studies testing a hypothesis

ggplot(data3, aes(x = sample, colour = pre_power)) + # plot distribution of sample sizes
  geom_density()

# Poisson regression with power analysis (a priori (y) or not power analysis (n)) as a predictor
model2 <- glm(sample ~ pre_power, family = quasipoisson, data = data3)

summary(model2) # summary statistics of the glm model
exp(confint(model2)) # 95% CI
exp(coef(model2))


#-----------------------------------------------------------------------------#
## Percentage of studies that tested a hypothesis and included an a-priori power analysis
data2 %>%
  group_by(hypothesis, pre_power) %>%
  tally() %>%
  group_by()

# Percentage of studies that tested a hypothesis and included an a-priori power analysis = 38 / 129 = 29.46%
# Percentage of studies that did not test a hypothesis and included an a-priori power analysis = 6 / 43 = 14%

