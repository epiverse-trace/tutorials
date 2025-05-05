
# Practical 2
# Activity 2

# Load packages -----------------------------------------------------------
library(cfr)
library(epiparameter)
library(tidyverse)


# Read reported cases -----------------------------------------------------
disease_dat <- readr::read_rds(
  #<COMPLETE>
)

disease_dat


# Create incidence object ------------------------------------------------
disease_incidence <- disease_dat %>%
  incidence2::incidence(
    #<COMPLETE>
  )

plot(disease_incidence)


# Confirm {cfr} data input format ----------------------------------------

# does input data already adapted to {cfr} input? 
disease_adapted <- disease_dat
# OR
# does input data require to be adapted to {cfr}? 
disease_adapted <- disease_incidence %>%
  cfr::prepare_data(
    #<COMPLETE>
  )

disease_adapted

# Access delay distribution -----------------------------------------------
disease_delay <- epiparameter::#<COMPLETE>


# Estimate naive and adjusted CFR ----------------------------------------

# Estimate Static CFR
disease_adapted %>%
  filter(
    #<COMPLETE>
  ) %>%
  cfr::cfr_static()

# Estimate Static Delay-Adjusted CFR
disease_adapted %>%
  filter(
    #<COMPLETE>
  ) %>%
  cfr::cfr_static(
    delay_density = function(x) density(disease_delay, x)
  )
