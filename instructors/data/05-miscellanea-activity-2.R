# nolint start

# Practical 2 -miscellaneous on final size of heterogeneous population
# Activity 1

room_number <- #<COMPLETE> replace with 1/2/3/

  # Load packages ----------------------------------------------------------
library(finalsize)
library(tidyverse)
library(socialmixr)

# Declare the value of the given R_0 ---------------------------------------
r0 <- #<COMPLETE>

# load the polymod survey ----------------------------------------
polymod <- socialmixr::polymod

# Extract data for the country and age groups assigned to your room--------

# get your country polymod data
contact_data <- socialmixr::contact_matrix(
  polymod,
  countries = #<COMPLETE>,
  age.limits = #<COMPLETE>,
  symmetric = TRUE
)

# view the elements of the contact data list
# the contact matrix
contact_data$matrix

# the demography data
contact_data$demography

# get the contact matrix and demography data
contact_matrix <- #<COMPLETE>
demography_vector <- #<COMPLETE>
demography_data <- #<COMPLETE>


# Transpose and normalize contact matrix---------------------------------------

# scale the contact matrix so the largest eigenvalue is 1.0
# this is to ensure that the overall epidemic dynamics correctly reflect
# the assumed value of R0
contact_matrix <- #<COMPLETE>

# divide each row of the contact matrix by the corresponding demography
# this reflects the assumption that each individual in group {j} make contacts
# at random with individuals in group {i}
contact_matrix <- #<COMPLETE>

# Create susceptibility, and demography-susceptibility distribution matrices---
n_demo_grps <- #<COMPLETE>

# Number of susceptible groups
n_susc_groups <- #<COMPLETE>
# susceptibility level
susc_guess <- # <COMPLETE>

# Declare susceptibility matrix

  susc_uniform <- matrix(
    data = #<COMPLETE>,
    nrow = #<COMPLETE>,
    ncol = #<COMPLETE>
  )

# Declare demography-susceptibility distribution matrix
p_susc_uniform <- matrix(
  data =  #<COMPLETE>,
  nrow =  #<COMPLETE>,
  ncol =  #<COMPLETE>
)

# Calculate the final size -----------------------------------------------------

final_size_data <- final_size(
  r0 = #<COMPLETE>,
  contact_matrix = #<COMPLETE>,
  demography_vector = #<COMPLETE>,
  susceptibility = #<COMPLETE>,
  p_susceptibility = #<COMPLETE>
)

# View the output data frame
final_size_data

# Visualize the proportion infected in each demographic group-------------------

# order demographic groups as factors
final_size_data$demo_grp <- factor(
  final_size_data$demo_grp,
  levels = demography_data$age.group
)
# plot data
ggplot(final_size_data) +
  geom_col(
    aes(
      demo_grp, p_infected
    ),
    colour = "black", fill = "grey"
  ) +
  scale_y_continuous(
    labels = scales::percent,
    limits = c(0, 1)
  ) +
  expand_limits(
    x = c(0.5, nrow(final_size_data) + 0.5)
  ) +
  theme_classic() +
  coord_cartesian(
    expand = FALSE
  ) +
  labs(
    x = "Age group",
    y = "% Infected"
  )
# Visualize the total number infected in each demographic group----------------
# prepare demography data
demography_data <- contact_data$demography

# merge final size counts with demography vector
final_size_data <- merge(
  final_size_data,
  demography_data,
  by.x = "demo_grp",
  by.y = "age.group"
)

# reset age group order
final_size_data$demo_grp <- factor(
  final_size_data$demo_grp,
  levels = contact_data$demography$age.group
)

# multiply counts with proportion infected
final_size_data$n_infected <- final_size_data$p_infected *
  final_size_data$population
# nolint end
