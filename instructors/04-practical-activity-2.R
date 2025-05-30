# nolint start

# Practical 4
# Activity 2

# Intervention ---------------------------------------------------------

rownames(socialcontact_matrix)

test_intervention <- epidemics::intervention(
  #<COMPLETE>
)

test_intervention

# Run {epidemics} ---------------------------------------------------------

simulate_intervention <- epidemics::model_default(
  population = population_object,
  transmission_rate = transmission_rate,
  infectiousness_rate = infectiousness_rate,
  recovery_rate = recovery_rate,
  # Intervention
  #<COMPLETE>,
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
infections_intervention$scenario <- "ADD Intervention Name" #<COMPLETE>

# Combine the data from both scenarios
infections_baseline_intervention <- bind_rows(infections_baseline, infections_intervention)

infections_baseline_intervention %>%
  ggplot(aes(x = time, y = new_infections, colour = scenario)) +
  geom_line() +
  geom_vline(
    xintercept = c(close_intervention$time_begin, close_intervention$time_end),
    linetype = "dashed",
    linewidth = 0.2
  ) +
  scale_y_continuous(labels = scales::comma)

# nolint end