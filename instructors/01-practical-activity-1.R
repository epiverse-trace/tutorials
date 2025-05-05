
# Practical 1
# Activity 1

# Load packages ----------------------------------------------------------
library(cleanepi)
library(linelist)
library(incidence2)
library(tidyverse)


# Adapt the data dictionary ----------------------------------------------

# replace 'variable_name' when you have the information
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
  #<COMPLETE>
  )

dat_raw


# Clean and standardize data ---------------------------------------------

# how many cleanepi functions you used to get clean data?
dat_clean <- dat_raw %>%
  cleanepi::#<COMPLETE>

dat_clean


# Create time span variable ----------------------------------------------

# what time span unit better describe 'delay' from 'onset' to 'death'?
dat_timespan <- dat_clean %>%
  cleanepi::timespan(
    #<COMPLETE>
    #<COMPLETE>
    #<COMPLETE>
    span_column_name = "timespan_variable",
    span_remainder_unit = NULL
  ) %>%
  # skimr::skim(timespan_variable)
  # categorize the delay numerical variable
  dplyr::mutate(
    timespan_category = base::cut(
      x = timespan_variable,
      breaks = #<COMPLETE>, 
      include.lowest = TRUE,
      right = FALSE
    )
  )

dat_timespan


