# nolint start

# Practical 1
# Activity 1

room_number <- 2

# Load packages ----------------------------------------------------------
library(cleanepi)
library(incidence2)
library(tidyverse)


# Adapt the data dictionary ----------------------------------------------

# Replace 'variable_name' when you have the information
dat_dictionary <- tibble::tribble(
  ~options,  ~values,  ~grp, ~orders,
       "1",   "male", "sex",      1L,
       "2", "female", "sex",      2L,
       "M",   "male", "sex",      3L,
       "F", "female", "sex",      4L,
       "m",   "male", "sex",      5L,
       "f", "female", "sex",      6L
)

dat_dictionary


# Read raw data ----------------------------------------------------------
dat_raw <- readr::read_csv(
  "https://epiverse-trace.github.io/tutorials-early/data/covid_simulated_data.csv"
  )

dat_raw


# Clean and standardize data ---------------------------------------------

# How many cleanepi functions did you use to get clean data?
dat_clean <- dat_raw %>%
  cleanepi::standardize_column_names() %>%
    cleanepi::standardize_dates(
      target_columns = c(
        "date_onset",
        "date_admission",
        "date_outcome",
        "date_first_contact",
        "date_last_contact"
      )
    ) %>%
    # first and last contact are outbreak investigation dates
    # not part of the natural history of disease progression
    cleanepi::check_date_sequence(
      target_columns = c(
        "date_onset",
        "date_admission",
        "date_outcome"
      )
    ) %>%
    cleanepi::convert_to_numeric(
      target_columns = "age"
    ) %>%
    # dplyr::count(sex)
    # using data_dictionary requires valid missing entries
    cleanepi::replace_missing_values(
      target_columns = "sex",
      na_strings = "-99"
    ) %>%
    cleanepi::clean_using_dictionary(
      dictionary = dat_dictionary
    ) %>%
    cleanepi::remove_constants() %>%
    cleanepi::remove_duplicates(
      target_columns = c(
        "case_id",
        "case_name"
      )
    ) %>% 
  cleanepi::timespan(
    target_column = "date_onset",
    end_date = "date_outcome",
    span_unit = "days",
    span_column_name = "timespan_variable",
    span_remainder_unit = NULL
  )

dat_clean


# nolint end
