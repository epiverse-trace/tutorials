# nolint start

# Practical 4
# Activity 1

# step: fill in your room number
room_number <- #<COMPLETE> replace with 1/2/3/4

# Load packages ----------------------------------------------------------
library(epidemics)
library(socialmixr)
library(tidyverse)


# (1) Contact matrix ------------------------------------------------------

# step: paste the survey link for your room
socialsurvey <- socialmixr::get_survey(
  #<COMPLETE>
)

# step: generate contact matrix by defining
# survey class object, country name, 
# age limits from table of parameters, 
# and whether to make a symmetric matrix
contact_data <- socialmixr::contact_matrix(
  #<COMPLETE>
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

# step: Combine the initial conditions
# add initial_conditions_inf or initial_conditions_free
# to the each age group as given in table of parameter
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

# step: Prepare the population to model as affected by the epidemic
# add the name of the country, 
# the symmetric and transposed contact matrix,
# the vector with the population size of each age group
# the binded matrix with initial conditions for each age group
population_object <- epidemics::population(
  #<COMPLETE>
)

population_object

# (4) Model parameters ----------------------------------------------------

# step: Rates
# add the values as given in table of parameter
infectiousness_rate <- 1 / #<COMPLETE> # 1/pre-infectious period
recovery_rate <- 1 / #<COMPLETE> # 1/infectious period
transmission_rate <- recovery_rate * #<COMPLETE> # recovery rate * R0


# (5) Run the model --------------------------------------------------------

# step: in each function argument add
# the population object
# each of the previously defined rates
# the total simulation time as given in table of parameter
simulate_baseline <- epidemics::model_default(
  #<COMPLETE>
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
