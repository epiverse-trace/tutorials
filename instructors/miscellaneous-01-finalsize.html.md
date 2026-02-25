---
title: "Session 1: Epidemic Final Size"
format: 
  html: # learners solutions
    embed-resources: true
  docx: default # learners practical
  gfm: default # instructors
keep-md: true
execute: 
  cache: true
format-links: false
---










<!-- works for text on html and MD only -->

This practical session focuses on calculating the expected final size of an epidemic for:

- a homogeneous (well-mixed); and
- heterogeneous populations with demographic differences in social contact patterns and susceptibility to infection.



## Epidemic Final Size for a Homogeneous Population

In this section, we calculate the epidemic final size for a homogeneous (well-mixed) population, which is  characterized solely by the basic reproduction number, $( R_0 )$.

The code chunk below uses the `finalsize()` function from the `{finalsize}` package to compute the expected final size when $( R_0 = 1.5 )$.







::: {.cell}

```{.r .cell-code}
# Load packages -----------------------------------------------------------
library(finalsize)

finalsize::final_size(1.5)
```

::: {.cell-output .cell-output-stdout}

```
    demo_grp   susc_grp susceptibility p_infected
1 demo_grp_1 susc_grp_1              1  0.5828132
```


:::
:::






### Interpretation

The estimated epidemic final size is reported in the `p_infected` column, which represents the proportion of individuals expected to be infected over the course of the epidemic.

For $R_0 = 1.5$, the estimated final size proportion is $0.5828132$, meaning that approximately $58\%$ of the population is expected to become infected by the end of the outbreak. 

::::{.callout-note}
## Exercise #1
 1. Calculate final size of epidemic in a well-mixed community with $R_0 = 2.3$, and interpret the result?
 2. Compute the corresponding herd immunity threshold?

::::

## Epidemic Final Size for a Heterogeneous Population

In this section, we calculate the epidemic final size for a heterogeneous population with demographic structure. Here, individuals are grouped by demographic characteristics (e.g., age, gender, or economic class), and may differ in:

- population size and composition,

- social contact patterns between and within groups, and

- susceptibility to infection.

These differences influence transmission dynamics and, consequently, the overall and group-specific epidemic final sizes.





::: {.cell}

```{.r .cell-code}
# Load packages -----------------------------------------------------------
library(socialmixr)
library(epidemics)

gam_survey <- socialmixr::get_survey("https://doi.org/10.5281/zenodo.13101862")
contact_data <- socialmixr::contact_matrix(gam_survey,
                                           countries = "Gambia",
                                           age_limits = c(0, 10, 20, 40, 60),
                                           symmetric = TRUE
)
# view the elements of the contact data list
# the contact matrix
contact_data$matrix
```

::: {.cell-output .cell-output-stdout}

```
         contact.age.group
age.group   [0,10)  [10,20)  [20,40)  [40,60)       60+
  [0,10)  5.582535 3.166356 2.966261 1.129670 0.4122642
  [10,20) 4.408645 9.447761 4.023993 1.316608 0.3930872
  [20,40) 3.441827 3.353448 4.630573 1.716340 0.5063502
  [40,60) 3.246096 2.717197 4.250437 2.505618 0.7141843
  60+     3.607269 2.470281 3.818337 2.174720 0.7358491
```


:::

```{.r .cell-code}
#the demography data
contact_data$demography
```

::: {.cell-output .cell-output-stdout}

```
   age.group population proportion  year
      <char>      <num>      <num> <int>
1:    [0,10)     650021 0.32869451  2015
2:   [10,20)     466855 0.23607341  2015
3:   [20,40)     560206 0.28327798  2015
4:   [40,60)     226213 0.11438857  2015
5:       60+      74289 0.03756553  2015
```


:::

```{.r .cell-code}
# get the contact matrix and demography data
contact_matrix <- t(contact_data$matrix)
demography_vector <- contact_data$demography$population
demography_data <- contact_data$demography
```
:::








#### Normalization of the Contact Matrix

The `{finalsize}` package requires a normalized contact matrix to ensure that the overall epidemic dynamics are consistent with the specified value of 
$R_0$. This normalization is carried outt in two steps:

1. **Scaling by the largest eigenvalue**: Divide the contact matrix by its largest eigenvalue (also called the dominant eigenvalue or spectral radius). By doing so, the resulting next-generation matrix has a dominant eigenvalue equal to $R_0$, ensuring that the transmission intensity across demographic groups matches the assumed reproduction number.

2. **Adjusting for group size** divide each row of the contact matrix by the corresponding demography. This reflects the assumption that each individual in group {j} make contacts at random with individuals in group {i}, correctly weighting contacts according to population composition.







::: {.cell}

```{.r .cell-code}
# scale the contact matrix so the largest eigenvalue is 1.0
contact_matrix <- contact_matrix / max(Re(eigen(contact_matrix)$values))

# divide each row of the contact matrix by the corresponding demography
# this reflects the assumption that each individual in group {j} make contacts
# at random with individuals in group {i}
contact_matrix <- contact_matrix / demography_vector

n_demo_grps <- length(demography_vector)
```
:::





#### Susceptibility matrix.

Individuals within each demographic group can be further subdivided into smaller subgroups (e.g., vaccinated and un-vaccinated), with each subgroup having its own level of susceptibility to infection. 

Accordingly, the `{finalsize}` package also requires a **susceptibility matrix** as input. This matrix has:

- rows equal to the number of demographic groups, and

- columns equal to the number of susceptibility groups.

- Each entry represents the proportion of individuals who belong to a given demographic group and susceptibility subgroup, capturing variation in susceptibility within and across demographic groups. 


In our example let us assume we have a full uniform susceptibility, which be modeled as a matrix with values of 1.0, with as many rows as there are demographic groups.





::: {.cell}

```{.r .cell-code}
suscep_matrix <- matrix(
  data = 1.0,
  nrow = n_demo_grps,
  ncol = 1
)
suscep_matrix
```

::: {.cell-output .cell-output-stdout}

```
     [,1]
[1,]    1
[2,]    1
[3,]    1
[4,]    1
[5,]    1
```


:::
:::





In addition, we must specify the proportion of each demographic group that falls into each susceptibility subgroup. This distribution is represented by the **demography–susceptibility** distribution matrix `(p_susc_matrix)`, which has:

 - rows equal to the number of demographic groups,

 - columns equal to the number of susceptibility groups, and

 - rows that each sum to 1.

Each entry gives the proportion of individuals in a given demographic group who belong to a particular susceptibility subgroup. In our special case where there is only one susceptibility group, this matrix reduces to a single-column vector of ones:




::: {.cell}

```{.r .cell-code}
p_suscep_matrix <- matrix(
  data = 1.0,
  nrow = n_demo_grps,
  ncol = 1
)
p_suscep_matrix
```

::: {.cell-output .cell-output-stdout}

```
     [,1]
[1,]    1
[2,]    1
[3,]    1
[4,]    1
[5,]    1
```


:::
:::





#### Calculating Final size

Putting together, now we can run the `final_size()`  with $R_0 = 1.5$





::: {.cell}

```{.r .cell-code}
fs_result <- finalsize::final_size(
  r0 = 1.5,
  contact_matrix = contact_matrix,
  demography_vector = demography_vector,
  susceptibility = suscep_matrix, 
  p_susceptibility = p_suscep_matrix
)
fs_result
```

::: {.cell-output .cell-output-stdout}

```
  demo_grp   susc_grp susceptibility p_infected
1   [0,10) susc_grp_1              1  0.5023614
2  [10,20) susc_grp_1              1  0.6699119
3  [20,40) susc_grp_1              1  0.5140867
4  [40,60) susc_grp_1              1  0.5035685
5      60+ susc_grp_1              1  0.4858792
```


:::
:::





#### Visualize final sizes 

The model returns the proportion of individuals infected in each age (and susceptibility) group during the epidemic. To obtain the final number of individuals infected in each group, multiply the estimated final proportion infected by the total population size of that group.

These results can then be visualized either as:

- proportions infected by group (to compare relative risk), or

- total numbers infected by group (to assess absolute burden).







::: {.cell}

```{.r .cell-code}
library(ggplot2)
# order demographic groups as factors
fs_result$demo_grp <- factor(
  fs_result$demo_grp,
  levels = demography_data$age.group)

# prepare demography data
demography_data <- contact_data$demography

fs_result <- merge(
  fs_result,
  demography_data,
  by.x = "demo_grp",
  by.y = "age.group"
)

# reset age group order
fs_result$demo_grp <- factor(
  fs_result$demo_grp,
  levels = contact_data$demography$age.group
)

# multiply counts with proportion infected
fs_result$n_infected <- fs_result$p_infected*fs_result$population


ggplot(fs_result) +
  geom_col(
    aes(
      x = demo_grp, y = n_infected
    ),
    fill = "grey", col = "black"
  ) +
  expand_limits(
    x = c(0.5, nrow(fs_result) + 0.5)
  ) +
  scale_y_continuous(
    labels = scales::comma_format(
      scale = 1e-6, suffix = "M"
    )
  ) +
  theme_classic() +
  coord_cartesian(
    expand = FALSE
  ) +
  labs(
    x = "Age group",
    y = "Number infected (millions)"
  )
```

::: {.cell-output-display}
![](miscellaneous-01-finalsize_files/figure-html/unnamed-chunk-8-1.png){width=672}
:::
:::






::::{.callout-note}

## Exercise #2

1. Calculate the final size of an epidemic in Italy under the following assumptions:
     - $R_0=2.4$
    - Demographic groups defined by age categories: `c(0, 30, 50)`
    - A single susceptibility group
    - Susceptibility vector: `c(0.5, 0.75, 1)`

2. Visualize the proportion infected in each demographic group.

3. Visualize the total number infected in each demographic group.

::::
