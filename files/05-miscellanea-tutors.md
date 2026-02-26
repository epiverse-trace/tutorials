# Session 1: Epidemic Final Size & Herd Immunity Threshold


<!-- visible for instructors only -->

<!-- practical-week.md is generated from practical-week.qmd. Please edit that file -->

<!-- commit .md and .qmd files together -->

<!-- does not work for instructors text messages -->

<!-- works for text on html and MD only -->

This practical is based on the following tutorial episodes:

- <https://epiverse-trace.github.io/tutorials-middle/quantify-transmissibility.html>
- <https://epiverse-trace.github.io/tutorials-late/contact-matrices.html>

This practical session focuses on calculating the expected final size of
an epidemic for:

- homogeneous (well-mixed) populations; and
- heterogeneous populations with demographic differences in social
  contact patterns and susceptibility to infection.

In addition, it also covers how to compute the herd immunity threshold
for a homogeneous population.

## Epidemic Final Size for a Homogeneous Population

In this section, we calculate the epidemic final size for a homogeneous
(well-mixed) population, which is characterized solely by the basic
reproduction number, $( R_0 )$.

The code chunk below uses the `finalsize()` function from the
`{finalsize}` package to compute the expected final size when
$( R_0 = 1.5 )$.

``` r
# Load packages -----------------------------------------------------------
library(finalsize)

finalsize::final_size(1.5)
#>     demo_grp   susc_grp susceptibility p_infected
#> 1 demo_grp_1 susc_grp_1              1  0.5828132
```

### Interpretation

The estimated epidemic final size is reported in the `p_infected`
column, which represents the proportion of individuals expected to be
infected over the course of the epidemic.

For $R_0 = 1.5$, the estimated final size proportion is $0.5828132$,
meaning that approximately $58\%$ of the population is expected to
become infected by the end of the outbreak.

## Herd immunity threshold

The herd immunity threshold (HIT) is given by
$$ HIT = 1- \frac{1}{R_0} $$ In our example, $R_0 = 1.5$, hence the
threshold is $$ HIT= 1 -1/1.5 \sim 0.33.$$

### Interpretation

This means that approximately $33\%$ of the population (about one third)
must be immune in order to prevent sustained transmission and contain
the epidemic under the assumption of a homogeneous, well-mixed
population.

## Activity 1: Calculate final size and herd immunity threshold

**Goal:**

Calculate the final size of the epidemic, and compute the corresponding
herd immunity threshold.

**Questions:**

Within your room, write your answers to these questions:

1.  What us the final size of the epidemic in a well-mixed community for
    the given $R_0$ value, and how do you interpret this result?
2.  What is the corresponding herd-immunity threshold, and how do you
    interpret this result?

### Inputs

| Room | $R_0$ value |
|------|-------------|
| 1    | $1.8$       |
| 2    | $3$         |
| 3    | $0.9$       |

## Epidemic Final Size for a Heterogeneous Population

In this section, we calculate the epidemic final size for a
heterogeneous population with demographic structure. Here, individuals
are grouped by demographic characteristics (e.g., age, gender, or
economic class), and may differ in:

- population size and composition,

- social contact patterns between and within groups, and

- susceptibility to infection.

These differences influence transmission dynamics and, consequently, the
overall and group-specific epidemic final sizes.

``` r
# Load packages -----------------------------------------------------------
library(socialmixr)
library(epidemics)

gam_survey <- socialmixr::get_survey("https://doi.org/10.5281/zenodo.13101862")
contact_data <- socialmixr::contact_matrix(
  gam_survey,
  countries = "Gambia",
  age_limits = c(0, 10, 20, 40, 60),
  symmetric = TRUE
)
# view the elements of the contact data list
# the contact matrix
contact_data$matrix
#>          contact.age.group
#> age.group   [0,10)  [10,20)  [20,40)  [40,60)       60+
#>   [0,10)  5.582535 3.166356 2.966261 1.129670 0.4122642
#>   [10,20) 4.408645 9.447761 4.023993 1.316608 0.3930872
#>   [20,40) 3.441827 3.353448 4.630573 1.716340 0.5063502
#>   [40,60) 3.246096 2.717197 4.250437 2.505618 0.7141843
#>   60+     3.607269 2.470281 3.818337 2.174720 0.7358491

#the demography data
contact_data$demography
#>    age.group population proportion  year
#>       <char>      <num>      <num> <int>
#> 1:    [0,10)     650021 0.32869451  2015
#> 2:   [10,20)     466855 0.23607341  2015
#> 3:   [20,40)     560206 0.28327798  2015
#> 4:   [40,60)     226213 0.11438857  2015
#> 5:       60+      74289 0.03756553  2015

# get the contact matrix and demography data
contact_matrix <- t(contact_data$matrix)
demography_vector <- contact_data$demography$population
demography_data <- contact_data$demography
```

#### Normalization of the Contact Matrix

The `{finalsize}` package requires a normalized contact matrix to ensure
that the overall epidemic dynamics are consistent with the specified
value of $R_0$. This normalization is carried outt in two steps:

1.  **Scaling by the largest eigenvalue**: Divide the contact matrix by
    its largest eigenvalue (also called the dominant eigenvalue or
    spectral radius). By doing so, the resulting next-generation matrix
    has a dominant eigenvalue equal to $R_0$, ensuring that the
    transmission intensity across demographic groups matches the assumed
    reproduction number.

2.  **Adjusting for group size** divide each row of the contact matrix
    by the corresponding demography. This reflects the assumption that
    each individual in group {j} make contacts at random with
    individuals in group {i}, correctly weighting contacts according to
    population composition.

``` r
# scale the contact matrix so the largest eigenvalue is 1.0
contact_matrix <- contact_matrix / max(Re(eigen(contact_matrix)$values))

# divide each row of the contact matrix by the corresponding demography
# this reflects the assumption that each individual in group {j} make contacts
# at random with individuals in group {i}
contact_matrix <- contact_matrix / demography_vector

n_demo_grps <- length(demography_vector)
```

#### Susceptibility matrix.

Individuals within each demographic group can be further subdivided into
smaller subgroups (e.g., vaccinated and un-vaccinated), with each
subgroup having its own level of susceptibility to infection.

Accordingly, the `{finalsize}` package also requires a **susceptibility
matrix** as input. This matrix has:

- rows equal to the number of demographic groups, and

- columns equal to the number of susceptibility groups.

- Each entry represents the proportion of individuals who belong to a
  given demographic group and susceptibility subgroup, capturing
  variation in susceptibility within and across demographic groups.

In our example let us assume we have a full uniform susceptibility,
which be modeled as a matrix with values of 1.0, with as many rows as
there are demographic groups.

``` r
suscep_matrix <- matrix(
  data = 1.0,
  nrow = n_demo_grps,
  ncol = 1
)
suscep_matrix
#>      [,1]
#> [1,]    1
#> [2,]    1
#> [3,]    1
#> [4,]    1
#> [5,]    1
```

In addition, we must specify the proportion of each demographic group
that falls into each susceptibility subgroup. This distribution is
represented by the **demography–susceptibility** distribution matrix
`(p_susc_matrix)`, which has:

- rows equal to the number of demographic groups,

- columns equal to the number of susceptibility groups, and

- rows that each sum to 1.

Each entry gives the proportion of individuals in a given demographic
group who belong to a particular susceptibility subgroup. In our special
case where there is only one susceptibility group, this matrix reduces
to a single-column vector of ones:

``` r
p_suscep_matrix <- matrix(
  data = 1.0,
  nrow = n_demo_grps,
  ncol = 1
)
p_suscep_matrix
#>      [,1]
#> [1,]    1
#> [2,]    1
#> [3,]    1
#> [4,]    1
#> [5,]    1
```

#### Calculating Final size

Putting together, now we can run the `final_size()` with $R_0 = 1.5$

``` r
fs_result <- finalsize::final_size(
  r0 = 1.5,
  contact_matrix = contact_matrix,
  demography_vector = demography_vector,
  susceptibility = suscep_matrix, 
  p_susceptibility = p_suscep_matrix
)
fs_result
#>   demo_grp   susc_grp susceptibility p_infected
#> 1   [0,10) susc_grp_1              1  0.5023614
#> 2  [10,20) susc_grp_1              1  0.6699119
#> 3  [20,40) susc_grp_1              1  0.5140867
#> 4  [40,60) susc_grp_1              1  0.5035685
#> 5      60+ susc_grp_1              1  0.4858792
```

#### Visualize final sizes

The model returns the proportion of individuals infected in each age
(and susceptibility) group during the epidemic. To obtain the final
number of individuals infected in each group, multiply the estimated
final proportion infected by the total population size of that group.

These results can then be visualized either as:

- proportions of infected by group (to compare relative risk), or

- total numbers of infected by group (to assess absolute burden).

``` r
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

![](05-miscellanea-tutors_files/figure-commonmark/unnamed-chunk-8-1.png)

## Activity 2: Final Size for Heterogeneous Population

**Goal:**

Calculate and visualize the final size of an epidemic for a population
with structure under given assumptions

**Steps:**

- Open the file `05-miscellanea-activity-2.R` and complete all the lines
  marked with `#<COMPLETE>`, following the detailed steps provided
  within the R file.

- First, extract contact data, and demography data from **polymod**
  survey.

- Second, transpose and normalize contact matrix.

- Third, create susceptibility, and demography-susceptibility
  distribution matrices

- Fourth, calculate final sizes

- Fifth, visualize the proportion infected in each demographic group.

- Sixth, visualize the total number infected in each demographic group.

- Paste your outputs.

### Inputs

Use assumptions assigned to your room.

| Room | $R_0$ | Country | Age groups | \#of susceptibility groups | susceptibility level |
|----|----|----|----|----|----|
| 1 | $1.8$ | Italy | {0, 30, 50, 80} | 1 | 1 |
| 2 | $3.0$ | Germany | {0, 20, 40, 60} | 1 | 1 |
| 3 | $0.9$ | Netherlands | {0, 30, 50, 70} | 1 | 1 |

# Continue your learning path

<!-- Suggest learners to Epiverse-TRACE documentation or external resources --->

Explore more about epidemic final size and herd immunity threshold

- <https://epiverse-trace.github.io/finalsize/index.html>

- Andreasen, Viggo. 2011. “The Final Size of an Epidemic and Its
  Relation to the Basic Reproduction Number.” <em>Bulletin of
  Mathematical Biology</em> 73 (10): 2305–2321.
  <a href="https://doi.org/10.1007/s11538-010-9623-3" target="_blank">
  https://doi.org/10.1007/s11538-010-9623-3 </a>.

- Bidari, Subekshya, Xinying Chen, Daniel Peters, Dylanger Pittman, and
  Péter L. Simon. 2016. “Solvability of Implicit Final Size Equations
  for SIR Epidemic Models.” <em>Mathematical Biosciences</em> 282
  (December): 181–190.
  <a href="https://doi.org/10.1016/j.mbs.2016.10.012" target="_blank">
  https://doi.org/10.1016/j.mbs.2016.10.012 </a>.

- Kucharski, Adam J., Kin O. Kwok, Vivian W. I. Wei, Benjamin J.
  Cowling, Jonathan M. Read, Justin Lessler, Derek A. Cummings, and
  Steven Riley. 2014. “The Contribution of Social Behaviour to the
  Transmission of Influenza A in a Human Population.” <em>PLoS
  Pathogens</em> 10 (6): e1004206.
  <a href="https://doi.org/10.1371/journal.ppat.1004206" target="_blank">
  https://doi.org/10.1371/journal.ppat.1004206 </a>.

- Miller, Joel C. 2012. “A Note on the Derivation of Epidemic Final
  Sizes.” <em>Bulletin of Mathematical Biology</em> 74 (9): 2125–2141.
  <a href="https://doi.org/10.1007/s11538-012-9749-6" target="_blank">
  https://doi.org/10.1007/s11538-012-9749-6 </a>.

- Anderson, Roy M., and Robert M. May. 1991. <em>Infectious Diseases of
  Humans: Dynamics and Control.</em> Oxford: Oxford University Press.

# end
