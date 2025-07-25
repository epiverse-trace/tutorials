# nolint start

# Practical 4
# Activity 1

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
