---
title: 'Modelling interventions'
teaching: 45 # teaching time in minutes
exercises: 30 # exercise time in minutes

---



:::::::::::::::::::::::::::::::::::::: questions 

- How do I investigate the effect of interventions on disease trajectories? 


::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Learn how to implement pharmaceutical and non-pharmaceutical interventions

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: prereq

## Prerequisites
+ Complete tutorial [Simulating transmission](../episodes/simulating-transmission.md)

This tutorial has the following concept dependencies:

**Outbreak response** : [Intervention types](https://www.cdc.gov/nonpharmaceutical-interventions/).
:::::::::::::::::::::::::::::::::


## Introduction

Mathematical models can be used to generate predictions for the implementation of non-pharmaceutical and pharmaceutical interventions at different stages of an outbreak. In this tutorial, we will introduce how to include different interventions in models.

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: instructor

In this tutorial different types of intervention and how they can be modelled are introduced. Learners should be able to understand the underlying mechanism of these interventions (e.g. reduce contact rate) as well as how to implement the code to include such interventions.

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

## Non-pharmaceutical interventions

Non-pharmaceutical interventions (NPIs) are measures put in place to reduce transmission that do not include taking medicine or vaccines. NPIs aim reduce contact between infectious and susceptible individuals. For example, washing hands, wearing masks and closures of school and workplaces.

In mathematical modelling, we must make assumptions about how NPIs will affect transmission. This may include adding additional disease states or reducing the value of relevant parameters. 

#### Effect of school closures on COVID-19 spread




We want to investigate the effect of school closures on reducing the number of individuals infectious with COVID-19 through time. We assume that a school closure will reduce the frequency of contacts within and between different age groups. 

Using an SEIR model (`model_default_cpp()` in the R package `{epidemics}`) we set $R_0 = 2.7$, preinfectious period $= 4$ and the infectious_period $= 5.5$ (parameters adapted from [Davies et al. (2020)](https://doi.org/10.1016/S2468-2667(20)30133-X)). We load a contact matrix with age bins 0-18, 18-65, 65 years and older using `{socialmixr}` and assume that one in every 1 million in each age group is infectious at the start of the epidemic.

We will assume that school closures will reduce the contacts between school aged children (aged 0-15) by 0.5, and will cause a small reduction (0.01) in the contacts between adults (aged 15 and over). 

::::::::::::::::::::::::::::::::::::: callout
### Effect of interventions on contacts

The contact matrix is scaled down by proportions for the period in which the intervention is in place. To explain the reduction, consider a contact matrix for two age groups with equal number of contacts:


```{.output}
     [,1] [,2]
[1,]    1    1
[2,]    1    1
```

If the reduction is 50% in group 1 and 10% in group 2, the contact matrix during the intervention will be:


```{.output}
     [,1] [,2]
[1,] 0.25 0.45
[2,] 0.45 0.81
```

The contacts within group 1 are reduced by 50% twice to accommodate for a 50% reduction in outgoing and incoming contacts ($1\times 0.5 \times 0.5 = 0.25$). Similarly, the contacts within group 2 are reduced by 10% twice. The contacts between group 1 and group 2 are reduced by 50% and then by 10% ($1 \times 0.5 \times 0.9= 0.45$). 

::::::::::::::::::::::::::::::::::::::::::::::::

To include an intervention in our model we must create an `intervention` object. The inputs are the name of the intervention (`name`), the type of intervention (`contacts` or `rate`), the start time (`time_begin`), the end time (`time_end`) and the reduction (`reduction`). The values of the reduction matrix are specified in the same order as the age groups in the contact matrix. 


```r
rownames(contact_matrix)
```

```{.output}
[1] "[0,15)"  "[15,65)" "65+"    
```

Therefore, we specify ` reduction = matrix(c(0.5, 0.01, 0.01))`. We assume that the school closures start on day 50 and are in place for a further 100 days. Therefore our intervention object is : 


```r
close_schools <- intervention(
  name = "School closure",
  type = "contacts",
  time_begin = 50,
  time_end = 50 + 100,
  reduction = matrix(c(0.5, 0.01, 0.01))
)
```




To run the model with an intervention we set ` intervention = list(contacts = close_schools)` as follows:


```r
output_school <- model_default_cpp(
  population = uk_population,
  infection = covid,
  intervention = list(contacts = close_schools),
  time_end = 300, increment = 1.0
)
```


We see that with the intervention (solid line) in place, the infection still spreads through the population, though the epidemic peak is smaller than the baseline with no intervention in place (dashed line).

<img src="fig/modelling-interventions-rendered-plot_school-1.png" style="display: block; margin: auto;" />

#### Effect of mask wearing on COVID-19 spread

We can model the effect of other NPIs as reducing the value of relevant parameters. For example, we want to investigate the effect of mask wearing on the number of individuals infectious with COVID-19 through time. 

We expect that mask wearing will reduce an individual's infectiousness. As we are using a population based model, we cannot make changes to individual behaviour and so assume that the transmission rate $\beta$ is reduced by a proportion due to mask wearing in the population. We specify this proportion, $\theta$ as product of the proportion wearing masks multiplied by the proportion reduction in transmissibility (adapted from [Li et al. 2020](https://doi.org/10.1371/journal.pone.0237691))

We create an intervention object with `type = rate` and `reduction = 0.161`. Using parameters adapted from [Li et al. 2020](https://doi.org/10.1371/journal.pone.0237691) we have proportion wearing masks = coverage $\times$ availability = $0.54 \times 0.525 = 0.2835$, proportion reduction in transmissibility = $0.575$. Therefore, $\theta = 0.2835 \times 0.575 = 0.163$. We assume that the mask wearing mandate starts at day 40 and is in place for 200 days.


```r
mask_mandate <- intervention(
  name = "mask mandate",
  type = "rate",
  time_begin = 40,
  time_end = 40 + 200,
  reduction = 0.163
)
```

To implement this intervention on the parameter $\beta$, we specify `intervention = list(beta = mask_mandate)`.


```r
output_masks <- model_default_cpp(
  population = uk_population,
  infection = covid,
  intervention = list(beta = mask_mandate),
  time_end = 300, increment = 1.0
)
```



<img src="fig/modelling-interventions-rendered-plot_masks-1.png" style="display: block; margin: auto;" />


## Pharmaceutical interventions

Models can be used to investigate the effect of pharmaceutical interventions, such as vaccination. In this case, it is useful to add another disease state to track the number of vaccinated individuals through time. The diagram below shows an SEIRV model where susceptible individuals are vaccinated and then move to the $V$ class.

<img src="fig/modelling-interventions-rendered-diagram_SEIRV-1.png" style="display: block; margin: auto;" />

The equations describing this model are as follows: 

$$
\begin{aligned}
\frac{dS_i}{dt} & = - \beta S_i \sum_j C_{i,j} I_j -\nu_{t} S_i \\
\frac{dE_i}{dt} &= \beta S_i\sum_j C_{i,j} I_j - \alpha E_i \\
\frac{dI_i}{dt} &= \alpha E_i - \gamma I_i \\
\frac{dR_i}{dt} &=\gamma I_i \\
\frac{dV_i}{dt} & =\nu_{i,t} S_i\\
\end{aligned}
$$
Individuals are vaccinated at an age group ($i$) specific time dependent ($t$) vaccination rate ($\nu$). The SEIR components of these equations are described in the tutorial Simulating transmission. 

To explore the effect of vaccination we need to create a vaccination object. As vaccination is age group specific, we must pass an age groups specific vaccination rate $\nu$ and age group specific start and end times of the vaccination program. Here we will assume all age groups are vaccinated at the same rate and that the vaccination program starts on day 40 and is in place for 150 days.



```r
# prepare a vaccination object
vaccinate <- vaccination(
  name = "vaccinate all",
  time_begin = matrix(40, nrow(contact_matrix)),
  time_end = matrix(40 + 150, nrow(contact_matrix)),
  nu = matrix(c(0.01, 0.01, 0.01))
)
```

We pass our vaccination object using `vaccination = vaccinate`:


```r
output_vaccinate <- model_default_cpp(
  population = uk_population,
  infection = covid,
  vaccination = vaccinate,
  time_end = 300, increment = 1.0
)
```

Here we see that the total number of infectious individuals when vaccination is in place is much lower compared to school closures and mask wearing interventions. 

<img src="fig/modelling-interventions-rendered-plot_vaccinate-1.png" style="display: block; margin: auto;" />


## Summary

Modelling interventions requires assumptions of how interventions affect model parameters such as contact matrices or parameter values. Next we want quantify the effect of an interventions. In the next tutorial, we will learn how to compare intervention scenarios against each other. 


::::::::::::::::::::::::::::::::::::: keypoints 

- Different types of intervention can be implemented using mathematical modelling

::::::::::::::::::::::::::::::::::::::::::::::::
