# nolint start

# Practical 4
# Activity 1

# step: fill in your room number
room_number <- #<COMPLETE> replace with 1/2/3/4

# step: fill in your room's assigned country name
# note: must match the name used by both wpp2024::popAge1dt$name
# and socialmixr::contact_matrix()
country_name <- #<COMPLETE>

# Load packages ----------------------------------------------------------
library(epidemics)
library(contactsurveys)
library(socialmixr)
library(wpp2024)
library(tidyverse)


# (1) Contact matrix ------------------------------------------------------

# note: all input parameters come from
# the table of parameters of the practical document

# step: paste the survey link assigned to your room
# then run the function to download the social contact data
survey_files <- contactsurveys::download_survey(
  verbose = FALSE,
  survey = #<COMPLETE>
)

# run: load the downloaded survey files
socialsurvey <- socialmixr::load_survey(files = survey_files)

socialsurvey

# run: population structure to weight the contact matrix,
# from {wpp2024}, for your room's country
data(popAge1dt, package = "wpp2024")

country_pop <- popAge1dt %>%
  dplyr::filter(year == 2020, name == country_name) %>%
  dplyr::select(lower.age.limit = age, population = pop) %>%
  dplyr::mutate(population = population * 1000)

# step: generate the contact matrix by defining
# - the survey class object just loaded,
# - the country name,
# - the age limits, as in the table of parameters,
# - TRUE or FALSE to create a symmetric matrix, and
# - the population structure to weight it.
contact_data <- socialmixr::contact_matrix(
  survey = socialsurvey,
  countries = country_name,
  age_limits = #<COMPLETE>,
  symmetric = #<COMPLETE>,
  survey_pop = country_pop
)

contact_data

# run: confirm the symmetry of the matrix
# Matrix are symmetric for the total number of contacts.
# The total number of contacts from one group to another is the same in both directions.
# Check this by multiplying the mean contacts by the population size for each group.
contact_data$matrix * contact_data$demography$proportion

# run: Prepare contact matrix
#
# {epidemics} (from version 0.5.0) transposes the contact matrix
# internally, so pass it exactly as returned by {socialmixr}, with no t()
socialcontact_matrix <- contact_data$matrix

socialcontact_matrix

# (2) Initial conditions --------------------------------------------------

## Infectious population ---------

# step: add the proportion of infectious 
# as given in table of parameter
initial_i <- 1 / #<COMPLETE>

# run: create an infectious vector
initial_conditions_inf <- c(
  S = 1 - initial_i,
  E = 0,
  I = initial_i,
  R = 0,
  V = 0
)

initial_conditions_inf

## Free of infection population ---------

# run: create an infection-free vector
initial_conditions_free <- c(
  S = 1,
  E = 0,
  I = 0,
  R = 0,
  V = 0
)

initial_conditions_free

## Combine initial conditions ------------

# note: not all the population needs to be infectious.
# The epidemic can start with infecitous in a specific age range.

# step: Combine the initial conditions
# Add initial_conditions_inf or initial_conditions_free
# to the each age group as detailed in table of parameter
initial_conditions <- base::rbind(
  initial_conditions_free, # age group 1
  initial_conditions_inf, # age group 2
  initial_conditions_free # age group 3
)

# run: Use contact matrix to assign age group names
rownames(initial_conditions) <- rownames(socialcontact_matrix)

initial_conditions

# (3) Population structure ------------------------------------------------

# run: Prepare the demography vector
demography_vector <- contact_data$demography$population
names(demography_vector) <- rownames(socialcontact_matrix)

# step: Prepare the population to model as affected by the epidemic adding
# - the name of the country,
# - the symmetric contact matrix,
# - the vector with the population size of each age group
# - the binded matrix with initial conditions for each age group
population_object <- epidemics::population(
  name = country_name,
  contact_matrix = socialcontact_matrix,
  demography_vector = demography_vector,
  initial_conditions = initial_conditions
)

population_object

# (4) Model parameters ----------------------------------------------------

# step: define the disease-specific parameters: the rates
# add the values as given in table of parameter
infectiousness_rate <- 1 / #<COMPLETE> # 1/pre-infectious period
recovery_rate <- 1 / #<COMPLETE> # 1/infectious period
transmission_rate <- recovery_rate * #<COMPLETE> # recovery rate * R0


# (5) Run the model --------------------------------------------------------

# step: in each function argument add
# - the population object
# - each of the previously defined disease-specific rates
# - the total simulation time as given in table of parameter
simulate_baseline <- epidemics::model_default(
  population = population_object,
  transmission_rate = transmission_rate,
  infectiousness_rate = infectiousness_rate,
  recovery_rate = recovery_rate,
  time_end = #<COMPLETE>,
  increment = 1.0
)

simulate_baseline


# (6) Plot all compartments ------------------------------------------------

# run: paste plot in report

# plot with total number of individual per compartment
# at different points in time
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

# (7) Peak of infectious -------------------------------------------------

# run: paste table output in report

# table of epidemic peak size and time
# per demographic group
epidemics::epidemic_peak(data = simulate_baseline)


# (8) Plot new infections -------------------------------------------------

# run: paste plot output in report

# New infections per demographic group in time
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
