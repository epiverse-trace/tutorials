# nolint start

# Practical 3
# Activity 2

room_number <- 1 #valid for all

# Load packages -----------------------------------------------------------
library(epiparameter)
library(epichains)
library(tidyverse)


# Set input parameters ---------------------------------------------------
known_basic_reproduction_number <- 0.8 #<DIFFERENT PER GROUP>
known_dispersion <- 0.01 #<DIFFERENT PER GROUP>
chain_to_observe <- 957 #<DIFFERENT PER GROUP>


# Set iteration parameters -----------------------------------------------

# Create generation time as an <epiparameter> object
generation_time <- epiparameter::epiparameter(
  disease = "disease x",
  epi_name = "generation time",
  prob_distribution = "gamma",
  summary_stats = list(mean = 3, sd = 1)
) %>% 
  epiparameter::discretise()


# Simulate multiple chains -----------------------------------------------
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
multiple_chains %>%
  # Use data.frame output from <epichains> object
  as_tibble() %>%
  filter(chain == chain_to_observe) %>%
  print(n = Inf)


# Visualize --------------------------------------------------------------

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