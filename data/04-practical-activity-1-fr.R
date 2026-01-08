# nolint start

# Activité pratique 4
# Activité 1

# étape: compléter le numéro du groupe
room_number <- #<À COMPLÉTER> remplacer avec 1/2/3/4
  
# charger les packages ----------------------------------------------------
library(epidemics)
library(socialmixr)
library(tidyverse)


# (1) matrice des contacts ------------------------------------------------------

# remarque: tous les paramètres sont issus du tableau des paramètres
# qui se trouve dans le fichier avec les activités pratiques

# étape: coller le lien correspondant à l'enquête assignée à votre groupe
# puis exécuter la fonction pour télécharger les données de contacts sociaux
socialsurvey <- socialmixr::get_survey(
  #<À COMPLÉTER>
)

socialsurvey

# étape: créer la matrice de contacts en définissant:
# - l'objet de classe <survey> que vous venez de créer,
# - le nom du pays, 
# - les limites d'âge, comme mentionnés dans le tableau des paramètres, et
# - TRUE ou FALSE pour créer une matrice symétrique.
contact_data <- socialmixr::contact_matrix(
  #<À COMPLÉTER>
)

contact_data

# exécuter la commande suivante pour confirmer la symmétrie de la matrice
# La matrice du nombre total de contact est une matrice symétrique.
# Le nombre total de contacts des individus d'un groupe à un autre est le même
# dans toutes les directions.
# Vérifier la symmétrie en multipliant le nombre moyen de contacts la taille de
# la population de chaque groupe.
contact_data$matrix * contact_data$demography$proportion

# Exécuter la commande ci-dessous pour préparer la matrice de contacts
#
# - {socialmixr} fournit une matrice du type de-à: de-participants -> à-contacts
#   les participants à une enquête révèle leurs contacts.
#
# - {epidemics} prend en entrée une matrice du type à-de: à-contacts <- de-participants
#   Les modèles supposent que chaque personne susceptible (contact) est exposée
#   à l'infection en fonction de la fréquence à laquelle elle est contactée
#   (par les participants) et du degré d'infectiosité (des participants).
# 
socialcontact_matrix <- t(contact_data$matrix)

socialcontact_matrix

# (2) Les conditions initiales  --------------------------------------------------

## Population indectieuse ---------

# étape: compléter la proportion d'individus infectieux
# selon le tableau des paramètres
initial_i <- #<À COMPLÉTER>
  
# Exécuter la commande ci-dessous pour créer le vecteur de conditions initiales
initial_conditions_inf <- c(
  S = 1 - initial_i,
  E = 0,
  I = initial_i,
  R = 0,
  V = 0
)

initial_conditions_inf

## Une population exempt d'infections ---------

# Exécuter la commande ci-dessous pour créer le vecteur de conditions initiales
# dans une population exempt d'infections
initial_conditions_free <- c(
  S = 1,
  E = 0,
  I = 0,
  R = 0,
  V = 0
)

initial_conditions_free

## Combiner les conditions initiales ------------

# Remarque: toute la population n’a pas besoin d’être contagieuse.
# L’épidémie peut débuter par une infection au sein d’une tranche d’âge
# spécifique.

# étape: Combiner les conditions initiales 
# Associer 'initial_conditions_inf' or 'initial_conditions_free' à chaque
# groupe selon le tableau des paramètres
initial_conditions <- base::rbind(
  #<À COMPLÉTER>, # groupe d'âge 1
  #<À COMPLÉTER>, # groupe d'âge 2
  #<À COMPLÉTER> # groupe d'âge 3
)

# Exécuter la commande ci-dessous pour renommer les groupes d'âge en utilisant
# les noms de lignes de la matrice de contact
rownames(initial_conditions) <- rownames(socialcontact_matrix)

initial_conditions

# (3) La structure de la population ------------------------------------------------

# Exécuter la commande ci-dessous pour préparer le vecteur de demographie
demography_vector <- contact_data$demography$population
names(demography_vector) <- rownames(socialcontact_matrix)

# étape: Préparer la population à modéliser en spécifiant:
# - le nom du pays, 
# - la matrice de contact symmétrique et transposée,
# - le vecteur avec la taille de la population de chaque groupe d'âge
# - la matrice des conditions initiales pour chaque groupe d'âge
population_object <- epidemics::population(
  #<À COMPLÉTER>
)

population_object

# (4) Les paramètres du modèle ----------------------------------------------------

# étape: définir les paramètres spécifiques à la maladie: les taux
# compléter les valeurs correspondantes selon le tableau des paramètres
infectiousness_rate <- 1 / #<À COMPLÉTER> # 1/pre-infectious period
recovery_rate <- 1 / #<À COMPLÉTER> # 1/infectious period
transmission_rate <- recovery_rate * #<À COMPLÉTER> # recovery rate * R0
  
  
# (5) Exécuter le modèle --------------------------------------------------------

# étape: donner les valeurs des arguments de la fonction
# - l'objet de classe <population>
# - chacun des taux spécifiques à la maladie définis précédemment
# - le temps de simulation fournit dans le tableau des paramètres
simulate_baseline <- epidemics::model_default(
  #<À COMPLÉTER>
)

simulate_baseline


# (6) Tracer la courbe de tous les compartiments ------------------------------------------------

# Exécuter la commande ci-dessous et coller la courbe dans votre rapport

# courbe du nombre total d'individus par compartiment au cours du temps
simulate_baseline %>%
  ggplot(aes(
    x = time,
    y = value,
    color = compartment,
    linetype = demography_group
  )) +
  geom_line() +
  scale_y_continuous(
    breaks = scales::breaks_pretty(n = 10),
    labels = scales::comma
  )

# (7) Pic d'infectiosité -------------------------------------------------

# Exécuter la commande ci-dessous et coller le tableau obtenu dans le rapport

# Tableau de l'ampleur et de la durée du pic épidémique par groupe démographique
epidemics::epidemic_peak(data = simulate_baseline)


# (8) Tracer la courbe des nouvelles infections -------------------------------------------------

# Exécuter la commande ci-dessous et coller le résultat obtenu dans le rapport

# Nouvelles infections par groupe démographique dans le temps
newinfections_bygroup <- epidemics::new_infections(data = simulate_baseline)

# Visualisez la propagation de l'épidémie en termes de nouvelles infections
newinfections_bygroup %>%
  ggplot(aes(time, new_infections, colour = demography_group)) +
  geom_line() +
  scale_y_continuous(
    breaks = scales::breaks_pretty(n = 10),
    labels = scales::comma
  )

# nolint end