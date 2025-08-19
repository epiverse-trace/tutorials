# Week 4: Simulate transmission and model interventions


<!-- visible for instructors only -->

<!-- practical-week.md is generated from practical-week.qmd. Please edit that file -->

<!-- commit .md and .qmd files together -->

<!-- does not work for instructors text messages -->

<!-- works for text on html and MD only -->

This practical is based in the following tutorial episodes:

- <https://epiverse-trace.github.io/tutorials-late/simulating-transmission.html>
- <https://epiverse-trace.github.io/tutorials-late/modelling-interventions.html>

# Practical

This practical has three activities.

## Activity 1: Generate Disease Trajectories Across Age Groups

Generate disease trajectories of **infectious individuals** and **new
infections** across age groups using the following available inputs:

- Social contact matrix
- Age group of the infectious population
- Disease parameters (basic reproduction number, pre-infectious period,
  infectious period)

**Steps:**

Open the file `04-practical-activity-1.R` and complete all the lines
marked with `#<COMPLETE>`, following the detailed steps provided within
the R file.

**Questions:**

Within your room, Write your answers to these questions:

- What are the time and size of the epidemic peak for *infectious
  individuals* in each age group? Use the table output.
- Compare and describe the similarities and differences between these
  two outputs: the table with the epidemic peak of *infectious
  individuals* across age groups, and the plot of *new infections*
  across age groups.
- Compare: What differences do you observe compared to the outputs from
  other rooms (if available)?

### Inputs

| Room | Country  | Survey Link                              |
|------|----------|------------------------------------------|
| 1    | Italy    | <https://doi.org/10.5281/zenodo.3874557> |
| 2    | Vietnam  | <https://doi.org/10.5281/zenodo.3874802> |
| 3    | Zimbabwe | <https://doi.org/10.5281/zenodo.3886638> |

| Parameter | Value | Notes |
|----|----|----|
| Age Limits | 0, 20, 40 | Age group cutoffs |
| Infectious Population | 1 / 1,000,000 | 1 infectious individual per million people in the Age group 20-40 |
| Basic Reproduction Number | 1.46 | R₀ value for influenza |
| Pre-infectious Period | 3 days | Incubation before becoming infectious |
| Infectious Period | 7 days | Duration of infectiousness |
| Time end | 1000 days | Total simulation time |

### Solution

<!-- visible for instructors and learners after practical (solutions) -->

#### Outputs

| country | all compartments | new infections |
|----|----|----|
| Italy | ![image](https://hackmd.io/_uploads/SyVnWdXvle.png) | ![image](https://hackmd.io/_uploads/Syua-OQPeg.png) |

    epidemics::epidemic_peak(data = simulate_baseline)
    #>    demography_group compartment  time    value
    #>              <char>      <char> <num>    <num>
    #> 1:           [0,20)  infectious   320 513985.5
    #> 2:          [20,40)  infectious   328 560947.3
    #> 3:              40+  infectious   329 932989.8

| country | all compartments | new infections |
|----|----|----|
| Vietnam | ![image](https://hackmd.io/_uploads/BJFgQ_mvel.png) | ![image](https://hackmd.io/_uploads/HJ8-Qdmvlg.png) |

    epidemics::epidemic_peak(data = simulate_baseline)
    #>    demography_group compartment  time     value
    #>              <char>      <char> <num>     <num>
    #> 1:           [0,20)  infectious   325  929142.4
    #> 2:          [20,40)  infectious   322  975411.0
    #> 3:              40+  infectious   317 1053391.8

| country | all compartments | new infections |
|----|----|----|
| Zimbabwe | ![image](https://hackmd.io/_uploads/HJ_t7dXwgg.png) | ![image](https://hackmd.io/_uploads/Sk_9mdXDgx.png) |

    epidemics::epidemic_peak(data = simulate_baseline)
    #>    demography_group compartment  time    value
    #>              <char>      <char> <num>    <num>
    #> 1:           [0,20)  infectious   322 277709.4
    #> 2:          [20,40)  infectious   321 188967.9
    #> 3:              40+  infectious   317 111165.7

#### Interpretation

Interpretation template:

- In an age-structured SEIR epidemic model for influenza transmission in
  Zimbabwe, the demographic group aged 0 to 20 years (`[0,20]`) reaches
  its peak number of *infectious individuals* on day `322`, with a peak
  size of `277,709` individuals.

Compare output types:

- `epidemics::epidemic_peak(data = simulate_baseline)`
  - The table output gives exact values for time and size of peak for
    *infectious individuals* across age groups.
- `epidemics::new_infections(data = simulate_baseline)`
  - We can plot the trajectories of *new infections* across age groups,
    but not get exact value for time and size of peak directly.
  - We can make qualitative comparisons between countries or scenarios.
- Comparing plots:
  - The peak size of *new infections* is lower than the peak size of
    *infectious individuals*.
    - New infections are defined as the daily outflow of individuals
      from the susceptible to the exposed compartment.
    - Infectious are defined as the total number of cumulative amount of
      individuals in the infectious compartment at each time.
  - The peak time may be similar in both outputs.
  - Other packages that can estimate the trend of new infections are
    `{EpiNow2}` and `{epichains}`.

Comparison between rooms:

- Population structure and age-specific social contact patterns in each
  country influence the progression of disease transmission.
- Using `{socialmixr}`, the symmetric contact matrix contains the *mean
  number of contacts* that an individual in each age group (row) reports
  having with individuals of the same or another age group (column).
  - Note: The contact matrix may look asymmetric, but it is *symmetric
    in total contacts*. That is, the total number of contacts from one
    group to another is the same in both directions — check this by
    multiplying the mean contacts by the population size for each group.

| Italy | Vietnam | Zimbabwe |
|----|----|----|
| ![image](https://hackmd.io/_uploads/HyYOZ57Dll.png) | ![image](https://hackmd.io/_uploads/HkTjb9QDxl.png) | ![image](https://hackmd.io/_uploads/Bkrhx5Xvlx.png) |

Figures using
`socialmixr::matrix_plot(contact_data$matrix * contact_data$demography$proportion)`

## Activity 2: Compare the Baseline Scenario with a Single Intervention

Compare the disease trajectories of **new infections** in the whole
population under two conditions:

1.  The baseline scenario (no intervention)
2.  A scenario with a single intervention

Use the following inputs to define and explore the intervention
scenario:

- Start time of the intervention
- Duration of the intervention
- Type of intervention (on contact reduction, on transmission rate
  reduction, or vaccination)
- Reduction or Vaccination rate

**Steps:**

Open the file `04-practical-activity-2.R` and complete all the lines
marked with `#<COMPLETE>`, following the detailed steps provided within
the R file.

**Questions:**

Within your room, write your answers to these questions:

- Does the impact of the intervention, compared to the baseline, align
  with your expectations? Why or why not? Use all the available outputs.
- Interpret the results: How would you explain these findings to a
  decision-maker?
- Compare: What differences do you observe compared to the outputs from
  other rooms (if available)?

### Inputs

| Room  | Country  | Survey Link                              |
|-------|----------|------------------------------------------|
| 1,2,3 | Zimbabwe | <https://doi.org/10.5281/zenodo.3886638> |

| Room | Intervention | Reduction/Vaccination rate | Time begin (day) | Duration (days) |
|----|----|----|----|----|
| 1 | School closure | Age 0–19: 0.5; Age 20+: 0.01 | 200 | 250 |
| 2 | Mask mandate | All ages: 0.163 | 200 | 250 |
| 3 | Vaccination | All ages: 0.001 | 200 | 250 |

### Solution

<!-- visible for instructors and learners after practical (solutions) -->

#### Outputs

| intervention | all compartments | new infections |
|----|----|----|
| School closure | ![image](https://hackmd.io/_uploads/SJcXBqmwxg.png) | ![image](https://hackmd.io/_uploads/B1G2HcXwlx.png) |

    epidemics::epidemic_peak(simulate_intervention)
    #>    demography_group compartment  time     value
    #> 1:           [0,20)  infectious   568 190371.93
    #> 2:          [20,40)  infectious   566 121626.39
    #> 3:              40+  infectious   562  70255.15

| intervention | all compartments | new infections |
|----|----|----|
| Mask mandate | ![image](https://hackmd.io/_uploads/S12cIcXPex.png) | ![image](https://hackmd.io/_uploads/BytgP5QPll.png) |

    epidemics::epidemic_peak(simulate_intervention)

    #>    demography_group compartment  time    value
    #> 1:           [0,20)  infectious   380 88058.78
    #> 2:          [20,40)  infectious   378 61155.76
    #> 3:              40+  infectious   374 38143.96

| intervention | all compartments | new infections |
|----|----|----|
| Vaccination | ![image](https://hackmd.io/_uploads/rJMVOcXPeg.png) | ![image](https://hackmd.io/_uploads/r1p_O9Qwgx.png) |

    epidemics::epidemic_peak(data = simulate_intervention)
    #>    demography_group compartment  time     value
    #> 1:           [0,20)  infectious   318 155276.44
    #> 2:          [20,40)  infectious   317 107294.83
    #> 3:              40+  infectious   314  65867.72

#### Interpretation

Interpretation Helpers:

- School closure starting on day 200 for a duration of 250 days can
  delay the peak of infectious across age groups by 240 days approx.,
  and reduce the total number of new infections in the whole population
  by 20,000 approx.
- Mask mandate starting on day 200 for a duration of 250 days can delay
  the peak of infectious across age groups by 40 days approx., and
  reduce the total number of new infections in the whole population by
  50,000 approx.
- Vaccinations starting on day 200 for a duration of 250 days will not
  delay the peak of infectious across age groups, but reduce the total
  number of new infections in the whole population by 40,000 approx.
  - Note that the effectiveness of vaccination can depend on various
    factors, including **vaccine efficacy** and **timing relative to the
    outbreak**.

### Additional challenges

1.  **How do the start time and duration of interventions influence the
    timing and size of the peak in new infections?** Try modifying the
    intervention start time from day 200 to day 100, or changing the
    duration from 250 days to 100 days, and observe the impact on the
    epidemic dynamics in Zimbabwe.

2.  **How can interventions affect the timing and size of the peak in
    new infections across different countries?** Try changing the
    population from Zimbabwe to Vietnam or Italy to observe how
    country-specific factors like population structure and social
    contacts influence the epidemic curve.

## Activity 3: Combine Multiple Interventions

Compare the baseline scenario with a simulation that includes two
overlapping or sequential interventions. Use the intervention parameters
described in the previous activity.

**Steps:**

Open the file `04-practical-activity-3.R` and complete all the lines
marked with `#<COMPLETE>`, following the detailed steps provided within
the R file.

**Questions:**

Within your room, Write your answers to these questions:

- Interpret the results: How would you explain these findings to a
  decision-maker?
- Compare: What differences do you observe compared to the outputs from
  other rooms (if available)?

### Inputs

| Room | Combine interventions           | Compare against |
|------|---------------------------------|-----------------|
| 1    | School closure AND Vaccine      | School closure  |
| 2    | Mask mandate AND School contact | Mask mandate    |
| 3    | Vaccine AND Mask mandate        | Vaccine         |

### Solution

<!-- visible for instructors and learners after practical (solutions) -->

#### Outputs

| room 1 | room 2 | room 3 |
|----|----|----|
| ![image](https://hackmd.io/_uploads/Bk_gXjQwex.png) | ![image](https://hackmd.io/_uploads/rylgZiXPeg.png) | ![image](https://hackmd.io/_uploads/S1KyEsXwgg.png) |

room 1

    epidemics::epidemic_peak(simulate_twointerventions)
    #>    demography_group compartment  time    value
    #> 1:           [0,20)  infectious   201 7078.228
    #> 2:          [20,40)  infectious   261 7677.865
    #> 3:              40+  infectious   260 5131.311

room 2

    epidemics::epidemic_peak(simulate_twointerventions)
    #>    demography_group compartment  time    value
    #> 1:           [0,20)  infectious   648 253705.5
    #> 2:          [20,40)  infectious   647 170917.0
    #> 3:              40+  infectious   642 100149.4

room 3

    epidemics::epidemic_peak(simulate_twointerventions)
    #>    demography_group compartment time    value
    #> 1:           [0,20)  infectious  324 29117.39
    #> 2:          [20,40)  infectious  324 20627.33
    #> 3:              40+  infectious  322 13569.35

#### Interpretation

Interpretation Helpers:

- Overlapping School closure and Vaccinations can have an earlier peak
  of infectious across age groups by 100 days approx., and reduce the
  total number of new infections in the whole population by 75,000
  approx.
- Overlapping Mask mandate and School closure can delay the peak of
  infectious across age groups by 300 days approx., and reduce the total
  number of new infections in the whole population by 10,000 approx.
- Overlapping Mask mandate and Vaccination will not change the time of
  peak of infectious across age groups, but reduce the total number of
  new infections in the whole population by 70,000 approx.

### Additional challenge

1.  **What sequence of interventions would you propose to delay the peak
    and reduce the impact of the epidemic?** Experiment by independently
    adjusting the start time and duration of each intervention.
    Implement them either sequentially or with overlapping periods, and
    observe their effects on the epidemic dynamics in Zimbabwe. This can
    support a response plan that allows time for risk assessment and
    efficient resource allocation.

## Code

### Actiivty 1

``` r
# nolint start

# Practical 4
# Activity 1

# step: fill in your room number
room_number <- 3 #valid for all

# Load packages ----------------------------------------------------------
library(epidemics)
library(socialmixr)
library(tidyverse)

# Group parameters -------------------------------------------------------

# activity 1
# socialsurvey_link <- "https://doi.org/10.5281/zenodo.3874557" # polymod
# socialsurvey_link <- "https://doi.org/10.5281/zenodo.3874802" # vietnam
socialsurvey_link <- "https://doi.org/10.5281/zenodo.3886638" # zimbabwe
# socialsurvey_country <- "Italy"
# socialsurvey_country <- "Vietnam"
socialsurvey_country <- "Zimbabwe"
age_limits <- c(0, 20, 40)
infectious_population <- 1 / 1e6 # 1 infectious out of 1,000,000

basic_reproduction_number <- 1.46
pre_infectious_period <- 3 # days
infectious_period <- 7 # days


# (1) Contact matrix ------------------------------------------------------

# step: paste the survey link for your room
socialsurvey <- socialmixr::get_survey(
  survey = socialsurvey_link
)

# step: generate contact matrix by defining
# survey class object, country name, 
# age limits, and whether to make a symmetric matrix
contact_data <- socialmixr::contact_matrix(
  survey = socialsurvey,
  countries = socialsurvey_country,
  age.limits = age_limits,
  symmetric = TRUE
)

contact_data

# Matrix are symmetric for the total number of contacts
# of one group with another is the same as the reverse
contact_data$matrix * contact_data$demography$proportion

# Prepare contact matrix
# {socialmixr} provides contacts from-to
# {epidemics} expects contacts to-from
socialcontact_matrix <- t(contact_data$matrix)

socialcontact_matrix

# (2) Initial conditions --------------------------------------------------

## Infectious population ---------

# step: add the proportion of infectious 
# as given in table of parameter
initial_i <- infectious_population

initial_conditions_inf <- c(
  S = 1 - initial_i,
  E = 0,
  I = initial_i,
  R = 0,
  V = 0
)

initial_conditions_inf

## Free of infection population ---------

initial_conditions_free <- c(
  S = 1,
  E = 0,
  I = 0,
  R = 0,
  V = 0
)

initial_conditions_free

## Combine initial conditions ------------

# step: Combine the initial conditions
# add initial_conditions_inf or initial_conditions_free
# to the each age group as given in table of parameter
initial_conditions <- base::rbind(
  initial_conditions_free, # age group 1
  initial_conditions_inf, # age group 2
  initial_conditions_free # age group 3
)

# Use contact matrix to assign age group names
rownames(initial_conditions) <- rownames(socialcontact_matrix)

initial_conditions

# (3) Population structure ------------------------------------------------

# Prepare the demography vector
demography_vector <- contact_data$demography$population
names(demography_vector) <- rownames(socialcontact_matrix)

# step: Prepare the population to model as affected by the epidemic
# add the name of the country, 
# the symmetric and transposed contact matrix,
# the vector with the population size of each age group
# the binded matrix with initial conditions for each age group
population_object <- epidemics::population(
  name = socialsurvey_country,
  contact_matrix = socialcontact_matrix,
  demography_vector = demography_vector,
  initial_conditions = initial_conditions
)

population_object

# (4) Model parameters ----------------------------------------------------

# step: Rates
# add the values from the parameters table
infectiousness_rate <- 1 / pre_infectious_period # 1/pre-infectious period
recovery_rate <- 1 / infectious_period # 1/infectious period
transmission_rate <- recovery_rate * basic_reproduction_number # recovery rate * R0


# (5) Run the model --------------------------------------------------------

# step: in each function argument add
# the population object
# each of the previously defined rates
# the total simulation time as given in table of parameter
simulate_baseline <- epidemics::model_default(
  # population
  population = population_object,
  # parameters
  transmission_rate = transmission_rate,
  infectiousness_rate = infectiousness_rate,
  recovery_rate = recovery_rate,
  # time setup
  time_end = 1000, # increase if needed
  increment = 1.0
)

simulate_baseline


# Plot all compartments --------------------------------------------------

# step: paste plot and table output in report

simulate_baseline %>%
  ggplot(aes(
    x = time,
    y = value,
    color = compartment,
    linetype = demography_group
  )) +
  geom_line() +
  scale_y_continuous(
    breaks = scales::breaks_pretty(n = 10),
    labels = scales::comma
  )

epidemics::epidemic_peak(data = simulate_baseline)


# Plot new infections ----------------------------------------------------

# step: paste plot output in report

# New infections
newinfections_bygroup <- epidemics::new_infections(data = simulate_baseline)

# Visualize the spread of the epidemic in terms of new infections
newinfections_bygroup %>%
  ggplot(aes(time, new_infections, colour = demography_group)) +
  geom_line() +
  scale_y_continuous(
    breaks = scales::breaks_pretty(n = 10),
    labels = scales::comma
  )

# nolint end
```

### Actiivty 2

``` r
# nolint start

# Practical 4
# Activity 2

# step: fill in your room number
room_number <- 1 #valid for all

# Group parameters -------------------------------------------------------

# activity 2/3
intervention_begin <- 200 # change (e.g., range 100-200)
intervention_duration <- 250 # change (e.g., range 150-250)


# * ----------------------------------------------------------------------
# Intervention 1 ---------------------------------------------------------
# * ----------------------------------------------------------------------


# Non-pharmaceutical interventions 
# on contacts 
# school closure 

rownames(socialcontact_matrix)

# step: create the intervention object:
# identify if you need to keep: 
# epidemics::intervention() or epidemics::vaccination()
# then add:
# - name of the intervention
# - type of intervention ("rate" or "contacts"), if needed
# - time when the intervention begins and ends (as values or matrix*)
# as given in table of inputs
# - reduction or vaccination rate (as values or matrix*)
# *if matrix, values follow same order as in the social contact matrix
test_intervention <- epidemics::intervention(
  name = "School closure",
  type = "contacts",
  time_begin = intervention_begin,
  time_end = intervention_begin + intervention_duration,
  reduction = matrix(c(0.5, 0.01, 0.01))
)

test_intervention

# Run {epidemics} ---------------------------------------------------------

# step: add the intervention argument
# as a list (for interventions against contacts or transmission rate) 
# or as an object (for vaccination)
simulate_intervention <- epidemics::model_default(
  population = population_object,
  transmission_rate = transmission_rate,
  infectiousness_rate = infectiousness_rate,
  recovery_rate = recovery_rate,
  # intervention
  intervention = list(contacts = test_intervention),
  time_end = 1000,
  increment = 1.0
)

simulate_intervention

# Plot all compartments --------------------------------------------------

# step: paste plot and table output in report

simulate_intervention %>%
  ggplot(aes(
    x = time,
    y = value,
    color = compartment,
    linetype = demography_group
  )) +
  geom_line() +
  geom_vline(
    xintercept = c(test_intervention$time_begin, test_intervention$time_end),
    linetype = "dashed",
    linewidth = 0.2
  ) +
  scale_y_continuous(
    breaks = scales::breaks_pretty(n = 10),
    labels = scales::comma
  )

epidemics::epidemic_peak(data = simulate_intervention)

# Visualize effect --------------------------------------------------------
# Plot new infections 

# step: 
# add intervention name
# if your intervention is vaccination, then
# activate the argument exclude_compartments
# run and paste plot output in report

infections_baseline <- epidemics::new_infections(
  data = simulate_baseline,
  # exclude_compartments = "vaccinated", # if vaccination
  by_group = FALSE # if TRUE, then age-stratified output
)

infections_intervention <- epidemics::new_infections(
  data = simulate_intervention,
  # exclude_compartments = "vaccinated", # if vaccination
  by_group = FALSE # if TRUE, then age-stratified output
)

# Assign scenario names
infections_baseline$scenario <- "Baseline"
infections_intervention$scenario <- "School closure"

# Combine the data from both scenarios
infections_baseline_intervention <- dplyr::bind_rows(infections_baseline, infections_intervention)

infections_baseline_intervention %>%
  ggplot(aes(
    x = time,
    y = new_infections,
    colour = scenario,
    # linetype = demography_group # if by_group = TRUE
  )) +
  geom_line() +
  geom_vline(
    xintercept = c(test_intervention$time_begin, test_intervention$time_end),
    linetype = "dashed",
    linewidth = 0.2
  ) +
  scale_y_continuous(labels = scales::comma)

# save intervention object
intervention_schoolclosure <- test_intervention
infections_schoolclosure <- infections_intervention


# * ----------------------------------------------------------------------
# Intervention 2 ---------------------------------------------------------
# * ----------------------------------------------------------------------


# Non-pharmaceutical interventions 
# on transmission
# mask mandate

rownames(socialcontact_matrix)

test_intervention <- epidemics::intervention(
  name = "mask mandate",
  type = "rate",
  time_begin = intervention_begin,
  time_end = intervention_begin + intervention_duration,
  reduction = 0.163
)

test_intervention

# Run {epidemics} ---------------------------------------------------------

simulate_intervention <- epidemics::model_default(
  population = population_object,
  transmission_rate = transmission_rate,
  infectiousness_rate = infectiousness_rate,
  recovery_rate = recovery_rate,
  # intervention
  intervention = list(transmission_rate = test_intervention),
  time_end = 1000,
  increment = 1.0
)

simulate_intervention

# Plot all compartments --------------------------------------------------

simulate_intervention %>%
  ggplot(aes(
    x = time,
    y = value,
    color = compartment,
    linetype = demography_group
  )) +
  geom_line() +
  geom_vline(
    xintercept = c(test_intervention$time_begin, test_intervention$time_end),
    linetype = "dashed",
    linewidth = 0.2
  ) +
  scale_y_continuous(
    breaks = scales::breaks_pretty(n = 10),
    labels = scales::comma
  )

epidemics::epidemic_peak(data = simulate_intervention)

# Visualize effect --------------------------------------------------------
# Plot new infections 

infections_baseline <- epidemics::new_infections(
  data = simulate_baseline,
  # exclude_compartments = "vaccinated", # if vaccination
  by_group = FALSE # if TRUE, then age-stratified output
)

infections_intervention <- epidemics::new_infections(
  data = simulate_intervention,
  # exclude_compartments = "vaccinated", # if vaccination
  by_group = FALSE # if TRUE, then age-stratified output
)

# Assign scenario names
infections_baseline$scenario <- "Baseline"
infections_intervention$scenario <- "Mask mandate"

# Combine the data from both scenarios
infections_baseline_intervention <- dplyr::bind_rows(infections_baseline, infections_intervention)

infections_baseline_intervention %>%
  ggplot(aes(
    x = time,
    y = new_infections,
    colour = scenario,
    # linetype = demography_group # if by_group = TRUE
  )) +
  geom_line() +
  geom_vline(
    xintercept = c(test_intervention$time_begin, test_intervention$time_end),
    linetype = "dashed",
    linewidth = 0.2
  ) +
  scale_y_continuous(labels = scales::comma)

# save intervention object
intervention_mask_mandate <- test_intervention
infections_mask_mandate <- infections_intervention


# * ----------------------------------------------------------------------
# Intervention 3 ---------------------------------------------------------
# * ----------------------------------------------------------------------


# Pharmaceutical interventions 
# Vaccination

rownames(socialcontact_matrix)

test_intervention <- epidemics::vaccination(
  name = "vaccinate all",
  time_begin = matrix(intervention_begin, nrow(socialcontact_matrix)),
  time_end = matrix(intervention_begin + intervention_duration, nrow(socialcontact_matrix)),
  nu = matrix(c(0.001, 0.001, 0.001))
)

test_intervention

# Run {epidemics} ---------------------------------------------------------

simulate_intervention <- epidemics::model_default(
  population = population_object,
  transmission_rate = transmission_rate,
  infectiousness_rate = infectiousness_rate,
  recovery_rate = recovery_rate,
  # intervention
  vaccination = test_intervention,
  time_end = 1000,
  increment = 1.0
)

simulate_intervention

# Plot all compartments --------------------------------------------------

simulate_intervention %>%
  ggplot(aes(
    x = time,
    y = value,
    color = compartment,
    linetype = demography_group
  )) +
  geom_line() +
  geom_vline(
    xintercept = c(test_intervention$time_begin, test_intervention$time_end),
    linetype = "dashed",
    linewidth = 0.2
  ) +
  scale_y_continuous(
    breaks = scales::breaks_pretty(n = 10),
    labels = scales::comma
  )

epidemics::epidemic_peak(data = simulate_intervention)

# Visualize effect --------------------------------------------------------
# Plot new infections 

infections_baseline <- epidemics::new_infections(
  data = simulate_baseline,
  exclude_compartments = "vaccinated", # if vaccination
  by_group = FALSE # if TRUE, then age-stratified output
)

infections_intervention <- epidemics::new_infections(
  data = simulate_intervention,
  exclude_compartments = "vaccinated", # if vaccination
  by_group = FALSE # if TRUE, then age-stratified output
)

# Assign scenario names
infections_baseline$scenario <- "Baseline"
infections_intervention$scenario <- "Vaccination"

# Combine the data from both scenarios
infections_baseline_intervention <- dplyr::bind_rows(infections_baseline, infections_intervention)

infections_baseline_intervention %>%
  ggplot(aes(
    x = time,
    y = new_infections,
    colour = scenario,
    # linetype = demography_group # if by_group = TRUE
  )) +
  geom_line() +
  geom_vline(
    xintercept = c(test_intervention$time_begin, test_intervention$time_end),
    linetype = "dashed",
    linewidth = 0.2
  ) +
  scale_y_continuous(labels = scales::comma)

# save intervention object
intervention_vaccinate <- test_intervention
infections_vaccinate <- infections_intervention

# nolint end
```

### Actiivty 3

``` r
# nolint start

# Practical 4
# Activity 3

# step: fill in your room number
room_number <- 1 # valid for all, account by specific changes

# Combine interventions --------------------------------------------------

#step: complete the intervention or vaccination arguments
simulate_twointerventions <- epidemics::model_default(
  population = population_object,
  transmission_rate = transmission_rate,
  infectiousness_rate = infectiousness_rate,
  recovery_rate = recovery_rate,
  # Intervention
  intervention = list(
    # transmission_rate = intervention_mask_mandate#, #<CHANGE-BY-ROOM>
    contacts = intervention_schoolclosure #<CHANGE-BY-ROOM>
  ),
  vaccination = intervention_vaccinate, #<CHANGE-BY-ROOM>
  time_end = 1000,
  increment = 1.0
)

# step: paste table output in report
epidemics::epidemic_peak(simulate_twointerventions)

# Visualize effect --------------------------------------------------------
# Plot new infections 

# step: 
# add intervention name
# if your intervention is vaccination, then
# activate the argument exclude_compartments
# run and paste plot output in report

infections_baseline <- epidemics::new_infections(
  data = simulate_baseline,
  exclude_compartments = "vaccinated", # if vaccination #<CHANGE-BY-ROOM>
  by_group = FALSE # if TRUE, then age-stratified output
)

infections_twointerventions <- epidemics::new_infections(
  data = simulate_twointerventions,
  exclude_compartments = "vaccinated", # if vaccination #<CHANGE-BY-ROOM>
  by_group = FALSE # if TRUE, then age-stratified output
)

# Assign scenario names
infections_baseline$scenario <- "Baseline"
infections_twointerventions$scenario <- "School closure + Vaccination" #<CHANGE-BY-ROOM>
# infections_twointerventions$scenario <- "Mask mandate + School closure" #<CHANGE-BY-ROOM>
# infections_twointerventions$scenario <- "Mask mandate + Vaccination" #<CHANGE-BY-ROOM>

# Compare interventions --------------------------------------------------

# Combine the data from all scenarios
compare_interventions <- dplyr::bind_rows(
  infections_baseline,
  infections_schoolclosure, #<CHANGE-BY-ROOM>
  # infections_mask_mandate, #<CHANGE-BY-ROOM>
  # infections_vaccinate, #<CHANGE-BY-ROOM>
  infections_twointerventions
)

compare_interventions %>%
  ggplot(aes(x = time, y = new_infections, colour = scenario)) +
  geom_line() +
  scale_y_continuous(labels = scales::comma) +
  labs(
    x = "Simulation time (days)",
    y = "New infections",
    colour = "Scenario"
  )

# nolint end
```

# Continue your learning path

<!-- Suggest learners to Epiverse-TRACE documentation or external resources --->

{epidemics} vignette on seasonality and disease-specific model
structures (compartments and parameters)

- <https://epiverse-trace.github.io/epidemics/dev/articles/>

# end
