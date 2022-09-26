# simMSM
#### Maintainer: *Ehsan Karim* 
I am a big fan of **scientific collaboration**. Feel free to [contact me](http://www.ehsankarim.com) to discuss your causal inference related projects for potential collaboration.
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

## Estimation of parameter

```R
require(simMSM)
simmsm(subjects = 10000, tpoints = 10, psi = 0.3, n = 1)
aggregate.data <- read.csv("r1.csv")
head(aggregate.data)
#  id tpoint tpoint2       T0 IT0      chk Y Ym A Am1 L Lm1 Am1L       pAt  T maxT        pL psi
#1  1      1       0 75.51818   0 1.000000 0  0 0   0 0   0    0 0.2222222 NA   10 0.3000000 0.3
#2  1      2       1 75.51818   0 2.000000 0  0 0   0 1   0    0 0.3202196 NA   10 0.3000000 0.3
#3  1      3       2 75.51818   0 3.349859 0  0 1   0 1   1    0 0.4371436 NA   10 0.3913043 0.3
#4  1      4       3 75.51818   0 4.699718 0  0 1   1 0   1    0 0.6532898 NA   10 0.2432432 0.3
#5  1      5       4 75.51818   0 6.049576 0  0 1   1 0   0    0 0.5333333 NA   10 0.1764706 0.3
#6  1      6       5 75.51818   0 7.049576 0  0 0   1 0   0    0 0.5333333 NA   10 0.1764706 0.3
#  select.seed.valx
#1                1
#2                1
#3                1
#4                1
#5                1
#6                1
# helper function to extract results
ext.cox <- function(fit){
  x <- summary(fit)
  b.se <- ifelse(x$used.robust == TRUE, x$coef["A","robust se"], x$coef["A","se(coef)"])
  if (is.null(fit$weights)) {
    res <- as.numeric(c(x$n, x$nevent, x$coef["A","coef"], b.se, 
                        confint(fit)["A",],x$coef["A", "Pr(>|z|)"], x$used.robust,
                        rep(NA,3) ))
  } else {
    res <- as.numeric(c(x$n, x$nevent, x$coef["A","coef"], b.se, 
                        confint(fit)["A",],x$coef["A", "Pr(>|z|)"], x$used.robust,
                        mean(fit$weights), range(fit$weights) ))
  }
  names(res) <- c("n", "events", "coef", "se", "lowerci", "upperci", "pval", "robust", "meanW", "minW", "maxW")
  return(res)
}

ww <- glm(A ~ tpoint + L + Am1 + Lm1, family = binomial(logit), data = aggregate.data)
# Step 2: Weight numerator model
ww0 <- glm(A ~ tpoint + Am1, family = binomial(logit), data = aggregate.data)
# Step 3: Obtain fir from the weight models
aggregate.data$wwp <- with(aggregate.data, ifelse(A == 0, 1 - fitted(ww), fitted(ww)))
aggregate.data$wwp0 <- with(aggregate.data, ifelse(A == 0, 1 - fitted(ww0),fitted(ww0)))
# Step 4: time-dependent weights
aggregate.data$w <- unlist(tapply(1/aggregate.data$wwp, aggregate.data$id, cumprod))
aggregate.data$sw <- unlist(tapply(aggregate.data$wwp0/aggregate.data$wwp, aggregate.data$id, cumprod))
summary(aggregate.data$sw)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.1396  0.7329  0.9091  1.0013  1.1788  6.2040 
require(survival)
# Step 5: Weighted outcome model
fit.msm.w <- coxph(Surv(tpoint2, tpoint, Y) ~ A + cluster(id), data = aggregate.data, weight = w, robust =TRUE)
ext.cox(fit.msm.w)
fit.msm <- coxph(Surv(tpoint2, tpoint, Y) ~ A + cluster(id), data = aggregate.data, weight = sw, robust =TRUE)
ext.cox(fit.msm)
#           n       events         coef           se      lowerci      upperci         pval       robust 
#9.481300e+04 1.147000e+03 3.341396e-01 6.882629e-02 1.992425e-01 4.690367e-01 1.204931e-06 1.000000e+00 
#       meanW         minW         maxW 
#1.001264e+00 1.395881e-01 6.203989e+00 
# Note that log-odds is 0.3, and you are getting back an estimate of 0.3341396
# Comparison with unweighted models
fit.cox <- coxph(Surv(tpoint2, tpoint, Y) ~ A + cluster(id), data = aggregate.data, robust =TRUE)
ext.cox(fit.cox)
fit.cox.adj <- coxph(Surv(tpoint2, tpoint, Y) ~ A + L + cluster(id), data = aggregate.data, robust =TRUE)
ext.cox(fit.cox.adj)
```

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
