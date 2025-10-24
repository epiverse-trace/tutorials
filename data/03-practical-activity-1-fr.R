# nolint start

# Practical 3
# Activity 1

# étape: donner le numéro du groupe
room_number <- #<À COMPLETER> replace with 1/2/3/4

# Load packages -----------------------------------------------------------
library(epicontacts)
library(fitdistrplus)
library(tidyverse)


# Importer les données d'entrées------------------------------------------------
# étape : copier et coller le lien fourni dans le fichier google doc.

dat_contacts <- readr::read_rds(
  "link/to/contact/data/url"#<À COMPLETER>
)

dat_linelist <- readr::read_rds(
  "link/to/linelist/data/url"#<À COMPLETER>
)


# Créer un objet de type epicontacts -------------------------------------------
# étape : Créez un réseau de contacts *dirigé* à l'aide 
# des données saisies dans la liste de lignes et les contacts.
# Collez une capture d'écran du réseau dans le rapport.

epi_contacts <- epicontacts::#<À COMPLETER>

# Imprimer la sortie
epi_contacts

# Visualiser le réseau de contacts
contact_network <- epicontacts::#<À COMPLÉTER>

# Imprimer la sortie
contact_network


# Compter les cas secondaires par sujet -----------------------------------------
# étape : Calculez le *degré sortant* pour chaque nœud (cas infectieux)
# dans le réseau de contacts, en utilisant *tous* les cas observés dans la liste.
# Collez l'histogramme obtenu dans le rapport.

secondary_cases <- epicontacts::#<À COMPLETER>

# Tracer l'histogramme des cas secondaires
individual_reproduction_num <- secondary_cases %>%
  enframe() %>% 
  ggplot(aes(value)) +
  geom_histogram(binwidth = 1) +
  labs(
    x = "Number of secondary cases",
    y = "Frequency"
  )

# Imprimer la sortie
individual_reproduction_num


# Ajuster une distribution binomiale négative -----------------------------------
# étape : Utilisez le vecteur avec le nombre de cas secondaires par cas infectieux
# pour ajuster une distribution binomiale négative à l'aide de {fitdistrplus}.
# Collez les paramètres de sortie dans le rapport.

offspring_fit <- #<À COMPLETER>

# Imprimer la sortie
offspring_fit


# Estimer la proportion de nouveaux cas à partir d'un groupe de cas secondaires ----
# étape : Utilisez {superspreading} pour calculer la probabilité (proportion)
# de nouveaux cas provenant d'un cluster d'une taille donnée (taille du cluster),
# en utilisant comme données d'entrée les paramètres de distribution des descendants :
# le nombre de reproduction et la dispersion.
# Collez le résultat obtenu dans le rapport.

# Définir la graine pour le générateur de nombres aléatoires
set.seed(33)

# Estimer la probabilité de nouveaux cas provenant d'
# un groupe de transmission d'au moins 5, 10 ou 25 cas
proportion_cases_by_cluster_size <- #<À COMPLETER>

# Imprimer la sortie
proportion_cases_by_cluster_size

# nolint end