# nolint start

# Practical 2
# Activity 1

# Load packages -----------------------------------------------------------
library(epiparameter)
library(EpiNow2)
library(tidyverse)


# Read reported cases -----------------------------------------------------
# for covid
dat <- read_rds(
  "paste/link/url/here/covid"#<COMPLETE>
) %>%
  dplyr::select(date, confirm)
# or
# for ebola
dat <- read_rds(
  "paste/link/url/here/ebola"#<COMPLETE>
) %>%
  dplyr::select(date, confirm = cases)


# Define a generation time from {epiparameter} to {EpiNow2} ---------------

# access a serial interval
dat_serialint <- epiparameter::epiparameter_db(
  #<COMPLETE>
)

# extract parameters from {epiparameter} object
dat_serialint_params <- epiparameter::#<COMPLETE>

# adapt {epiparameter} to {EpiNow2} distribution inferfase
dat_generationtime <- EpiNow2::#<COMPLETE>


# Define the delays from infection to case report for {EpiNow2} -----------

# define delay from symptom onset to case report
dat_reportdelay <- EpiNow2::#<COMPLETE>

# define a delay from infection to symptom onset
dat_incubationtime <- epiparameter::epiparameter_db(
  #<COMPLETE>
)

# incubation period: extract distribution parameters
dat_incubationtime_params <- epiparameter::#<COMPLETE>

# incubation period: discretize and extract maximum value (p = 99%)
dat_incubationtime_max <- dat_incubationtime %>% #<COMPLETE>

# incubation period: adapt to {EpiNow2} distribution interface
dat_incubationtime_epinow <- EpiNow2::#<COMPLETE>

# print required input
dat_generationtime
dat_reportdelay
dat_incubationtime_epinow


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