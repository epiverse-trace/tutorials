# nolint start

# Practical 3
# Activity 1

# step: fill in your room number
room_number <- 1 #valid for all

# Load packages -----------------------------------------------------------
library(epicontacts)
library(fitdistrplus)
library(tidyverse)


# Read linelist and contacts ----------------------------------------------
# step: Paste the URL links as a string to read input data.

dat_contacts <- readr::read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/set-01-contacts.rds"  #<DIFFERENT PER ROOM>
)

dat_linelist <- readr::read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/set-01-linelist.rds"  #<DIFFERENT PER ROOM>
)


# Create an epicontacts object -------------------------------------------
# step: Create a *directed* contact network 
# using the linelist and contacts data inputs.
# Paste a screenshot of the network in the report.

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
# step: Calculate the *out-degree* for each node (infector case)
# in the contact network, using *all* the cases observed in the linelist.
# Paste the output histogram in the report.

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
# step: Use the vector with the number of secondary cases per infector case 
# to fit a Negative Binomial distribution using {fitdistrplus}
# Paste the output parameters in the report.

offspring_fit <- secondary_cases %>%
  fitdistrplus::fitdist(distr = "nbinom")

# Print output
offspring_fit


# Estimate proportion of new cases from a cluster of secondary cases ------
# step: Use {superspreading} to calculate the probability (proportion)
# of new cases originating from a cluster of a given size (cluster size),
# using as input the offspring distribution parameters: 
# the reproduction number and dispersion.
# Paste the output result in the report.

# Set seed for random number generator
set.seed(33)

# Estimate the probability of new cases originating from 
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