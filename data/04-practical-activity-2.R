# nolint start

# Practical 4
# Activity 2

# step: fill in your room number
room_number <- #<COMPLETE> replace with 1/2/3/4

# Intervention ---------------------------------------------------------

# note: all input parameters come from
# the table of parameters of the practical document
  
rownames(socialcontact_matrix)

# step: create the intervention object:
# 
# identify if you need to keep: 
# epidemics::intervention() or epidemics::vaccination()
#
# then add:
# - name of the intervention
# - type of intervention ("rate" or "contacts"), if needed
# - time when the intervention begins and ends (as values or matrix*)
# - reduction or vaccination rate (as values or matrix*)
# 
# *if matrix, values follow same order as in the social contact matrix
#  
test_intervention <- epidemics::intervention(#<COMPLETE>
)
# or
test_intervention <- epidemics::vaccination(#<COMPLETE>
)

test_intervention

# Run {epidemics} ---------------------------------------------------------

# step: add the intervention argument
# 
# as a list (for interventions against contacts or transmission rate) 
# or as an object (for vaccination)
# 
simulate_intervention <- epidemics::model_default(
  population = population_object,
  transmission_rate = transmission_rate,
  infectiousness_rate = infectiousness_rate,
  recovery_rate = recovery_rate,
  # Intervention
  #<COMPLETE>,
  time_end = 1000,
  increment = 1.0
)

simulate_intervention

# Plot all compartments --------------------------------------------------

# run: paste plot in report

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


# Peak of infectious -----------------------------------------------------

# run: paste table output in report

epidemics::epidemic_peak(data = simulate_intervention)

# Visualize effect --------------------------------------------------------
# Plot new infections 

# step: 
# - add intervention name
# - if your intervention is vaccination, then
# - activate the argument "exclude_compartments"
# - run and paste plot output in report

infections_baseline <- epidemics::new_infections(
  data = simulate_baseline,
  # exclude_compartments = "vaccinated", # if vaccination
  by_group = FALSE # if TRUE, then age-stratified output
)

infections_intervention <- epidemics::new_infections(
  data = simulate_intervention,
  # exclude_compartments = "vaccinated", # if vaccination
  by_group = FALSE # if TRUE, then age-stratified output
)

# Assign scenario names
infections_baseline$scenario <- "Baseline"
infections_intervention$scenario <- "ADD Intervention Name" #<COMPLETE>

# Combine the data from both scenarios
infections_baseline_intervention <- bind_rows(infections_baseline, infections_intervention)

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

# nolint end