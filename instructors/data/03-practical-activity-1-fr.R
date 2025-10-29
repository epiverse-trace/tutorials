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
  "link/to/contact/data/url" #<À COMPLETER>
)

dat_linelist <- readr::read_rds(
  "link/to/linelist/data/url" #<À COMPLETER>
)


# Créer un objet de type epicontacts -------------------------------------------
# étape : Créez un réseau de contacts *dirigé* à l'aide
# des données de cas et contacts.
# Collez une capture d'écran du réseau dans le rapport.

epi_contacts <- epicontacts::#<À COMPLETER>

# voir un aperçu de l'objet créé
epi_contacts

# Visualiser le réseau de contacts
plot(epi_contacts)


# Compter les cas secondaires par individu -----------------------------------------
# étape : Calculez le *degré sortant* pour chaque nœud (cas infectieux)
# dans le réseau de contacts, en utilisant *tous* les cas observés dans le
# tableau de données.
# Collez l'histogramme obtenu dans le rapport.

secondary_cases <- epicontacts::#<À COMPLETER>

# Tracer l'histogramme des cas secondaires
individual_reproduction_num <- secondary_cases %>%
  enframe() %>%
  ggplot(aes(value)) +
  geom_histogram(binwidth = 1) +
  labs(
    x = "Nombre de cas secondaires",
    y = "Fréquence"
  )

# voir un aperçu du graphe
individual_reproduction_num


# Ajuster une distribution binomiale négative -----------------------------------
# étape : Utilisez le vecteur avec le nombre de cas secondaires engendrés par
# chaque cas infectieux pour ajuster une distribution binomiale négative à
# l'aide de {fitdistrplus}.
# Collez les paramètres de sortie dans le rapport.

offspring_fit <- #<À COMPLETER>

# voir un aperçu de l'objet créé
offspring_fit


# Estimer la proportion de nouveaux cas à partir d'un groupe de cas secondaires ----
# étape : Utilisez {superspreading} pour calculer la probabilité (proportion)
# de nouveaux cas provenant d'un cluster d'une taille donnée (taille du cluster),
# en utilisant comme données d'entrée les paramètres de distribution des descendants :
# le nombre de reproduction et la dispersion.
# Collez le résultat obtenu dans le rapport.

# Définir le générateur de nombres aléatoires
set.seed(33)

# Estimer la probabilité que de nouveaux cas proviennent d'un groupe de
# transmission d'au moins 5, 10 ou 25 cas
proportion_cases_by_cluster_size <- #<À COMPLETER>

# voir un aperçu du résultat
proportion_cases_by_cluster_size

# nolint end
