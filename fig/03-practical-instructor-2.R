# nolint start

# Practical 3
# Activity 2

# step: fill in your room number
room_number <- 1 #valid for all

# Load packages -----------------------------------------------------------
library(epiparameter)
library(epichains)
library(tidyverse)


# Set input parameters ---------------------------------------------------
# step: Paste the corresponding input parameter for this room.

known_basic_reproduction_number <- 0.8 #<DIFFERENT PER GROUP>
known_dispersion <- 0.01 #<DIFFERENT PER GROUP>
chain_to_observe <- 957 #<DIFFERENT PER GROUP>


# Set iteration parameters -----------------------------------------------
# step: Read how to create a <epiparameter> class object from scratch.
# This is a step to learn.

# Create generation time as an <epiparameter> object
generation_time <- epiparameter::epiparameter(
  disease = "disease x",
  epi_name = "generation time",
  prob_distribution = "gamma",
  summary_stats = list(mean = 3, sd = 1)
)


# Simulate multiple chains -----------------------------------------------
# step: Create 1000 simulation runs with 1 initial case.
# Add the input offspring distribution parameters to the corresponding arguments.
# Add the input generation time of class <epiparameter> as a function.
# Run set.seed() and epichains::simulate_chains() together, in the same run

# Set seed for random number generator
set.seed(33)

multiple_chains <- epichains::simulate_chains(
  # Simulation controls
  n_chains = 1000, # Number of chains to simulate
  statistic = "size",
  stat_threshold = 500, # Stopping criteria
  # Offspring
  offspring_dist = rnbinom,
  mu = known_basic_reproduction_number,
  size = known_dispersion,
  # Generation
  generation_time = function(x) generate(x = generation_time, times = x)
)

multiple_chains


# Explore suggested chain ------------------------------------------------
# step: Read the output of the selected chain to observe.
# Paste the screenshot in the report.
# Write in the report a paragraph describing:
# - the number of unknown and known infectors, their IDs.
# - the number of generations.
# - who infected whom in each generation, and when?
# i.e., the time range in days of these infections per generation.

multiple_chains %>%
  # Use data.frame output from <epichains> object
  as_tibble() %>%
  filter(chain == chain_to_observe) %>%
  print(n = Inf)


# Visualize --------------------------------------------------------------
# step: Run the code to create a summary data frame of the whole simulation.
# Paste the plot output in the report
# Use the plot or summary data frame (or any other calculation) 
# to write in the report a description of:
# - How many chains reached a 100 case threshold?
# - What is the maximum size of chain? (The cumulative number of case)
# - What is the maximum length of chain? (The number of days until the chain stops)
# Write in the report: interpretation and comparison between rooms.

# Daily aggregate of cases
aggregate_chains <- multiple_chains %>%
  as_tibble() %>%
  # Count the daily number of cases in each chain
  mutate(day = ceiling(time)) %>%
  count(chain, day, name = "cases") %>%
  # Calculate the cumulative number of cases for each chain
  group_by(chain) %>%
  mutate(cumulative_cases = cumsum(cases)) %>%
  ungroup()

# Visualize transmission chains by cumulative cases
aggregate_chains %>%
  # Create grouped chain trajectories
  ggplot(aes(x = day, y = cumulative_cases, group = chain)) +
  geom_line(color = "black", alpha = 0.25, show.legend = FALSE) +
  # Define a 100-case threshold
  geom_hline(aes(yintercept = 100), lty = 2) +
  labs(x = "Day", y = "Cumulative cases")

# count chains over 100 cases
aggregate_chains %>%
  filter(cumulative_cases >= 100) %>%
  count(chain)
# distribution of size of chains
aggregate_chains %>%
  filter(cumulative_cases >= 100) %>% 
  skimr::skim(cumulative_cases)
# distribution of lenght of chains
aggregate_chains %>%
  filter(cumulative_cases >= 100) %>% 
  skimr::skim(day)

# nolint end