library(contactsurveys)
library(socialmixr)
library(wpp2024)
library(tidyverse)

# Download and load the contact survey data for Zambia from Zenodo
survey_files_zambia <- contactsurveys::download_survey(
  survey = "https://doi.org/10.5281/zenodo.3874675",
  verbose = FALSE
)

survey_load_zambia <- socialmixr::load_survey(files = survey_files_zambia)

# Inspect the countries within the survey object
levels(survey_load_zambia$participants$country)

# Population structure to weight the contact matrix, from {wpp2024}
data(popAge1dt, package = "wpp2024")

zambia_pop <- popAge1dt %>%
  dplyr::filter(name == "Zambia", year == 2020) %>%
  dplyr::select(lower.age.limit = age, population = pop) %>%
  dplyr::mutate(population = population * 1000)

# Generate the contact matrix for Zambia only
contact_data_zambia <- socialmixr::contact_matrix(
  survey = survey_load_zambia,
  countries = "Zambia", # key argument
  age_limits = c(0, 20),
  symmetric = TRUE,
  survey_pop = zambia_pop
)

# Print the contact matrix for Zambia only
contact_data_zambia

# Print the vector of population size for {epidemics}
contact_data_zambia$demography$population
