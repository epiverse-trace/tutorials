# Week 1: Clean, validate linelist, and plot epicurves


<!-- visible for instructors only -->

<!-- practical-week.md is generated from practical-week.qmd. Please edit that file -->

<!-- commit .md and .qmd files together -->

<!-- does not work for instructors text messages -->

<!-- works for text on html and MD only -->

This practical is based in the following tutorial episodes:

- <https://epiverse-trace.github.io/tutorials-early/clean-data.html>
- <https://epiverse-trace.github.io/tutorials-early/validate.html>
- <https://epiverse-trace.github.io/tutorials-early/describe-cases.html>

# Practical

This practical has two activities.

## Activity 1: Clean and standardize raw data

Get a clean and standardized data frame using the following available
inputs:

- Raw messy data frame in CSV format

Within your room, Write your answers to these questions:

- Diagnose the raw data. What data cleaning operations need to be
  performed on the dataset? Write all of them before writing the code.
- What time unit best describes the time span to calculate?
- Print the report: What features do you find useful to communicate with
  a decision-maker?
- Compare: What differences do you identify from other room outputs? (if
  available)

**Steps:**

- Open file `01-practical-activity-1.R` and fill in your `room_number`
  in the script.
- First, complete the argument to read the data. Paste the link as a
  “string” in `read_csv()`.
- Second, complete the cleaning process. Add functions based on the data
  needs. Connect them using the pipe `%>%`:
  - Standardize column names
  - Standardize dates
  - Check date sequence
  - Convert to numeric
  - Replace missing values
  - Clean using dictionary
  - Remove constants
  - Remove duplicates
- Third, complete the cleanepi::timespan() arguments. Access the help
  manual running `?cleanepi::timespan()` in the console.
- Paste the outputs. Reply to questions.

### Inputs

| Room | Data | Link | Calculate time span | Categorize time span |
|----|----|----|----|----|
| 1 | Small linelist | <https://epiverse-trace.github.io/tutorials-early/data/linelist-date_of_birth.csv> | Age as of today | breaks = c(0, 20, 35, 60, 80) |
| 2 | Large linelist | <https://epiverse-trace.github.io/tutorials-early/data/covid_simulated_data.csv> | Delay from onset of symptoms to the time of death | breaks = c(0, 10, 15, 40) |
| 3 | Serology data [^1] | <https://epiverse-trace.github.io/tutorials-early/data/delta_full-messy.csv> | Time from last exposure to vaccine | breaks = c(0, 30, 100, 600) |

## Activity 2: Validate linelist and plot epicurve

Get a validated linelist and incidence plot using the following
available inputs:

- Clean data frame object

Within your room, Write your answers to these questions:

- In the validation step, Do you need to allow for extra variable names
  and types for the `Date` and `Categorical` variable?
  - *[Read this GitHub issue as a
    hint](https://github.com/epiverse-trace/linelist/issues/176) to
    allow for extra variables.*
- What is the most apprioriate time unit to aggregate the incidence
  plot, based on visual inspection?
- Does keeping or dropping arguments like `fill`, `show_cases`, `angle`,
  `n_breaks` improve the incidence plot?
  - *[Read `plot()` reference
    manual](https://www.reconverse.org/incidence2/manual.html#sec:man-plot.incidence2)
    to find its arguments.*
- Interpret: How would you communicate these results to a
  decision-maker?
- Compare: What differences do you identify from other room outputs? (if
  available)

**Steps:**

- Open the file `01-practical-activity-2.R` and fill in your
  `room_number` in the script.
- First, complete linelist::make_linelist() arguments.
- Second, complete the {linelist} function that can validate a linelist.
- Third, complete the arguments of the incidence2::incidence()
- Fourth, keep, drop, or change argument values in function plot()
- Paste the outputs. Reply to questions.

### Inputs

Use outputs from activity 1.

| Room | Date               | Categorical variable |
|------|--------------------|----------------------|
| 1    | Date reporting     | Age category         |
| 2    | Date onset         | Outcome              |
| 3    | Last exposure date | Last vaccine type    |

### Solution

<!-- visible for instructors and learners after practical (solutions) -->

#### Code

##### Room 1

activity 1

``` r
# nolint start

# Practical 1
# Activity 1

room_number <- 1

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
```

activity 2

``` r
# nolint start

# Practical 1
# Activity 2

room_number <- 1

# Validate linelist ------------------------------------------------------

# Activate error message
linelist::lost_tags_action(action = "error")
# linelist::lost_tags_action(action = "warning")

# Print tag types, names, and data to guide make_linelist
linelist::tags_types()
linelist::tags_names()
dat_timespan

# Does the categorical variable of interest pass the validation step?
dat_validate <- dat_timespan %>%
  # Tag variables
  linelist::make_linelist(
    id = "study_id",
    date_reporting = "date_first_pcr_positive_test",
    gender = "sex_fem_2",
    age = "timespan_variable",
    allow_extra = TRUE,
    age_category = "timespan_category"
  ) %>%
  # Validate linelist
  linelist::validate_linelist(
    allow_extra = TRUE,
    ref_types = linelist::tags_types(
      age_category = c("factor"),
      allow_extra = TRUE
    )
  ) %>%
  # Test safeguard
  # dplyr::select(case_id, date_onset, sex)
  # INSTEAD
  linelist::tags_df()


# Create incidence -------------------------------------------------------

# What is the most appropriate time-aggregate (days, months) to plot?
dat_incidence <- dat_validate %>%  
  # Transform from individual-level to time-aggregate
  incidence2::incidence(
    date_index = "date_reporting",
    groups = "age_category", # the categorical variable
    interval = "month",
    complete_dates = TRUE
  )


# Plot epicurve ----------------------------------------------------------

# Do arguments like 'fill', 'show_cases', 'angle', 'n_breaks' improve the plot?
dat_incidence %>% 
  plot(
    fill = "age_category", # the categorical variable
    show_cases = TRUE, # <KEEP OR DROP>
    angle = 45, # <KEEP OR DROP>
    n_breaks = 5 # <KEEP OR DROP>
  )

# Find plot() arguments at ?incidence2:::plot.incidence2()

# nolint end
```

##### Room 2

activity 1

``` r
# nolint start

# Practical 1
# Activity 1

room_number <- 2

# Load packages ----------------------------------------------------------
library(cleanepi)
library(linelist)
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
    cleanepi::check_date_sequence(
      target_columns = c(
        "date_first_contact",
        "date_last_contact",
        "date_onset",
        "date_admission",
        "date_outcome"
      )
    ) %>%
    cleanepi::convert_to_numeric(target_columns = "age") %>%
    # dplyr::count(sex)
    # using data_dictionary requires valid missing entries
    cleanepi::replace_missing_values(
      target_columns = "sex",
      na_strings = "-99"
    ) %>%
    cleanepi::clean_using_dictionary(dictionary = dat_dictionary) %>%
    cleanepi::remove_constants() %>%
    cleanepi::remove_duplicates(
      target_columns = c("case_id", "case_name")
    )

dat_clean


# Create time span variable ----------------------------------------------

# What time span unit best describes the 'delay' from 'onset' to 'death'?
dat_timespan <- dat_clean %>%
  cleanepi::timespan(
    target_column = "date_onset",
    end_date = "date_outcome",
    span_unit = "days",
    span_column_name = "timespan_variable",
    span_remainder_unit = NULL
  ) %>%
  # skimr::skim(timespan_variable)
  # Categorize the delay numerical variable
  dplyr::mutate(
    timespan_category = base::cut(
      x = timespan_variable,
      breaks = c(0, 10, 15, 40), 
      include.lowest = TRUE,
      right = FALSE
    )
  )

dat_timespan


# nolint end
```

activity 2

``` r
# nolint start

# Practical 1
# Activity 2

room_number <- 2

# Validate linelist ------------------------------------------------------

# Activate error message
linelist::lost_tags_action(action = "error")
# linelist::lost_tags_action(action = "warning")

# Print tag types, names, and data to guide make_linelist
linelist::tags_types()
linelist::tags_names()
dat_timespan

# Does the categorical variable of interest pass the validation step?
dat_validate <- dat_timespan %>% 
  # Tag variables
  linelist::make_linelist(
    id = "case_id",
    date_onset = "date_onset",
    gender = "sex",
    age = "age",
    outcome = "outcome"
  ) %>% 
  # Validate linelist
  linelist::validate_linelist() %>% 
  # Test safeguard
  # dplyr::select(case_id, date_onset, sex)
  # INSTEAD
  linelist::tags_df()


# Create incidence -------------------------------------------------------

# What is the most appropriate time-aggregate (days, months) to plot?
dat_incidence <- dat_validate %>%  
  # Transform from individual-level to time-aggregate
  incidence2::incidence(
    date_index = "date_onset",
    groups = "outcome", # the categorical variable
    interval = "day",
    complete_dates = TRUE
  )


# Plot epicurve ----------------------------------------------------------

# Do arguments like 'fill', 'show_cases', 'angle', 'n_breaks' improve the plot?
dat_incidence %>% 
  plot(
    angle = 45, # <KEEP OR DROP>
    n_breaks = 5 # <KEEP OR DROP>
  )

# Find plot() arguments at ?incidence2:::plot.incidence2()

# nolint end
```

##### Room 3

activity 1

``` r
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
```

activity 2

``` r
# nolint start

# Practical 1
# Activity 2

room_number <- 3

# Validate linelist ------------------------------------------------------

# Activate error message
linelist::lost_tags_action(action = "error")
# linelist::lost_tags_action(action = "warning")

# Print tag types, names, and data to guide make_linelist
linelist::tags_types()
linelist::tags_names()
dat_timespan

# Does the categorical variable of interest pass the validation step?
dat_validate <- dat_timespan %>% 
  # Tag variables
  linelist::make_linelist(
    id = "pid",
    allow_extra = TRUE,
    last_exp_date = "last_exp_date",
    last_vax_type = "last_vax_type"
  ) %>% 
  # Validate linelist
  linelist::validate_linelist(
    allow_extra = TRUE,
    ref_types = linelist::tags_types(
      last_exp_date = c("Date"),
      last_vax_type = c("character"),
      allow_extra = TRUE
    )
  ) %>% 
  # Test safeguard
  # dplyr::select(case_id, date_onset, sex)
  # INSTEAD
  linelist::tags_df()


# Create incidence -------------------------------------------------------

# What is the most appropriate time-aggregate (days, months) to plot?
dat_incidence <- dat_validate %>%  
  # Transform from individual-level to time-aggregate
  incidence2::incidence(
    date_index = "last_exp_date",
    groups = "last_vax_type", # the categorical variable
    interval = "month",
    complete_dates = TRUE
  )


# Plot epicurve ----------------------------------------------------------

# Do arguments like 'fill', 'show_cases', 'angle', 'n_breaks' improve the plot?
dat_incidence %>% 
  plot(
    fill = "last_vax_type" # the categorical variable # <KEEP OR DROP>
  )

# Find plot() arguments at ?incidence2:::plot.incidence2()

# nolint end
```

#### Outputs

##### activity 1

| Room | Cleaning | Time span |
|----|----|----|
| 1 | Suggested order: replace missing values before clean using a dictionary for sex variable. Relevant step: remove constants like `Location` and duplicates. | The time unit to calculate age from date of birth to today is “years”. To express today, you can use `Sys.Date()`. It is also the default of `cleanepi::timespan()` |
| 2 | Relevant step: convert strings to numeric for age, Suggested order: replace inconsistent missing values before clean using a dictionary for sex variable. | The time unit for calculate the delay from date of onset to date of outcome is “days”. |
| 3 | Relevant step: convert strings to numeric for age. | The time unit to calculate the time from last exposure to vaccine to the date of sample collection is “days”. |

##### activity 2

| Room | Output                                              |
|------|-----------------------------------------------------|
| 1    | ![image](https://hackmd.io/_uploads/ry5d6xnA1e.png) |
| 2    | ![image](https://hackmd.io/_uploads/SJ2f0e2Cyx.png) |
| 3    | ![image](https://hackmd.io/_uploads/H1-PRlhA1g.png) |

| Room | validation | time unit | incidence plot |
|----|----|----|----|
| 1 | The timespan_category (age categories) must be added as an extra variable. Declare age as “factor”. | An appropriate time unit to aggregated is using interval by month. | The argument `show_cases` can improve the visibility of `fill` categorical variables |
| 2 | It is not required to add an extra variable. | An appropriate time unit to aggregate is using interval by day. | Keeping angle and `n_breaks` works. Dropping `fill` keeps the facets making “died” are move visible. |
| 3 | last_exp_date and last_vax_type must be added as extra variables. Declare last_vax_type as “character”, and last_vax_date as “Date”. | An appropriate time unit to aggregated is using interval by month. | Keeping `fill` by last_vax_type works. |

#### Interpretation

Cleaning

- In small data frames, we can diagnose cleaning operations easier than
  large data frames.
- For example, in the large data frame, before cleaning the sex variable
  with a data dictionary, we need to remove unconsistent missing values.
  We can use `dplyr::count()` to find this issue.

Validation

- Using the `linelist::tags_df()` output can keep stable downstream
  analysis. Jointly with `linelist::lost_tags_action(action = "error")`
  we can improve the capacity to diagnose changes in the input data.
  This can prevent getting misleading outputs from automatic daily code
  runs or dashboards updates.

Epicurve

- The argument `show_cases` can improve the visibility of `fill`
  categorical variables when the amount of observed cases is small.

# Continue your learning path

<!-- Suggest learners to Epiverse-TRACE documentation or external resources --->

Explore the downstream analysis you can do with {incidence2} outputs

- <https://www.reconverse.org/incidence2/doc/incidence2.html#sec:building-on-incidence2>

<!-- You can use [{epikinetics}](https://seroanalytics.org/epikinetics/) to estimate antibody kinetics. Explore this sample code:
&#10;- <https://epiverse-trace.github.io/tutorials-early/epikinetics-statistics.html> -->

# end

[^1]: Context of Serological data: Participants of a study are exposed
    to COVID-19 vaccines, then their serum samples are collected and
    challenged to emerging SARS-CoV-2 variants. They measure the titer
    of this immunological response. The higher the titre, the higher the
    antigenic response. Let’s focus on describing the change in the
    frequency of vaccine categories (last vaccine exposure) through time
    (last date of exposure). Ref:
    https://www.thelancet.com/journals/laninf/article/PIIS1473-3099(24)00484-5/fulltext
