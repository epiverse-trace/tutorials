# nolint start

# Practical 1
# Activity 2

room_number <- #<COMPLETE> replace with 1/2/3/4

# Load packages ----------------------------------------------------------
library(cleanepi)
library(incidence2)
library(tidyverse)

# Read raw data ----------------------------------------------------------

# Replace the string with the URL provided (or location to local file)
dat_linelist <- readr::read_rds(
  "paste/complete/URL/#<COMPLETE>" #<COMPLETE>
  )

dat_linelist %>% dplyr::glimpse()

# Describe delays --------------------------------------------------------

# Run and describe
dat_delays <- dat_linelist %>% 
  cleanepi::timespan(
    target_column = "date_onset",
    end_date = "date_reporting",
    span_unit = "days",
    span_column_name = "delay_reporting"
  )

# Run and describe
dat_delays %>% 
  dplyr::select(id, date_onset, date_reporting, delay_reporting)

# Run and describe
dat_delays %>% 
  skimr::skim(delay_reporting)

# Run and describe
dat_delays %>% 
  ggplot(aes(delay_reporting)) +
  geom_histogram(binwidth = 1) +
  xlim(0,30)

# Create incidence -------------------------------------------------------

# What is the most appropriate time-aggregate (days, months) to plot?
dat_incidence <- dat_linelist %>%  
  # Transform from individual-level to time-aggregate
  incidence2::incidence(
    date_index = #<COMPLETE>,
    groups = #<COMPLETE>, # the categorical variable
    interval = #<COMPLETE>,
    complete_dates = TRUE
  )


# Plot epicurve ----------------------------------------------------------

dat_incidence %>% plot()

# Do arguments like 'fill', 'nrow', 'show_cases', 'angle', 'n_breaks' 
# improve the plot?
dat_incidence %>% 
  plot(
    fill = #<COMPLETE>, # the categorical variable # <KEEP OR DROP>
    #nrow = 1, # 1 or 2 <KEEP OR DROP>
    show_cases = FALSE, # <KEEP OR DROP>
    angle = 45, # <KEEP OR DROP>
    n_breaks = 5 # <KEEP OR DROP>
  )

# Find plot() arguments at ?incidence2:::plot.incidence2()

# nolint end
