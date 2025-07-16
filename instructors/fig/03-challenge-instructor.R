# load packages ---------------------------
library(epichains)
library(epiparameter)
library(fitdistrplus)
library(tidyverse)

# Number of individuals in the trees
n <- 152
# Number of secondary cases for all individuals
c1 <- c(1, 2, 2, 5, 14, 1, 4, 4, 1, 3, 3, 8, 2, 1, 1,
        4, 9, 9, 1, 1, 17, 2, 1, 1, 1, 4, 3, 3, 4, 2,
        5, 1, 2, 2, 1, 9, 1, 3, 1, 2, 1, 1, 2)
c0 <- c(c1, rep(0, n - length(c1)))

c0 %>%
  enframe() %>%
  ggplot(aes(value)) +
  geom_histogram()

# fit a negative binomial distribution ------------------------------------

# Fitting a negative binomial distribution to the number of secondary cases
fit.cases <- fitdistrplus::fitdist(c0, "nbinom")
fit.cases

# serial interval parameters ----------------------------------------------

ebola_serialinter <- epiparameter::epiparameter_db(
  disease = "ebola",
  epi_name = "serial interval",
  single_epiparameter = TRUE
)

# simulate outbreak trajectories ------------------------------------------

# Set seed for random number generator
set.seed(645)
sim_multiple_chains <- epichains::simulate_chains(
  n_chains = 100,
  statistic = "size",
  offspring_dist = rnbinom,
  mu = fit.cases$estimate["mu"],
  size = fit.cases$estimate["size"],
  generation_time = function(x) generate(x = ebola_serialinter, times = x)
)

# visualize ----------------------------------------

sim_chains_aggregate <-
  sim_multiple_chains %>%
  # use data.frame output from <epichains> object
  as_tibble() %>%
  # Count the daily number of cases in each chain
  mutate(day = ceiling(time)) %>%
  count(chain, day, name = "cases") %>%
  # Calculate the cumulative number of cases for each chain
  group_by(chain) %>%
  mutate(cumulative_cases = cumsum(cases)) %>%
  ungroup()

sim_chains_aggregate %>%
  # Create grouped chain trajectories
  ggplot(aes(x = day, y = cumulative_cases, group = chain)) +
  geom_line() +
  # Define a 100-case threshold
  geom_hline(aes(yintercept = 100), lty = 2) +
  labs(x = "Day", y = "Cumulative cases")