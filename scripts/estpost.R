# cheat sheet for doing this in R with entropy data
# code by Martin Schilling, organized by Sylvia Kinosian

library("coda")

# load in big qs for each k
filename <- system("ls", intern= T)

kq <- filename[c(2,4,6)]

kqname <- unlist(strsplit(kq, 'q'))[c(1,3,5)]

for(i in 1:length(kq)){
     oname = paste(kqname[i], "q", sep= "")
     assign(oname, read.csv(kq[i], sep= ',', header= F))
 }

dim(aek2q)

# create a list for each to do stuff with later
# hard coded - make sure it matches your data
entr2list <- function(df, k= 5, nind= 115, nchains= 3, iter= 2000){
    kqmat <- as.matrix(df[,2:(iter*nchains+1)])
    start <- seq(1, iter*nchains-1999, iter)
    stop <- seq(iter, nchains*iter, iter)
    startK <- seq(1, k*nind-(nind-1), nind)
    stopK <- seq(nind, k*nind, nind)
    chainnames <- paste("c", seq(1, nchains, 1), sep= '')
    for(i in 1:nchains){
    	lastit <- kqmat[, start[i]:stop[i]]
    	lastit <- apply(lastit, 1, median)
    	dfnew <- as.data.frame(matrix(nrow= nind, ncol= k))
    for(j in 1:k){
    	dfnew[,j] <- lastit[startK[j]:stopK[j]]
    }
    assign(chainnames[i], dfnew)#, envir= .GlobalEnv)
    	#dfchain <- t(df[, start[i]:stop[i]])
    	#return(mcmc(dfchain), thin= thin)
    }
    return(list(c1, c2, c3))
}

k2q_list <- entr2list(df = aek2q, k = 2)
k3q_list <- entr2list(df = aek3q, k = 3)
k4q_list <- entr2list(df = aek4q, k = 4)

# function to plot each chain for a given k
plot_q_per_chain <- function(kqlist, xlabel, ...){
	cols <- c("#FFC1D9", "#167527", "#B24200", "#822C97", "#461B07", "#00675A", "#756A34", "#8C184E", "#331D48", "#293621", "#C5313E", "#FAF0CF", "#4E538C", "#6D4650", "#D8A851", "#3C5B24")
	par(mfrow= c(length(kqlist),1), mar=c(1.5,2,1,1) + 0.1, oma= c(5,0,0,0), mgp= c(0,1,0))
	chain <- seq(1, length(kqlist), 1) 
	for(i in 1:length(kqlist)){
	barplot(t(kqlist[[i]]), beside= F, col= cols, las= 2, axisnames= T, cex.name= 1, cex.axis= 1.2, border= NA, space= c(0.05,0.05), yaxt= 'n', ylab= paste("chain", chain[i], sep= ' '), cex.lab= 2, names.arg= xlabel)
axis(2, at= c(0, 0.5, 1), cex.axis= 2, las= 2, pos= -0.2)
 }
 }

plot_q_per_chain(k2q_list, 1:115)

#####
# gelman.diag

# function formats the data to be used by coda
entr2coda <- function(df, nchains= 3, thin= 4, iter= 2000){
	kqmat <- as.matrix(df[,2:(iter*nchains+1)])
	start <- seq(1, iter*nchains-1999, iter)
	stop <- seq(iter, 12000, iter)
	chainnames <- paste("c", seq(1, nchains, 1), sep= '')
	for(i in 1:nchains){
		dfnew <- mcmc(t(kqmat[, start[i]:stop[i]]), thin= thin)
		assign(chainnames[i], dfnew, envir= .GlobalEnv)
		#dfchain <- t(df[, start[i]:stop[i]])
		#return(mcmc(dfchain), thin= thin)
	}
	return(mcmc.list(c1, c2, c3))
}

k2coda <- entr2coda(aek2q)
k3coda <- entr2coda(aek3q)
k4coda <- entr2coda3c(aek4q)

k2grd <- gelman.diag(k2coda, autoburnin= T, multivariate= F, transform= T)
k3grd <- gelman.diag(k3coda, autoburnin= T, multivariate= F, transform= T)
k4grd <- gelman.diag(k4coda, autoburnin= T, multivariate= F, transform= T)

# make error bars
error.bar <- function(x, y, upper, lower=upper, length=0.1,...){
	if(length(x) != length(y) | length(y) !=length(lower) | length(lower) != length(upper))
		stop("vectors must be same length")
		arrows(x,y+upper, x, y-lower, angle=90, code=3, length=length, ...)
}

 error.bar(meank2[c(1:92,108:115)], 1:100, avg_k2)
> plot(inds$sp, qindsk2, xlab = "Pteridium spp.", ylab = "admixture proportion", main = "Admixture proportions for Pteridium (k = 2)")

