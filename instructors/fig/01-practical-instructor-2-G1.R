# nolint start

# Practical 1
# Activity 2

room_number <- 1

# Load packages ----------------------------------------------------------
library(cleanepi)
library(incidence2)
library(tidyverse)

# Read raw data ----------------------------------------------------------
dat_linelist <- readr::read_rds(
  "https://epiverse-trace.github.io/tutorials-early/data/covid_simulist.rds"
  )

dat_linelist %>% dplyr::glimpse()

# Describe delays --------------------------------------------------------

dat_delays <- dat_linelist %>% 
  cleanepi::timespan(
    target_column = "date_onset",
    end_date = "date_reporting",
    span_unit = "days",
    span_column_name = "delay_reporting"
  )

dat_delays %>% 
  skimr::skim(delay_reporting)

dat_delays %>% 
  ggplot(aes(delay_reporting)) +
  geom_histogram(binwidth = 1) +
  xlim(0,30)

# Create incidence -------------------------------------------------------

# What is the most appropriate time-aggregate (days, months) to plot?
dat_incidence <- dat_linelist %>%  
  # Transform from individual-level to time-aggregate
  incidence2::incidence_(
    date_index = c(date_onset,date_outcome),
    groups = age_category, # the categorical variable
    interval = "day",
    complete_dates = TRUE
  )


# Plot epicurve ----------------------------------------------------------

# Do arguments like 'fill', 'show_cases', 'angle', 'n_breaks' improve the plot?
dat_incidence %>% 
  plot(
    fill = "age_category", # the categorical variable
    #nrow = 1, # 1 or 2 <KEEP OR DROP>
    show_cases = FALSE, # <KEEP OR DROP>
    angle = 45, # <KEEP OR DROP>
    n_breaks = 5 # <KEEP OR DROP>
  )

# Find plot() arguments at ?incidence2:::plot.incidence2()

# nolint end