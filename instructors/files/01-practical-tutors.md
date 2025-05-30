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

Welcome!

- A reminder of our [Code of
  Conduct](https://github.com/epiverse-trace/.github/blob/main/CODE_OF_CONDUCT.md).
  If you experience or witness unacceptable behaviour, or have any other
  concerns, please notify the course organisers or host of the event. To
  report an issue involving one of the organisers, please use the
  [LSHTM’s Report and Support
  tool](https://reportandsupport.lshtm.ac.uk/).

# Read This First

<!-- visible for learners and instructors at practical -->

Instructions:

- Each `Activity` has five sections: the Goal, Questions, Inputs, Your
  Code, and Your Answers.
- Solve each Activity in the corresponding `.R` file mentioned in the
  `Your Code` section.
- Paste your figure and table outputs and write your answer to the
  questions in the section `Your Answers`.
- Choose one group member to share your group’s results with the rest of
  the participants.

During the practical, instead of simply copying and pasting, we
encourage learners to increase their fluency writing R by using:

- The double-colon notation, e.g. `package::function()` to specify which
  package a function comes from, avoid namespace conflicts, and find
  functions using keywords.
- Tab key <kbd>↹</kbd> to [autocomplete package or function
  names](https://support.posit.co/hc/en-us/articles/205273297-Code-Completion-in-the-RStudio-IDE)
  and [display possible
  arguments](https://docs.posit.co/ide/user/ide/guide/code/console.html).
- [Execute one line of
  code](https://docs.posit.co/ide/user/ide/guide/code/execution.html) or
  multiple lines connected by the pipe operator (`%>%`) by placing the
  cursor in the code of interest and pressing the `Ctrl`+`Enter`.
- [R
  shortcuts](https://positron.posit.co/keyboard-shortcuts.html#r-shortcuts)
  to insert the pipe operator (`%>%`) using `Ctrl/Cmd`+`Shift`+`M`, or
  insert the assignment operator (`<-`) using `Alt/Option`+`-`.
  <!-- - Get [help yourself with R](https://www.r-project.org/help.html) using the `help()` function or `?` operator to access the function reference manual. -->

If your local configuration was not possible to setup:

- Create one copy of the [Posit Cloud RStudio
  project](https://posit.cloud/spaces/609790/join?access_code=hPM1tIeKt5ax_Y-P0lMGVUGqzFPNH4wxkKSzXZYb).

## Paste your !Error messages here





# Practical

This practical has two activities.

## Activity 1: Clean and standardize raw data

Get a clean and standardized data frame using the following available
inputs:

- Raw messy data frame in CSV format

As a group, Write your answers to these questions:

- Diagnose the raw data. What data cleaning operations need to be
  performed on the dataset? Write all of them before writing the code.
- What time unit best describes the time span to calculate?
- Print the report: How would you communicate these results to a
  decision-maker?
- Compare: What differences do you identify from other group outputs?
  (if available)

### Inputs

| Group | Data | Link | Calculate time span | Categorize time span |
|----|----|----|----|----|
| 1 | Small linelist | <https://epiverse-trace.github.io/tutorials-early/data/linelist-date_of_birth.csv> | Age as of today | breaks = c(0, 20, 35, 60, 80) |
| 2 | Large linelist | <https://epiverse-trace.github.io/tutorials-early/data/covid_simulated_data.csv> | Delay from onset of symptoms to the time of death | breaks = c(0, 10, 15, 40) |
| 3 | Serology data | <https://epiverse-trace.github.io/tutorials-early/data/delta_full-messy.csv> | Time from last exposure to vaccine | breaks = c(0, 30, 100, 600) |

## Activity 2: Validate linelist and plot epicurve

Get a validated linelist and incidence plot using the following
available inputs:

- Clean data frame object

As a group, Write your answers to these questions:

- In the validation step, Do you need to allow for extra variable names
  and types?
- What is the most apprioriate time unit to aggregate the incidence
  plot, based on visual inspection?
- Does using arguments like `fill`, `show_cases`, `angle`, `n_breaks`
  improve the incidence plot?
- Interpret: How would you communicate these results to a
  decision-maker?
- Compare: What differences do you identify from other group outputs?
  (if available)

### Inputs

Use outputs from activity 1.

### Solution

<!-- visible for instructors and learners after practical (solutions) -->

#### Code

##### Sample 1

``` r
# Load packages ----------------------------------------------------------
library(cleanepi)
library(linelist)
library(incidence2)
library(tidyverse)


# Adapt the data dictionary ----------------------------------------------
# wait until have more information
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

dat_clean


# Create categorical variable --------------------------------------------

# what time span unit better describe age?
dat_timespan <- dat_clean %>%
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
      breaks = c(0, 20, 35, 60, 80),
      include.lowest = TRUE,
      right = FALSE
    )
    # age_category = Hmisc::cut2(x = age_in_years,cuts = c(20,35,60))
  )

dat_timespan


# Validate linelist ------------------------------------------------------

# activate Error message
linelist::lost_tags_action(action = "error")
# linelist::lost_tags_action(action = "warning")

# print tags types, names, and data to guide make_linelist
linelist::tags_types()
linelist::tags_names()
dat_timespan

# does the age variable pass the validation step?
dat_validate <- dat_timespan %>%
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
dat_validate


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

dat_incidence


# Plot epicurve ----------------------------------------------------------

# does using arguments like 'fill' or 'show_cases' improve the plot?
dat_incidence %>%
  plot(
    fill = "occupation", # "age_category",
    show_cases = TRUE,
    angle = 45,
    n_breaks = 5
  )

# find plot() arguments at ?incidence2:::plot.incidence2()
```

##### Sample 2

``` r
# Load packages ----------------------------------------------------------
library(cleanepi)
library(linelist)
library(incidence2)
library(tidyverse)


# Adapt the data dictionary ----------------------------------------------
# wait until have more information
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

dat_clean


# Create time span variable ----------------------------------------------

# what time span unit better describe delay from onset to death?
dat_timespan <- dat_clean %>%
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
      breaks = c(0, 10, 15, 40),
      include.lowest = TRUE,
      right = FALSE
    )
    # age_category = Hmisc::cut2(x = age_in_years,cuts = c(20,35,60))
  )

dat_timespan


# Validate linelist ------------------------------------------------------

# activate Error message
linelist::lost_tags_action(action = "error")
# linelist::lost_tags_action(action = "warning")

# print tags types, names, and data to guide make_linelist
linelist::tags_types()
linelist::tags_names()
dat_timespan

# does the age variable pass the validation step?
dat_validate <- dat_timespan %>%
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
dat_validate


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

dat_incidence


# Plot epicurve ----------------------------------------------------------

# does using arguments like 'fill' or 'show_cases' improve the plot?
dat_incidence %>%
  plot(
    angle = 45,
    n_breaks = 5
  )

# find plot() arguments at ?incidence2:::plot.incidence2()
```

##### Sample 3

> Group 3 should investigate about how the argument `allow_extra = TRUE`
> us used in this howto entry
> <https://epiverse-trace.github.io/howto/analyses/describe_cases/cleanepi-linelist-incidence2-stratified.html>

``` r
# Load packages ----------------------------------------------------------
library(cleanepi)
library(linelist)
library(incidence2)
library(tidyverse)


# Read raw data ----------------------------------------------------------
dat_raw <- readr::read_csv("https://epiverse-trace.github.io/tutorials-early/data/delta_full-messy.csv")

dat_raw


# Clean and standardize data ---------------------------------------------
dat_clean <- dat_raw %>%
  # cleanepi
  cleanepi::standardize_column_names() %>%
  cleanepi::standardize_dates(target_columns = "date") %>% #
  cleanepi::convert_to_numeric(target_columns = "exp_num") %>%
  cleanepi::check_date_sequence(
    target_columns = c("last_exp_date", "date")
  )

dat_clean


# Create time span variable ----------------------------------------------

# what time span unit better describe 'time' from 'last exposure' to 'date'?
dat_timespan <- dat_clean %>%
  # cleanepi::print_report()
  cleanepi::timespan(
    target_column = "last_exp_date",
    end_date = "date",
    span_unit = "days",
    span_column_name = "t_since_last_exp",
    span_remainder_unit = NULL
  ) %>%
  # skimr::skim(t_since_last_exp)
  # categorize the delay numerical variable
  dplyr::mutate(
    time_category = base::cut(
      x = t_since_last_exp,
      breaks = c(0, 30, 100, 600),
      include.lowest = TRUE,
      right = FALSE
    )
  )

dat_timespan


# Validate linelist ------------------------------------------------------

dat_validate <- dat_timespan %>%
  # tag with {linelist}
  linelist::make_linelist(
    id = "pid",
    occupation = "time_category",
    allow_extra = TRUE,
    last_exp_date = "last_exp_date",
    t_since_last_exp = "t_since_last_exp",
    last_vax_type = "last_vax_type"
  ) %>%
  # validate
  linelist::validate_linelist(
    allow_extra = TRUE,
    ref_types = linelist::tags_types(
      last_exp_date = c("Date"),
      t_since_last_exp = c("numeric"),
      last_vax_type = c("character"),
      allow_extra = TRUE
    )
  ) %>%
  # keep tags data frame
  linelist::tags_df()

dat_validate


# Create incidence -------------------------------------------------------

dat_incidence <- dat_validate %>%
    # aggregate
    incidence2::incidence(
      date_index = "last_exp_date",
      groups = "last_vax_type", 
      interval = "month", # change: "day" or "week" etc
      complete_dates = TRUE # relevant to downstream analysis [time-series data]
    )

dat_incidence


# Plot epicurve ----------------------------------------------------------

dat_incidence %>%
  # plot
  plot(
    fill = "last_vax_type" # change to groups variable
  )

# find plot() arguments at ?incidence2:::plot.incidence2()
```

#### Outputs

| Group | Output                                              |
|-------|-----------------------------------------------------|
| 1     | ![image](https://hackmd.io/_uploads/ry5d6xnA1e.png) |
| 2     | ![image](https://hackmd.io/_uploads/SJ2f0e2Cyx.png) |
| 3     | ![image](https://hackmd.io/_uploads/H1-PRlhA1g.png) |

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

You can use [{epikinetics}](https://seroanalytics.org/epikinetics/) to
estimate antibody kinetics. Explore this sample code:

- <https://epiverse-trace.github.io/tutorials-early/epikinetics-statistics.html>

# end
