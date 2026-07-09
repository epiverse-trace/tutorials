library(epiparameter)
library(EpiNow2)

# access epidemiological delays -------------------------------------------

# ebola serial interval
ebola_serial <-
  epiparameter::epiparameter_db(
    disease = "ebola",
    epi_name = "serial",
    single_epiparameter = TRUE
  )

# print distribution parameters
ebola_serial

# find maximum value
plot(ebola_serial)


# adapt parameters to EpiNow2 ---------------------------------------------

# add parameter values to distribution function
ebola_serial_epinow <- EpiNow2::Gamma(
  shape = epiparameter::get_parameters(ebola_serial)[1],
  scale = epiparameter::get_parameters(ebola_serial)[2],
  max = 40
)

# print output
ebola_serial_epinow

# plot epinow2 distribution
plot(ebola_serial_epinow)
