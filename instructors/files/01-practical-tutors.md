# Week 1: Clean, validate linelist, and plot epicurves


<!-- visible for instructors only -->

<!-- practical-week.md is generated from practical-week.qmd. Please edit that file -->

<!-- commit .md and .qmd files together -->

<!-- does not work for instructors text messages -->

<!-- works for text on html and MD only -->

This practical is based in the following tutorial episodes:

- <https://epiverse-trace.github.io/tutorials-early/clean-data.html>
- <https://epiverse-trace.github.io/tutorials-early/describe-cases.html>

# Practical

This practical has two activities.

## Activity 1: Clean and standardize raw data

**Goal:**

Produce a clean and standardized data frame from the following input:

- Raw, messy CSV file

**Steps:**

1.  Open `01-practical-activity-1.R` and complete every line marked with
    `#<COMPLETE>`, following the instructions in the file.
2.  Complete the argument in `read_csv()` by pasting the data link as a
    string.
3.  Complete the cleaning function arguments. Remove functions based on
    the data needs.
4.  Paste your outputs and answer the questions below.

**Questions:**

1.  **Diagnose the raw data.** What cleaning operations are needed? List
    them all before writing any code.
2.  **Time unit.** What time unit best describes the time span you need
    to calculate?
3.  **Report.** Print the report. Which features would be most useful
    when presenting findings to a decision-maker?
4.  **Compare** *(if applicable).* What differences do you notice
    compared to outputs from other rooms?

Discuss your answers with your group before sharing with the wider room.

### Inputs

| Room | Data | Link | Calculate time span |
|----|----|----|----|
| 1 | Small linelist | <https://epiverse-trace.github.io/tutorials-early/data/linelist-date_of_birth.csv> | Age (as of today) |
| 2 | Large linelist | <https://epiverse-trace.github.io/tutorials-early/data/covid_simulated_data.csv> | Time from symptom onset to death |
| 3 | Serology data [^1] | <https://epiverse-trace.github.io/tutorials-early/data/delta_full-messy.csv> | Time from last vaccine dose to sample collection [^2] |

## Activity 2: Plot delays and epicurves

**Goal:**

Using a clean linelist data frame, produce:

- A delay distribution plot showing time between two epidemiological
  events.
- An incidence plot (epicurve) showing case counts over time.

**Steps:**

- Open `01-practical-activity-2.R` and complete all lines marked with
  `#<COMPLETE>`.
- Complete the argument to read the data. Paste the link as a “string”
  in `read_rds()`.
- Describe the pre-configured epidemiological delay. Explore others you
  find relevant.
- Complete the arguments of `incidence2::incidence()` to generate an
  incidence object.
- Adjust the arguments of `plot()` to get the most informative epicurve.
  Read the [`plot()` reference
  manual](https://www.reconverse.org/incidence2/manual.html#sec:man-plot.incidence2)
  to find available arguments.
- Paste your plots and reply to the discussion questions.

**Questions:**

- Which is larger in your delay distribution: the mean or the median,
  and what does that tell you about its shape?
- How might delays in the data collection process affect your
  interpretation of the most recent cases?
- Which combination of time unit and case categories best captures the
  outbreak pattern and why?
- What does the shape of your epicurve suggest about how this outbreak
  spread?

Discuss your answers with your group before sharing with the wider room.

### Inputs

| Room | Data | Link |
|----|----|----|
| 1 | COVID | <https://epiverse-trace.github.io/tutorials-early/data/covid_simulist.rds> |
| 2 | Ebola | <https://epiverse-trace.github.io/tutorials-early/data/ebola_simulist.rds> |
| 3 | Unknown | <https://epiverse-trace.github.io/tutorials-early/data/unknown_simulist.rds> |

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
  cleanepi::clean_using_dictionary(
    dictionary = dat_dictionary
  ) %>%
  cleanepi::remove_constants() %>%
  cleanepi::remove_duplicates(
    target_columns = c(
      "study_id",
      "date_of_birth"
    )
  ) %>% 
  cleanepi::timespan(
    target_column = "date_of_birth",
    end_date = Sys.Date(),
    span_unit = "years",
    span_column_name = "timespan_variable",
    span_remainder_unit = "months"
  )

dat_clean

# nolint end
```

activity 2

``` r
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
    )

dat_clean


# nolint end
```

activity 2

``` r
# nolint start

# Practical 1
# Activity 2

room_number <- 2

# Load packages ----------------------------------------------------------
library(cleanepi)
library(incidence2)
library(tidyverse)

# Read raw data ----------------------------------------------------------
dat_linelist <- readr::read_rds(
  "https://epiverse-trace.github.io/tutorials-early/data/ebola_simulist.rds"
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
    cleanepi::standardize_dates(
      target_columns = "date"
    ) %>% #
    cleanepi::convert_to_numeric(
      target_columns = "exp_num"
    ) %>%
    cleanepi::check_date_sequence(
      target_columns = c(
        "last_exp_date",
        "date"
      )
    )

dat_clean


# nolint end
```

activity 2

``` r
# nolint start

# Practical 1
# Activity 2

room_number <- 3

# Load packages ----------------------------------------------------------
library(cleanepi)
library(incidence2)
library(tidyverse)

# Read raw data ----------------------------------------------------------
dat_linelist <- readr::read_rds(
  "https://epiverse-trace.github.io/tutorials-early/data/unknown_simulist.rds"
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
    date_index = date_onset,
    groups = c(sex, age_category), # the categorical variable
    interval = "month",
    complete_dates = TRUE
  )


# Plot epicurve ----------------------------------------------------------

# Do arguments like 'fill', 'show_cases', 'angle', 'n_breaks' improve the plot?
dat_incidence %>% 
  plot(
    fill = "sex", # the categorical variable
    nrow = 1, # 1 or 2 <KEEP OR DROP>
    show_cases = FALSE, # <KEEP OR DROP>
    angle = 45, # <KEEP OR DROP>
    n_breaks = 5 # <KEEP OR DROP>
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

[^2]: How to read the repeated-measurements cohort dataset: Subject
    `pid = 1` was `Infection naive` (never exposed to infection). Was
    exposed 2 times (`exp_num`) to the vaccine type BNT162b2
    (`last_vax_type`). The last vaccine exposure was on 2021-03-08
    (`last_exp_date`). One serum sample was obtain on 2021-03-10
    (`date`, two days after last vaccine exposure). The antibody titer
    against Alpha and Delta COVID variants (`titre_type`) was 5 units
    (`value`). The antibody titer against Ancestral COVID variants was
    176 units.
