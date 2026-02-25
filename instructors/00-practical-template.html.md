---
title: "Week 2: Name"
format: 
  html: # learners solutions
    embed-resources: true
  docx: default # learners practical
  gfm: default # instructors
keep-md: true
format-links: false
---








::: {.content-hidden when-format="html"}

<!-- visible for instructors only -->
<!-- practical-week.md is generated from practical-week.qmd. Please edit that file -->
<!-- commit .md and .qmd files together -->

<!-- does not work for instructors text messages -->

:::

::: {.content-hidden when-format="docx"}

<!-- works for text on html and MD only -->

This practical is based in the following tutorial episodes:

- <link/episode>
- <link/episode>


:::



Welcome!

- A reminder of our [Code of Conduct](https://github.com/epiverse-trace/.github/blob/main/CODE_OF_CONDUCT.md). If you experience or witness unacceptable behaviour, or have any other concerns, please notify the course organisers or host of the event. To report an issue involving one of the organisers, please use the [LSHTM’s Report and Support tool](https://reportandsupport.lshtm.ac.uk/).

| **Roll call** (Confirm you can edit) |
|---|
| - Your name + Find an emoji writing only a double-colon “**:**”  (+ Add room number) |

# Read This First

<!-- visible for learners and instructors at practical -->

Instructions:

- Each `Activity` has five sections: the Goal, Questions, Steps, Inputs, and Your Answers.
- Solve each Activity in the corresponding `.R` file mentioned in the `Steps` section.
- Paste your figure and table outputs and write your answer to the questions in the section `Your Answers`.
- Choose one room member to share your room's results with the rest of the participants.

| **Room** | **Write the room member names** |
|---|---|
| 1 |  |
| 2 |  |
| 3 |  |
| 4 |  |

Remember:

During the practical, instead of simply copying and pasting, we encourage learners to increase their fluency in writing R by using:

- **The double-colon notation**, e.g. `package::function()`, to specify which package a function comes from, avoid namespace conflicts, and find functions using keywords.
- **Tab key <kbd>↹</kbd>** 
to [autocomplete package or function names](https://support.posit.co/hc/en-us/articles/205273297-Code-Completion-in-the-RStudio-IDE) and [display possible arguments](https://docs.posit.co/ide/user/ide/guide/code/console.html).
- [**R shortcuts**](https://positron.posit.co/keyboard-shortcuts.html#r-shortcuts) to 
    - Insert the pipe operator (`%>%`) using `Ctrl/Cmd`+`Shift`+`M`, 
    - Insert the assignment operator (`<-`) using `Alt/Option`+`-`, and 
    - [Execute one line of code](https://docs.posit.co/ide/user/ide/guide/code/execution.html) or multiple lines connected by the pipe operator (`%>%`) by placing the cursor in the code of interest and pressing `Ctrl`+`Enter`.
- **The `help()` function** or `?` operator to access the [function reference manual](https://www.r-project.org/help.html).

If your local configuration was not possible to set up:

- Create one copy of the [Posit Cloud RStudio project](https://posit.cloud/content/10566863).

<!-- - Create one copy of the [Posit Cloud RStudio project](https://posit.cloud/spaces/609790/join?access_code=hPM1tIeKt5ax_Y-P0lMGVUGqzFPNH4wxkKSzXZYb). -->

## Paste your !Error messages here

Participants, if you get an unexpected message in the console. Copy and paste it into this section.

```







```




## Activity 1: Theme

Estimate ... using the following available inputs:

- input 1
- input 2

As a group, Write your answers to these questions:

- ... phase?
- ... results expected?
- Interpret: How would you communicate these results to a decision-maker?
- Compare: What differences do you identify from other group outputs? (if available)

### Inputs

| Group | Incidence | Link |
|---|---|---|
| 1 | COVID 30 days | <https://epiverse-trace.github.io/tutorials-middle/data/covid_30days.rds> |
| 2 | Ebola 35 days |  |
| 3 | Ebola 60 days |  |
| 4 | COVID 60 days |  |


| Disease | params |
|---|---|
| Ebola | ... |
| COVID | ... |

: {tbl-colwidths="[15,85]"}

::: {.content-visible when-format="docx"}

### Code chunk

```r
# Load packages -----------------------------------------------------------
library(epiparameter)
library(EpiNow2)
library(tidyverse)


# Read reported cases -----------------------------------------------------

# faded code

```

### Your answers

Group 1

| output | paste here |
|---|---|
| figure |  |
| table |  |

Write your answers to the questions above:

```







```


------------------------

Group 2

| output | paste here |
|---|---|
| figure |  |
| table |  |

Write your answers to the questions above:

```







```


------------------------

Group 3

| output | paste here |
|---|---|
| figure |  |
| table |  |

Write your answers to the questions above:

```







```


------------------------

Group 4

| output | paste here |
|---|---|
| figure |  |
| table |  |

Write your answers to the questions above:

```







```
:::

::: {.content-visible unless-format="docx"}

### Solution

<!-- visible for instructors and learners after practical (solutions) -->

#### Code





::: {.cell}

```{.r .cell-code}
# Load packages -----------------------------------------------------------
library(epiparameter)
library(EpiNow2)
library(tidyverse)

# Read reported cases -----------------------------------------------------

# runnable howto-like
```
:::






#### Outputs

##### Group 4: COVID 60 days

With reporting delay plus Incubation time:
![image](https://hackmd.io/_uploads/S1q6ItjvC.png){width=50%}

With reporting delay plus Incubation time:
```
> summary(covid60_epinow_delays)
                            measure               estimate
                             <char>                 <char>
1:           New infections per day     1987 (760 -- 4566)
2: Expected change in daily reports      Likely decreasing
3:       Effective reproduction no.     0.81 (0.43 -- 1.3)
4:                   Rate of growth -0.047 (-0.2 -- 0.092)
5:     Doubling/halving time (days)      -15 (7.5 -- -3.5)
```

#### Interpretation

Interpretation template:

+ From the summary of our analysis we see that the expected change in reports is 
`Likely decreasing` with the estimated new infections, on average, of
`1987` with 90% credible interval of `760` to `4566`.

+ ...

Interpretation Helpers:

- About the effective reproduction number:
    - An Rt greater than 1 implies an increase in cases or an epidemic. 
    - An Rt less than 1 implies a decrease in cases or extinction.
- ...


# Continue your learning path

<!-- Suggest learners to Epiverse-TRACE documentation or external resources --->

Where

- <link> 

:::

# end