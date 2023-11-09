---
title: 'Choosing an appropriate model'
teaching: 10 # teaching time in minutes
exercises: 20 # exercise time in minutes

---




:::::::::::::::::::::::::::::::::::::: questions 

- How do I choose a model for my task?


::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Learn how to access the model library in `epidemics`
- Understand the model requirements for a question 

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: prereq

## Prerequisites
+ Complete tutorial [Simulating transmission](../episodes/simulating-transmission.md)
:::::::::::::::::::::::::::::::::


## Introduction

Using mathematical models in outbreak analysis does not necessarily require developing a new model. There are existing models for different infections, interventions and transmission patterns which can be used to answer new questions. In this tutorial, we will learn how to choose an existing model to generate predictions for a given scenario.

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: instructor

The focus of this tutorial is understanding existing models to decide if they are appropriate for a defined question. 

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

### Choosing a model 

When deciding whether an existing model can be used, we must consider :

+ What is the infection/disease of interest? 

A model may already exist for your study disease, or there may be a model for an infection that has the same transmission pathways and epidemiological features that can be used. 

+ Do we need a [deterministic](../learners/reference.md#deterministic) or [stochastic](../learners/reference.md#stochastic) model? 

Model structures differ for whether the disease has pandemic potential or not. When predicted numbers of infection are small, stochastic variation in output can have an effect on whether an outbreak takes off or not. Outbreaks are usually smaller in magnitude than epidemics, so its often appropriate to use a stochastic model to characterise the uncertainty in the early stages of the outbreak. Epidemics are larger in magnitude than outbreaks and so a deterministic model is suitable as we have less interest in the stochastic variation in output. 

+ What is the outcome of interest?

The outcome of interest can be a feature of a mathematical model. It may be that you are interested in the predicted numbers of infection through time, or in a specific outcome such as hospitalisations or cases of severe disease.

+ Will any interventions be modelled? 

Finally, interventions such as vaccination may be of interest. A model may or may not have the capability to include the impact of different interventions on different time scales (continuous time or at discrete time points). We will discuss interventions in detail in the next tutorial.

### Available  models
 
The R package `epidemics` contains functions to run existing models.
For details on the models that are available, see the package [vignettes](https://epiverse-trace.github.io/epidemics/articles). To learn how to run the models in R, read the documentation using `?epidemics::epidemic_ebola`. Remember to use the 'Check model equation' questions to help your understanding of an  existing model. 

::::::::::::::::::::::::::::::::::::: checklist
### Check model equations

- How is transmission modelled? e.g. direct or indirect, airborne or vector-borne
- What interventions are modelled? 
- What state variables are there and how do they relate to assumptions about infection?

::::::::::::::::::::::::::::::::::::::::::::::::



## Challenge

::::::::::::::::::::::::::::::::::::: challenge

## What model?

You have been asked to explore the variation in numbers of infected individuals in the early stages of an Ebola outbreak. 

Which of the following models would be an appropriate choice for this task:

+  `epidemic_default`

+ `epidemic_ebola`

::::::::::::::::: hint

### HINT

Consider the following questions:

::::::::::::::::::::::::::::::::::::: checklist

+ What is the infection/disease of interest? 
+ Do we need a deterministic or stochastic model? 
+ What is the outcome of interest?
+ Will any interventions be modelled? 

::::::::::::::::::::::::::::::::::::::::::::::::


::::::::::::::::::::::


::::::::::::::::: solution

### SOLUTION


+ What is the infection/disease of interest? **Ebola**
+ Do we need a deterministic or stochastic model?  **A stochastic model would allow us to explore variation in the early stages of the outbreak**
+ What is the outcome of interest? **Number of infections**
+ Will any interventions be modelled? **No**

#### `epidemic_default`

A deterministic SEIR model with age specific direct transmission. 

<!--html_preserve--><div class="grViz html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-133f080a5048e6f8c46b" style="width:504px;height:504px;"></div>
<script type="application/json" data-for="htmlwidget-133f080a5048e6f8c46b">{"x":{"diagram":"digraph {\n  # graph statement\n  #################\n  graph [layout = dot,\n         rankdir = LR,\n         overlap = true,\n         fontsize = 10]\n  # nodes\n  #######\n  node [shape = square,\n       fixedsize = true,\n       width = 1.3]\n       S\n       E\n       I\n       R\n\n  # edges\n  #######\n  S -> E [label = \" infection\"]\n  E -> I [label = \" onset of \ninfectiousness\"]\n  I -> R [label = \" recovery\"]\n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


The model is capable of predicting an Ebola type outbreak, but as the model is deterministic, we are not able to explore stochastic variation in the early stages of the outbreak.


#### `epidemic_ebola`

A stochastic SEIHFR (Susceptible, Exposed, Infectious, Hospitalised, Funeral, Removed) model that was developed specifically for infection with Ebola.

<!--html_preserve--><div class="grViz html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-2bce1f548a563a09141f" style="width:504px;height:504px;"></div>
<script type="application/json" data-for="htmlwidget-2bce1f548a563a09141f">{"x":{"diagram":"digraph {\n\n  # graph statement\n  #################\n  graph [layout = dot,\n  rankdir = LR,\n  overlap = true,\n  fontsize = 10]\n\n  # nodes\n  #######\n  node [shape = square,\n       fixedsize = true\n       width = 1.3]\n\n       S\n       E\n       I\n       H\n       F\n       R\n\n  # edges\n  #######\n  S -> E [label = \" infection \"]\n  E -> I [label = \" onset of \ninfectiousness\"]\n  I -> F [label = \" death \n(funeral) \"]\n  F -> R [label = \" safe burial\"]\n  I -> H [label = \" hospitalisation\"]\n  H -> R [label = \" recovery or \nsafe burial\"]\n\n  subgraph {\n    rank = same; I; F;\n  }\n  subgraph {\n    rank = same; H; R;\n  }\n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->



As this model is stochastic, it is the most appropriate choice to explore how variation in numbers of infected individuals in the early stages of an Ebola outbreak. 


:::::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::::::::::::::



::::::::::::::::::::::::::::::::::::: keypoints 

- Existing models can be used for new questions
- Check that a model has appropriate assumptions about transmission, outbreak potential, outcomes and interventions 
::::::::::::::::::::::::::::::::::::::::::::::::
