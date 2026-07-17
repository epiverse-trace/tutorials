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
# step: Learn to create an <epiparameter> class object from scratch.

# Create generation time as an <epiparameter> object
generation_time <- epiparameter::epiparameter(
  disease = "disease x",
  epi_name = "generation time",
  # summary_stats = list(mean = 3, sd = 1)
  prob_distribution =
    epiparameter::create_prob_distribution(
      prob_distribution = "gamma",
      prob_distribution_params = c(shape = 9.000, scale = 0.333)
    )
)

generation_time

plot(generation_time)

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
  mu = known_basic_reproduction_number,
  size = known_dispersion,
  # Generation
  generation_time = function(x) generate(x = generation_time, times = x)
)

multiple_chains

# Print size of all simulated chains
summary(multiple_chains)

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
  # get the round number (day) of infection times
  mutate(day = ceiling(time)) %>%
  # count the number of daily incident cases in each chain
  count(chain, day, name = "incident_cases") %>%
  # Calculate the cumulative number of cases for each chain
  group_by(chain) %>%
  mutate(cumulative_cases = cumsum(incident_cases)) %>%
  ungroup()

# Print a couple of chains to better understand the output
aggregate_chains %>% 
  arrange(chain) %>% 
  print(n=50)

# Visualize transmission chains by cumulative cases
aggregate_chains %>%
  # Create grouped chain trajectories
  ggplot(aes(x = day, y = cumulative_cases, group = chain)) +
  geom_line(color = "black", alpha = 0.25, show.legend = FALSE) +
  # Define a 100-case threshold
  geom_hline(aes(yintercept = 100), lty = 2) +
  labs(x = "Day", y = "Cumulative cases")

# Summarise the chain duration and size
summary_chains <-
  aggregate_chains %>%
  dplyr::group_by(chain) %>%
  dplyr::summarise(
    max_day = max(day), # chain duration
    total_cases = max(cumulative_cases) # chain size
  ) %>%
  dplyr::ungroup()

# Print the duration and size for chains above threshold
summary_chains %>% 
  dplyr::filter(total_cases > 100)

# nolint end