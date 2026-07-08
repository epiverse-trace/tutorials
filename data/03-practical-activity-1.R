# nolint start

# Practical 3
# Activity 1

# step: fill in your room number
room_number <- #<COMPLETE> replace with 1/2/3/4

# Load packages -----------------------------------------------------------
library(epicontacts)
library(fitdistrplus)
library(tidyverse)


# Read linelist and contacts ----------------------------------------------
# step: Paste the URL links as a string to read input data.

dat_contacts <- readr::read_rds(
  "link/to/contact/data/url"#<COMPLETE>
)

dat_linelist <- readr::read_rds(
  "link/to/linelist/data/url"#<COMPLETE>
)


# Create an epicontacts object -------------------------------------------
# step: Build a *directed* epicontacts network from the linelist
# and contacts; paste a screenshot of the network in the report.

epi_contacts <- epicontacts::make_epicontacts(
  linelist = #<COMPLETE>,
  contacts = #<COMPLETE>,
  directed = TRUE
)

# Print output
epi_contacts

# Visualize the contact network
plot(epi_contacts)


# Count secondary cases per subject in contacts and linelist --------------
# step: Calculate the *out-degree* per case (all linelist cases)
# and paste the output histogram in the report.

secondary_cases <- epicontacts::get_degree(
  x = #<COMPLETE>,
  type = #<COMPLETE>,
  only_linelist = TRUE
)

# Plot the histogram of secondary cases
secondary_cases %>%
  enframe() %>% 
  ggplot(aes(value)) +
  geom_histogram(binwidth = 1) +
  labs(
    x = "Number of secondary cases",
    y = "Frequency"
  )


# Fit a negative binomial distribution -----------------------------------
# step: Fit a Negative Binomial distribution to the secondary case
# counts using {fitdistrplus}; paste the parameters in the report.

offspring_fit <- secondary_cases %>%
  fitdistrplus::fitdist(distr = "nbinom")

# Print output
offspring_fit


# Estimate proportion of new cases from a cluster of secondary cases ------
# step: Use {superspreading} with the fitted R and k to estimate
# the probability new cases come from a cluster of a given size;
# paste the output in the report.

# Set seed for random number generator
set.seed(33)

# Estimate the probability of new cases originating from 
# a transmission cluster of at least 5, 10, or 25 cases
proportion_cases_by_cluster_size <-
  superspreading::proportion_cluster_size(
    R = offspring_fit$estimate[#<COMPLETE>],
    k = offspring_fit$estimate[#<COMPLETE>],
    cluster_size = c(5, 10, 25)
  )

# Print output
proportion_cases_by_cluster_size

# nolint end