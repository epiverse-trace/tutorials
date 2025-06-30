# nolint start

# Practical 2
# Activity 2

# Load packages -----------------------------------------------------------
library(cfr)
library(epiparameter)
library(tidyverse)


# Read reported cases -----------------------------------------------------
disease_dat <- readr::read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/mers_linelist.rds"
)

disease_dat


# Create incidence object ------------------------------------------------
disease_incidence <- disease_dat %>%
  incidence2::incidence(
    date_index = c("dt_onset", "dt_death"),
    complete_dates = TRUE
  )

plot(disease_incidence)


# Confirm {cfr} data input format ----------------------------------------

# Is the input data already adapted to {cfr} input? 
disease_adapted <- disease_dat
# OR
# Does the input data need to be adapted to {cfr}? 
disease_adapted <- disease_incidence %>%
  cfr::prepare_data(
    cases = "dt_onset",
    deaths = "dt_death"
  )

disease_adapted

# Access delay distribution -----------------------------------------------
disease_delay <- epiparameter::epiparameter_db(
  disease = "mers",
  epi_name = "onset-to-death",
  single_epiparameter = TRUE
)


# Estimate naive and adjusted CFR ----------------------------------------

# Estimate static CFR
disease_adapted %>%
  # filter(
  #   #<COMPLETE>
  # ) %>%
  cfr::cfr_static()

# Estimate static delay-adjusted CFR
disease_adapted %>%
  # filter(
  #   #<COMPLETE>
  # ) %>%
  cfr::cfr_static(
    delay_density = function(x) density(disease_delay, x)
  )

# nolint end