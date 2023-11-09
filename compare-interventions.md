---
title: 'Comparing public health outcomes of interventions'
teaching: 45 # teaching time in minutes
exercises: 30 # exercise time in minutes

---



:::::::::::::::::::::::::::::::::::::: questions 

- How can I quantify the effect of an intervention?

 
::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Understand how to compare intervention scenarios

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: prereq

## Prerequisites
+ Complete tutorials [Simulating transmission](../episodes/simulating-transmission.md) and [Modelling interventions](../episodes/modelling-interventions.md)

This tutorial has the following concept dependencies:

**Outbreak response** : [Intervention types](https://www.cdc.gov/nonpharmaceutical-interventions/).
:::::::::::::::::::::::::::::::::


## Introduction

In this tutorial we will compare intervention scenarios against each other. To quantify the effect of the intervention we need to compare our intervention scenario to a counter factual scenario. The *counter factual* is the scenario in which nothing changes, often referred to as the 'do nothing' scenario. The counter factual scenario may include no interventions, or if we are investigating the potential impact of an additional intervention in the later stages of an outbreak there may be existing interventions in place. 

We must also decide what our *outcome of interest* is to make comparisons between intervention and counter factual scenarios. The outcome of interest can be:

+ a model outcome, e.g. number of infections or hospitalisations,
+ a metric such as the epidemic peak time or size,
+ a measure that uses the model outcomes such as QALY/DALYs.


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: instructor

In this tutorial we introduce the concept of the counter factual and how to compare scenarios (counter factual versus intervention) against each other. 

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

## Vacamole model

The Vacamole model is a deterministic model based on a system of ODEs in [Ainslie et al. 2022]( https://doi.org/10.2807/1560-7917.ES.2022.27.44.2101090). The model consists of 11 compartments, individuals are classed as one of the following:

+ susceptible, $S$,
+ partial vaccination ($V_1$), fully vaccination ($V_2$),
+ exposed, $E$ and exposed while vaccinated, $E_V$,
+ infectious, $I$ and infectious while vaccinated, $I_V$,
+ hospitalised, $H$ and hospitalised while vaccinated, $H_V$,
+ dead, $D$,
+ recovered, $R$.

The diagram below describes the flow of individuals through the different compartments. 

<img src="fig/compare-interventions-rendered-unnamed-chunk-1-1.png" style="display: block; margin: auto;" />

See `?epidemics::model_vacamole_cpp` for detail on how to run the model. 

## Comparing scenarios

*Coming soon*

## Challenge

*Coming soon*

<!-- ::::::::::::::::::::::::::::::::::::: challenge -->

<!-- ## The effect of vaccination on COVID-19 hospitalisations   -->



<!-- ::::::::::::::::: hint -->

<!-- ### HINT -->


<!-- :::::::::::::::::::::: -->


<!-- ::::::::::::::::: solution -->

<!-- ### SOLUTION -->





<!-- ::::::::::::::::::::::::::: -->


<!-- :::::::::::::::::::::::::::::::::::::::::::::::: -->



::::::::::::::::::::::::::::::::::::: keypoints 

- The counter factual scenario must be defined to make comparisons

::::::::::::::::::::::::::::::::::::::::::::::::
