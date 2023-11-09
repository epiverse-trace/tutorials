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

<!--html_preserve--><div class="grViz html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-ca6af240f574fa8839fc" style="width:504px;height:504px;"></div>
<script type="application/json" data-for="htmlwidget-ca6af240f574fa8839fc">{"x":{"diagram":"digraph{\n  # graph statement\n  #################\n  graph [layout = dot,\n         rankdir = LR,\n         overlap = true,\n         fontsize = 10]\n\n  # nodes\n  #######\n  node [shape = square,\n       fixedsize = true\n       width = 1.3]\n\n       S\n       E\n       Ev [label = <E<FONT POINT-SIZE=\"8\"><SUB>V<\/SUB><\/FONT>>, style = filled, fillcolour = \"gray\"]\n       I\n       Iv [label = <I<FONT POINT-SIZE=\"8\"><SUB>V<\/SUB><\/FONT>>, style = filled, fillcolour = \"gray\"]\n       H\n       Hv [label = <H<FONT POINT-SIZE=\"8\"><SUB>V<\/SUB><\/FONT>>, style = filled, fillcolour = \"gray\"]\n       D\n       R\n       V1 [label = <V<FONT POINT-SIZE=\"8\"><SUB>1<\/SUB><\/FONT>>, style = filled, fillcolour = \"gray\"]\n       V2 [label = <V<FONT POINT-SIZE=\"8\"><SUB>2<\/SUB><\/FONT>>, style = filled, fillcolour = \"gray\"]\n\n\n  # edges\n  #######\n  S -> E [label = \" infection (&beta;) \"]\n  S -> V1 [label = \" vaccination (&nu;1)\"]\n  V1 -> E [label = \" infection (&beta;)\"]\n  V1 -> V2 [label = \" vaccination\n(second dose) (&nu;2)\"]\n  V2 -> Ev [label = \" infection (&beta;)\"]\n  Ev -> Iv [label = \" onset of \ninfectiousness (&alpha;) \"]\n  E -> I [label = \" onset of \ninfectiousness (&alpha;) \"]\n  I -> H [label = \" hospitalisation (&eta;)\"]\n  Iv -> Hv [label = < hospitalisation (&eta;<FONT POINT-SIZE=\"8\"><SUB>V<\/SUB><\/FONT>)>]\n  I -> D [label = \" death (&omega;)\"]\n  I -> R [label = \" recovery (&gamma;)\"]\n  Iv -> D [label = < death (&omega;<FONT POINT-SIZE=\"8\"><SUB>V<\/SUB><\/FONT>)>]\n  Iv -> R [label = \" recovery (&gamma;)\"]\n  Hv -> D [label = < death (&omega;<FONT POINT-SIZE=\"8\"><SUB>V<\/SUB><\/FONT>)>]\n  Hv -> R [label = \" recovery (&gamma;)\"]\n  H -> D [label = \" death (&omega;)\"]\n  H -> R [label = \" recovery (&gamma;)\"]\n\n  subgraph {\n  rank = same; S; V1;V2;\n  }\n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

See `?epidemics::epidemic_vacamole` for detail on how to run the model. 

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
