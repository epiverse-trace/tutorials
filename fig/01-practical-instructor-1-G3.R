# nolint start

# Practical 1
# Activity 1

room_number <- 3

# Load packages ----------------------------------------------------------
library(cleanepi)
library(linelist)
library(incidence2)
library(tidyverse)


# Adapt the data dictionary ----------------------------------------------

# Replace 'variable_name' when you have the information
dat_dictionary <- tibble::tribble(
  ~options,  ~values,            ~grp, ~orders,
       "1",   "male", "variable_name",      1L,
       "2", "female", "variable_name",      2L,
       "M",   "male", "variable_name",      3L,
       "F", "female", "variable_name",      4L,
       "m",   "male", "variable_name",      5L,
       "f", "female", "variable_name",      6L
)

dat_dictionary


# Read raw data ----------------------------------------------------------
dat_raw <- readr::read_csv(
  "https://epiverse-trace.github.io/tutorials-early/data/delta_full-messy.csv"
  )

dat_raw


# Clean and standardize data ---------------------------------------------

# How many cleanepi functions did you use to get clean data?
dat_clean <- dat_raw %>%
  cleanepi::standardize_column_names() %>%
    cleanepi::standardize_dates(target_columns = "date") %>% #
    cleanepi::convert_to_numeric(target_columns = "exp_num") %>%
    cleanepi::check_date_sequence(
      target_columns = c("last_exp_date", "date")
    )

dat_clean


# Create time span variable ----------------------------------------------

# What time span unit best describes the 'delay' from 'onset' to 'death'?
dat_timespan <- dat_clean %>%
  cleanepi::timespan(
    target_column = "last_exp_date",
    end_date = "date",
    span_unit = "days",
    span_column_name = "timespan_variable",
    span_remainder_unit = NULL
  ) %>%
  # skimr::skim(timespan_variable)
  # Categorize the delay numerical variable
  dplyr::mutate(
    timespan_category = base::cut(
      x = timespan_variable,
      breaks = c(0, 30, 100, 600), 
      include.lowest = TRUE,
      right = FALSE
    )
  )

dat_timespan


# nolint end