library(epiparameter)

# ebola serial interval
ebola_serial <-
  epiparameter::epiparameter_db(
    disease = "ebola",
    epi_name = "serial",
    single_epiparameter = TRUE
  )

# get the sd
ebola_serial$summary_stats$sd

# get the sample_size
ebola_serial$metadata$sample_size