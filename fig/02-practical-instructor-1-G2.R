# nolint start

# Practical 2
# Activity 1

room_number <- 2 # valid for 3

# Load packages -----------------------------------------------------------
library(epiparameter)
library(EpiNow2)
library(tidyverse)


# Read reported cases -----------------------------------------------------
# for ebola
dat <- read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/ebola_35days.rds" #<DIFFERENT PER ROOM>
) %>%
  dplyr::select(date, confirm = cases)


# Define a generation time from {epiparameter} to {EpiNow2} ---------------

# access a serial interval
dat_serialint <- epiparameter::epiparameter_db(
  disease = "ebola",
  epi_name = "serial",
  single_epiparameter = TRUE
)

# extract parameters from {epiparameter} object
dat_serialint_params <- epiparameter::get_parameters(dat_serialint)

# adapt {epiparameter} to {EpiNow2} distribution inferfase
dat_generationtime <- EpiNow2::Gamma(
  shape = dat_serialint_params["shape"],
  scale = dat_serialint_params["scale"]
)
# or
dat_generationtime <- EpiNow2::Gamma(
  mean = dat_serialint$summary_stats$mean,
  sd = dat_serialint$summary_stats$sd
)

# Define the delays from infection to case report for {EpiNow2} -----------

# define delay from symptom onset to case report
dat_reportdelay <- EpiNow2::LogNormal(
  meanlog = EpiNow2::Normal(mean = 1.4, sd = 0.5),
  sdlog = EpiNow2::Normal(mean = 0.25, sd = 0.2),
  max = 5
)

# define a delay from infection to symptom onset
dat_incubationtime <- epiparameter::epiparameter_db(
  disease = "ebola",
  epi_name = "incubation",
  single_epiparameter = TRUE
)

# incubation period: extract distribution parameters
dat_incubationtime_params <- epiparameter::get_parameters(
  dat_incubationtime
)

# incubation period: discretize and extract maximum value (p = 99%)
dat_incubationtime_max <- dat_incubationtime %>% 
  epiparameter::discretise() %>%
  quantile(p = 0.99)
# or
dat_incubationtime_max <- dat_incubationtime %>%
  quantile(p = 0.99) %>%
  base::round()

# incubation period: adapt to {EpiNow2} distribution interface
dat_incubationtime_epinow <- EpiNow2::Gamma(
  shape = dat_incubationtime_params["shape"],
  scale = dat_incubationtime_params["scale"],
  max = dat_incubationtime_max
)

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
  generation_time = EpiNow2::generation_time_opts(dat_generationtime),
  delays = EpiNow2::delay_opts(dat_incubationtime_epinow + dat_reportdelay),
  stan = EpiNow2::stan_opts(samples = 1000, chains = 3)
)


# Print plot and summary table outputs ------------------------------------
summary(estimates)
plot(estimates)


# nolint end