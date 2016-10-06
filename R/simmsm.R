#' @title Function for Simulating Data for Marginal Structural Model
#'
#' @description Simulates data suitable for fitting Marginal Structural Model.
#' @author Ehsan Karim (R porting from SAS)
#' @references Young J.G., Hernan M.A., Picciotto S., and Robins J.M. Relation between three classes of structural models for the effect of a time-varying exposure on survival. Lifetime Data Analysis, 16(1):71-84, 2010.
#' @param subjects Number of Subjects in each simulated dataset
#' @param tpoints Maximum number of time-points each subjects are followed
#' @param psi Causal effect parameter for Marginal Structural Model
#' @param n Number of simulated datasets an user wants to generate
#' @keywords Simulation, Marginal Structural Model
#' @return NULL



simmsm <- function(subjects = 2500, tpoints = 10, psi = .3, n = 5){
  # subjects= number of subjects
  # tpoints= maximum number of measurements for each subject
  # psi true psi
  # n = number of simulated datasets
  # small  <- subjects < 2500
  cat("Datasets being saved in:", getwd(), "\n")
  for (select.seed.val  in 1:n){
    # seeds
    #gamma =parameters for L
    gamma0 = log(3/7)
    gamma1 = 2
    gamma2 = log(0.5)
    gamma3 = log(1.5)
    #alpha = parameters for A
    alpha0= log(2/7)
    alpha1=0.5
    alpha2 = 0.5
    alpha3 = log(4)
    cut=30;
    lam=0.01 #scale parameter for weibull
    shape=1 #shape parameter for weibull

    outputx <- NULL
    set.seed(select.seed.val)

    pb <- txtProgressBar(min = 0, max = subjects, style = 3)

    for (id in 1:subjects){
      expvar = rexp(1, rate = 1)
      T0 = (expvar/(lam^shape))^(1/shape)
      if (T0<cut) {IT0=1} else {IT0=0}
      maxT = tpoints
      initA = NA
      C1time = NA
      C2time = NA

      L = double(tpoints)
      A = double(tpoints)
      Y = double(tpoints)
      Ym = double(tpoints)
      pA = double(tpoints)
      pL = double(tpoints)
      chk = double(tpoints)
      ty = double(tpoints)
      Cense = double(tpoints)
      Cens  = double(tpoints)
      pcens = double(tpoints)
      pcense = double(tpoints)

      time = 1.0
      j = 1
      Ym[1]=0

      logitL = gamma0 + gamma1 * IT0
      pL[1] = 1/(1+(1/exp(logitL)))
      if (pL[1]==1) {L[1] = 1} else {L[1] = rbinom(1,1,pL[1])}

      logitA = alpha0 + alpha1 * L[1]
      pA[1] = 1/(1+(1/exp(logitA)))
      A[1] = rbinom(1,1,pA[1])

      # generate Y's
      chk[1] = exp(psi*A[1])
      if (T0 > chk[1]) {
        Y[1]=0
        ty[1]=NA
      } else {
        Y[1]=1
        ty[1] = T0*exp(-psi*A[1])
      }

      j = 1
      Cense[1] = 0
      Cens[1] = 0
      pcens[1] = 0


      for (j in 2:tpoints){
        time = j
        if (!is.na(C2time) & j == C2time) {j = tpoints}
        if (!is.na(C1time) & j == C1time) {j = tpoints}
        Ym[j]=Y[j-1]

        logitL = gamma0 + gamma1 * IT0 + gamma2 * A[j-1] + gamma3 * L[j-1]
        pL[j]=exp(logitL)/(1+exp(logitL))

        if (pL[j] == 1) {L[j] = 1} else {L[j] = rbinom(1,1,pL[j])}

        logitA = alpha0 + alpha1 * L[j] + alpha2 * L[j-1] + alpha3 * A[j-1]
        pA[j]=exp(logitA)/(1+exp(logitA))
        pp= pA[j]
        A[j] = rbinom(1,1,pA[j])

        if (A[j]==1) {time=j}
        if (Ym[j]==1) {
          A[j]=0
          L[j]=0
        }

        # generate Y's
        chk[j] = chk[j-1] + exp(psi*A[j])

        if (T0 > chk[j]) {
          Y[j]=0
          ty[j]=NA
        } else {
          Y[j]=1
          if (Ym[j]==1) {ty[j]<-ty[j-1]} else {ty[j]<-(j-1)+((T0-chk[j-1])*exp(-psi*A[j]))}
        }

        Cense[j] = Cense[1]
        Cens[j] = 0
        pcens[j] = 0
        pcense[j] = pcense[1]
        cens_1 = Cens[j]

      } #end j = 2 to tpoints

      if (is.na(ty[tpoints])) {
        C1time = tpoints
        C2time = tpoints
      } else {
        C1time = ceiling(ty[tpoints])
        C2time = ceiling(ty[tpoints])
      }

      time_used = min(C1time,C2time);

      idx = double(time_used)
      Lx = double(time_used)
      Ax = double(time_used)
      Yx = double(time_used)
      Ymx = double(time_used)
      Lm1 = double(time_used)
      Am1 = double(time_used)
      Am1L = double(time_used)
      pA_tx = double(time_used)
      pLx = double(time_used)
      chkx = double(time_used)
      Tx = double(time_used)
      tpointx = double(time_used)
      tpoint2x = double(time_used)
      T0x = double(time_used)
      IT0x = double(time_used)
      maxTx = double(time_used)
      censor1 = double(time_used)
      censor2 = double(time_used)
      select.seed.valx= double(time_used)

      for (tpoint in 1:time_used){
        tpoint2 = tpoint-1
        T0x[tpoint]=T0
        IT0x[tpoint]=IT0
        tpointx[tpoint]=tpoint
        tpoint2x[tpoint]=tpoint2
        idx[tpoint]=id
        Lx[tpoint]=L[tpoint]
        chkx[tpoint]=chk[tpoint]
        pLx[tpoint] = pL[tpoint]
        Ax[tpoint]=A[tpoint]
        pA_tx[tpoint]=pA[tpoint]
        if (tpoint==1) {Am1[tpoint]<-0} else {Am1[tpoint]<-A[tpoint-1]}
        if (tpoint==1) {Lm1[tpoint]<-0} else {Lm1[tpoint]<-L[tpoint-1]}
        Am1L[tpoint] = Am1[tpoint]*Lx[tpoint]

        censor1[tpoint] = Cens[tpoint]
        censor2[tpoint] = Cense[tpoint]

        Ymx[tpoint] = Ym[tpoint]
        select.seed.valx[tpoint] = select.seed.val

        if (time_used < tpoints) {
          if (tpoint < time_used) {Yx[tpoint] = Y[tpoint]} else {Yx[tpoint] = 1}
        } else { if (time_used == tpoints) {Yx[tpoint] = Y[tpoint]} }

        Tx[tpoint]=ty[maxT]
        maxTx[tpoint] = maxT

      } # end of tpoint loop

      output <- cbind(idx, tpointx, tpoint2x, T0x, IT0x, chkx, Yx, Ymx, Ax, Am1, Lx, Lm1, Am1L, pA_tx, Tx, maxTx, pLx, psi, select.seed.valx)
      dimnames(output) <- list(NULL,c("id" ,"tpoint" ,"tpoint2" ,"T0" ,"IT0" ,"chk" ,"Y" ,"Ym" ,"A" ,"Am1" ,"L" ,"Lm1" ,"Am1L" ,"pAt" , "T", "maxT", "pL", "psi", "select.seed.valx"))
      #if (small) {
      outputx <- rbind(outputx, output)
      #}
      #if (small == FALSE) {
      #  write.csv(output, file = paste("rid", id, ".csv", sep = ""), row.names = F)
      #  rm(output)
      #}
      setTxtProgressBar(pb, id)
    } # end of id loop
    close(pb)

    #if (small) {
    dataset2 <- as.data.frame(outputx)
    write.csv(dataset2, file = paste("r", dataset2$select.seed.valx[1], ".csv", sep = ""), row.names = F)
    #}
    cat("Output created for iteration", dataset2$select.seed.valx[1], "\n")
  }
  cat("Datasets being saved in:", getwd(), "\n")
  return(NULL)
}
