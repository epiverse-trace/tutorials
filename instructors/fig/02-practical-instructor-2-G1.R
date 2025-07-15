# nolint start

# Practical 2
# Activity 2

room_number <- 1 #valid for 2

# Load packages -----------------------------------------------------------
library(cfr)
library(epiparameter)
library(tidyverse)


# Read reported cases -----------------------------------------------------
disease_dat <- readr::read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/diamond_70days.rds"
)

disease_dat


# Create incidence object ------------------------------------------------
disease_incidence <- disease_dat %>%
  incidence2::incidence(
    date_index = "date",
    counts = c("cases", "deaths"),
    complete_dates = TRUE
  )

# with data available before march 1st
disease_incidence %>%
  dplyr::filter(date_index < ymd(20200301)) %>% 
  plot()

# with complete data
disease_incidence %>% 
  plot()


# Confirm {cfr} data input format ----------------------------------------

# Is the input data already adapted to {cfr} input? 
disease_adapted <- disease_dat
# # OR
# # Does the input data need to be adapted to {cfr}? 
# disease_adapted <- disease_incidence %>%
#   cfr::prepare_data(
#     #<COMPLETE>
#   )

disease_adapted

# Access delay distribution -----------------------------------------------
disease_delay <- epiparameter::epiparameter_db(
  disease = "covid",
  epi_name = "onset-to-death",
  single_epiparameter = TRUE
)


# Estimate naive and adjusted CFR ----------------------------------------

# Estimate static CFR
disease_adapted %>%
  filter(
    date < ymd(20200301)
  ) %>%
  cfr::cfr_static()

# Estimate static delay-adjusted CFR
disease_adapted %>%
  filter(
    date < ymd(20200301)
  ) %>%
  cfr::cfr_static(
    delay_density = function(x) density(disease_delay, x)
  )


# Estimate in complete time series ---------------------------------------

# Estimate static CFR
disease_adapted %>%
  cfr::cfr_static()

# Estimate static delay-adjusted CFR
disease_adapted %>%
  cfr::cfr_static(
    delay_density = function(x) density(disease_delay, x)
  )

# nolint end