# simMSM
### R package to generate data suitable for Marginal Structural Cox Model fit
* This package simulates data suitable for fitting Marginal Structural Model.

## Installation
```R
library(devtools)
install_github("ehsanx/simMSM")
```

## Loading the package
```R
require(simMSM)
```

## Pulling the help file
```R
?simmsm
```

## Setting working directory to save the generated datafiles
```R
setwd("C:/data") # change working dir
```

## Using simmsm command to generate data in the wording directory
```R
simmsm(subjects = 2500, tpoints = 10, psi = 0.3, n = 5)
```
- [x] *subjects*: Number of Subjects in each simulated dataset
- [x] *tpoints*: Maximum number of time-points each subjects are followed
- [x] *psi*: Causal effect parameter for Marginal Structural Model
- [x] *n*: Number of simulated datasets an user wants to generate

|    **Item**    | **Status** |
|----------------|------------|
| *subjects*  | :Number of Subjects in each simulated dataset: |
| *tpoints*      | :Maximum number of time-points each subjects are followed:   |
| *psi* | :Causal effect parameter for Marginal Structural Model:  |
| *n* | :Number of simulated datasets an user wants to generate:  |

### Author 
* Ehsan Karim (R porting from SAS)

### Original Paper
* Young J.G., Hernan M.A., Picciotto S., and Robins J.M. [Relation between three classes of structural models for the effect of a time-varying exposure on survival](http://link.springer.com/article/10.1007/s10985-009-9135-3). Lifetime Data Analysis, 16(1):71-84, 2010. 
