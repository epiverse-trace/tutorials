# nolint start

# Practical 4
# Activity 3

room_number <- #<COMPLETE> replace with 1/2/3/4

# Combine interventions --------------------------------------------------

simulate_twointerventions <- epidemics::model_default(
  population = population_object,
  transmission_rate = transmission_rate,
  infectiousness_rate = infectiousness_rate,
  recovery_rate = recovery_rate,
  # Intervention
  #<COMPLETE>
  time_end = 600,
  increment = 1.0
)


# Visualize effect --------------------------------------------------------
# Plot new infections 

infections_baseline <- epidemics::new_infections(
  data = simulate_baseline,
  by_group = FALSE
)

infections_twointerventions <- epidemics::new_infections(
  data = simulate_twointerventions,
  by_group = FALSE
)

# Assign scenario names
infections_baseline$scenario <- "Baseline"
infections_twointerventions$scenario <- "ADD intervention 1 + ADD intervention 2" #<COMPLETE>

# Combine the data from both scenarios
infections_baseline_twointerventions <- bind_rows(
  infections_baseline,
  infections_twointerventions
)

infections_baseline_twointerventions %>%
  ggplot(aes(x = time, y = new_infections, colour = scenario)) +
  geom_line() +
  scale_y_continuous(labels = scales::comma)


# Compare interventions --------------------------------------------------

compare_interventions <- bind_rows(
  infections_baseline,
  infections_intervention,
  infections_baseline_twointerventions
)

compare_interventions %>%
  ggplot(aes(x = time, y = new_infections, colour = scenario)) +
  geom_line() +
  scale_y_continuous(labels = scales::comma) +
  labs(
    x = "Simulation time (days)",
    y = "New infections",
    colour = "Scenario"
  )

# nolint end