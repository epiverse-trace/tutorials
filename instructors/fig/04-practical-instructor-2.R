# nolint start

# Practical 4
# Activity 2

# step: fill in your room number
room_number <- 1 #valid for all

# Group parameters -------------------------------------------------------

# activity 2/3
intervention_begin <- 200 # change (e.g., range 100-200)
intervention_duration <- 250 # change (e.g., range 150-250)


# * ----------------------------------------------------------------------
# Intervention 1 ---------------------------------------------------------
# * ----------------------------------------------------------------------


# Non-pharmaceutical interventions 
# on contacts 
# school closure 

rownames(socialcontact_matrix)

# step: create the intervention object:
# identify if you need to keep: 
# epidemics::intervention() or epidemics::vaccination()
# then add:
# - name of the intervention
# - type of intervention ("rate" or "contacts"), if needed
# - time when the intervention begins and ends (as values or matrix*)
# as given in table of inputs
# - reduction or vaccination rate (as values or matrix*)
# *if matrix, values follow same order as in the social contact matrix
test_intervention <- epidemics::intervention(
  name = "School closure",
  type = "contacts",
  time_begin = intervention_begin,
  time_end = intervention_begin + intervention_duration,
  reduction = matrix(c(0.5, 0.01, 0.01))
)

test_intervention

# Run {epidemics} ---------------------------------------------------------

# step: add the intervention argument
# as a list (for interventions against contacts or transmission rate) 
# or as an object (for vaccination)
simulate_intervention <- epidemics::model_default(
  population = population_object,
  transmission_rate = transmission_rate,
  infectiousness_rate = infectiousness_rate,
  recovery_rate = recovery_rate,
  # intervention
  intervention = list(contacts = test_intervention),
  time_end = 1000,
  increment = 1.0
)

simulate_intervention

# Plot all compartments --------------------------------------------------

# step: paste plot and table output in report

simulate_intervention %>%
  ggplot(aes(
    x = time,
    y = value,
    color = compartment,
    linetype = demography_group
  )) +
  geom_line() +
  geom_vline(
    xintercept = c(test_intervention$time_begin, test_intervention$time_end),
    linetype = "dashed",
    linewidth = 0.2
  ) +
  scale_y_continuous(
    breaks = scales::breaks_pretty(n = 10),
    labels = scales::comma
  )

epidemics::epidemic_peak(data = simulate_intervention)

# Visualize effect --------------------------------------------------------
# Plot new infections 

# step: 
# add intervention name
# if your intervention is vaccination, then
# activate the argument compartments_from_susceptible
# run and paste plot output in report

infections_baseline <- epidemics::new_infections(
  data = simulate_baseline,
  # compartments_from_susceptible = "vaccinated", # if vaccination
  by_group = FALSE # if TRUE, then age-stratified output
)

infections_intervention <- epidemics::new_infections(
  data = simulate_intervention,
  # compartments_from_susceptible = "vaccinated", # if vaccination
  by_group = FALSE # if TRUE, then age-stratified output
)

# Assign scenario names
infections_baseline$scenario <- "Baseline"
infections_intervention$scenario <- "School closure"

# Combine the data from both scenarios
infections_baseline_intervention <- dplyr::bind_rows(infections_baseline, infections_intervention)

infections_baseline_intervention %>%
  ggplot(aes(
    x = time,
    y = new_infections,
    colour = scenario,
    # linetype = demography_group # if by_group = TRUE
  )) +
  geom_line() +
  geom_vline(
    xintercept = c(test_intervention$time_begin, test_intervention$time_end),
    linetype = "dashed",
    linewidth = 0.2
  ) +
  scale_y_continuous(labels = scales::comma)

# save intervention object
intervention_schoolclosure <- test_intervention
infections_schoolclosure <- infections_intervention


# * ----------------------------------------------------------------------
# Intervention 2 ---------------------------------------------------------
# * ----------------------------------------------------------------------


# Non-pharmaceutical interventions 
# on transmission
# mask mandate

rownames(socialcontact_matrix)

test_intervention <- epidemics::intervention(
  name = "mask mandate",
  type = "rate",
  time_begin = intervention_begin,
  time_end = intervention_begin + intervention_duration,
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
  time_end = 1000,
  increment = 1.0
)

simulate_intervention

# Plot all compartments --------------------------------------------------

simulate_intervention %>%
  ggplot(aes(
    x = time,
    y = value,
    color = compartment,
    linetype = demography_group
  )) +
  geom_line() +
  geom_vline(
    xintercept = c(test_intervention$time_begin, test_intervention$time_end),
    linetype = "dashed",
    linewidth = 0.2
  ) +
  scale_y_continuous(
    breaks = scales::breaks_pretty(n = 10),
    labels = scales::comma
  )

epidemics::epidemic_peak(data = simulate_intervention)

# Visualize effect --------------------------------------------------------
# Plot new infections 

infections_baseline <- epidemics::new_infections(
  data = simulate_baseline,
  # compartments_from_susceptible = "vaccinated", # if vaccination
  by_group = FALSE # if TRUE, then age-stratified output
)

infections_intervention <- epidemics::new_infections(
  data = simulate_intervention,
  # compartments_from_susceptible = "vaccinated", # if vaccination
  by_group = FALSE # if TRUE, then age-stratified output
)

# Assign scenario names
infections_baseline$scenario <- "Baseline"
infections_intervention$scenario <- "Mask mandate"

# Combine the data from both scenarios
infections_baseline_intervention <- dplyr::bind_rows(infections_baseline, infections_intervention)

infections_baseline_intervention %>%
  ggplot(aes(
    x = time,
    y = new_infections,
    colour = scenario,
    # linetype = demography_group # if by_group = TRUE
  )) +
  geom_line() +
  geom_vline(
    xintercept = c(test_intervention$time_begin, test_intervention$time_end),
    linetype = "dashed",
    linewidth = 0.2
  ) +
  scale_y_continuous(labels = scales::comma)

# save intervention object
intervention_mask_mandate <- test_intervention
infections_mask_mandate <- infections_intervention


# * ----------------------------------------------------------------------
# Intervention 3 ---------------------------------------------------------
# * ----------------------------------------------------------------------


# Pharmaceutical interventions 
# Vaccination

rownames(socialcontact_matrix)

test_intervention <- epidemics::vaccination(
  name = "vaccinate all",
  time_begin = matrix(intervention_begin, nrow(socialcontact_matrix)),
  time_end = matrix(intervention_begin + intervention_duration, nrow(socialcontact_matrix)),
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
  time_end = 1000,
  increment = 1.0
)

simulate_intervention

# Plot all compartments --------------------------------------------------

simulate_intervention %>%
  ggplot(aes(
    x = time,
    y = value,
    color = compartment,
    linetype = demography_group
  )) +
  geom_line() +
  geom_vline(
    xintercept = c(test_intervention$time_begin, test_intervention$time_end),
    linetype = "dashed",
    linewidth = 0.2
  ) +
  scale_y_continuous(
    breaks = scales::breaks_pretty(n = 10),
    labels = scales::comma
  )

epidemics::epidemic_peak(data = simulate_intervention)

# Visualize effect --------------------------------------------------------
# Plot new infections 

infections_baseline <- epidemics::new_infections(
  data = simulate_baseline,
  compartments_from_susceptible = "vaccinated", # if vaccination
  by_group = FALSE # if TRUE, then age-stratified output
)

infections_intervention <- epidemics::new_infections(
  data = simulate_intervention,
  compartments_from_susceptible = "vaccinated", # if vaccination
  by_group = FALSE # if TRUE, then age-stratified output
)

# Assign scenario names
infections_baseline$scenario <- "Baseline"
infections_intervention$scenario <- "Vaccination"

# Combine the data from both scenarios
infections_baseline_intervention <- dplyr::bind_rows(infections_baseline, infections_intervention)

infections_baseline_intervention %>%
  ggplot(aes(
    x = time,
    y = new_infections,
    colour = scenario,
    # linetype = demography_group # if by_group = TRUE
  )) +
  geom_line() +
  geom_vline(
    xintercept = c(test_intervention$time_begin, test_intervention$time_end),
    linetype = "dashed",
    linewidth = 0.2
  ) +
  scale_y_continuous(labels = scales::comma)

# save intervention object
intervention_vaccinate <- test_intervention
infections_vaccinate <- infections_intervention

# nolint end