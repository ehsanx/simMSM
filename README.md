# simMSM: an R package to generate data suitable for Marginal Structural Cox Model fit

## Installation
* library(devtools)
* install_github("ehsanx/simMSM")

## Loading the package
* require(simMSM)

## Pulling the help file
* ?simmsm

## Setting working directory to save the generated datafiles
* setwd("C:/data") # change working dir

## Using simmsm command to generate data in the wording directory
* simmsm(subjects = 2500, tpoints = 10, psi = 0.3, n = 5)
