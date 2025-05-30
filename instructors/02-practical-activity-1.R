# nolint start

# Practical 2
# Activity 1

# Load packages -----------------------------------------------------------
library(epiparameter)
library(EpiNow2)
library(tidyverse)


# Read reported cases -----------------------------------------------------
# For COVID
# NOTE: Replace the link with the actual data source
# dat <- read_rds("paste/link/url/here/covid") %>%
#   dplyr::select(date, confirm)
# Or for Ebola
# dat <- read_rds("paste/link/url/here/ebola") %>%
#   dplyr::select(date, confirm = cases)

dat <- read_rds("paste/link/url/here/covid") %>%
  dplyr::select(date, confirm)
# or
# dat <- read_rds("paste/link/url/here/ebola") %>%
#   dplyr::select(date, confirm = cases)


# Define a generation time from {epiparameter} to {EpiNow2} ---------------

# Access a serial interval
ebola_serialint <- epiparameter::epiparameter_db(
  #<COMPLETE>
)

# Extract parameters from {epiparameter} object
ebola_serialint_params <- epiparameter::#<COMPLETE>

# Adapt {epiparameter} to {EpiNow2} distribution interface
ebola_generationtime <- EpiNow2::#<COMPLETE>


# Define the delays from infection to case report for {EpiNow2} -----------

# Define delay from symptom onset to case report
ebola_reportdelay <- EpiNow2::#<COMPLETE>

# Define a delay from infection to symptom onset
ebola_incubationtime <- epiparameter::epiparameter_db(
  #<COMPLETE>
)

# Incubation period: extract distribution parameters
ebola_incubationtime_params <- epiparameter::#<COMPLETE>

# Incubation period: discretize and extract maximum value (p = 99%)
ebola_incubationtime_max <- ebola_incubationtime %>% #<COMPLETE>

# Incubation period: adapt to {EpiNow2} distribution interface
ebola_incubationtime_epinow <- EpiNow2::#<COMPLETE>

# Print required input
ebola_generationtime
ebola_reportdelay
ebola_incubationtime_epinow


# Set the number of parallel cores for {EpiNow2} --------------------------
withr::local_options(list(mc.cores = parallel::detectCores() - 1))


# Estimate transmission using EpiNow2::epinow() ---------------------------
# with EpiNow2::*_opts() functions for generation time, delays, and stan.
estimates <- EpiNow2::epinow(
  data = dat,
  #<COMPLETE>
  stan = EpiNow2::stan_opts(samples = 1000, chains = 3)
)


# Print plot and summary table outputs ------------------------------------
summary(estimates)
plot(estimates)


# nolint end