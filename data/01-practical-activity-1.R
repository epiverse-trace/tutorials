# nolint start

# Practical 1
# Activity 1

room_number <- #<COMPLETE> replace with 1/2/3/4

# Load packages ----------------------------------------------------------
library(cleanepi)
library(tidyverse)


# Adapt the data dictionary ----------------------------------------------

# Replace '#<COMPLETE>' when you have the information
dat_dictionary <- tibble::tribble(
  ~options,  ~values,          ~grp, ~orders,
       "1",   "male", "#<COMPLETE>",      1L,
       "2", "female", "#<COMPLETE>",      2L,
       "M",   "male", "#<COMPLETE>",      3L, # drop rows if not needed
       "F", "female", "#<COMPLETE>",      4L,
       "m",   "male", "#<COMPLETE>",      5L,
       "f", "female", "#<COMPLETE>",      6L
)

dat_dictionary


# Read raw data ----------------------------------------------------------

# Replace the string with the URL provided (or location to local file)
dat_raw <- readr::read_csv(
  "paste/complete/URL/#<COMPLETE>" #<COMPLETE>
  )

dat_raw


# Clean and standardize data ---------------------------------------------

# How many cleanepi functions did you use to get clean data?
# Remove those functions not needed in the cleaning workflow

dat_clean <- dat_raw %>%
  cleanepi::standardize_column_names() %>%
  cleanepi::standardize_dates(
    target_columns = c(
      #<COMPLETE>,
      #<COMPLETE>, # drop if not needed
      #<COMPLETE> # could be one or more
    )
  ) %>%
  cleanepi::check_date_sequence(
    target_columns = c(
      #<COMPLETE>,
      #<COMPLETE>,
      #<COMPLETE>
    )
  ) %>%
  cleanepi::convert_to_numeric(
    target_columns = #<COMPLETE>
  ) %>% 
  # using data_dictionary requires valid missing entries
  cleanepi::replace_missing_values(
    target_columns = #<COMPLETE>,
    na_strings = #<COMPLETE>
  ) %>%
  cleanepi::clean_using_dictionary(
    dictionary = #<COMPLETE>
  ) %>%
  cleanepi::remove_constants() %>%
  cleanepi::remove_duplicates(
    target_columns = c(
      #<COMPLETE>,
      #<COMPLETE>
    )
  ) %>%
  cleanepi::timespan(
    target_column = #<COMPLETE>,
    end_date = #<COMPLETE>,
    span_unit = #<COMPLETE>,
    span_column_name = #<COMPLETE>,
    span_remainder_unit = #<COMPLETE>
  )

dat_clean


# nolint end