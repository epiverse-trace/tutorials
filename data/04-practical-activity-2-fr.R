# nolint start

# Exercice pratique 4
# Activité 2

# étape: remplissez le numéro du groupe
room_number <- #<À COMPLETER> remplacer avec 1/2/3/4
  
# Intervention ---------------------------------------------------------

# remarque: Tous les paramètres d'entrée proviennent du tableau des paramètres
# du document pratique

rownames(socialcontact_matrix)

# étape: créer un object de la classe <intervention>
# 
# utiliser la fonction epidemics::intervention() ou epidemics::vaccination()
# avec les arguments suivants
#
# - nom de l'intervention
# - type de l'intervention ("rate" or "contacts"), si nécessaire
# - les dates de début et de fin de l'intervention (en valeur entière ou sous
#   forme de matrice*)
# - le taux de réduction ou vaccination (en valeur réelle or sous la forme d'une
#   matrice*)
# 
# *lorsqu'il s'agit d'une matrice, les valeurs doivent suivent l'ordre défini
# dans la matrice de contact social
#  
test_intervention <- epidemics::intervention(
  #<À COMPLETER>
)
# or
test_intervention <- epidemics::vaccination(
  #<À COMPLETER>
)

test_intervention

# Exécuter {epidemics} ---------------------------------------------------------

# étape: ajouter les arguments de la fonction
# 
# sous la forme d'une liste (pour les interventions contre les contacts ou le
# taux de transmission) ou d'un object (pour la vaccination)
# 
simulate_intervention <- epidemics::model_default(
  population = population_object,
  transmission_rate = transmission_rate,
  infectiousness_rate = infectiousness_rate,
  recovery_rate = recovery_rate,
  # Intervention
  #<À COMPLETER>,
  time_end = 1000,
  increment = 1.0
)

simulate_intervention

# tracer la courbe de tous les compartiments -----------------------------------

# exécuter: coller la figure obtenue dans le rapport

simulate_intervention %>%
  ggplot(aes(
    x = time,
    y = value,
    color = compartment,
    linetype = demography_group
  )) +
  geom_line() +
  geom_vline(
    xintercept = c(test_intervention$time_begin, test_intervention$time_end),
    linetype = "dashed",
    linewidth = 0.2
  ) +
  scale_y_continuous(
    breaks = scales::breaks_pretty(n = 10),
    labels = scales::comma
  )


# pic d'infectiosité -----------------------------------------------------

# exécuter: coller le tableau obtenu dans le rapport

epidemics::epidemic_peak(data = simulate_intervention)

# visualiser les effets des interventions --------------------------------------
# tracer la courbe des nouvelles infections 

# étape: 
# - ajouter le nom de l'intervention
# - s'il s'agit d'une vaccination, alors
# - activer l'argument "exclude_compartments"
# - exécuter et coller la courbe obtenue dans le rapport

infections_baseline <- epidemics::new_infections(
  data = simulate_baseline,
  # exclude_compartments = "vaccinated", # lorsqu'il s'agit d'une vaccination
  by_group = FALSE # si TRUE, alors le résultat sera stratifié par groupe d'âge
)

infections_intervention <- epidemics::new_infections(
  data = simulate_intervention,
  # exclude_compartments = "vaccinated", # lorsqu'il s'agit d'une vaccination
  by_group = FALSE # si TRUE, alors le résultat sera stratifié par groupe d'âge
)

# désigner les noms des scénarios
infections_baseline$scenario <- "Baseline"
infections_intervention$scenario <- "donner le nom de l'intervention" #<À COMPLETER>

# combiner les données de deux scenarios
infections_baseline_intervention <- dplyr::bind_rows(
  infections_baseline, infections_intervention
)

infections_baseline_intervention %>%
  ggplot(aes(
    x = time,
    y = new_infections,
    colour = scenario,
    # linetype = demography_group # si by_group = TRUE
  )) +
  geom_line() +
  geom_vline(
    xintercept = c(test_intervention$time_begin, test_intervention$time_end),
    linetype = "dashed",
    linewidth = 0.2
  ) +
  scale_y_continuous(labels = scales::comma)

# nolint end