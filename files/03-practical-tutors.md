# Week 3: Estimate superspreading and simulate transmission chains


<!-- visible for instructors only -->

<!-- practical-week.md is generated from practical-week.qmd. Please edit that file -->

<!-- commit .md and .qmd files together -->

<!-- does not work for instructors text messages -->

<!-- works for text on html and MD only -->

This practical is based in the following tutorial episodes:

- <https://epiverse-trace.github.io/tutorials-middle/superspreading-estimate.html>
- <https://epiverse-trace.github.io/tutorials-middle/superspreading-simulate.html>

# Practical

This practical has two activities.

## Activity 1: Account for superspreading

Estimate the extent of individual-level variation (i.e. the dispersion
parameter) of the offspring distribution, which refers to the
variability in the number of secondary cases per individual, and assess
the implications for variation in transmission for decision-making using
the following available inputs:

- Line list of cases
- Contact tracing data

**Steps:**

Open the file `03-practical-activity-1.R` and fill in all the
`#<COMPLETE>` lines following the `steps:` detailed in the R file.

Within your room, Write your answers to these questions:

- From descriptive and estimation steps:
  - Does the estimated dispersion parameter correlate with the contact
    network and histogram of secondary cases?
- On decision making:
  - What is the probability of new cases originating from a cluster of
    at least 10 cases?
  - Would you recommend a backward contact tracing strategy?
- Interpret: How would you communicate these results to a
  decision-maker?
- Compare: What differences do you identify from other room outputs? (if
  available)
  - Which room has more infections related to fewer clusters in the
    contact network?
  - What room has the most skewed histogram of secondary cases?
  - Is there a relationship between contact network clusters, histogram
    of secondary cases, and dispersion parameter estimates?

### Inputs

| Room | Data |
|----|----|
| 1 | <https://epiverse-trace.github.io/tutorials-middle/data/set-01-contacts.rds>, <https://epiverse-trace.github.io/tutorials-middle/data/set-01-linelist.rds> |
| 2 | <https://epiverse-trace.github.io/tutorials-middle/data/set-02-contacts.rds>, <https://epiverse-trace.github.io/tutorials-middle/data/set-02-linelist.rds> |
| 3 | <https://epiverse-trace.github.io/tutorials-middle/data/set-03-contacts.rds>, <https://epiverse-trace.github.io/tutorials-middle/data/set-03-linelist.rds> |
| 4 | <https://epiverse-trace.github.io/tutorials-middle/data/set-04-contacts.rds>, <https://epiverse-trace.github.io/tutorials-middle/data/set-04-linelist.rds> |
| 5 | <https://epiverse-trace.github.io/tutorials-middle/data/set-05-contacts.rds>, <https://epiverse-trace.github.io/tutorials-middle/data/set-05-linelist.rds> |
| 6 | <https://epiverse-trace.github.io/tutorials-middle/data/set-06-contacts.rds>, <https://epiverse-trace.github.io/tutorials-middle/data/set-06-linelist.rds> |

### Solution

<!-- visible for instructors and learners after practical (solutions) -->

#### Code

##### Room 1 (sample)

``` r
# nolint start

# Practical 3
# Activity 1

# step: fill in your room number
room_number <- 1 #valid for all

# Load packages -----------------------------------------------------------
library(epicontacts)
library(fitdistrplus)
library(tidyverse)


# Read linelist and contacts ----------------------------------------------
# step: Paste the URL links as a string to read input data.

dat_contacts <- readr::read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/set-01-contacts.rds"  #<DIFFERENT PER ROOM>
)

dat_linelist <- readr::read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/set-01-linelist.rds"  #<DIFFERENT PER ROOM>
)


# Create an epicontacts object -------------------------------------------
# step: Create a *directed* contact network 
# using the linelist and contacts data inputs.
# Paste a screenshot of the network in the report.

epi_contacts <- epicontacts::make_epicontacts(
  linelist = dat_linelist,
  contacts = dat_contacts,
  directed = TRUE
)

# Print output
epi_contacts

# Visualize the contact network
contact_network <- epicontacts::vis_epicontacts(epi_contacts)

# Print output
contact_network


# Count secondary cases per subject in contacts and linelist --------------
# step: Calculate the *out-degree* for each node (infector case)
# in the contact network, using *all* the cases observed in the linelist.
# Paste the output histogram in the report.

secondary_cases <- epicontacts::get_degree(
  x = epi_contacts,
  type = "out",
  only_linelist = TRUE
)

# Plot the histogram of secondary cases
individual_reproduction_num <- secondary_cases %>%
  enframe() %>% 
  ggplot(aes(value)) +
  geom_histogram(binwidth = 1) +
  labs(
    x = "Number of secondary cases",
    y = "Frequency"
  )

# Print output
individual_reproduction_num


# Fit a negative binomial distribution -----------------------------------
# step: Use the vector with the number of secondary cases per infector case 
# to fit a Negative Binomial distribution using {fitdistrplus}
# Paste the output parameters in the report.

offspring_fit <- secondary_cases %>%
  fitdistrplus::fitdist(distr = "nbinom")

# Print output
offspring_fit


# Estimate proportion of new cases from a cluster of secondary cases ------
# step: Use {superspreading} to calculate the probability (proportion)
# of new cases originating from a cluster of a given size (cluster size),
# using as input the offspring distribution parameters: 
# the reproduction number and dispersion.
# Paste the output result in the report.

# Set seed for random number generator
set.seed(33)

# Estimate the probability of new cases originating from 
# a transmission cluster of at least 5, 10, or 25 cases
proportion_cases_by_cluster_size <- 
  superspreading::proportion_cluster_size(
    R = offspring_fit$estimate["mu"],
    k = offspring_fit$estimate["size"],
    cluster_size = c(5, 10, 25)
  )

# Print output
proportion_cases_by_cluster_size

# nolint end
```

#### Outputs

Room 1

| contact network | histogram of secondary cases |
|----|----|
| ![Untitled-1](https://hackmd.io/_uploads/H1DVLbsTyx.png) | ![Untitled](https://hackmd.io/_uploads/BkW48Wo6yg.png) |

Room 2

| contact network | histogram of secondary cases |
|----|----|
| ![Untitled](https://hackmd.io/_uploads/Hkhg8WspJg.png) | ![Untitled-1](https://hackmd.io/_uploads/HyIlUWopJx.png) |

Room 3

| contact network | histogram of secondary cases |
|----|----|
| ![Untitled](https://hackmd.io/_uploads/HkzkUZjpyx.png) | ![Untitled-1](https://hackmd.io/_uploads/SkjCBZjpJe.png) |

Room 1/2/3

``` r
#>     R    k prop_5 prop_10 prop_25
#> 1 0.8 0.01  95.1%   89.8%   75.1%
#> 2 0.8 0.10  66.7%   38.7%    7.6%
#> 3 0.8 0.50  25.1%    2.8%      0%
```

#### Interpretation

Interpretation template:

- Two valid alternatives, For R = 0.8 and k = 0.01:
  - The probability of new cases originating from a cluster of 5 cases
    or more is 95%.
  - The proportion of all transmission events that were part of
    secondary case clusters (i.e., from the same primary case) of at
    least 5 cases is 95%.

Interpretation Helpers:

- From the contact network, room 1 has the highest frequency of
  infections related with a small number of clusters (four major
  clusters out of all the transmission events).
- From the histogram of secondary cases, skewness in room 1 is higher
  than room 2 and room 3.
- Room 1 has cases with the highest number of secondary cases (n = 50),
  compared with room 2 (n = ~25) and room 3 (n = 11).
- The contact networks and histograms of secondary cases correlate with
  the estimated dispersion parameters: A small number of clusters
  generating most of new cases produces a more skewed histogram, and a
  lowest estimate of dispersion parameter.
- About probability of new cases from transmission cluster of size at
  least 10 cases, and the recommending backward tracing strategy:
  - room 1: 89%, yes.
  - room 2: 38%, probably no?
  - room 3: 3%, no.

## Activity 2: Simulate transmission chains

Estimate the potential for large outbreaks that could occur based on
1000 simulated outbreaks with one initial case, using the following
available inputs:

- Basic reproduction number
- Dispersion parameter

**Steps:**

Open the file `03-practical-activity-2.R` and fill in all the
`#<COMPLETE>` lines following the `steps:` detailed in the R file.

Within your room, Write your answers to these questions:

- You have been assigned to explore `Chain ID`. From the output data
  frame, describe:
  - How many generations does this chain have?
  - The story of this chain: Who infected whom, and when (with reference
    to the day of infection).
- Among simulated outbreaks:
  - How many chains reached a 100-case threshold?
  - What is the maximum size among all the chains?
  - What is the maximum length among all the chains? (in days)
- Interpret: How would you communicate these results to a
  decision-maker?
- Compare: What differences do you identify from other room outputs? (if
  available)

### Inputs

| Room | Parameters        | Chain ID |
|------|-------------------|----------|
| 1    | R = 0.8, k = 0.01 | 957      |
| 2    | R = 0.8, k = 0.1  | 281      |
| 3    | R = 0.8, k = 0.5  | 38       |
| 4    | R = 1.5, k = 0.01 | 261      |
| 5    | R = 1.5, k = 0.1  | 325      |
| 6    | R = 1.5, k = 0.5  | 591      |

### Solution

<!-- visible for instructors and learners after practical (solutions) -->

#### Code

##### Room 1 (sample)

``` r
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
```

#### Outputs

Room 1

| contact network | secondary cases | simulated chains |
|----|----|----|
| ![Untitled-1](https://hackmd.io/_uploads/H1DVLbsTyx.png) | ![Untitled](https://hackmd.io/_uploads/BkW48Wo6yg.png) | ![image](https://hackmd.io/_uploads/Sy3x3MNAJe.png) |

Room 2

| contact network | secondary cases | simulated chains |
|----|----|----|
| ![Untitled](https://hackmd.io/_uploads/Hkhg8WspJg.png) | ![Untitled-1](https://hackmd.io/_uploads/HyIlUWopJx.png) | ![image](https://hackmd.io/_uploads/rkw-hGN0kl.png) |

Room 3

| contact network | secondary cases | simulated chains |
|----|----|----|
| ![Untitled](https://hackmd.io/_uploads/HkzkUZjpyx.png) | ![Untitled-1](https://hackmd.io/_uploads/SkjCBZjpJe.png) | ![image](https://hackmd.io/_uploads/S1p-2MNRJe.png) |

Sample

``` r
# infector-infectee data frame 
simulated_chains_map %>%
  dplyr::filter(chain == 957) %>%
  dplyr::as_tibble()
```

    # A tibble: 16 × 5
       chain infector infectee generation  time
       <int>    <dbl>    <dbl>      <int> <dbl>
     1   957       NA        1          1  0   
     2   957        1        2          2  3.13
     3   957        1        3          2  4.12
     4   957        1        4          2  3.42
     5   957        1        5          2  3.12
     6   957        1        6          2  3.50
     7   957        1        7          2  2.79
     8   957        1        8          2  3.92
     9   957        1        9          2  6.56
    10   957        1       10          2  2.93
    11   957        1       11          2  4.02
    12   957        1       12          2  3.17
    13   957        1       13          2  2.99
    14   957       10       14          3  6.79
    15   957       10       15          3  4.43
    16   957       10       16          3  6.18

#### Interpretation

Interpretation template:

- Simulated chain `957` have 1 unknown infector `ID = NA`, 2 known
  infectors `ID = c(1, 10)`, and 3 generations.
- In the generation 1, subject `ID = NA` infected subject `ID = 1`.
- In the generation 2, subject `ID = 1` infected 12 subjects
  `IDs from 2 to 13`. These infections occurred between day 2 and 6
  after the first infection (initial case).
- In the generation 3, subject `ID = 10` infected subjects
  `ID = c(14, 15, 16)`. These infections occurred between day 4 and 7
  after the first infection (initial case).

Interpretation Helpers:

From the plot of cumulative cases by day for each simulated chain:

| Room | Parameters | Number of Chains Above 100 | Max Chain Size | Max Chain Length |
|----|----|----|----|----|
| 1 | R = 0.8, k = 0.01 | 10 | ~200 | ~20 days |
| 2 | R = 0.8, k = 0.1 | 8 | ~420 | ~60 days |
| 3 | R = 0.8, k = 0.5 | 3 | ~180 | ~70 days |
| 4 | R = 1.5, k = 0.01 | 16 | ~840 | ~20 days |
| 5 | R = 1.5, k = 0.1 | 65 | ~890 | ~50 days |
| 6 | R = 1.5, k = 0.5 | 216 | ~850 | ~90 days |

# Continue your learning path

<!-- Suggest learners to Epiverse-TRACE documentation or external resources --->

{superspreading} vignette on epidemic risk

- <https://epiverse-trace.github.io/superspreading/articles/epidemic_risk.html>

{epichains} vignette on projecting infectious disease incidence

- <https://epiverse-trace.github.io/epichains/articles/projecting_incidence.html>

Epi R handbook episode on {epicontacts} to visualise transmission chains
in time

- <https://www.epirhandbook.com/en/transmission-chains.html>

# end
