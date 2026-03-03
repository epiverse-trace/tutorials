# nolint start

# Practical 2
# Activity 1

# step: fill in your room number
room_number <- #<COMPLETE> replace with 1/2/3/4

# Load packages -----------------------------------------------------------
library(epiparameter)
library(EpiNow2)
library(tidyverse)


# Read reported cases -----------------------------------------------------
# step: Paste the URL links as a string to read input data.

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


# Verify format of incidence data ----------------------------------------
# step: Check if the column names in incidence data
# match the EpiNow2 requirement of column names: date and confirm

dat

# Define a generation time from {epiparameter} to {EpiNow2} ---------------

# step: access a serial interval (based on the disease)
dat_serialint <- epiparameter::epiparameter_db(
  #<COMPLETE>
)

dat_serialint
plot(dat_serialint)

# step: extract parameters from {epiparameter} object
dat_serialint_params <- epiparameter::#<COMPLETE>

dat_serialint_params

# step: adapt {epiparameter} to {EpiNow2} distribution interface
dat_generationtime <- EpiNow2::#<COMPLETE>

dat_generationtime


# Define the delays from infection to case report for {EpiNow2} -----------

# step: define a delay from infection to symptom onset (based on the disease)
dat_incubationtime <- epiparameter::epiparameter_db(
  #<COMPLETE>
)

dat_incubationtime
plot(dat_incubationtime)

# step: incubation period: extract distribution parameters
dat_incubationtime_params <- epiparameter::#<COMPLETE>

dat_incubationtime_params

# step: incubation period: discretize and extract maximum value (p = 99%)
dat_incubationtime_max <- dat_incubationtime %>% #<COMPLETE>

dat_incubationtime_max
  
# step: incubation period: adapt to {EpiNow2} distribution interface
dat_incubationtime_epinow <- EpiNow2::#<COMPLETE>

dat_incubationtime_epinow


# step: define delay from symptom onset to case report
# You need to interpret the description given in the Inputs table
# located in the shared document

dat_reportdelay <- EpiNow2::#<COMPLETE>


# step: print required input
dat_generationtime
dat_incubationtime_epinow
dat_reportdelay


# Set the number of parallel cores for {EpiNow2} --------------------------
# step: run this configuration step

withr::local_options(list(mc.cores = parallel::detectCores() - 1))


# Estimate transmission using EpiNow2::epinow() ---------------------------
# step: run epinow() using incidence cases, and required delays
# with EpiNow2::*_opts() functions for generation time, delays, and stan.
estimates <- EpiNow2::epinow(
  data = dat,
  #<COMPLETE>
  stan = EpiNow2::stan_opts(samples = 1000, chains = 3)
)


# Print plot and summary table outputs ------------------------------------
# step: paste the figure and table outputs in the shared document

summary(estimates)
plot(estimates)

# step: reply to questions in document

# nolint end