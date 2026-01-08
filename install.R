# nolint start
pak::pak("epiverse-trace/epidemics")
epidemics::population(
  name = "UK population",
  contact_matrix = matrix(1),
  demography_vector = 67e6,
  initial_conditions = matrix(
    c(0.9999, 0.0001, 0, 0),
    nrow = 1,
    ncol = 4
  )
)
pak::pak("cyclocomp")
cyclocomp::cyclocomp(quote( if (condition) "foo" else "bar" ))
# nolint end