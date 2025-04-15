# Week 2: Name

<!-- visible for instructors only -->
<!-- practical-week.md is generated from practical-week.qmd. Please edit that file -->
<!-- commit .md and .qmd files together -->
<!-- does not work for instructors text messages -->
<!-- works for text on html and MD only -->

This practical is based in the following tutorial episodes:

- <link/episode>
- <link/episode>

Welcome!

- A reminder of our Code of Conduct:
- <https://github.com/epiverse-trace/.github/blob/main/CODE_OF_CONDUCT.md>
- If you experience or witness unacceptable behaviour, or have any other
  concerns, please report by email or online form available at the “How
  to report a violation” section.
- To report an issue involving one of the organisers, please use the
  LSHTM’s Report and Support tool, where your concern will be triaged by
  a member of LSHTM’s Equity and Diversity Team.
- <https://reportandsupport.lshtm.ac.uk/>

Roll call:

- Group 1: …, …
- Group 2: …, …
- Group 3: …, …
- Group 4: …, …
- Group 5: …, …
- Group 6: …, …

# Practical

<!-- visible for learners and instructors at practical -->

This practical has two activities.

Before your start, as a group:

- Create one copy of the Posit Cloud project `<paste link>`.
- Solve each challenge using the `Code chunk` as a guide.
- Paste your figure and table outputs.
- Write your answer to the questions.
- Choose one person from your group to share your results with everyone.

During the practical, instead of copy-paste, we encourage learners to
increase their fluency writing R by using:

- Tab key <kbd>↹</kbd> for [code completion
  feature](https://support.posit.co/hc/en-us/articles/205273297-Code-Completion-in-the-RStudio-IDE)
  and [possible arguments
  displayed](https://docs.posit.co/ide/user/ide/guide/code/console.html).
- The double-colon notation, e.g. `package::function()`. This helps us
  remember package functions and avoid namespace conflicts.
- [R
  shortcuts](https://positron.posit.co/keyboard-shortcuts.html#r-shortcuts):
  - `Cmd/Ctrl`+`Shift`+`M` to Insert the pipe operator (`|>` or `%>%`)
  - `Alt`+`-` to Insert the assignment operator (`<-`)
- [Execute one line of
  code](https://docs.posit.co/ide/user/ide/guide/code/execution.html) by
  placing the cursor in the code of interest and press the
  `Ctrl`+`Enter`. This also works for multiple lines conected by the
  pipe operator.
- Get [help yourself with R](https://www.r-project.org/help.html) using
  `help()` function or `?` operator to access function reference manual.

## Paste your !Error messages here






## Activity 1: Theme

Estimate … using the following available inputs:

- input 1
- input 2

As a group, Write your answer to these questions:

- … phase?
- … results expected?
- Interpret: How would you communicate these results to a
  decision-maker?
- Compare: What differences you identify from other group outputs? (if
  available)

### Inputs

| Group | Incidence     | Link                                                                      |
|-------|---------------|---------------------------------------------------------------------------|
| 1     | COVID 30 days | <https://epiverse-trace.github.io/tutorials-middle/data/covid_30days.rds> |
| 2     | Ebola 35 days |                                                                           |
| 3     | Ebola 60 days |                                                                           |
| 4     | COVID 60 days |                                                                           |

| Disease | params |
|---------|--------|
| Ebola   | …      |
| COVID   | …      |

### Solution

<!-- visible for instructors and learners after practical (solutions) -->

#### Code

##### sample 1

``` r
# Load packages ----------------------------------------------------------
library(cleanepi)
library(linelist)
library(incidence2)
library(tidyverse)


# Adapt the data dictionary ----------------------------------------------
# wait until have more information
dat_dictionary <- tibble::tribble(
  ~options,
  ~values,
  ~grp,
  ~orders,
  "1",
  "male",
  "sex_fem_2",
  1L, # remove this line: how this affects the code downstream?
  "2",
  "female",
  "sex_fem_2",
  2L
)


# Read raw data ----------------------------------------------------------
dat_raw <- readr::read_csv(
  "https://epiverse-trace.github.io/tutorials-early/data/linelist-date_of_birth.csv"
)


# Clean and standardize data ---------------------------------------------

# what steps you required to have clean data?
dat_clean <- dat_raw %>%
  # standardize column names and dates
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


# Create categorical variable --------------------------------------------

# what time span unit better describe age?
dat_category <- dat_clean %>%
  # calculate the age in 'years' and return the remainder in 'months'
  cleanepi::timespan(
    target_column = "date_of_birth",
    end_date = Sys.Date(),
    span_unit = "years",
    span_column_name = "age_in_years",
    span_remainder_unit = "months"
  ) %>%
  # skimr::skim(age_in_years)
  # categorize the age numerical variable
  dplyr::mutate(
    age_category = base::cut(
      x = age_in_years,
      breaks = c(0, 20, 35, 60, 80), # replace with max value if known
      include.lowest = TRUE,
      right = FALSE
    )
    # age_category = Hmisc::cut2(x = age_in_years,cuts = c(20,35,60))
  )


# Validate data ----------------------------------------------------------

# activate Error message
linelist::lost_tags_action(action = "error")
# linelist::lost_tags_action(action = "warning")

# print tags types, names, and data to guide make_linelist
linelist::tags_types()
linelist::tags_names()
dat_category

# does the age variable pass the validation step?
dat_validate <- dat_category %>%
  # tag variables
  linelist::make_linelist(
    id = "study_id",
    date_reporting = "date_first_pcr_positive_test",
    gender = "sex_fem_2",
    # age = "age_category", # does not pass validation
    age = "age_in_years",
    occupation = "age_category" # (downstream implications!)
  ) %>%
  # validate linelist
  linelist::validate_linelist() %>%
  # safeguard
  # TRY using
  # dplyr::select(study_id, sex_fem_2, age_category)
  # CONSEQUENCE
  # You get an ERROR notification due to loosing tags
  # INSTEAD
  # get a dataframe with all validated tags
  linelist::tags_df()

# relevant change: the variable names CHANGE to tag names!
# (can simplify downstream analysis!)

# Create incidence -------------------------------------------------------

# what is the most appropriate time-aggregate (days, months) to plot?
dat_incidence <- dat_validate %>%
  # transform from individual-level to time-aggregate
  incidence2::incidence(
    date_index = "date_reporting", #"date_first_pcr_positive_test",
    groups = "occupation", #"age_category", # change to sex, ...
    interval = "month", # change to days, weeks, ...
    complete_dates = TRUE # relevant to downstream analysis [time-series data]
  )


# Plot epicurve ----------------------------------------------------------

# does using arguments like 'fill' or 'show_cases' improves the plot?
dat_incidence %>%
  plot(
    fill = "occupation", # "age_category",
    show_cases = TRUE,
    angle = 45,
    n_breaks = 5
  )

# find plot() arguments at ?incidence2:::plot.incidence2()
```

##### sample 2

``` r
# Load packages ----------------------------------------------------------
library(cleanepi)
library(linelist)
library(incidence2)
library(tidyverse)


# Adapt the data dictionary ----------------------------------------------
# wait until have more information
dat_dictionary <- tibble::tribble(
  ~options,
  ~values,
  ~grp,
  ~orders,
  "1",
  "male",
  "sex",
  1L, # remove this line: how this affects the code downstream?
  "2",
  "female",
  "sex",
  2L,
  "M",
  "male",
  "sex",
  3L,
  "F",
  "female",
  "sex",
  4L,
  "m",
  "male",
  "sex",
  5L,
  "f",
  "female",
  "sex",
  6L
)


# Read raw data ----------------------------------------------------------
dat_raw <- readr::read_csv(
  "https://epiverse-trace.github.io/tutorials-early/data/covid_simulated_data.csv"
)


# Clean and standardize data ---------------------------------------------

# what steps you required to have clean data?
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


# Create categorical variable --------------------------------------------

# what time span unit better describe delay from onset to death?
dat_category <- dat_clean %>%
  # calculate the time delay from 'onset' to 'death' in 'days'
  cleanepi::timespan(
    target_column = "date_onset",
    end_date = "date_outcome",
    span_unit = "days",
    span_column_name = "delay_onset_death",
    span_remainder_unit = NULL
  ) %>%
  # skimr::skim(delay_onset_death)
  # categorize the delay numerical variable
  dplyr::mutate(
    delay_category = base::cut(
      x = delay_onset_death,
      breaks = c(0, 10, 15, 40), # replace with max value if known
      include.lowest = TRUE,
      right = FALSE
    )
    # age_category = Hmisc::cut2(x = age_in_years,cuts = c(20,35,60))
  )


# Validate data ----------------------------------------------------------

# activate Error message
linelist::lost_tags_action(action = "error")
# linelist::lost_tags_action(action = "warning")

# print tags types, names, and data to guide make_linelist
linelist::tags_types()
linelist::tags_names()
dat_category

# does the age variable pass the validation step?
dat_validate <- dat_category %>%
  # tag variables
  linelist::make_linelist(
    id = "case_id",
    date_onset = "date_onset",
    gender = "sex",
    age = "age",
    outcome = "outcome",
    occupation = "delay_category" # (downstream implications!)
  ) %>%
  # validate linelist
  linelist::validate_linelist() %>%
  # safeguard
  # TRY using
  # dplyr::select(case_id, date_onset, sex)
  # CONSEQUENCE
  # You get an ERROR notification due to loosing tags
  # INSTEAD
  # get a dataframe with all validated tags
  linelist::tags_df()

# relevant change: the variable names CHANGE to tag names!
# (can simplify downstream analysis!)

# Create incidence -------------------------------------------------------

# what is the most appropriate time-aggregate (days, months) to plot?
dat_incidence <- dat_validate %>%
  # transform from individual-level to time-aggregate
  incidence2::incidence(
    date_index = "date_onset",
    groups = "outcome", #"age_category", # change to sex, ...
    interval = "day", # change to days, weeks, ...
    complete_dates = TRUE # relevant to downstream analysis [time-series data]
  )


# Plot epicurve ----------------------------------------------------------

# does using arguments like 'fill' or 'show_cases' improves the plot?
dat_incidence %>%
  plot(
    angle = 45,
    n_breaks = 5
  )

# find plot() arguments at ?incidence2:::plot.incidence2()
```

#### Outputs

##### Group 4: COVID 60 days

With reporting delay plus Incubation time:
<img src="https://hackmd.io/_uploads/S1q6ItjvC.png" style="width:50.0%"
alt="image" />

With reporting delay plus Incubation time:

    > summary(covid60_epinow_delays)
                                measure               estimate
                                 <char>                 <char>
    1:           New infections per day     1987 (760 -- 4566)
    2: Expected change in daily reports      Likely decreasing
    3:       Effective reproduction no.     0.81 (0.43 -- 1.3)
    4:                   Rate of growth -0.047 (-0.2 -- 0.092)
    5:     Doubling/halving time (days)      -15 (7.5 -- -3.5)

#### Interpretation

Interpretation template:

- From the summary of our analysis we see that the expected change in
  reports is `Likely decreasing` with the estimated new infections, on
  average, of `1987` with 90% credible interval of `760` to `4566`.

- …

Interpretation Helpers:

- About the effective reproduction number:
  - An Rt greater than 1 implies an increase in cases or an epidemic.
  - An Rt less than 1 implies a decrease in cases or extinction.
- …

# Continue your learning path

<!-- Suggest learners to Epiverse-TRACE documentation or external resources --->

Where

- <link>

# end
