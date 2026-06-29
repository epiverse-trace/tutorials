# nolint start

# Practical 2
# Activity 1

room_number <- 1 # valid for 4

# Load packages -----------------------------------------------------------
library(EpiNow2)
library(tidyverse)


# Read reported cases -----------------------------------------------------
# for covid
dat <- read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/covid_30days.rds" #<DIFFERENT PER ROOM>
) %>%
  dplyr::select(date, confirm)


# Define a generation time from {epiparameter} to {EpiNow2} ---------------

# access a serial interval
epiparameter::epiparameter_db(
  disease = "covid",
  epi_name = "serial",
  single_epiparameter = TRUE
)

dat_generationtime <- EpiNow2::LogNormal(
  meanlog = 1.386,
  sdlog = 0.568
)

# Define the delays from infection to case report for {EpiNow2} -----------

# define delay from symptom onset to case report
dat_reportdelay <- EpiNow2::Normal(
  mean = EpiNow2::Normal(mean = 2, sd = 0.5),
  sd = EpiNow2::Normal(mean = 1, sd = 0.5),
  max = 5
)

# define a delay from infection to symptom onset

epiparameter::epiparameter_db(
  disease = "covid",
  epi_name = "incubation",
  single_epiparameter = TRUE
)

dat_incubationtime <- EpiNow2::LogNormal(
  meanlog = 1.525,
  sdlog = 0.629,
  max = 20
)

# print required input
dat_generationtime
dat_reportdelay
dat_incubationtime


# Set the number of parallel cores for {EpiNow2} --------------------------
withr::local_options(list(mc.cores = parallel::detectCores() - 1))


# Estimate transmission using EpiNow2::epinow() ---------------------------
# with EpiNow2::*_opts() functions for generation time, delays, and stan.
estimates <- EpiNow2::epinow(
  data = dat,
  generation_time = EpiNow2::generation_time_opts(dat_generationtime),
  delays = EpiNow2::delay_opts(dat_reportdelay + dat_incubationtime),
  stan = EpiNow2::stan_opts(samples = 1000, chains = 3)
)


# Print plot and summary table outputs ------------------------------------
summary(estimates)
plot(estimates)


# nolint end