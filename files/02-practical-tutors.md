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

## Activity 1: Transmission

Estimate $R_{t}$, *new infections*, *new reports*, *growth rate*, and
*doubling/halving time* using the following available inputs:

- Incidence of reported cases per day
- Reporting delay

As a group, Write your answers to these questions:

- What phase of the epidemic are you observing? (Exponential growth
  phase, near peak, or decay end phase)
- Is the expected change in daily reports consistent with the estimated
  effective reproductive number, growth rate, and doubling time?
- Interpret: How would you communicate these results to a
  decision-maker?
- Compare: What differences do you identify from other group outputs?
  (if available)

### Inputs

| Group | Incidence | Link |
|----|----|----|
| 1 | COVID 30 days | <https://epiverse-trace.github.io/tutorials-middle/data/covid_30days.rds> |
| 2 | Ebola 35 days | <https://epiverse-trace.github.io/tutorials-middle/data/ebola_35days.rds> |
| 3 | Ebola 60 days | <https://epiverse-trace.github.io/tutorials-middle/data/ebola_60days.rds> |
| 4 | COVID 60 days | <https://epiverse-trace.github.io/tutorials-middle/data/covid_60days.rds> |

| Disease | Reporting delays |
|----|----|
| Ebola | The time difference between symptom onset and case report follows a Lognormal distribution with uncertainty. The **meanlog** follows a Normal distribution with mean = 1.4 days and sd = 0.5 days. The **sdlog** follows a Normal distribution with mean = 0.25 days and sd = 0.2 days. Bound the distribution with a maximum = 5 days. |
| COVID | The time difference between symptom onset and case report follows a Gamma distribution with uncertainty. The **mean** follows a Normal distribution with mean = 2 days and sd = 0.5 days. The **standard deviation** follows a Normal distribution with mean = 1 day and sd = 0.5 days. Bound the distribution with a maximum = 5 days. |

### Solution

<!-- visible for instructors and learners after practical (solutions) -->

#### Code

##### Ebola (sample)

``` r
# Load packages -----------------------------------------------------------
library(epiparameter)
library(EpiNow2)
library(tidyverse)

# Read reported cases -----------------------------------------------------
dat_ebola <- readr::read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/ebola_35days.rds"  #<DIFFERENT PER GROUP>
) %>%
  dplyr::select(date, confirm = cases)

# Define a generation time from {epiparameter} to {EpiNow2} ---------------

# access a serial interval
ebola_serialint <- epiparameter::epiparameter_db(
  disease = "ebola",
  epi_name = "serial",
  single_epiparameter = TRUE
)

# extract parameters from {epiparameter} object
ebola_serialint_params <- epiparameter::get_parameters(ebola_serialint)

# adapt {epiparameter} to {EpiNow2} distribution inferfase
# preferred
ebola_generationtime <- EpiNow2::Gamma(
  shape = ebola_serialint_params["shape"],
  scale = ebola_serialint_params["scale"]
)
# or
ebola_generationtime <- EpiNow2::Gamma(
  mean = ebola_serialint$summary_stats$mean,
  sd = ebola_serialint$summary_stats$sd
)


# Define the delays from infection to case report for {EpiNow2} -----------

# define delay from symptom onset to case report
# or reporting delay
ebola_reportdelay <- EpiNow2::LogNormal(
  meanlog = EpiNow2::Normal(mean = 1.4, sd = 0.5),
  sdlog = EpiNow2::Normal(mean = 0.25, sd = 0.2),
  max = 5
)

# define a delay from infection to symptom onset
# or incubation period
ebola_incubationtime <- epiparameter::epiparameter_db(
  disease = "ebola",
  epi_name = "incubation",
  single_epiparameter = TRUE
)

# incubation period: extract distribution parameters
ebola_incubationtime_params <- epiparameter::get_parameters(
  ebola_incubationtime
)

# incubation period: discretize and extract maximum value (p = 99%)
# preferred
ebola_incubationtime_max <- ebola_incubationtime %>%
  epiparameter::discretise() %>%
  quantile(p = 0.99)
# or
ebola_incubationtime_max <- ebola_incubationtime %>%
  quantile(p = 0.99) %>%
  base::round()

# incubation period: adapt to {EpiNow2} distribution interface
ebola_incubationtime_epinow <- EpiNow2::Gamma(
  shape = ebola_incubationtime_params["shape"],
  scale = ebola_incubationtime_params["scale"],
  max = ebola_incubationtime_max
)

# collect required input
ebola_generationtime
ebola_reportdelay
ebola_incubationtime_epinow


# Set the number of parallel cores for {EpiNow2} --------------------------
withr::local_options(list(mc.cores = parallel::detectCores() - 1))


# Estimate transmission using EpiNow2::epinow() ---------------------------
# with EpiNow2::*_opts() functions for generation time, delays, and stan.
ebola_estimates <- EpiNow2::epinow(
  data = dat_ebola,
  generation_time = EpiNow2::generation_time_opts(ebola_generationtime),
  delays = EpiNow2::delay_opts(ebola_incubationtime_epinow + ebola_reportdelay),
  stan = EpiNow2::stan_opts(samples = 1000, chains = 3)
)


# Print plot and summary table outputs ------------------------------------
summary(ebola_estimates)
plot(ebola_estimates)
```

##### COVID (sample)

``` r
# Load packages -----------------------------------------------------------
library(epiparameter)
library(EpiNow2)
library(tidyverse)

# Read reported cases -----------------------------------------------------
dat_covid <- read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/covid_30days.rds"  #<DIFFERENT PER GROUP>
) %>%
  dplyr::select(date, confirm)

# Define a generation time from {epiparameter} to {EpiNow2} ---------------

# access a serial interval
covid_serialint <- epiparameter::epiparameter_db(
  disease = "covid",
  epi_name = "serial",
  single_epiparameter = TRUE
)

# extract parameters from {epiparameter} object
covid_serialint_params <- epiparameter::get_parameters(covid_serialint)

# adapt {epiparameter} to {EpiNow2} distribution inferfase
# preferred
covid_generationtime <- EpiNow2::LogNormal(
  meanlog = covid_serialint_params["meanlog"],
  sdlog = covid_serialint_params["sdlog"]
)
# or
covid_generationtime <- EpiNow2::LogNormal(
  mean = covid_serialint$summary_stats$mean,
  sd = covid_serialint$summary_stats$sd
)


# Define the delays from infection to case report for {EpiNow2} -----------

# define delay from symptom onset to case report
# or reporting delay
covid_reportdelay <- EpiNow2::Gamma(
  mean = EpiNow2::Normal(mean = 2, sd = 0.5),
  sd = EpiNow2::Normal(mean = 1, sd = 0.5),
  max = 5
)

# define a delay from infection to symptom onset
# or incubation period
covid_incubationtime <- epiparameter::epiparameter_db(
  disease = "covid",
  epi_name = "incubation",
  single_epiparameter = TRUE
)

# incubation period: extract distribution parameters
covid_incubationtime_params <- epiparameter::get_parameters(
  covid_incubationtime
)

# incubation period: discretize and extract maximum value (p = 99%)
# preferred
covid_incubationtime_max <- covid_incubationtime %>%
  epiparameter::discretise() %>%
  quantile(p = 0.99)
# or
ebola_incubationtime_max <- covid_incubationtime %>%
  quantile(p = 0.99) %>%
  base::round()

# incubation period: adapt to {EpiNow2} distribution interface
covid_incubationtime_epinow <- EpiNow2::LogNormal(
  meanlog = covid_incubationtime_params["meanlog"],
  sdlog = covid_incubationtime_params["sdlog"],
  max = covid_incubationtime_max
)

# collect required input
covid_generationtime
covid_reportdelay
covid_incubationtime_epinow


# Set the number of parallel cores for {EpiNow2} --------------------------
withr::local_options(list(mc.cores = parallel::detectCores() - 1))


# Estimate transmission using EpiNow2::epinow() ---------------------------
# with EpiNow2::*_opts() functions for generation time, delays, and stan.
covid_estimates <- EpiNow2::epinow(
  data = dat_covid,
  generation_time = EpiNow2::generation_time_opts(covid_generationtime),
  delays = EpiNow2::delay_opts(covid_reportdelay + covid_incubationtime_epinow),
  stan = EpiNow2::stan_opts(samples = 1000, chains = 3)
)


# Print plot and summary table outputs ------------------------------------
summary(covid_estimates)
plot(covid_estimates)
```

#### Outputs

##### Group 1: COVID 30 days

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

##### Group 2: Ebola 35 days

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

##### Group 3: Ebola 60 days

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

##### Group 4: COVID 60 days

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
- From table:
  - The values from the `summary()` output correspond to the latest
    available date under analysis.
  - The `Expected change in reports` categories (e.g., `Stable` or
    `Likely decreasing`) describe the expected change in daily cases
    based on the posterior probability that Rt \< 1. Find the tutorial
    table at:
    <https://epiverse-trace.github.io/tutorials-middle/quantify-transmissibility.html#expected-change-in-reports>
- From figure:
  - The estimate of Reports fits the input incidence curve.
  - The forecast of New infections and Reports per day assumes no change
    in the reproduction number. For that reason, the forecast section of
    “Effective reproduction no.” is constant.
  - When we include at `delays` both the incubation and reporting delay,
    - In Reports, the forecast credible intervals increases.
    - New infections per day, uncertainty increases in an equivalent
      size to the delays
- From comparing COVID and Ebola outputs:
  - The finite maximum value of the generation time distribution define
    the range of the “estimate based on parial data”.

## Activity 2: Severity

Estimate the *naive CFR (nCFR)* and *delay-adjusted CFR (aCFR)* using
the following inputs:

- Reported cases (aggregate incidence by date of onset)
- Onset to death delay

As a group, Write your answers to these questions:

- What phase of the epidemic are you observing? (Exponential growth
  phase, near peak, or decay end phase)
- Does the time series include all the possible deaths to observe from
  known cases?
- How much difference is there between the nCFR and aCFR estimates?
- Interpret: How would you communicate these results to a
  decision-maker?
- Compare: What differences do you identify from other group outputs?
  (if available)

### Inputs

| Group | Data | Action to data input | Link |
|----|----|----|----|
| 1 | COVID-19 Diamond Princess | Keep dates before March 1st | <https://epiverse-trace.github.io/tutorials-middle/data/diamond_70days.rds> |
| 2 | COVID-19 Diamond Princess | Estimate from complete time series | <https://epiverse-trace.github.io/tutorials-middle/data/diamond_70days.rds> |
| 3 | MERS Korea 2015 | Adapt from incidence to {cfr} | <https://epiverse-trace.github.io/tutorials-middle/data/mers_linelist.rds> |

### Solution

<!-- visible for instructors and learners after practical (solutions) -->

#### Code

##### COVID (sample)

``` r
# Load packages -----------------------------------------------------------
library(cfr)
library(epiparameter)
library(tidyverse)


# Read reported cases -----------------------------------------------------
covid_dat <- read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/diamond_70days.rds" 
)

covid_dat


# Create incidence object ------------------------------------------------
covid_incidence <- covid_dat %>%
  incidence2::incidence(
    date_index = "date",
    counts = c("cases", "deaths"),
    complete_dates = TRUE
  )

plot(covid_incidence)


# Confirm {cfr} data input format ----------------------------------------

# does input data already adapted to {cfr} input? Yes.
covid_adapted <- covid_dat
# does input data require to be adapted to {cfr}? No.
# covid_adapted <- covid_incidence %>%
#   cfr::prepare_data(
#     cases = "cases",
#     deaths = "deaths"
#   )

covid_adapted

# Access delay distribution -----------------------------------------------
covid_delay <- epiparameter::epiparameter_db(
  disease = "covid",
  epi_name = "onset-to-death",
  single_epiparameter = TRUE
)


# Estimate naive and adjusted CFR ----------------------------------------

# Estimate Static Delay-Adjusted CFR
covid_dat %>%
  filter(
    date < ymd(20200301)
  ) %>% 
  cfr::cfr_static()

# Estimate Static Delay-Adjusted CFR
covid_dat %>%
  filter(
    date < ymd(20200301)
  ) %>% 
  cfr::cfr_static(
    delay_density = function(x) density(covid_delay, x)
  )


# CFR estimates in whole data --------------------------------------------

# Estimate Static Delay-Adjusted CFR
covid_dat %>% 
  cfr::cfr_static()

# Estimate Static Delay-Adjusted CFR
covid_dat %>%
  cfr::cfr_static(
    delay_density = function(x) density(covid_delay, x)
  )
```

##### MERS (sample)

``` r
# Load packages -----------------------------------------------------------
library(cfr)
library(epiparameter)
library(tidyverse)


# Read reported cases -----------------------------------------------------
mers_dat <- readr::read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/mers_linelist.rds"
)

mers_dat


# Create incidence object ------------------------------------------------
mers_incidence <- mers_dat %>%
  incidence2::incidence(
    date_index = c("dt_onset", "dt_death"),
    complete_dates = TRUE
  )

plot(mers_incidence)


# Confirm {cfr} data input format ----------------------------------------

# does input data already adapted to {cfr} input? No.
# mers_adapted <- mers_dat
# does input data require to be adapted to {cfr}? Yes.
mers_adapted <- mers_incidence %>%
  cfr::prepare_data(
    cases = "dt_onset",
    deaths = "dt_death"
  )

mers_adapted

# Access delay distribution -----------------------------------------------
mers_delay <- epiparameter::epiparameter_db(
  disease = "mers",
  epi_name = "onset-to-death",
  single_epiparameter = TRUE
)


# Estimate naive and adjusted CFR ----------------------------------------

# Estimate Static CFR
mers_adapted %>%
  # filter(
  #   #<COMPLETE>
  # ) %>%
  cfr::cfr_static()

# Estimate Static Delay-Adjusted CFR
mers_adapted %>%
  # filter(
  #   #<COMPLETE>
  # ) %>%
  cfr::cfr_static(
    delay_density = function(x) density(mers_delay, x)
  )
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

- The MERS incidence curve seems to be in a decay phase. However, it is
  expected to have death reports in upcoming dates, as observed in the
  COVID Diamond Princess data.
- For COVID, until the end of February (on March 1st), the aCFR central
  estimate is closer to the CFR estimates on April 15th.
- For MERS, the aCFR estimate is almost the double of the nCFR estimate.

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
