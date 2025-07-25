# nolint start

# Practical 4
# Activity 2

room_number <- 1 #valid for all

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
infections_intervention$scenario <- "School closure"

# Combine the data from both scenarios
infections_baseline_intervention <- bind_rows(infections_baseline, infections_intervention)

infections_baseline_intervention %>%
  ggplot(aes(x = time, y = new_infections, colour = scenario)) +
  geom_line() +
  geom_vline(
    xintercept = c(test_intervention$time_begin, test_intervention$time_end),
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
infections_intervention$scenario <- "Mask mandate"

# Combine the data from both scenarios
infections_baseline_intervention <- bind_rows(infections_baseline, infections_intervention)

infections_baseline_intervention %>%
  ggplot(aes(x = time, y = new_infections, colour = scenario)) +
  geom_line() +
  geom_vline(
    xintercept = c(test_intervention$time_begin, test_intervention$time_end),
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
infections_intervention$scenario <- "Vaccination"

# Combine the data from both scenarios
infections_baseline_intervention <- bind_rows(infections_baseline, infections_intervention)

infections_baseline_intervention %>%
  ggplot(aes(x = time, y = new_infections, colour = scenario)) +
  geom_line() +
  geom_vline(
    xintercept = c(test_intervention$time_begin, test_intervention$time_end),
    linetype = "dashed",
    linewidth = 0.2
  ) +
  scale_y_continuous(labels = scales::comma)

# save intervention object
intervention_vaccinate <- test_intervention

# nolint end