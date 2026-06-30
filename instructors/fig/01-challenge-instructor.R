# Load packages
library(simulist)
library(incidence2)
library(tidyverse)

# Simulate linelist data for an outbreak with size between 1000 and 1500
set.seed(1) # Set seed for reproducibility

sim_data <- simulist::sim_linelist(outbreak_size = c(1000, 1500)) %>%
  dplyr::as_tibble() # for a simple data frame output

# Create an incidence object
biweekly_incidence <- incidence2::incidence(
  sim_data,
  date_index = c("date_onset", "date_outcome"),
  groups = c("sex", "case_type"),
  interval = 14
)

# View the incidence data
biweekly_incidence

plot(biweekly_incidence,
  angle = 45,
  fill = "case_type"
)
