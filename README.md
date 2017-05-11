# simMSM
#### Maintainer: *Ehsan Karim*: http://www.ehsankarim.com 
#### I am a big fan of *scientific collaboration*. Feel free to contact me to discuss potential projects where I could help.
### R package to generate data suitable for Marginal Structural Cox Model fit
* This package simulates survival data suitable for fitting Marginal Structural Model.

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

## Using this package to generate data in the working directory
```R
simmsm(subjects = 2500, tpoints = 10, psi = 0.3, n = 1000)
# This code generates 1000 datasets (takes time!)
# 2500 subjects in each datasets
# Each subject followed upto 10 time-points (say, months)
# Causal effect (log-odds) is 0.3
```
|    **Parameter**    | **Description** |
|----------------|------------|
| *subjects*  | Number of Subjects in each simulated dataset |
| *tpoints*      | Maximum number of time-points each subjects are followed   |
| *psi* | Causal effect parameter for Marginal Structural Model  |
| *n* | Number of simulated datasets an user wants to generate  |

### Author 
* Ehsan Karim :octocat: (only R porting from the [SAS](https://cdn1.sph.harvard.edu/wp-content/uploads/sites/148/2012/10/simulate_snaftm.txt) code). I wrote them in R basically to understand the mechanism, but the SAS / SAS IML / Stata codes (I have them as well, available upon request) are faster than this. Feel free to [report](http://www.ehsankarim.com/) any errors / update suggestions. 

### Original Papers
- [x] Young J.G., Hernan M.A., Picciotto S., and Robins J.M. [Relation between three classes of structural models for the effect of a time-varying exposure on survival](http://link.springer.com/article/10.1007/s10985-009-9135-3). Lifetime Data Analysis, 16(1):71-84, 2010. 
- [ ] Young, Jessica G., et al. Simulation from structural survival models under complex time-varying data structures. JSM proceedings, section on statistics in epidemiology. American Statistical Association, Denver, CO (2008)

### Follow-up References
- [ ] Ali R.A., Ali M.A., and Wei Z. [On computing standard errors for marginal structural cox models](http://link.springer.com/article/10.1007%2Fs10985-013-9255-7). Lifetime data analysis, pages 1–26, 2013. doi: 10.1007/s10985-013-9255-7.
- [ ] Xiao Y., Abrahamowicz M., and Moodie E.E.M. [Accuracy of conventional and marginal structural Cox model estimators: A simulation study](http://www.degruyter.com/view/j/ijb.2010.6.2/ijb.2010.6.2.1208/ijb.2010.6.2.1208.xml?format=INT). The International Journal of Biostatistics, 6(2):1–28, 2010. 
- [ ] Karim, M. E.; Petkau, J.; Gustafson, P.; Platt, R.; Tremlett, H. and BeAMS study group. [Comparison of Statistical Approaches Dealing with Time-dependent Confounding in Drug Eﬀectiveness Studies](http://smm.sagepub.com/content/early/2016/09/21/0962280216668554.abstract). Statistical Methods in Medical Research. First published online: September 21. doi: 10.1177/0962280216668554
- [ ] Karim, M. E.; Petkau, J.; Gustafson, P.; Tremlett, H. and BeAMS study group. [On the application of statistical learning approaches to construct inverse probability weights in marginal structural Cox models: hedging against weight-model misspeciﬁcation](http://www.tandfonline.com/toc/lssp20/current). Communications in Statistics - Simulation and Computation (In Press).

### Related web-Apps
- [x] [Causal Inference Web-Apps](http://www.ehsankarim.com/software/webapps)
