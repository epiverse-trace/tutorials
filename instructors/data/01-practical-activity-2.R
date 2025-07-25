# nolint start

# Practical 1
# Activity 2

room_number <- #<COMPLETE> replace with 1/2/3/4

# Validate linelist ------------------------------------------------------

# Activate error message
linelist::lost_tags_action(action = "error")
# linelist::lost_tags_action(action = "warning")

# Print tag types, names, and data to guide make_linelist
linelist::tags_types()
linelist::tags_names()
dat_timespan

# Does the categorical variable of interest pass the validation step?
dat_validate <- dat_timespan %>% 
  # Tag variables
  linelist::make_linelist(
    #<COMPLETE>,
    #<COMPLETE> # include one categorical variable
  ) %>% 
  # Validate linelist
  linelist::#<COMPLETE> %>% 
  # Test safeguard
  # dplyr::select(case_id, date_onset, sex)
  # INSTEAD
  linelist::tags_df()


# Create incidence -------------------------------------------------------

# What is the most appropriate time-aggregate (days, months) to plot?
dat_incidence <- dat_validate %>%  
  # Transform from individual-level to time-aggregate
  incidence2::incidence(
    date_index = #<COMPLETE>,
    groups = #<COMPLETE>, # the categorical variable
    interval = #<COMPLETE>,
    complete_dates = TRUE
  )


# Plot epicurve ----------------------------------------------------------

# Do arguments like 'fill', 'show_cases', 'angle', 'n_breaks' improve the plot?
dat_incidence %>% 
  plot(
    fill = #<COMPLETE>, # the categorical variable # <KEEP OR DROP>
    show_cases = TRUE, # <KEEP OR DROP>
    angle = 45, # <KEEP OR DROP>
    n_breaks = 5 # <KEEP OR DROP>
  )

# Find plot() arguments at ?incidence2:::plot.incidence2()

# nolint end