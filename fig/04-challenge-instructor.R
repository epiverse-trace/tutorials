library(socialmixr)

# Access the contact survey data from Zenodo
zambia_sa_survey <- socialmixr::get_survey(
  "https://doi.org/10.5281/zenodo.3874675"
)

# Inspect the countries within the survey object
levels(zambia_sa_survey$participants$country)

# Generate the contact matrix for Zambia only
contact_data_zambia <- socialmixr::contact_matrix(
  survey = zambia_sa_survey,
  countries = "Zambia", # key argument
  age.limits = c(0, 20),
  symmetric = TRUE
)

# Print the contact matrix for Zambia only
contact_data_zambia

# Print the vector of population size for {epidemics}
contact_data_zambia$demography$population
