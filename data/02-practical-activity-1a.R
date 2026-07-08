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
  disease = #<COMPLETE>,
  epi_name = #<COMPLETE>,
  single_epiparameter = TRUE
)

dat_serialint
plot(dat_serialint)

# step: adapt {epiparameter} to {EpiNow2} distribution interface

# - Does the serial interval follow a LogNormal or Gamma distribution?
# - What are the *distribution parameters* of the serial interval?
# - Based on that distribution, which function should we use: `EpiNow2::LogNormal()` or `EpiNow2::Gamma()`?
# - What could be a maximum number of days for this distribution? Read this from the plot.

# Now complete the code below
# (note: you can copy/paste values to corresponding parameters)
dat_generationtime <- EpiNow2::#<COMPLETE>(
  #<COMPLETE> = #<COMPLETE>,
  #<COMPLETE> = #<COMPLETE>,
  max = #<COMPLETE>
)

dat_generationtime


# Define the delays from infection to case report for {EpiNow2} -----------

# step: define a delay from infection to symptom onset (based on the disease)
dat_incubationtime <- epiparameter::epiparameter_db(
  disease = #<COMPLETE>,
  epi_name = #<COMPLETE>,
  single_epiparameter = TRUE
)

dat_incubationtime
plot(dat_incubationtime)

# step: adapt {epiparameter} to {EpiNow2} distribution interface

# - Does the incubation time follow a LogNormal or Gamma distribution?
# - What are the *distribution parameters* of the incubation time?
# - Based on that distribution, which function should we use: `EpiNow2::LogNormal()` or `EpiNow2::Gamma()`?
# - What could be a maximum number of days for this distribution? Read this from the plot.

# Now complete the code below
# (note: you can copy/paste values to corresponding parameters)
dat_incubationtime_epinow <- EpiNow2::#<COMPLETE>(
  #<COMPLETE> = #<COMPLETE>,
  #<COMPLETE> = #<COMPLETE>,
  max = #<COMPLETE>
)

dat_incubationtime_epinow


# step: define delay from symptom onset to case report
# Run the code below:
# - Identify how to configure a distribution with uncertainty on each parameter using EpiNow2
# - Why should we consider uncertain distributions (over fixed distributions)?

dat_reportdelay <- EpiNow2::Gamma(
  mean = EpiNow2::Normal(mean = 2, sd = 0.5),
  sd = EpiNow2::Normal(mean = 1, sd = 0.5),
  max = 5
)


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
  generation_time = EpiNow2::generation_time_opts(#<COMPLETE>),
  delays = EpiNow2::delay_opts(#<COMPLETE> + #<COMPLETE>),
  stan = EpiNow2::stan_opts(samples = 1000, chains = 3)
)


# Print plot and summary table outputs ------------------------------------
# step: paste the figure and table outputs in the shared document

summary(estimates)
plot(estimates)

# step: reply to questions in document

# nolint end
