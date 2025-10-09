# nolint start

# Practical 2
# Activity 2

# step: fill in your room number
room_number <- #<COMPLETE> replace with 1/2/3/4

# Load packages -----------------------------------------------------------
library(cfr)
library(epiparameter)
library(tidyverse)


# Read reported cases -----------------------------------------------------
# step: Paste the URL links as a string to read input data.
disease_dat <- readr::read_rds(
  #<COMPLETE>
)

disease_dat


# Create incidence object ------------------------------------------------
# step: Fill in the argument to plot an incidence curve.
disease_incidence <- disease_dat %>%
  incidence2::incidence(
    #<COMPLETE>
  )

plot(disease_incidence)


# Confirm {cfr} data input format ----------------------------------------

# step: Check if the column names in incidence data
# match the {cfr} requirement of column names:
# date, cases, deaths

disease_dat

# Is the input data already adapted to {cfr} input?
# If yes, use:
disease_adapted <- disease_dat
# OR
# If not, use cfr::prepare_data() to adapted it:
disease_adapted <- disease_incidence %>%
  cfr::prepare_data(
    #<COMPLETE>
  )

disease_adapted

# Access delay distribution -----------------------------------------------
# step: Access to the probability distribution for the delay from case onset to death.

# What delay you need to use to adjust the CFR? (based on the disease)
disease_delay <- epiparameter::#<COMPLETE>


# Estimate naive and adjusted CFR ----------------------------------------
# step: Estimate the naive and delay-adjusted CFR.

# Estimate static CFR
disease_adapted %>%
  cfr::cfr_static()

# Estimate static delay-adjusted CFR
disease_adapted %>%
  cfr::cfr_static(
    delay_density = #<COMPLETE>
  )

# step: Paste both outputs. Reply to questions.

# nolint end