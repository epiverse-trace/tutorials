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

## Activity 1: Generate disease trajectories of new infections

Generate disease trajectories of infectious subjects and new infections
using the following available inputs:

- Social contact matrix
- Age group of the infectious population
- Disease parameters (basic reproduction number, pre infectious period,
  infectious period)

As a group, Write your answers to these questions:

- What is the location (time) and size of epidemic peak for infectious
  subjects in each age group?
- What is the number of new infections at the epidemic peak?
- Change the basic reproduction number to 1.1 and 3. Are the changes in
  location (time) and size of the peak of new infections as expected?
  (based on the concept definition of reproduction number)
- Interpret: How would you communicate these results to a
  decision-maker?
- Compare: What differences do you identify from other group outputs?
  (if available)

### Inputs

| Group | Country  | Survey Link                              |
|-------|----------|------------------------------------------|
| 1     | Italy    | <https://doi.org/10.5281/zenodo.3874557> |
| 2     | Vietnam  | <https://doi.org/10.5281/zenodo.3874802> |
| 3     | Zimbabwe | <https://doi.org/10.5281/zenodo.3886638> |

| Parameter | Value | Notes |
|----|----|----|
| Age Limits | 0, 20, 40 | Age group cutoffs |
| Infectious Population | 1 / 1,000,000 | 1 infectious individual per million people |
| Basic Reproduction Number | 1.46 | R₀ value for influenza |
| Pre-infectious Period | 3 days | Incubation before becoming infectious |
| Infectious Period | 7 days | Duration of infectiousness |
| Max Timesteps (days) | 600 | Total simulation time |

### Solution

<!-- visible for instructors and learners after practical (solutions) -->

#### Outputs

| all compartments | new infections |
|----|----|
| ![image](https://hackmd.io/_uploads/r1o8OF_Rkx.png) | ![image](https://hackmd.io/_uploads/Syi1tY_R1x.png) |

    # Get epidemic_peak
    epidemics::epidemic_peak(data = simulate_baseline)
    # Output:
    #   demography_group compartment  time    value
    #             <char>      <char> <num>    <num>
    # 1:           [0,20)  infectious   320 513985.6
    # 2:          [20,40)  infectious   328 560947.2
    # 3:              40+  infectious   329 932989.6

#### Interpretation

Interpretation template:

- In the population, the demographic group of `age from [0,20]` has a
  peak of infectious subjects at day 320 with a size of `513,986`.

Interpretation Helpers:

| R = 1.1 | R = 3 |
|----|----|
| ![image](https://hackmd.io/_uploads/H1UupFOAyl.png) | ![image](https://hackmd.io/_uploads/ryVoat_R1l.png) |

- An epidemic with R=1.1 has a days delayed and smaller outbreak based
  on number of infections (day 1200, 9000 new infections), compared with
  R=3 with a earlier and higher peak than R = 1.5 (day 100, 1,000,000
  new infections).

| Vietnam | Zimbabwe |
|----|----|
| ![image](https://hackmd.io/_uploads/BkZGRY_Rkx.png) | ![image](https://hackmd.io/_uploads/SJVlkcORkl.png) |

- Population structure from Italy, Vietnam, and Zimbabwe influences the
  progression of the transmission in each population.

## Activity 2: Compare interventions

Compare the disease trajectories of new infections against an
intervention using the following available inputs:

- Time to start the intervention
- Duration of the intervention
- Type of intervention (on contacts, on transmission, or vaccination)
- Reduction effect or rate of vaccination

As a group, write your answers to these questions:

- How does the time to start of the intervention (early/late) impact the
  timing and size of the peak of new infectious individuals?
- Is the observed impact of the intervention in these results expected?
- Interpret: How would you communicate these results to a
  decision-maker?
- Compare: What differences do you identify from other group outputs?
  (if available)

### Inputs

| Group | Intervention | Early Start | Late Start | Duration (days) | Effect (Reduction or Rate) |
|----|----|----|----|----|----|
| 1 | School | 100 | 200 | 100 | Age 0–19: 0.5; Age 20+: 0.01 |
| 2 | Mask | 100 | 200 | 200 | All ages: 0.163 |
| 3 | Vaccine | 100 | 200 | 150 | All ages: 0.001 |

### Solution

<!-- visible for instructors and learners after practical (solutions) -->

#### Outputs

| Intervention | Early start | Late start |
|----|----|----|
| **School Closure** | ![image](https://hackmd.io/_uploads/H1IKxq_A1e.png) | ![image](https://hackmd.io/_uploads/rJt8ttdA1e.png) |
| **Mask Mandate** | ![image](https://hackmd.io/_uploads/rkV2ttO0yx.png) | ![image](https://hackmd.io/_uploads/Bk8wKYOR1l.png) |
| **Vaccination** | ![image](https://hackmd.io/_uploads/rycdKYOA1e.png) | ![image](https://hackmd.io/_uploads/B1ff-9_Ckl.png) |

#### Interpretation

Interpretation Helpers:

- School closure with short duration can delay the peak of new
  infections, but this will keep the same size.
- Mask mandate of 200 days during the time of the epidemic peak can
  delay and reduce the size of new infections.
- Vaccinations earlier in time will have a higher impact in reducing the
  size of the epidemic peak and extending its delay. Note that the
  effectiveness of vaccination can depend on various factors, including
  vaccine efficacy and timing relative to the outbreak.

## Activity 3: Combine interventions

Combine two intervention in the same simulation and compare the disease
trajectories of new infections against the baseline or only one
intervention. Use the intervention parameters above.

As a group, Write your answers to these questions:

- Interpret: How would you communicate these results to a
  decision-maker?
- Compare: What differences do you identify from other group outputs?
  (if available)

### Inputs

| Group | Combine interventions           | Compare against |
|-------|---------------------------------|-----------------|
| 1     | School closure AND Vaccine      | School closure  |
| 2     | Mask mandate AND School contact | Mask mandate    |
| 3     | Vaccine AND Mask mandate        | Vaccine         |

### Solution

<!-- visible for instructors and learners after practical (solutions) -->

#### Outputs

| Combine interventions | Compare interventions |
|----|----|
| ![image](https://hackmd.io/_uploads/rk9cqK_CJe.png) | ![image](https://hackmd.io/_uploads/BJro5KuC1e.png) |

#### Interpretation

Interpretation Helpers:

- The combination of school closure and mask mandate can delay the
  epidemic peak, but will not reduce it size.
- Vaccination can sustain a reduced epidemic peak compared with mask
  mandate alone.

#### Code

``` r
# nolint start

# Practical 4
# Activity 1

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

socialmixr::list_surveys()

socialsurvey <- socialmixr::get_survey(
  survey = socialsurvey_link
)

contact_data <- socialmixr::contact_matrix(
  survey = socialsurvey,
  countries = socialsurvey_country,
  age.limits = age_limits,
  symmetric = TRUE
)

# Prepare contact matrix
socialcontact_matrix <- t(contact_data$matrix)

# (2) Initial conditions --------------------------------------------------

## Infectious population ---------
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

# Combine the initial conditions
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

# Prepare the population to model as affected by the epidemic
population_object <- epidemics::population(
  name = socialsurvey_country,
  contact_matrix = socialcontact_matrix,
  demography_vector = demography_vector,
  initial_conditions = initial_conditions
)

population_object

# (4) Model parameters ----------------------------------------------------

# Rates
infectiousness_rate <- 1 / pre_infectious_period # 1/pre-infectious period
recovery_rate <- 1 / infectious_period # 1/infectious period
transmission_rate <- recovery_rate * basic_reproduction_number # recovery rate * R0


# (5) Run the model --------------------------------------------------------

simulate_baseline <- epidemics::model_default(
  # population
  population = population_object,
  # parameters
  transmission_rate = transmission_rate,
  infectiousness_rate = infectiousness_rate,
  recovery_rate = recovery_rate,
  # time setup
  time_end = 600,
  increment = 1.0
)

simulate_baseline


# Plot all compartments --------------------------------------------------

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
epidemics::epidemic_size(data = simulate_baseline)


# Plot new infections ----------------------------------------------------

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

``` r
# nolint start

# Practical 4
# Activity 2

# Group parameters -------------------------------------------------------

# activity 2/3
# school_begin_early <- 100
school_begin_late <- 200
# mask_begin_early <- 100
mask_begin_late <- 200
vaccine_begin_early <- 100
# vaccine_begin_late <- 200


# Intervention 1 ---------------------------------------------------------

# Non-pharmaceutical interventions 
# on contacts 
# school closure 

rownames(socialcontact_matrix)

test_intervention <- epidemics::intervention(
  name = "School closure",
  type = "contacts",
  time_begin = school_begin_late,
  time_end = school_begin_late + 100,
  reduction = matrix(c(0.5, 0.01, 0.01))
)

test_intervention

# Run {epidemics} ---------------------------------------------------------

simulate_intervention <- epidemics::model_default(
  population = population_object,
  transmission_rate = transmission_rate,
  infectiousness_rate = infectiousness_rate,
  recovery_rate = recovery_rate,
  # intervention
  intervention = list(contacts = test_intervention),
  time_end = 600,
  increment = 1.0
)

simulate_intervention

# Visualize effect --------------------------------------------------------

infections_baseline <- epidemics::new_infections(
  data = simulate_baseline,
  # compartments_from_susceptible = "vaccinated", # if vaccination
  by_group = FALSE
)

infections_intervention <- epidemics::new_infections(
  data = simulate_intervention,
  # compartments_from_susceptible = "vaccinated", # if vaccination
  by_group = FALSE
)

# Assign scenario names
infections_baseline$scenario <- "Baseline"
infections_intervention$scenario <- "School closure" #<COMPLETE>

# Combine the data from both scenarios
infections_baseline_intervention <- bind_rows(infections_baseline, infections_intervention)

infections_baseline_intervention %>%
  ggplot(aes(x = time, y = new_infections, colour = scenario)) +
  geom_line() +
  geom_vline(
    xintercept = c(simulate_intervention$time_begin, simulate_intervention$time_end),
    linetype = "dashed",
    linewidth = 0.2
  ) +
  scale_y_continuous(labels = scales::comma)

# save intervention object
intervention_schoolclosure <- test_intervention



# Intervention 2 ---------------------------------------------------------

# Non-pharmaceutical interventions 
# on transmission
# mask mandate

rownames(socialcontact_matrix)

test_intervention <- epidemics::intervention(
  name = "mask mandate",
  type = "rate",
  time_begin = mask_begin_late,
  time_end = mask_begin_late + 200,
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
  time_end = 600,
  increment = 1.0
)

simulate_intervention

# Visualize effect --------------------------------------------------------

infections_baseline <- epidemics::new_infections(
  data = simulate_baseline,
  # compartments_from_susceptible = "vaccinated", # if vaccination
  by_group = FALSE
)

infections_intervention <- epidemics::new_infections(
  data = simulate_intervention,
  # compartments_from_susceptible = "vaccinated", # if vaccination
  by_group = FALSE
)

# Assign scenario names
infections_baseline$scenario <- "Baseline"
infections_intervention$scenario <- "Mask mandate" #<COMPLETE>

# Combine the data from both scenarios
infections_baseline_intervention <- bind_rows(infections_baseline, infections_intervention)

infections_baseline_intervention %>%
  ggplot(aes(x = time, y = new_infections, colour = scenario)) +
  geom_line() +
  geom_vline(
    xintercept = c(simulate_intervention$time_begin, simulate_intervention$time_end),
    linetype = "dashed",
    linewidth = 0.2
  ) +
  scale_y_continuous(labels = scales::comma)

# save intervention object
intervention_mask_mandate <- test_intervention



# Intervention 3 ---------------------------------------------------------

# Pharmaceutical interventions 
# Vaccination

rownames(socialcontact_matrix)

test_intervention <- epidemics::vaccination(
  name = "vaccinate all",
  time_begin = matrix(vaccine_begin_early, nrow(socialcontact_matrix)),
  time_end = matrix(vaccine_begin_early + 150, nrow(socialcontact_matrix)),
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
  time_end = 600,
  increment = 1.0
)

simulate_intervention

# Visualize effect --------------------------------------------------------

infections_baseline <- epidemics::new_infections(
  data = simulate_baseline,
  compartments_from_susceptible = "vaccinated", # if vaccination
  by_group = FALSE
)

infections_intervention <- epidemics::new_infections(
  data = simulate_intervention,
  compartments_from_susceptible = "vaccinated", # if vaccination
  by_group = FALSE
)

# Assign scenario names
infections_baseline$scenario <- "Baseline"
infections_intervention$scenario <- "Mask mandate" #<COMPLETE>

# Combine the data from both scenarios
infections_baseline_intervention <- bind_rows(infections_baseline, infections_intervention)

infections_baseline_intervention %>%
  ggplot(aes(x = time, y = new_infections, colour = scenario)) +
  geom_line() +
  geom_vline(
    xintercept = c(simulate_intervention$time_begin, simulate_intervention$time_end),
    linetype = "dashed",
    linewidth = 0.2
  ) +
  scale_y_continuous(labels = scales::comma)

# save intervention object
intervention_vaccinate <- test_intervention

# nolint end
```

``` r
# nolint start

# Practical 4
# Activity 3

# Combine interventions --------------------------------------------------

simulate_twointerventions <- epidemics::model_default(
  population = population_object,
  transmission_rate = transmission_rate,
  infectiousness_rate = infectiousness_rate,
  recovery_rate = recovery_rate,
  # Intervention
  intervention = list(
    transmission_rate = intervention_mask_mandate,
    contacts = intervention_schoolclosure
  ),
  time_end = 600,
  increment = 1.0
)


# Visualize effect --------------------------------------------------------

infections_baseline <- epidemics::new_infections(
  data = simulate_baseline,
  by_group = FALSE
)

infections_twointerventions <- epidemics::new_infections(
  data = simulate_twointerventions,
  by_group = FALSE
)

# Assign scenario names
infections_baseline$scenario <- "Baseline"
infections_twointerventions$scenario <- "Mask mandate + School closure" #<COMPLETE>

# Combine the data from both scenarios
infections_baseline_twointerventions <- bind_rows(
  infections_baseline,
  infections_twointerventions
)

infections_baseline_twointerventions %>%
  ggplot(aes(x = time, y = new_infections, colour = scenario)) +
  geom_line() +
  scale_y_continuous(labels = scales::comma)


# Compare interventions --------------------------------------------------

compare_interventions <- bind_rows(
  infections_baseline,
  infections_baseline_intervention,
  infections_baseline_twointerventions
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
