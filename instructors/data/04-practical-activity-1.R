# nolint start

# Practical 4
# Activity 1

# Load packages ----------------------------------------------------------
library(epidemics)
library(socialmixr)
library(tidyverse)


# (1) contact matrix ------------------------------------------------------

socialmixr::list_surveys()

socialsurvey <- socialmixr::get_survey(
  #<COMPLETE>
)

contact_data <- socialmixr::contact_matrix(
  #<COMPLETE>
)

# prepare contact matrix
socialcontact_matrix <- t(contact_data$matrix)

# (2) initial conditions --------------------------------------------------

## infectious population ---------
initial_i <- #<COMPLETE>

initial_conditions_inf <- c(
  S = 1 - initial_i,
  E = 0,
  I = initial_i,
  R = 0,
  V = 0
)

initial_conditions_inf

## free of infection population ---------

initial_conditions_free <- c(
  S = 1,
  E = 0,
  I = 0,
  R = 0,
  V = 0
)

initial_conditions_free

## combine initial conditions ------------

# combine the initial conditions
initial_conditions <- base::rbind(
  #<COMPLETE>
)

# use contact matrix to assign age group names
rownames(initial_conditions) <- rownames(socialcontact_matrix)

initial_conditions

# (3) population structure ------------------------------------------------

# prepare the demography vector
demography_vector <- contact_data$demography$population
names(demography_vector) <- rownames(socialcontact_matrix)

# prepare the population to model as affected by the epidemic
population_object <- epidemics::population(
  #<COMPLETE>
)

population_object

# (4) model parameters ----------------------------------------------------

# rates
infectiousness_rate <- 1 / #<COMPLETE> # 1/pre-infectious period
recovery_rate <- 1 / #<COMPLETE> # 1/infectious period
transmission_rate <- recovery_rate * #<COMPLETE> # recovery rate * R0


# (5) run the model --------------------------------------------------------

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
epidemics::epidemic_size(data = simulate_baseline)


# Plot new infections ----------------------------------------------------

# new infections
newinfections_bygroup <- epidemics::new_infections(data = simulate_baseline)

# visualise the spread of the epidemic in terms of new infections
newinfections_bygroup %>%
  ggplot(aes(time, new_infections, colour = demography_group)) +
  geom_line() +
  scale_y_continuous(
    breaks = scales::breaks_pretty(n = 10),
    labels = scales::comma
  )

# nolint end
