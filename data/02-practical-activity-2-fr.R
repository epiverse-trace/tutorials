# nolint start

# Practical 2
# Activity 1

# étape: donner le numéro du groupe
room_number <- #<À COMPLETER> replace with 1/2/3/4

# charger les packages ---------------------------------------------------------
library(cfr)
library(epiparameter)
library(tidyverse)


# Importer les données d'entrées------------------------------------------------
# étape: copier et coller le lien fourni dans le fichier google doc.
disease_dat <- readr::read_rds(
  #<À COMPLETER>
)

disease_dat


# Créer un objet de type incidence ---------------------------------------------
# étape: compléter les arguments nécessaires pour obtenir l'incidence des cas et
# de décès.
disease_incidence <- disease_dat %>%
  incidence2::incidence(
    #<À COMPLETER>
  )

plot(disease_incidence)


# Confirmer le format des données d'entrées pour {cfr} -------------------------

# étape: vérifier si les noms de colonnes dans les données d'incidence sont
# conformes aux noms requis par {cfr}:
# date, cases, deaths

disease_dat

# Est-ce que les données d'entrées sont conformes au format attendu par {cfr} ?
# Si oui, utiliser:
disease_adapted <- disease_dat
# OU
# Si no, utiliser `cfr::prepare_data()` pour l'adapter:
disease_adapted <- disease_incidence %>%
  cfr::prepare_data(
    #<À COMPLETER>
  )

disease_adapted

# Accéder aux functions de distribution de délais ------------------------------
# étape: Accéder aux distributions de probability de délais entre apparition des
# symptomes et le décès.

# De quel délai a t-on besoin pour ajuster le RL? (dépend de la maladie)
disease_delay <- epiparameter::#<À COMPLETER>


# Estimer le RL naïf and ajusté aux délais -------------------------------------
# étape: Estimation du RL naïf and ajusté aux délais.

# Estimer le RL naïf static
disease_adapted %>%
  cfr::cfr_static()

# Estimer le RL static ajusté au délai
disease_adapted %>%
  cfr::cfr_static(
    delay_density = #<À COMPLETER>
  )

# étape: copier et coller les résultats obtenus, et répondre aux questions.

# nolint end
