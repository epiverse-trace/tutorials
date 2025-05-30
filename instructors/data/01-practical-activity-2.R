# nolint start

# Practical 1
# Activity 2

# Validate linelist ------------------------------------------------------

# activate Error message
linelist::lost_tags_action(action = "error")
# linelist::lost_tags_action(action = "warning")

# print tags types, names, and data to guide make_linelist
linelist::tags_types()
linelist::tags_names()
dat_timespan

# does the age variable pass the validation step?
dat_validate <- dat_timespan %>% 
  # tag variables
  linelist::make_linelist(
    #<COMPLETE>
    occupation = "timespan_category" # categorical var.
  ) %>% 
  # validate linelist
  linelist::#<COMPLETE> %>% 
  # test safeguard
  # dplyr::select(case_id, date_onset, sex)
  # INSTEAD
  linelist::tags_df()


# Create incidence -------------------------------------------------------

# what is the most appropriate time-aggregate (days, months) to plot?
dat_incidence <- dat_validate %>%  
  # transform from individual-level to time-aggregate
  incidence2::incidence(
    date_index = #<COMPLETE>,
    groups = "occupation", #OR any categorical variable
    interval = #<COMPLETE>,
    complete_dates = TRUE
  )


# Plot epicurve ----------------------------------------------------------

# does using arguments like 'fill', 'show_cases', 'angle', 'n_breaks' improve the plot?
dat_incidence %>% 
  plot(
    fill = "occupation", #<KEEP OR DROP>
    show_cases = TRUE, #<KEEP OR DROP>
    angle = 45, #<KEEP OR DROP>
    n_breaks = 5 #<KEEP OR DROP>
  )

# find plot() arguments at ?incidence2:::plot.incidence2()

# nolint end