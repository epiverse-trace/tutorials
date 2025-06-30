# nolint start

# Practical 3
# Activity 1

# Load packages -----------------------------------------------------------
library(epicontacts)
library(fitdistrplus)
library(tidyverse)


# Read linelist and contacts ----------------------------------------------
dat_contacts <- readr::read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/set-01-contacts.rds"  #<DIFFERENT PER GROUP>
)

dat_linelist <- readr::read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/set-01-linelist.rds"  #<DIFFERENT PER GROUP>
)


# Create an epicontacts object -------------------------------------------
epi_contacts <- epicontacts::make_epicontacts(
  linelist = dat_linelist,
  contacts = dat_contacts,
  directed = TRUE
)

# Print output
epi_contacts

# Visualize the contact network
contact_network <- epicontacts::vis_epicontacts(epi_contacts)

# Print output
contact_network


# Count secondary cases per subject in contacts and linelist --------------
secondary_cases <- epicontacts::get_degree(
  x = epi_contacts,
  type = "out",
  only_linelist = TRUE
)

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
offspring_fit <- secondary_cases %>%
  fitdistrplus::fitdist(distr = "nbinom")

# Print output
offspring_fit


# Estimate proportion of new cases from a cluster of secondary cases ------

# Set seed for random number generator
set.seed(33)

# Estimate the proportion of new cases originating from 
# a transmission cluster of at least 5, 10, or 25 cases
proportion_cases_by_cluster_size <- 
  superspreading::proportion_cluster_size(
    R = offspring_fit$estimate["mu"],
    k = offspring_fit$estimate["size"],
    cluster_size = c(5, 10, 25)
  )

# Print output
proportion_cases_by_cluster_size

# nolint end