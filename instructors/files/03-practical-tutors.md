# Week 3: Estimate superspreading and simulate transmission chains


<!-- visible for instructors only -->

<!-- practical-week.md is generated from practical-week.qmd. Please edit that file -->

<!-- commit .md and .qmd files together -->

<!-- does not work for instructors text messages -->

<!-- works for text on html and MD only -->

This practical is based in the following tutorial episodes:

- <https://epiverse-trace.github.io/tutorials-middle/superspreading-estimate.html>
- <https://epiverse-trace.github.io/tutorials-middle/superspreading-simulate.html>

Welcome!

- A reminder of our [Code of
  Conduct](https://github.com/epiverse-trace/.github/blob/main/CODE_OF_CONDUCT.md).
  If you experience or witness unacceptable behaviour, or have any other
  concerns, please notify the course organisers or host of the event. To
  report an issue involving one of the organisers, please use the
  [LSHTM’s Report and Support
  tool](https://reportandsupport.lshtm.ac.uk/).

# Read This First

<!-- visible for learners and instructors at practical -->

Instructions:

- Each `Activity` has five sections: the Goal, Questions, Inputs, Your
  Code, and Your Answers.
- Solve each Activity in the corresponding `.R` file mentioned in the
  `Your Code` section.
- Paste your figure and table outputs and write your answer to the
  questions in the section `Your Answers`.
- Choose one group member to share your group’s results with the rest of
  the participants.

During the practical, instead of simply copying and pasting, we
encourage learners to increase their fluency writing R by using:

- The double-colon notation, e.g. `package::function()` to specify which
  package a function comes from, avoid namespace conflicts, and find
  functions using keywords.
- Tab key <kbd>↹</kbd> to [autocomplete package or function
  names](https://support.posit.co/hc/en-us/articles/205273297-Code-Completion-in-the-RStudio-IDE)
  and [display possible
  arguments](https://docs.posit.co/ide/user/ide/guide/code/console.html).
- [Execute one line of
  code](https://docs.posit.co/ide/user/ide/guide/code/execution.html) or
  multiple lines connected by the pipe operator (`%>%`) by placing the
  cursor in the code of interest and pressing the `Ctrl`+`Enter`.
- [R
  shortcuts](https://positron.posit.co/keyboard-shortcuts.html#r-shortcuts)
  to insert the pipe operator (`%>%`) using `Ctrl/Cmd`+`Shift`+`M`, or
  insert the assignment operator (`<-`) using `Alt/Option`+`-`.
  <!-- - Get [help yourself with R](https://www.r-project.org/help.html) using the `help()` function or `?` operator to access the function reference manual. -->

If your local configuration was not possible to setup:

- Create one copy of the [Posit Cloud RStudio
  project](https://posit.cloud/spaces/609790/join?access_code=hPM1tIeKt5ax_Y-P0lMGVUGqzFPNH4wxkKSzXZYb).

## Paste your !Error messages here





# Practical

This practical has two activities.

## Activity 1: Account for superspreading

Estimate extent of individual-level variation (i.e. the dispersion
parameter) of the offspring distribution, which refers to the
variability in the number of secondary cases per individual, and the
proportion of transmission that is linked to ‘superspreading events’
using the following available inputs:

- Line list of cases
- Contact tracing data

As a group, Write your answers to these questions:

- From descriptive and estimation steps:
  - What set has more infections related to fewer clusters in the
    contact network?
  - What set has the most skewed histogram of secondary cases?
  - Does the estimated dispersion parameter correlate with the contact
    network and histogram of secondary cases?
- On decision making:
  - What is the proportion of new cases originating from a cluster of at
    least 10 cases?
  - Would you recommend a backward tracing strategy?
- Interpret: How would you communicate these results to a
  decision-maker?
- Compare: What differences do you identify from other group outputs?
  (if available)

### Inputs

| Group | Data |
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

##### Set 1 (sample)

``` r
# nolint start

# Practical 3
# Activity 1

# Load packages -----------------------------------------------------------
library(epicontacts)
library(fitdistrplus)
library(tidyverse)


# Read linelist and contacts ----------------------------------------------
dat_contacts <- readr::read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/set-01-contacts.rds"  #<DIFFERENT PER GROUP>
)

dat_linelist <- readr::read_rds(
  "https://epiverse-trace.github.io/tutorials-middle/data/set-01-linelist.rds"  #<DIFFERENT PER GROUP>
)


# Create an epicontacts object -------------------------------------------
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
offspring_fit <- secondary_cases %>%
  fitdistrplus::fitdist(distr = "nbinom")

# Print output
offspring_fit


# Estimate proportion of new cases from a cluster of secondary cases ------

# Set seed for random number generator
set.seed(33)

# Estimate the proportion of new cases originating from 
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

Group 1

| contact network | histogram of secondary cases |
|----|----|
| ![Untitled-1](https://hackmd.io/_uploads/H1DVLbsTyx.png) | ![Untitled](https://hackmd.io/_uploads/BkW48Wo6yg.png) |

Group 2

| contact network | histogram of secondary cases |
|----|----|
| ![Untitled](https://hackmd.io/_uploads/Hkhg8WspJg.png) | ![Untitled-1](https://hackmd.io/_uploads/HyIlUWopJx.png) |

Group 3

| contact network | histogram of secondary cases |
|----|----|
| ![Untitled](https://hackmd.io/_uploads/HkzkUZjpyx.png) | ![Untitled-1](https://hackmd.io/_uploads/SkjCBZjpJe.png) |

Group 1/2/3

``` r
#>     R    k prop_5 prop_10 prop_25
#> 1 0.8 0.01  95.1%   89.8%   75.1%
#> 2 0.8 0.10  66.7%   38.7%    7.6%
#> 3 0.8 0.50  25.1%    2.8%      0%
```

#### Interpretation

Interpretation template:

- For R = 0.8 and k = 0.01:
  - The proportion of new cases originating from a cluster of at least 5
    secondary cases from a primary case is 95%
  - The proportion of all transmission events that were part of
    secondary case clusters (i.e., from the same primary case) of at
    least 5 cases is 95%

Interpretation Helpers:

- From the contact network, set 1 has the highest frequency of
  infections related with a small proportion of clusters.
- From the histogram of secondary cases, skewness in set 1 is higher
  than set 2 and set 3.
- Set 1 has cases with the highest number of secondary cases (n = 50),
  compared with set 2 (n = ~25) and set 3 (n = 11).
- The contact networks and histograms of secondary cases correlate with
  the estimated dispersion parameters: A small proportion of clusters
  generating most of new cases produces a more skewed histogram, and a
  lowest estimate of dispersion parameter.
- About probability of new cases from transmission cluster of size at
  least 10 cases, and the recommending backward tracing strategy:
  - set 1: 89%, yes.
  - set 2: 38%, probably no?
  - set 3: 3%, no.

## Activity 2: Simulate transmission chains

Estimate the potential for large outbreaks that could occur based on
1000 simulated outbreaks using the following available inputs:

- Basic reproduction number
- Dispersion parameter

As a group, Write your answers to these questions:

- You have been assigned to explore `Chain ID`. From the output data
  frame, describe:
  - How many generations there are.
  - Who infected whom, and when (with reference to the day of
    infection).
- Among simulated outbreaks:
  - How many chains reached a 100 case threshold?
  - What is the maximum size of chain? (The cumulative number of case)
  - What is the maximum length of chain? (The number of days until the
    chain stops)
- Interpret: How would you communicate these results to a
  decision-maker?
- Compare: What differences do you identify from other group outputs?
  (if available)

### Inputs

| Group | Parameters        | Chain ID |
|-------|-------------------|----------|
| 1     | R = 0.8, k = 0.01 | 957      |
| 2     | R = 0.8, k = 0.1  | 281      |
| 3     | R = 0.8, k = 0.5  | 38       |
| 4     | R = 1.5, k = 0.01 | 261      |
| 5     | R = 1.5, k = 0.1  | 325      |
| 6     | R = 1.5, k = 0.5  | 591      |

### Solution

<!-- visible for instructors and learners after practical (solutions) -->

#### Code

##### Set 1 (sample)

``` r
# nolint start

# Practical 3
# Activity 2

# Load packages -----------------------------------------------------------
library(epiparameter)
library(epichains)
library(tidyverse)


# Set input parameters ---------------------------------------------------
known_basic_reproduction_number <- 0.8
known_dispersion <- 0.01
chain_to_observe <- 957


# Set iteration parameters -----------------------------------------------

# Create generation time as an <epiparameter> object
generation_time <- epiparameter::epiparameter(
  disease = "disease x",
  epi_name = "generation time",
  prob_distribution = "gamma",
  summary_stats = list(mean = 3, sd = 1)
)


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
```

#### Outputs

Group 1

| contact network | secondary cases | simulated chains |
|----|----|----|
| ![Untitled-1](https://hackmd.io/_uploads/H1DVLbsTyx.png) | ![Untitled](https://hackmd.io/_uploads/BkW48Wo6yg.png) | ![image](https://hackmd.io/_uploads/Sy3x3MNAJe.png) |

Group 2

| contact network | secondary cases | simulated chains |
|----|----|----|
| ![Untitled](https://hackmd.io/_uploads/Hkhg8WspJg.png) | ![Untitled-1](https://hackmd.io/_uploads/HyIlUWopJx.png) | ![image](https://hackmd.io/_uploads/rkw-hGN0kl.png) |

Group 3

| contact network | secondary cases | simulated chains |
|----|----|----|
| ![Untitled](https://hackmd.io/_uploads/HkzkUZjpyx.png) | ![Untitled-1](https://hackmd.io/_uploads/SkjCBZjpJe.png) | ![image](https://hackmd.io/_uploads/S1p-2MNRJe.png) |

Sample

``` r
# infector-infectee data frame 
simulated_chains_map %>%
  dplyr::filter(simulation_id == 806) %>%
  dplyr::as_tibble()
```

    # A tibble: 9 × 6
      chain infector infectee generation  time simulation_id
      <int>    <dbl>    <dbl>      <int> <dbl>         <int>
    1     1       NA        1          1   0             806
    2     1        1        2          2  16.4           806
    3     1        1        3          2  11.8           806
    4     1        1        4          2  10.8           806
    5     1        1        5          2  11.4           806
    6     1        1        6          2  10.2           806
    7     1        2        7          3  26.0           806
    8     1        2        8          3  29.8           806
    9     1        2        9          3  26.6           806

#### Interpretation

Interpretation template:

- Simulation `806` have `1` chain with `3` known infectors (`NA`, 1, 2),
  and `3` generations.
- In the generation 0, subject `NA` infected subject 1.
- In the generation 1, subject 1 infected subjects 2, 3, 4, 5, 6. These
  infections occurred between day 10 and 16 after the “case zero”.
- In the generation 2, subject 2 infected subjects 7, 8, 9. These
  infections occurred between day 26 and 29 after the “case zero”.

Interpretation Helpers:

From the plot of cumulative cases by day for each simulated chain:

| Group | Parameters | Number of Chains Above 100 | Max Chain Size | Max Chain Length |
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
