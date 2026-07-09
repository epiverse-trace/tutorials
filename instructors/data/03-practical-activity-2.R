# nolint start

# Practical 3
# Activity 2

# step: fill in your room number
room_number <- #<COMPLETE> replace with 1/2/3/4

# Load packages -----------------------------------------------------------
library(epiparameter)
library(epichains)
library(tidyverse)


# Set input parameters ---------------------------------------------------
# step: Paste the corresponding input parameter for this room.

known_basic_reproduction_number <- #<COMPLETE>
known_dispersion <- #<COMPLETE>
chain_to_observe <- #<COMPLETE>


# Set iteration parameters -----------------------------------------------
# step: Learn to create an <epiparameter> class object from scratch.

# Create generation time as an <epiparameter> object
generation_time <- epiparameter::epiparameter(
  disease = "disease x",
  epi_name = "generation time",
  prob_distribution =
    epiparameter::create_prob_distribution(
      prob_distribution = "gamma",
      prob_distribution_params = c(shape = 9.000, scale = 0.333)
    )
)


# Simulate multiple chains -----------------------------------------------
# step: Simulate 1000 chains from 1 initial case. Add the offspring
# and generation time parameters, and run set.seed() together with
# simulate_chains().

# Set seed for random number generator
set.seed(33)

multiple_chains <- epichains::simulate_chains(
  # Simulation controls
  n_chains = 1000, # Number of chains to simulate
  statistic = "size",
  stat_threshold = 500, # Stopping criteria
  # Offspring
  offspring_dist = rnbinom,
  mu = #<COMPLETE>,
  size = #<COMPLETE>,
  # Generation
  generation_time = function(x) generate(x = #<COMPLETE>, times = x)
)

multiple_chains


# Explore suggested chain ------------------------------------------------
# step: Inspect the selected chain, paste a screenshot, and describe
# in the report: number of infectors and their IDs, number of
# generations, and who infected whom (and when) per generation.

multiple_chains %>%
  # Use data.frame output from <epichains> object
  as_tibble() %>%
  filter(chain == chain_to_observe) %>%
  print(n = Inf)


# Visualize --------------------------------------------------------------
# step: Plot the simulation and build a summary data frame; paste
# the plot output in the report. Use it to describe:
# - proportion of chains that go extinct quickly (probability of
#   extinction)
# - proportion that crossed the 100-case threshold (explosive
#   growth from one index case)
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

# nolint end
