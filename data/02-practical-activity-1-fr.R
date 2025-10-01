# nolint start

# Pratique 2
# Activité 1

# étape : indiquez votre numéro de chambre
room_number <- #<COMPLETE> remplacer par 1/2/3/4

# Charger les paquets -----------------------------------------------------------
library(epiparameter)
library(EpiNow2)
library(tidyverse)


# Lire les cas signalés -----------------------------------------------------
# étape : Coller les liens URL sous forme de chaîne pour lire les données d'entrée.

# pour covid
dat <- read_rds(
  "paste/link/url/here/covid"#<COMPLETE>
) %>%
  dplyr::select(date, confirm)
# ou
# for ebola
dat <- read_rds(
  "paste/link/url/here/ebola"#<COMPLETE>
) %>%
  dplyr::select(date, confirm = cases)


# Vérifier le format des données d'incidence ----------------------------------------
# étape : Vérifier les noms des colonnes dans les données d'incidence
# correspondre aux exigences d'EpiNow2 concernant les noms des colonnes : date et confirmer

dat

# Définir un temps de génération de {epiparameter} à {EpiNow2} ---------------

# étape : accéder à un intervalle sériel
dat_serialint <- epiparameter::epiparameter_db(
  #<COMPLETE>
)

# étape : extraire les paramètres de l'objet {epiparameter}
dat_serialint_params <- epiparameter::#<COMPLETE>

# étape : adapter {epiparamètre} à l'interface de distribution {EpiNow2}
dat_generationtime <- EpiNow2::#<COMPLETE>


# Définir les délais entre l'infection et la déclaration du cas pour {EpiNow2} -----------

# étape : définir le délai entre l'apparition des symptômes et la déclaration du cas
# Vous devez interprétez la description fournie dans le tableau Entrées

dat_reportdelay <- EpiNow2::#<COMPLETE>

# étape : définir un délai entre l'infection et l'apparition des symptômes
dat_incubationtime <- epiparameter::epiparameter_db(
  #<COMPLETE>
)

# étape : période d'incubation : extraire les paramètres de distribution
dat_incubationtime_params <- epiparameter::#<COMPLETE>

# étape : période d'incubation : discrétiser et extraire la valeur maximale (p = 99 %)
dat_incubationtime_max <- dat_incubationtime %>% #<COMPLETE>

# étape : période d'incubation : adaptation à l'interface de distribution {EpiNow2}
dat_incubationtime_epinow <- EpiNow2::#<COMPLETE>

# étape : impression des données requises
dat_generationtime
dat_reportdelay
dat_incubationtime_epinow


# Définir le nombre de cœurs parallèles pour {EpiNow2} --------------------------
# étape : exécuter cette étape de configuration

withr::local_options(list(mc.cores = parallel::detectCores() - 1))


# Estimer la transmission à l'aide de EpiNow2::epinow() ---------------------------
# étape : exécuter epinow() en utilisant les cas d'incidence et les délais requis
# avec les fonctions EpiNow2::*_opts() pour le temps de génération, les délais et stan.

estimates <- EpiNow2::epinow(
  data = dat,
  #<COMPLETE>
  stan = EpiNow2::stan_opts(samples = 1000, chains = 3)
)


# Imprimer les résultats du graphique et du tableau récapitulatif ------------------------------------
# étape : coller les résultats du graphique et du tableau dans le document partagé

summary(estimates)
plot(estimates)

# étape : répondre aux questions dans le document

# nolint end