# nolint start

# Practical 4
# Activity 3

# step: fill in your room number
room_number <- 1 # valid for all, account by specific changes

# Combine interventions --------------------------------------------------

#step: complete the intervention or vaccination arguments
simulate_twointerventions <- epidemics::model_default(
  population = population_object,
  transmission_rate = transmission_rate,
  infectiousness_rate = infectiousness_rate,
  recovery_rate = recovery_rate,
  # Intervention
  intervention = list(
    # transmission_rate = intervention_mask_mandate#, #<CHANGE-BY-ROOM>
    contacts = intervention_schoolclosure #<CHANGE-BY-ROOM>
  ),
  vaccination = intervention_vaccinate, #<CHANGE-BY-ROOM>
  time_end = 1000,
  increment = 1.0
)

# step: paste table output in report
epidemics::epidemic_peak(simulate_twointerventions)

# Visualize effect --------------------------------------------------------
# Plot new infections 

# step: 
# add intervention name
# if your intervention is vaccination, then
# activate the argument compartments_from_susceptible
# run and paste plot output in report

infections_baseline <- epidemics::new_infections(
  data = simulate_baseline,
  compartments_from_susceptible = "vaccinated", # if vaccination #<CHANGE-BY-ROOM>
  by_group = FALSE # if TRUE, then age-stratified output
)

infections_twointerventions <- epidemics::new_infections(
  data = simulate_twointerventions,
  compartments_from_susceptible = "vaccinated", # if vaccination #<CHANGE-BY-ROOM>
  by_group = FALSE # if TRUE, then age-stratified output
)

# Assign scenario names
infections_baseline$scenario <- "Baseline"
infections_twointerventions$scenario <- "School closure + Vaccination" #<CHANGE-BY-ROOM>
# infections_twointerventions$scenario <- "Mask mandate + School closure" #<CHANGE-BY-ROOM>
# infections_twointerventions$scenario <- "Mask mandate + Vaccination" #<CHANGE-BY-ROOM>

# Compare interventions --------------------------------------------------

# Combine the data from all scenarios
compare_interventions <- dplyr::bind_rows(
  infections_baseline,
  infections_schoolclosure, #<CHANGE-BY-ROOM>
  # infections_mask_mandate, #<CHANGE-BY-ROOM>
  # infections_vaccinate, #<CHANGE-BY-ROOM>
  infections_twointerventions
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