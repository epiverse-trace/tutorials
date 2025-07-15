# Week 2: Access delays to estimate transmission and severity


<!-- visible for instructors only -->

<!-- practical-week.md is generated from practical-week.qmd. Please edit that file -->

<!-- commit .md and .qmd files together -->

<!-- does not work for instructors text messages -->

<!-- works for text on html and MD only -->

This practical is based in the following tutorial episodes:

- <https://epiverse-trace.github.io/tutorials-middle/delays-access.html>
- <https://epiverse-trace.github.io/tutorials-middle/quantify-transmissibility.html>
- <https://epiverse-trace.github.io/tutorials-middle/delays-functions.html>
- <https://epiverse-trace.github.io/tutorials-middle/severity-static.html>

# Practical

This practical has two activities.

## Activity 1: Transmission

Estimate $R_{t}$, *new infections*, *new reports*, *growth rate*, and
*doubling/halving time* using the following available inputs:

- Incidence of reported cases per day
- Reporting delay

Within your room, Write your answers to these questions:

- What phase of the epidemic are you observing? (Exponential growth
  phase, near peak, or decay end phase)
- Is the expected change in daily reports consistent with the estimated
  effective reproductive number, growth rate, and doubling time?
- Interpret: How would you communicate these results to a
  decision-maker?
- Compare: What differences do you identify from other room outputs? (if
  available)

**Steps:**

- Open the file `02-practical-activity-1.R` and fill in your
  `room_number` in the script.
- Paste the URL link as a string to read input data.
- Keep the reading function that corresponds to your input data disease.
- Define a generation time:
  - Access to a generation time, if available, or an approximation.
  - Extract distribution parameters or summary statistics.
  - Adapt to {EpiNow2} distribution interface.
- Define the delays from infection to case report (observation):
  - For the reporting delay, interpret the description in the `Inputs`
    section.
  - For the incubation period, the steps are similar to the generation
    time.
- Add generation time and delays using the {EpiNow2} helper functions in
  `EpiNow2::epinow()`.
- Run `EpiNow2::epinow()` and print the summary and plot outputs.
- Paste the outputs. Reply to questions.

### Inputs

| Room | Incidence | Link |
|----|----|----|
| 1 | COVID-19 30 days | <https://epiverse-trace.github.io/tutorials-middle/data/covid_30days.rds> |
| 2 | Ebola 35 days | <https://epiverse-trace.github.io/tutorials-middle/data/ebola_35days.rds> |
| 3 | Ebola 60 days | <https://epiverse-trace.github.io/tutorials-middle/data/ebola_60days.rds> |
| 4 | COVID-19 60 days | <https://epiverse-trace.github.io/tutorials-middle/data/covid_60days.rds> |

| Disease | Reporting delays |
|----|----|
| Ebola | The time difference between symptom onset and case report follows a Lognormal distribution with uncertainty. The **meanlog** follows a Normal distribution with mean = 1.4 days and sd = 0.5 days. The **sdlog** follows a Normal distribution with mean = 0.25 days and sd = 0.2 days. Bound the Lognormal distribution with a maximum = 5 days. |
| COVID | The time difference between symptom onset and case report follows a Gamma distribution with uncertainty. The **mean** follows a Normal distribution with mean = 2 days and sd = 0.5 days. The **standard deviation** follows a Normal distribution with mean = 1 day and sd = 0.5 days. Bound the Gamma distribution with a maximum = 5 days. |

### Solution

<!-- visible for instructors and learners after practical (solutions) -->

#### Code

##### Ebola (sample)

``` r
# nolint start

# Practical 2
# Activity 1

room_number <- 2 # valid for 3

# Load packages -----------------------------------------------------------
library(epiparameter)
library(EpiNow2)
library(tidyverse)


# Read reported cases -----------------------------------------------------
# for ebola
dat <- read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/ebola_35days.rds" #<DIFFERENT PER ROOM>
) %>%
  dplyr::select(date, confirm = cases)


# Define a generation time from {epiparameter} to {EpiNow2} ---------------

# access a serial interval
dat_serialint <- epiparameter::epiparameter_db(
  disease = "ebola",
  epi_name = "serial",
  single_epiparameter = TRUE
)

# extract parameters from {epiparameter} object
dat_serialint_params <- epiparameter::get_parameters(dat_serialint)

# adapt {epiparameter} to {EpiNow2} distribution inferfase
dat_generationtime <- EpiNow2::Gamma(
  shape = dat_serialint_params["shape"],
  scale = dat_serialint_params["scale"]
)
# or
dat_generationtime <- EpiNow2::Gamma(
  mean = dat_serialint$summary_stats$mean,
  sd = dat_serialint$summary_stats$sd
)

# Define the delays from infection to case report for {EpiNow2} -----------

# define delay from symptom onset to case report
dat_reportdelay <- EpiNow2::LogNormal(
  meanlog = EpiNow2::Normal(mean = 1.4, sd = 0.5),
  sdlog = EpiNow2::Normal(mean = 0.25, sd = 0.2),
  max = 5
)

# define a delay from infection to symptom onset
dat_incubationtime <- epiparameter::epiparameter_db(
  disease = "ebola",
  epi_name = "incubation",
  single_epiparameter = TRUE
)

# incubation period: extract distribution parameters
dat_incubationtime_params <- epiparameter::get_parameters(
  dat_incubationtime
)

# incubation period: discretize and extract maximum value (p = 99%)
dat_incubationtime_max <- dat_incubationtime %>% 
  epiparameter::discretise() %>%
  quantile(p = 0.99)
# or
dat_incubationtime_max <- dat_incubationtime %>%
  quantile(p = 0.99) %>%
  base::round()

# incubation period: adapt to {EpiNow2} distribution interface
dat_incubationtime_epinow <- EpiNow2::Gamma(
  shape = dat_incubationtime_params["shape"],
  scale = dat_incubationtime_params["scale"],
  max = dat_incubationtime_max
)

# print required input
dat_generationtime
dat_reportdelay
dat_incubationtime_epinow


# Set the number of parallel cores for {EpiNow2} --------------------------
withr::local_options(list(mc.cores = parallel::detectCores() - 1))


# Estimate transmission using EpiNow2::epinow() ---------------------------
# with EpiNow2::*_opts() functions for generation time, delays, and stan.
estimates <- EpiNow2::epinow(
  data = dat,
  generation_time = EpiNow2::generation_time_opts(dat_generationtime),
  delays = EpiNow2::delay_opts(dat_incubationtime_epinow + dat_reportdelay),
  stan = EpiNow2::stan_opts(samples = 1000, chains = 3)
)


# Print plot and summary table outputs ------------------------------------
summary(estimates)
plot(estimates)


# nolint end
```

##### COVID (sample)

``` r
# nolint start

# Practical 2
# Activity 1

room_number <- 1 # valid for 4

# Load packages -----------------------------------------------------------
library(epiparameter)
library(EpiNow2)
library(tidyverse)


# Read reported cases -----------------------------------------------------
# for covid
dat <- read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/covid_30days.rds" #<DIFFERENT PER ROOM>
) %>%
  dplyr::select(date, confirm)


# Define a generation time from {epiparameter} to {EpiNow2} ---------------

# access a serial interval
dat_serialint <- epiparameter::epiparameter_db(
  disease = "covid",
  epi_name = "serial",
  single_epiparameter = TRUE
)

# extract parameters from {epiparameter} object
dat_serialint_params <- epiparameter::get_parameters(dat_serialint)

# adapt {epiparameter} to {EpiNow2} distribution inferfase
dat_generationtime <- EpiNow2::LogNormal(
  meanlog = dat_serialint_params["meanlog"],
  sdlog = dat_serialint_params["sdlog"]
)
# or
dat_generationtime <- EpiNow2::LogNormal(
  mean = dat_serialint$summary_stats$mean,
  sd = dat_serialint$summary_stats$sd
)


# Define the delays from infection to case report for {EpiNow2} -----------

# define delay from symptom onset to case report
dat_reportdelay <- EpiNow2::Gamma(
  mean = EpiNow2::Normal(mean = 2, sd = 0.5),
  sd = EpiNow2::Normal(mean = 1, sd = 0.5),
  max = 5
)

# define a delay from infection to symptom onset
dat_incubationtime <- epiparameter::epiparameter_db(
  disease = "covid",
  epi_name = "incubation",
  single_epiparameter = TRUE
)

# incubation period: extract distribution parameters
dat_incubationtime_params <- epiparameter::get_parameters(
  dat_incubationtime
)

# incubation period: discretize and extract maximum value (p = 99%)
dat_incubationtime_max <- dat_incubationtime %>%
  epiparameter::discretise() %>%
  quantile(p = 0.99)
# or
dat_incubationtime_max <- dat_incubationtime %>%
  quantile(p = 0.99) %>%
  base::round()

# incubation period: adapt to {EpiNow2} distribution interface
dat_incubationtime_epinow <- EpiNow2::LogNormal(
  meanlog = dat_incubationtime_params["meanlog"],
  sdlog = dat_incubationtime_params["sdlog"],
  max = dat_incubationtime_max
)

# print required input
dat_generationtime
dat_reportdelay
dat_incubationtime_epinow


# Set the number of parallel cores for {EpiNow2} --------------------------
withr::local_options(list(mc.cores = parallel::detectCores() - 1))


# Estimate transmission using EpiNow2::epinow() ---------------------------
# with EpiNow2::*_opts() functions for generation time, delays, and stan.
estimates <- EpiNow2::epinow(
  data = dat,
  generation_time = EpiNow2::generation_time_opts(dat_generationtime),
  delays = EpiNow2::delay_opts(dat_reportdelay + dat_incubationtime_epinow),
  stan = EpiNow2::stan_opts(samples = 1000, chains = 3)
)


# Print plot and summary table outputs ------------------------------------
summary(estimates)
plot(estimates)


# nolint end
```

#### Outputs

##### Room 1: COVID 30 days

With reporting delay plus Incubation time:
<img src="https://hackmd.io/_uploads/BJl8wYiDC.png" style="width:25.0%"
alt="image" />

With reporting delay plus Incubation time:

    > summary(covid30_epinow_delay)
                                measure               estimate
                                 <char>                 <char>
    1:           New infections per day  13193 (5129 -- 33668)
    2: Expected change in daily reports      Likely increasing
    3:       Effective reproduction no.      1.5 (0.92 -- 2.5)
    4:                   Rate of growth 0.099 (-0.049 -- 0.26)
    5:     Doubling/halving time (days)         7 (2.7 -- -14)

##### Room 2: Ebola 35 days

With reporting delay plus Incubation time:
<img src="https://hackmd.io/_uploads/H1ZrYYsvR.png" style="width:25.0%"
alt="image" />

With reporting delay plus Incubation time:

    > summary(ebola35_epinow_delays)
                                measure               estimate
                                 <char>                 <char>
    1:           New infections per day            5 (0 -- 26)
    2: Expected change in daily reports      Likely decreasing
    3:       Effective reproduction no.     0.66 (0.13 -- 2.2)
    4:                   Rate of growth -0.039 (-0.18 -- 0.12)
    5:     Doubling/halving time (days)      -18 (5.5 -- -3.9)

##### Room 3: Ebola 60 days

With reporting delay plus Incubation time:
<img src="https://hackmd.io/_uploads/Byu3FFoDR.png" style="width:25.0%"
alt="image" />

With reporting delay plus Incubation time:

    > summary(ebola60_epinow_delays)
                                measure                  estimate
                                 <char>                    <char>
    1:           New infections per day                0 (0 -- 0)
    2: Expected change in daily reports                Decreasing
    3:       Effective reproduction no.    0.038 (0.0013 -- 0.39)
    4:                   Rate of growth -0.16 (-0.32 -- -0.00055)
    5:     Doubling/halving time (days)      -4.4 (-1300 -- -2.2)

##### Room 4: COVID 60 days

With reporting delay plus Incubation time:
<img src="https://hackmd.io/_uploads/S1q6ItjvC.png" style="width:25.0%"
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

- The effective reproduction number $R_t$ estimate (on the last date of
  the data), or the number of new infections caused by one infectious
  individual, on average, is `0.81`, with a 90% credible interval of
  `0.43` to `1.30`.

- The exponential growth rate of case reports is, on average `-0.047`,
  with a 90% credible interval of `-0.2` to `0.01`.

- The doubling time (the time taken for case reports to double) is, on
  average, `-15.0`, with a 90% credible interval of `7.5` to `-3.5`.

Interpretation Helpers:

- About the effective reproduction number:
  - An Rt greater than 1 implies an increase in cases or an epidemic.
  - An Rt less than 1 implies a decrease in transmission, which could
    lead to extinction if sustained.
- An analysis closest to extinction has a central estimate of:
  - Rt less than 1
  - growth rate is negative
  - doubling or halving time negative, which indicate a decline in cases
- However, given the uncertainty in all of these estimates, there is no
  statistical evidence of extinction if the 90% credible intervals of:
  - Rt include the value 1,
  - growth rate include the value 0,
  - doubling or halving time include the value 0.

**From table**:

- The values from the `summary()` output correspond to the latest
  available date under analysis.
- The `Expected change in reports` categories (e.g., `Stable` or
  `Likely decreasing`) describe the expected change in daily cases based
  on the posterior probability that Rt \< 1. Find the tutorial table at:
  <https://epiverse-trace.github.io/tutorials-middle/quantify-transmissibility.html#expected-change-in-reports>

**From figure**:

- The estimate of `Reports` fits the input incidence curve.
- The forecast of `New infections` and `Reports` per day assumes no
  change in the reproduction number. For that reason, the forecast
  section of “Effective reproduction no.” is constant.
- The estimated trajectory of `New Infections` (line) is delayed from
  the `New Reports` (bars), due to the added incubation and reporting
  delays.
- About delays:
  - When we correctly include **incubation** and **reporting** `delays`
    in `EpiNow2::epinow()`,
    - In `Reports`, the forecast credible intervals increases.
    - In `New infections` per day, uncertainty is expanded due to the
      length of delays.
  - If we forget adding delays, `{EpiNow2}` could misinterpret `Reports`
    (confirmed cases) as `Infections`.
    - For example, using one same input data of reference (e.g., COVID
      30 days).
    - If we forget adding delays, **Panel B** overlaps the trajectory of
      New infections and the frequency of Reports.
    - If we correctly add delays, In Reports, the upper interval
      increases from 30k to 45k. In New infections per day, uncertainty
      expands from Mar 16 onwards.
- From comparing COVID and Ebola outputs:
  - The finite maximum value of the **generation** time distribution
    define the range of the `Estimate based on parial data`.
  - Both values are defined by default by {EpiNow2} using a percentile
    of 99%
    - COVID: `max` = ~14 days,
    - Ebola: `max` = ~45 days.
  - For this reason, Ebola 35 days has no `Estimate` but only
    `Estimate based on partial data` and `Forecast`.

## Activity 2: Severity

Estimate the *naive CFR (nCFR)* and *delay-adjusted CFR (aCFR)* using
the following inputs:

- Reported cases (aggregate incidence by date of onset)
- Onset to death delay

Within your room, Write your answers to these questions:

- What phase of the epidemic are you observing? (Exponential growth
  phase, near peak, or decay end phase)
- Does the time series include all the possible deaths to observe from
  known cases?
- How much difference is there between the nCFR and aCFR estimates?
- Interpret: How would you communicate these results to a
  decision-maker?
- Compare: What differences do you identify from other room outputs? (if
  available)

**Steps:**

- Open the file `02-practical-activity-2.R` and fill in your
  `room_number` in the script.
- Paste the URL link as a string to read input data.
- Fill in the argument to plot an incidence curve.
- Evaluate if the input data format needs adaptation to {cfr}.
- Access to the probability distribution for the delay from case onset
  to death.
- Evaluate if you need to keep dates or omit using `dplyr::filter()`.
- Estimate the naive and delay-adjusted CFR.
- Paste the outputs. Reply to questions.

### Inputs

| Room | Data | Action on data input | Link |
|----|----|----|----|
| 1 | COVID-19 Diamond Princess | Keep dates before March 1st | <https://epiverse-trace.github.io/tutorials-middle/data/diamond_70days.rds> |
| 2 | COVID-19 Diamond Princess | Estimate from a complete time series | <https://epiverse-trace.github.io/tutorials-middle/data/diamond_70days.rds> |
| 3 | MERS Korea 2015 | Adapt from incidence to {cfr} | <https://epiverse-trace.github.io/tutorials-middle/data/mers_linelist.rds> |

### Solution

<!-- visible for instructors and learners after practical (solutions) -->

#### Code

##### Room 1: COVID 25 days

25 days (before March 1st)

``` r
# nolint start

# Practical 2
# Activity 2

room_number <- 1

# Load packages -----------------------------------------------------------
library(cfr)
library(epiparameter)
library(tidyverse)


# Read reported cases -----------------------------------------------------
disease_dat <- readr::read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/diamond_25days.rds"
)

disease_dat


# Create incidence object ------------------------------------------------
disease_incidence <- disease_dat %>%
  incidence2::incidence(
    date_index = "date",
    counts = c("cases", "deaths"),
    complete_dates = TRUE
  )

# with data available before march 1st
disease_incidence %>%
  plot()

# with complete data
disease_incidence %>% 
  plot()


# Confirm {cfr} data input format ----------------------------------------

# Is the input data already adapted to {cfr} input? 
disease_adapted <- disease_dat
# # OR
# # Does the input data need to be adapted to {cfr}? 
# disease_adapted <- disease_incidence %>%
#   cfr::prepare_data(
#     #<COMPLETE>
#   )

disease_adapted

# Access delay distribution -----------------------------------------------
disease_delay <- epiparameter::epiparameter_db(
  disease = "covid",
  epi_name = "onset-to-death",
  single_epiparameter = TRUE
)


# Estimate naive and adjusted CFR ----------------------------------------

# Estimate static CFR
disease_adapted %>%
  cfr::cfr_static()

# Estimate static delay-adjusted CFR
disease_adapted %>%
  cfr::cfr_static(
    delay_density = function(x) density(disease_delay, x)
  )

# nolint end
```

##### Room 2: COVID 70 days

70 days (until April 15th)

``` r
# nolint start

# Practical 2
# Activity 2

room_number <- 2

# Load packages -----------------------------------------------------------
library(cfr)
library(epiparameter)
library(tidyverse)


# Read reported cases -----------------------------------------------------
disease_dat <- readr::read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/diamond_70days.rds"
)

disease_dat


# Create incidence object ------------------------------------------------
disease_incidence <- disease_dat %>%
  incidence2::incidence(
    date_index = "date",
    counts = c("cases", "deaths"),
    complete_dates = TRUE
  )

# with data available before march 1st
disease_incidence %>%
  plot()

# with complete data
disease_incidence %>% 
  plot()


# Confirm {cfr} data input format ----------------------------------------

# Is the input data already adapted to {cfr} input? 
disease_adapted <- disease_dat
# # OR
# # Does the input data need to be adapted to {cfr}? 
# disease_adapted <- disease_incidence %>%
#   cfr::prepare_data(
#     #<COMPLETE>
#   )

disease_adapted

# Access delay distribution -----------------------------------------------
disease_delay <- epiparameter::epiparameter_db(
  disease = "covid",
  epi_name = "onset-to-death",
  single_epiparameter = TRUE
)


# Estimate naive and adjusted CFR ----------------------------------------

# Estimate static CFR
disease_adapted %>%
  cfr::cfr_static()

# Estimate static delay-adjusted CFR
disease_adapted %>%
  cfr::cfr_static(
    delay_density = function(x) density(disease_delay, x)
  )

# nolint end
```

##### Room 3: MERS

``` r
# nolint start

# Practical 2
# Activity 2

room_number <- 3

# Load packages -----------------------------------------------------------
library(cfr)
library(epiparameter)
library(tidyverse)


# Read reported cases -----------------------------------------------------
disease_dat <- readr::read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/mers_linelist.rds"
)

disease_dat


# Create incidence object ------------------------------------------------
disease_incidence <- disease_dat %>%
  incidence2::incidence(
    date_index = c("dt_onset", "dt_death"),
    complete_dates = TRUE
  )

plot(disease_incidence)


# Confirm {cfr} data input format ----------------------------------------

# Is the input data already adapted to {cfr} input? 
disease_adapted <- disease_dat
# OR
# Does the input data need to be adapted to {cfr}? 
disease_adapted <- disease_incidence %>%
  cfr::prepare_data(
    cases = "dt_onset",
    deaths = "dt_death"
  )

disease_adapted

# Access delay distribution -----------------------------------------------
disease_delay <- epiparameter::epiparameter_db(
  disease = "mers",
  epi_name = "onset-to-death",
  single_epiparameter = TRUE
)


# Estimate naive and adjusted CFR ----------------------------------------

# Estimate static CFR
disease_adapted %>%
  # filter(
  #   #<COMPLETE>
  # ) %>%
  cfr::cfr_static()

# Estimate static delay-adjusted CFR
disease_adapted %>%
  # filter(
  #   #<COMPLETE>
  # ) %>%
  cfr::cfr_static(
    delay_density = function(x) density(disease_delay, x)
  )

# nolint end
```

#### Outputs

| Covid Diamond Princess 2020 | Mers Korea 2015 |
|----|----|
| ![image](https://hackmd.io/_uploads/ryWr0vNRyx.png) | ![image](https://hackmd.io/_uploads/Sk2J0kjA1g.png) |

| Data Input | Filter Category                    | estimate | low   | high  |
|------------|------------------------------------|----------|-------|-------|
| covid      | date \< 2020-03-01                 | 0.009    | 0.003 | 0.018 |
| covid      | date \< 2020-03-01 + delay density | 0.026    | 0.010 | 0.053 |
| covid      | no filter                          | 0.020    | 0.011 | 0.033 |
| covid      | delay density                      | 0.020    | 0.011 | 0.033 |
| mers       | no filter                          | 0.074    | 0.036 | 0.132 |
| mers       | delay density                      | 0.138    | 0.072 | 0.229 |

#### Interpretation

Interpretation template:

- As of `15th June 2015`, the MERS cases in the population have a
  delay-adjusted case fatality risk of `13.8%` with a 95% confidence
  interval between `7.2%` and `22.9%`.

Intepretation helpers:

- We can assess if the time series include all the possible deaths to
  observe from known cases using:
  - the delay distribution from onset to death. Using the percentile-99,
    for COVID we may need to wait ~60 days and for MERS, ~49 days.
  - calculating the time difference between the observed date of onset
    and date of death from the input linelist data, stratified by age
    category.
- For COVID-19, until the end of February (on March 1st), the
  delay-adjusted (aCFR) central estimate is higher than the naive CFR
  (nCFR), but closer to the nCFR estimates on April 15th.
- With all data available, the delay-adusted and naive are similar
  (exactly the same). This is not the case for the data available up
  until March 1.
- The MERS incidence curve seems to be in a decay phase. However, it is
  expected to have death reports in upcoming dates, as observed in the
  COVID Diamond Princess data.
- For MERS, the aCFR central estimate is almost the double of the nCFR
  estimate, but 95% confidence intervals quite overlapped.

Complementary notes:

- `cfr::static()` assumption and limitations
  - One key assumption of `cfr::static()` is that reporting rate and
    fatality risk is consistent over the time window considered.
  - Early data from national surveillance systems had limitations (e.g.,
    limited testing, changing case definitions, often only most severe
    being tested -a.k.a., preferential assessertainment-). So neither
    method (aCFR nor nCFR) gives the ‘true’ % of fatal symptomatic
    cases.
  - Compared to the Diamond Princess data, for national surveillance
    systems `cfr::static()` is therefore most useful over longer
    timeseries.
  - Alternativelly, `{cfr}` can also estimate the proportion of cases
    that are ascertained during an outbreak using
    `cfr::estimate_ascertainment()`.

# Continue your learning path

<!-- Suggest learners to Epiverse-TRACE documentation or external resources --->

{EpiNow2} Case studies and use in the literature

- <https://epiforecasts.io/EpiNow2/articles/case-studies.html>

{cfr} Estimating the proportion of cases that are ascertained during an
outbreak

- <https://epiverse-trace.github.io/cfr/articles/estimate_ascertainment.html>

# end
