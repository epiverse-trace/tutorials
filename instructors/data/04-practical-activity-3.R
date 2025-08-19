# nolint start

# Practical 4
# Activity 3

# step: fill in your room number
room_number <- #<COMPLETE> replace with 1/2/3/4

# Combine interventions --------------------------------------------------

#step: complete the intervention or vaccination arguments
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

# step: paste table output in report
epidemics::epidemic_peak(simulate_twointerventions)

# Visualize effect --------------------------------------------------------
# Plot new infections 

# step: 
# add intervention name
# if your intervention is vaccination, then
# activate the argument exclude_compartments
# run and paste plot output in report

infections_baseline <- epidemics::new_infections(
  data = simulate_baseline,
  # exclude_compartments = "vaccinated", # if vaccination
  by_group = FALSE # if TRUE, then age-stratified output
)

infections_twointerventions <- epidemics::new_infections(
  data = simulate_twointerventions,
  # exclude_compartments = "vaccinated", # if vaccination
  by_group = FALSE # if TRUE, then age-stratified output
)

# Assign scenario names
infections_baseline$scenario <- "Baseline"
infections_twointerventions$scenario <- "ADD intervention 1 + ADD intervention 2" #<COMPLETE>

# Compare interventions --------------------------------------------------

# Combine the data from both scenarios
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