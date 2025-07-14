# nolint start

# Practical 3
# Activity 1

room_number <- #<COMPLETE> replace with 1/2/3/4

# Load packages -----------------------------------------------------------
library(epicontacts)
library(fitdistrplus)
library(tidyverse)


# Read linelist and contacts ----------------------------------------------
dat_contacts <- readr::read_rds(
  "link/to/contact/data/url"#<COMPLETE>
)

dat_linelist <- readr::read_rds(
  "link/to/linelist/data/url"#<COMPLETE>
)


# Create an epicontacts object -------------------------------------------
epi_contacts <- epicontacts::#<COMPLETE>

# Print output
epi_contacts

# Visualize the contact network
contact_network <- epicontacts::#<COMPLETE>

# Print output
contact_network


# Count secondary cases per subject in contacts and linelist --------------
secondary_cases <- epicontacts::#<COMPLETE>

# Plot the histogram of secondary cases
individual_reproduction_num <- secondary_cases %>%
  enframe() %>% 
  ggplot(aes(value)) +
  geom_histogram(binwidth = 1) +
  labs(
    x = "Number of secondary cases",
    y = "Frequency"
  )

# Print output
individual_reproduction_num


# Fit a negative binomial distribution -----------------------------------
offspring_fit <- #<COMPLETE>

# Print output
offspring_fit


# Estimate proportion of new cases from a cluster of secondary cases ------

# Set seed for random number generator
set.seed(33)

# Estimate the proportion of new cases originating from 
# a transmission cluster of at least 5, 10, or 25 cases
proportion_cases_by_cluster_size <- #<COMPLETE>

# Print output
proportion_cases_by_cluster_size

# nolint end