# nolint start

# Practical 1
# Activity 2

# Validate linelist ------------------------------------------------------

# Activate error message
linelist::lost_tags_action(action = "error")
# linelist::lost_tags_action(action = "warning")

# Print tag types, names, and data to guide make_linelist
linelist::tags_types()
linelist::tags_names()
dat_timespan

# Does the age variable pass the validation step?
dat_validate <- dat_timespan %>% 
  # Tag variables
  linelist::make_linelist(
    id = "pid",
    occupation = "timespan_category", # Categorical variable
    allow_extra = TRUE,
    last_exp_date = "last_exp_date",
    last_vax_type = "last_vax_type"
  ) %>% 
  # Validate linelist
  linelist::validate_linelist(
    allow_extra = TRUE,
    ref_types = linelist::tags_types(
      last_exp_date = c("Date"),
      last_vax_type = c("character"),
      allow_extra = TRUE
    )
  ) %>% 
  # Test safeguard
  # dplyr::select(case_id, date_onset, sex)
  # INSTEAD
  linelist::tags_df()


# Create incidence -------------------------------------------------------

# What is the most appropriate time-aggregate (days, months) to plot?
dat_incidence <- dat_validate %>%  
  # Transform from individual-level to time-aggregate
  incidence2::incidence(
    date_index = "last_exp_date",
    groups = "last_vax_type", # OR any categorical variable
    interval = "month",
    complete_dates = TRUE
  )


# Plot epicurve ----------------------------------------------------------

# Do arguments like 'fill', 'show_cases', 'angle', 'n_breaks' improve the plot?
dat_incidence %>% 
  plot(
    fill = "last_vax_type"
  )

# Find plot() arguments at ?incidence2:::plot.incidence2()

# nolint end