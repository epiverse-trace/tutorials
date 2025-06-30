# nolint start

# Practical 1
# Activity 1

# Load packages ----------------------------------------------------------
library(cleanepi)
library(linelist)
library(incidence2)
library(tidyverse)


# Adapt the data dictionary ----------------------------------------------

# Replace 'variable_name' when you have the information
dat_dictionary <- tibble::tribble(
  ~options,  ~values,        ~grp, ~orders,
       "1",   "male", "sex_fem_2",      1L,
       "2", "female", "sex_fem_2",      2L
)

dat_dictionary


# Read raw data ----------------------------------------------------------
dat_raw <- readr::read_csv(
  "https://epiverse-trace.github.io/tutorials-early/data/linelist-date_of_birth.csv"
  )

dat_raw


# Clean and standardize data ---------------------------------------------

# How many cleanepi functions did you use to get clean data?
dat_clean <- dat_raw %>%
  cleanepi::standardize_column_names() %>%
    cleanepi::standardize_dates(
      target_columns = c(
        "date_of_admission",
        "date_of_birth",
        "date_first_pcr_positive_test"
      )
    ) %>%
    cleanepi::check_date_sequence(
      target_columns = c(
        "date_of_birth",
        "date_first_pcr_positive_test",
        "date_of_admission"
      )
    ) %>%
    # using data_dictionary requires valid missing entries
    cleanepi::replace_missing_values(
      target_columns = "sex_fem_2",
      na_strings = "-99"
    ) %>%
    cleanepi::clean_using_dictionary(dictionary = dat_dictionary) %>%
    cleanepi::remove_constants() %>%
    cleanepi::remove_duplicates(
      target_columns = c("study_id", "date_of_birth")
    )

dat_clean


# Create time span variable ----------------------------------------------

# What time span unit best describes the 'delay' from 'onset' to 'death'?
dat_timespan <- dat_clean %>%
  cleanepi::timespan(
    target_column = "date_of_birth",
    end_date = Sys.Date(),
    span_unit = "years",
    span_column_name = "timespan_variable",
    span_remainder_unit = "months"
  ) %>%
  # skimr::skim(timespan_variable)
  # Categorize the delay numerical variable
  dplyr::mutate(
    timespan_category = base::cut(
      x = timespan_variable,
      breaks = c(0, 20, 35, 60, 80), 
      include.lowest = TRUE,
      right = FALSE
    )
  )

dat_timespan


# nolint end