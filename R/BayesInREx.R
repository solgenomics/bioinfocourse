int=20
b <- rep(0, 2001)
    b[1] = 3.4
    i = 1
    while (i <= int) {
        bv = rnorm(1, 0, 30)
        index = sample(seq(2:2001), 1)
        b[index] = bv
        i = i + 1
    }

ppa2<-runif(2000)
nsb=200
re_b=b
ppa_start=ppa2
testPi=1
mcmc=2000

BayesInREx<-function(nsb,re_b,ppa_start,testPi, mcmc)
{

    nsubjects=nsb
    nmarkers = 2000
    numiter = mcmc
    pi = testPi
    vara = 1/20
    logPi = log(pi)
    logPiComp = log(1 - pi)
    mean2pq = 0.5
    nua = 4
    cat("Simulation of Bayes\n")
    
    data<-matrix(sample(c(0,1,2),nsubjects*nmarkers,replace=T),nrow=nsubjects,ncol = nmarkers , byrow = TRUE)

    
    nrecords = dim(data)[1]
    startMarker = 1
    x = cbind(1, data[, startMarker:nmarkers])
    
    b=re_b
    y = x %*% b + rnorm(nsubjects)
    oldy = y
    oldb = b
    
    storePi = array(0, numiter)
    nmarkers = nmarkers - startMarker + 1
    varEffects = vara/(nmarkers * (1 - pi) * mean2pq)
    scalec = varEffects * (nua - 2)/nua
    meanb = b
    b[1] = mean(y)
    var = array(0, nmarkers)
    ppa = ppa_start
    piMean = 0
    meanVar = 0
    ycorr = y - x[, 1] * b[1]
    acf_mu <- array()
    bf <- array(0, dim = c(mcmc, 2000))
    b_effect <- array(0, dim = c(mcmc, 2001))
    
    for (iter in 1:numiter) {
        vare = (t(ycorr) %*% ycorr)/rchisq(1, nrecords + 3)
        ycorr = ycorr + x[, 1] * b[1]
        rhs = sum(ycorr)/vare
        invLhs = 1/(nrecords/vare)
        mean = rhs * invLhs
        b[1] = rnorm(1, mean, sqrt(invLhs))
        ycorr = ycorr - x[, 1] * b[1]
        meanb[1] = meanb[1] + b[1]
        acf_mu[iter] = b[1]
        nLoci = 0
        b_effect[iter, 1] = b[1]
        for (locus in 1:nmarkers) {
            ycorr = ycorr + x[, 1 + locus] * b[1 + locus]
            rhs = t(x[, 1 + locus]) %*% ycorr
            xpx = t(x[, 1 + locus]) %*% x[, 1 + locus]
            v0 = xpx * vare
            v1 = (xpx^2 * varEffects + xpx * vare)
            logDelta0 = -0.5 * (log(v0) + rhs^2/v0) + logPi
            logDelta1 = -0.5 * (log(v1) + rhs^2/v1) + logPiComp
            probDelta1 = 1/(1 + exp(logDelta0 - logDelta1))
            bf[iter, locus] = probDelta1
            u = runif(1)
            if (u < probDelta1) {
                nLoci = nLoci + 1
                lhs = xpx/vare + 1/varEffects
                invLhs = 1/lhs
                mean = invLhs * rhs/vare
                b[1 + locus] = rnorm(1, mean, sqrt(invLhs))
                ycorr = ycorr - x[, 1 + locus] * b[1 + locus]
                meanb[1 + locus] = meanb[1 + locus] + b[1 + locus]
                ppa[locus] = ppa[locus] + 1
                var[locus] = varEffects
            }
            else {
                b[1 + locus] = 0
                var[locus] = 0
            }
             b_effect[iter, locus] = b[1 + locus]
            
        }
        if (iter%%100 == 0)
            cat("iteration ", iter, " number of loci in model = ",
                nLoci, "\n")
        countLoci = 0
        sum = 0
        for (locus in 1:nmarkers) {
            if (var[locus] > 0) {
                countLoci = countLoci + 1
                sum = sum + b[1 + locus]^2
            }
        }
        cat(countLoci, nLoci, "\n")
        varEffects = (scalec * nua + countLoci * sum)/rchisq(1,
            nua + countLoci)
        meanVar = meanVar + varEffects
        aa = nmarkers - countLoci + 1
        bb = countLoci + 1
        pi = rbeta(1, aa, bb)
        storePi[iter] = pi
        piMean = piMean + pi
        scalec = (nua - 2)/nua * vara/((1 - pi) * nmarkers *
            mean2pq)
        logPi = log(pi)
        logPiComp = log(1 - pi)
    }
    
    
    meanb = 0.5*meanb/numiter


    ppa = ppa/numiter
    piMean = piMean/numiter
    meanVar = meanVar/numiter
    aHat_tr = x %*% meanb
    results <- list()
    results[[1]] <- meanb
    results[[2]] <- ppa
    results[[3]] <- storePi
    results[[4]] <- oldb
    results[[5]] <- bf
    results[[6]] <- dim(x)
    results[[7]] <- y
    results[[8]] <- b_effect
    results[[9]] <- x
    
    corr_realb_meanb = cor(oldb, meanb)
    mse_realb_meanb = sum((oldb - meanb)^2)/(length(meanb))
    cat("corr_realb_meanb=", corr_realb_meanb, "\n")
    cat("mse_realb_meanb=", int, mse_realb_meanb, "\n")
    corrY = cor(y, aHat_tr)
    cat("corrY = ", corrY, "\n")
    
    return(results)
}

result.ex<-BayesInREx(nsb,re_b,ppa_start,testPi,mcmc)

plot(result.ex[[4]],col="blue",type="b",xlab="Marker index",ylab="Effect")
lines(result.ex[[1]],col="red",type="b")