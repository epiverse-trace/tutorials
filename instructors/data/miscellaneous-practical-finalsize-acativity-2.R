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

# scale the contact matrix so the largest eigenvalue is 1.0
# this is to ensure that the overall epidemic dynamics correctly reflect
# the assumed value of R0
contact_matrix <- #<COMPLETE>

# divide each row of the contact matrix by the corresponding demography
# this reflects the assumption that each individual in group {j} make contacts
# at random with individuals in group {i}
contact_matrix <- #<COMPLETE>

n_demo_grps <- #<COMPLETE>


# Calculate the final size ---------------------------------------------


  # nolint end
