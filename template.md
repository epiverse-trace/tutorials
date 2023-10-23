---
title: 'Lesson title'
teaching: 10 # teaching time in minutes
exercises: 5 # exercise time in minutes
---

:::::::::::::::::::::::::::::::::::::: questions 

- What questions will this lesson cover?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Objective 1
- Objective 2

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: prereq

## Prerequisites

List (and hyperlink) the lessons/packages which need to be covered before this lesson

:::::::::::::::::::::::::::::::::


## Introduction

Introductory text

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: instructor

Inline instructor notes can help inform instructors of timing challenges
associated with the lessons. They appear in the "Instructor View".

READ THESE LINES AND ERASE:

The Workbench-related sections that the developer must keep are:

- YAML on top
- Questions
- Objectives
- Keypoints

The Epiverse-TRACE sections that we encourage to keep are:

- Prerequisites
- Introduction

Take a look to the Contributing.md file for more writing guidelines.

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


## Section header

Lesson content

::::::::::::::::::::::::::::::::::::: challenge 

## Challenge 1 : can the learner run existing code

Load contact and population data from socialmixr::polymod

```r
polymod <- socialmixr::polymod
contact_data <- socialmixr::contact_matrix(
  polymod,
  countries = "United Kingdom",
  age.limits = c(0, 20, 40),
  symmetric = TRUE
)
contact_data
```

:::::::::::::::::::::::: solution 

## Output
 

```{.output}
Using POLYMOD social contact data. To cite this in a publication, use the 'get_citation()' function
```

```{.output}
Removing participants that have contacts without age information. To change this behaviour, set the 'missing.contact.age' option
```

```{.output}
$matrix
      contact.age.group
         [0,20)  [20,40)      40+
  [1,] 7.883663 3.120220 3.063895
  [2,] 2.794154 4.854839 4.599893
  [3,] 1.565665 2.624868 5.005571

$demography
   age.group population proportion year
1:    [0,20)   14799290  0.2454816 2005
2:   [20,40)   16526302  0.2741283 2005
3:       40+   28961159  0.4803901 2005

$participants
   age.group participants proportion
1:    [0,20)          404  0.3996044
2:   [20,40)          248  0.2453017
3:       40+          359  0.3550940
```


:::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::


## Section header

Lesson content

::::::::::::::::::::::::::::::::::::: callout
## Explainer
Add additional maths (or epi) content for novice learners

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: challenge 

## Challenge 2 : edit code/answer a question

Load contact and population data for Poland from socialmixr::polymod using the following age bins:

+ [0,15)
+ [15, 50)
+ 50 +

:::::::::::::::::::::::: solution 


```r
polymod <- socialmixr::polymod
contact_data <- socialmixr::contact_matrix(
  polymod,
  countries = "Poland",
  age.limits = c(0, 15, 50),
  symmetric = TRUE
)
```

```{.output}
Using POLYMOD social contact data. To cite this in a publication, use the 'get_citation()' function
```

```{.output}
Removing participants that have contacts without age information. To change this behaviour, set the 'missing.contact.age' option
```

```r
contact_data
```

```{.output}
$matrix
      contact.age.group
          [0,15)   [15,50)      50+
  [1,] 8.4882943  5.047958 1.765826
  [2,] 1.5998125 14.049041 3.624419
  [3,] 0.9468591  6.132289 4.314050

$demography
   age.group population proportion year
1:    [0,15)    6372248  0.1661054 2005
2:   [15,50)   20106632  0.5241197 2005
3:       50+   11883794  0.3097749 2005

$participants
   age.group participants proportion
1:    [0,15)          299  0.2960396
2:   [15,50)          469  0.4643564
3:       50+          242  0.2396040
```
:::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::





::::::::::::::::::::::::::::::::::::: keypoints 

- Summarise the key points of the lesson using bullet points


::::::::::::::::::::::::::::::::::::::::::::::::
