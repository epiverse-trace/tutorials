# nolint start

# Practical 4
# Activity 1

room_number <- #<COMPLETE> replace with 1/2/3/4

# Load packages ----------------------------------------------------------
library(epidemics)
library(socialmixr)
library(tidyverse)


# (1) Contact matrix ------------------------------------------------------

socialmixr::list_surveys()

socialsurvey <- socialmixr::get_survey(
  #<COMPLETE>
)

contact_data <- socialmixr::contact_matrix(
  #<COMPLETE>
)

# Prepare contact matrix
socialcontact_matrix <- t(contact_data$matrix)

# (2) Initial conditions --------------------------------------------------

## Infectious population ---------
initial_i <- #<COMPLETE>

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
  #<COMPLETE>, # age group 1
  #<COMPLETE>, # age group 2
  #<COMPLETE> # age group 3
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
  #<COMPLETE>
)

population_object

# (4) Model parameters ----------------------------------------------------

# Rates
infectiousness_rate <- 1 / #<COMPLETE> # 1/pre-infectious period
recovery_rate <- 1 / #<COMPLETE> # 1/infectious period
transmission_rate <- recovery_rate * #<COMPLETE> # recovery rate * R0


# (5) Run the model --------------------------------------------------------

simulate_baseline <- epidemics::model_default(
  #<COMPLETE>
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
