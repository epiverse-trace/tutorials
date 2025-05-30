# nolint start

# Practical 3
# Activity 2

# Load packages -----------------------------------------------------------
library(epiparameter)
library(epichains)
library(tidyverse)


# Set input parameters ---------------------------------------------------
known_basic_reproduction_number <- #<COMPLETE>
known_dispersion <- #<COMPLETE>
chain_to_observe <- #<COMPLETE>


# Set iteration parameters -----------------------------------------------

# Create generation time as <epiparameter> object
generation_time <- epiparameter::epiparameter(
  disease = "disease x",
  epi_name = "generation time",
  prob_distribution = "gamma",
  summary_stats = list(mean = 3, sd = 1)
)


# Simulate multiple chains -----------------------------------------------
# run set.seed() and epichains::simulate_chains() together, in the same run

# Set seed for random number generator
set.seed(33)

multiple_chains <- epichains::simulate_chains(
  # simulation controls
  n_chains = #<COMPLETE>, # number of chains to simulate
  statistic = "size",
  stat_threshold = 500, # stopping criteria
  # offspring
  offspring_dist = rnbinom,
  mu = #<COMPLETE>,
  size = #<COMPLETE>,
  # generation
  generation_time = #<COMPLETE>
)

multiple_chains


# Explore suggested chain ------------------------------------------------
multiple_chains %>%
  # use data.frame output from <epichains> object
  as_tibble() %>%
  filter(chain == chain_to_observe) %>%
  print(n = Inf)


# visualize ---------------------------------------------------------------

# daily aggregate of cases
aggregate_chains <- multiple_chains %>%
  as_tibble() %>%
  # count the daily number of cases in each chain
  mutate(day = ceiling(time)) %>%
  count(chain, day, name = "cases") %>%
  # calculate the cumulative number of cases for each chain
  group_by(chain) %>%
  mutate(cumulative_cases = cumsum(cases)) %>%
  ungroup()

# Visualize transmission chains by cumulative cases
aggregate_chains %>%
  # create grouped chain trajectories
  ggplot(aes(x = day, y = cumulative_cases, group = chain)) +
  geom_line(color = "black", alpha = 0.25, show.legend = FALSE) +
  # define a 100-case threshold
  geom_hline(aes(yintercept = 100), lty = 2) +
  labs(x = "Day", y = "Cumulative cases")

# nolint end