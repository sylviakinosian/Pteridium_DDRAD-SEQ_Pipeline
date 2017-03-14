
# common vars data (lasio107_cmn.gl) 


filename <- system("ls", intern= T)

est <- filename[grep("estdf", filename)]#[c(1:14, 16)]
estname <- unlist(strsplit(est, 'e'))[seq(1, 25, 2)]
### read prob files
for(i in 1:length(est)){
    #oname = paste(estname[i], "est", sep= "")
    assign(estname[i], read.csv(est[i], sep= ' ', header= F))
}


# 116 
# inds <- c("CR1308", "CR1309", "FW1630", "FW516", "JB1587", "JB419", "MS444", "MS446", "MS447", "MS453", "MS455", "MS458", "MS485", "MS488", "MS513", "MS562", "MS563", "MS565", "MS566", "MS568_rep", "MS570", "MS575", "MS576", "MS580", "MS582", "MS583", "MS584", "MS585", "MS586", "MS587", "MS589", "MS590", "MS591", "MS593", "MS594", "MS595", "MS597", "MS601", "MS603", "MS605", "MS606", "MS609", "MS610", "MS611", "MS612", "MS613", "MS614", "MS615", "MS617", "MS618", "MS620", "MS622", "MS623", "MS629", "MS630", "MS631", "MS632", "MS633", "MS636", "MS637", "MS638", "MS639", "MS640", "MS641", "MS644", "MS646", "MS648", "MS649", "MS652", "MS653", "MS654", "MS655", "MS657", "MS658", "MS661", "MS662", "MS663", "MS665", "MS666", "MS667", "MS668", "MS688", "MS689", "MS691", "MS699", "MS701", "MS702", "MS704", "MS705", "MS706", "MS707", "MS708", "MS709", "MS711", "MS712", "MS713", "MS714", "MS715", "MS717", "MS718", "MS719", "MS720", "MS721", "MS722", "MS723", "MS725", "MS726", "MS727", "MS729", "MS730", "MS731", "MS732", "MS733", "MS734", "MS735", "MS736")

# 107 
inds <- c("MS444", "MS446", "MS447", "MS453", "MS455", "MS458", "MS562", "MS563", "MS565", "MS566", "MS568_rep", "MS570", "MS575", "MS576", "MS580", "MS582", "MS583", "MS584", "MS585", "MS586", "MS587", "MS589", "MS590", "MS591", "MS593", "MS594", "MS595", "MS597", "MS601", "MS603", "MS605", "MS606", "MS609", "MS610", "MS611", "MS612", "MS613", "MS614", "MS615", "MS617", "MS618", "MS620", "MS622", "MS623", "MS629", "MS630", "MS631", "MS632", "MS633", "MS636", "MS637", "MS638", "MS639", "MS640", "MS641", "MS644", "MS646", "MS648", "MS649", "MS652", "MS653", "MS654", "MS655", "MS657", "MS658", "MS661", "MS662", "MS663", "MS665", "MS666", "MS667", "MS668", "MS688", "MS689", "MS691", "MS699", "MS701", "MS702", "MS704", "MS705", "MS706", "MS707", "MS708", "MS709", "MS711", "MS712", "MS713", "MS714", "MS715", "MS717", "MS718", "MS719", "MS720", "MS721", "MS722", "MS723", "MS725", "MS726", "MS727", "MS729", "MS730", "MS731", "MS732", "MS733", "MS734", "MS735", "MS736")

la105 <- read.table("~/Desktop/boechera/lasio/manuscript/data/lasio105.txt", header= F, sep= ' ')

###############
### drp (latest: Jun16 - 105 inds)
drp <- inds %in% la105$V1

inds_drop <- inds[drp]
###############

k5d <- k5[drp,]
k6d <- k6[drp,]
k7d <- k7[drp,]
k8d <- k8[drp,]
k9d <- k9[drp,]
k10d <- k10[drp,]
k11d <- k11[drp,]
k12d <- k12[drp,]
k13d <- k13[drp,]
k14d <- k14[drp,]

###############fstcol <- col14[c(7,2,4,9,5,1,11,12,13,10,6,8,3,14)]


pops <- read.csv("~/Desktop/boechera/lasio/popI107.csv", header= F)
#barplot(t(k8), beside= F, col= brewer.pal(10, "Set3"), las= 2, axisnames= T, cex.name= 1, cex.axis= 1.2, border= NA, space= c(0.05,0.05), yaxt= 'n', ylab= "k = 6", cex.lab= 2, names.arg= pops$V2)
pop <- pops[drp,]

col14cmn <- c("#CDBA8F", "#B862D3", "#79D958", "#CA4B87", "#D2C948", "#6386CA", "#D1543B", "#7ECDBA", "#6F3636", "#5A8E45", "#583C6D", "#9F7734", "#BDA3BB", "#405043")

# sort inds
wmax <- apply(k11d, 1, which.max) # NOTE: currently used k= 14 for rare !!
maxprob <- apply(k11d, 1, max)
ultim_ord <- order(pop$V2,-wmax, maxprob)   # first -wmax, maxprob, but that seems to group too arbitrarily...

#ultim_ord <- ultim_ord[c(1:22, 25:58, 23:24, 59:107)]

####

# same cols as in rare
col14 <- col14cmn[c(2,1,5,6,8,4,7,3,9,10,11,12,13,14)]


par(mfrow= c(5,1), mar=c(1.5,2,1,1) + 0.1, oma= c(5,0,0,0), mgp= c(0,1,0))

barplot(t(k5d[ultim_ord,]), beside= F, col= col14[c(3,4,10,1,8,2,5,6,9,7,11,12:13)], las= 2, axisnames= F, cex.name= 1, cex.axis= 1.2, border= NA, space= 0.14, yaxt= 'n', ylab= "k = 5", cex.lab= 2, names.arg= pops$V1[order(pop$V2)])
axis(2, at= c(0, 0.5, 1), cex.axis= 2, las= 2, pos= -0.2)

#
barplot(t(k6d[ultim_ord,]), beside= F, col= col14[c(3,1,10,6,4,8,7,5,9,2,11,12:13)], las= 2, axisnames= F, cex.name= 1, cex.axis= 1.2, border= NA, space= 0.14, yaxt= 'n', ylab= "k = 6", cex.lab= 2, names.arg= pops$V1[order(pop$V2)])
axis(2, at= c(0, 0.5, 1), cex.axis= 2, las= 2, pos= -0.2)

barplot(t(k7d[ultim_ord,]), beside= F, col= col14[c(5,10,3,1,6,8,4,7,9,2,11,12:14)], las= 2, axisnames= F, cex.name= 1, cex.axis= 1.2, border= NA, space= 0.14, yaxt= 'n', ylab= "k = 7", cex.lab= 2, names.arg= pops$V1[order(pop$V2)])
axis(2, at= c(0, 0.5, 1), cex.axis= 2, las= 2, pos= -0.2)

barplot(t(k8d[ultim_ord,]), beside= F, col= col14[c(5,4,10,7,6,1,3,8,9,2,11,12:13)], las= 2, axisnames= F, cex.name= 1, cex.axis= 1.2, border= NA, space= 0.14, yaxt= 'n', ylab= "k = 8", cex.lab= 2, names.arg= pop$V2[ultim_ord])
axis(2, at= c(0, 0.5, 1), cex.axis= 2, las= 2, pos= -0.2)

barplot(t(k9d[ultim_ord,]), beside= F, col= col14[c(4,10,3,1,5,6,7,8,9,2,11,12:13)], las= 2, axisnames= F, cex.name= 1, cex.axis= 1.2, border= NA, space= 0.14, yaxt= 'n', ylab= "k = 9", cex.lab= 2, names.arg= pop$V1[ultim_ord])
axis(2, at= c(0, 0.5, 1), cex.axis= 2, las= 2, pos= -0.2)

######

barplot(t(k10d[ultim_ord,]), beside= F, col= col14[c(7,4,3,2,6,1,5,8,9,10,11,12:13)], las= 2, axisnames= F, cex.name= 1, cex.axis= 1.2, border= NA, space= 0.14, yaxt= 'n', ylab= "k = 10", cex.lab= 2, names.arg= pop$V1[order(pops$V2)])
axis(2, at= c(0, 0.5, 1), cex.axis= 2, las= 2, pos= -0.2)

barplot(t(k11d[ultim_ord,]), beside= F, col= col14[c(3,2,1,4,9,6,5,8,7,10,11,12:13)], las= 2, axisnames= F, cex.name= 1, cex.axis= 1.2, border= NA, space= 0.14, yaxt= 'n', ylab= "k = 11", cex.lab= 2, names.arg= pop$V1[ultim_ord])

axis(2, at= c(0, 0.5, 1), cex.axis= 2, las= 2, pos= -0.2)

barplot(t(k12d[ultim_ord,]), beside= F, col= col14[c(11,1,4,10,12,2,7,9,8,6,5,3,13)], las= 2, axisnames= F, cex.name= 1, cex.axis= 1.2, border= NA, space= 0.14, yaxt= 'n', ylab= "k = 12", cex.lab= 2, names.arg= pop$V1[order(pops$V2)])
axis(2, at= c(0, 0.5, 1), cex.axis= 2, las= 2, pos= -0.2)

barplot(t(k13d[ultim_ord,]), beside= F, col= col14[c(12,8,11,9,13,5,6,7,4,3,10,2,1)], las= 2, axisnames= F, cex.name= 1, cex.axis= 1.2, border= NA, space= 0.14, yaxt= 'n', ylab= "k = 13", cex.lab= 2, names.arg= pop$V2[ultim_ord])
axis(2, at= c(0, 0.5, 1), cex.axis= 2, las= 2, pos= -0.2)

barplot(t(k14d[ultim_ord,]), beside= F, col= col14[c(1,3,4,6,5,4,2,8,13,7,10,12,9)], las= 1, axisnames= T, cex.name= 1.6, cex.axis= 2, border= NA, space= 0.14, yaxt= 'n', ylab= "k = 14", cex.lab= 2, names.arg= seq(1, 105, 1))#pop$V1[ultim_ord])
axis(2, at= c(0, 0.5, 1), cex.axis= 2, las= 2, pos= -0.2)

####################################################################################
#k2est$ind <- substring(k2est$param, 3, nchar(as.character(k2est$param))-6)
#
################
#chains <- c(rep(1, 79), rep(2, 79),  rep(3, 79), rep(4, 79), rep(5, 79), rep(6, 79), rep(7, 79), rep(8, 79), rep(9, 79), rep(10, 79),rep(11, 79), rep(12, 79),rep(13, 79),rep(14, 79),rep(15, 79), rep(16, 79))
#chainsk <- paste("k", chains, sep= '')
#iseq <- seq(2,16, 1)*79
#k2s <- split(k2est, chainsk[1:iseq[1]])

nam <- c("id", rep(c("mean", "median", "ci_lower", "ci_upper"), 8))
colnames(k8est) <- nam
#}

df <- as.data.frame(matrix(nrow= 79), ncol= 2)
#df <- data.frame()
for(i in 1:2){
	k <- paste("k", i, sep= '')
	df$k <- k2s$k$mean
}





dic <- read.csv("DIC.txt", header= F, sep= ' ')

#inds <- c("CR1043", "CR1091", "CR1164", "CR1181", "CR1308", "CR1309", "FW1630", "FW237", "FW241", "FW516", "FW73", "FW76", "JB1255", "JB1258", "JB1275", "JB1587", "JB1610", "JB1611", "JB176", "JB186", "JB377", "JB381", "JB382", "JB419", "JB659", "JB867", "MS102", "MS11", "MS163", "MS165", "MS169", "MS18", "MS275", "MS280", "MS282", "MS283", "MS286", "MS294", "MS297", "MS298", "MS302", "MS305", "MS313", "MS327", "MS328", "MS367", "MS392", "MS402", "MS403", "MS413", "MS422", "MS425", "MS426", "MS444", "MS446", "MS447", "MS453", "MS455", "MS458", "MS465", "MS469", "MS471", "MS473", "MS485", "MS488", "MS496", "MS513", "MS554", "MS556", "MS557", "MS558", "MS69", "MS7", "MS72", "MS79", "MS80", "MS9", "MS93", "MS94")




########################################## 
########### coda - Gelman-Rubin diagnostic
##########################################

library(coda)

#k2q <- read.csv("k2q.txt", header= F, sep= ',')
#k2qmt <- as.matrix(k2q[,2:10001])
	#tk2q <- t(k2qmt)
#k3q <- read.csv("k3q.txt", header= F, sep= ',')
#k3qmt <- as.matrix(k3q[,2:10001])

# used for BDA final project - Pteridium

filename <- system("ls", intern= T)

#kq <- filename[grep("q.txt", filename)]
kq <- filename[1:3]
#kqname <- unlist(strsplit(kq, 'q'))[seq(1, 25, 2)]
kqname <- unlist(strsplit(kq, 'q'))[c(1,3,5)]
### read kq files
for(i in 1:length(kq)){
    oname = paste(kqname[i], "q", sep= "")
    assign(oname, read.csv(kq[i], sep= ',', header= F))
}

#####
# converts from entropy to mcmc.list object to be read in by coda
#
entr2coda <- function(df, nchains= 6, thin= 6, iter= 2000){
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
	return(mcmc.list(c1, c2, c3, c4, c5, c6))
}
#####

k2coda <- entr2coda(k2q, 6, 6)
k3coda <- entr2coda(k3q, 6, 6)
k4coda <- entr2coda3c(k4q, 5, 6)
k5coda <- entr2coda(k5q, 6, 6)
k6coda <- entr2coda(k6q, 6, 6) 
k7coda <- entr2coda(k7q, 6, 6)
k8coda <- entr2coda(k8q, 6, 6)
k9coda <- entr2coda(k9q, 6, 6)
k10coda <- entr2coda(k10q, 6, 6)
k11coda <- entr2coda(k11q, 6, 6)
k12coda <- entr2coda(k12q, 6, 6)
k13coda <- entr2coda(k13q, 6, 6)
k14coda <- entr2coda(k14q, 6, 6)


entr2coda3c <- function(df, nchains= 6, thin= 6, iter= 2000){
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
	return(mcmc.list(c1, c2, c3, c4, c5))#, c6))
}

#gelman.diag(k3coda, autoburnin= 4000, multivariate= F)

k8coda <- entr2coda(k8q, 6,6)
#k8grd <- gelman.diag(k8coda, autoburnin= 4000, multivariate= F)


k2grd <- gelman.diag(k2coda, autoburnin= T, multivariate= F, transform= T)
k3grd <- gelman.diag(k3coda, autoburnin= T, multivariate= F, transform= T)
k4grd <- gelman.diag(k4coda, autoburnin= T, multivariate= F, transform= T)
k5grd <- gelman.diag(k5coda, autoburnin= T, multivariate= F, transform= T)
k6grd <- gelman.diag(k6coda, autoburnin= T, multivariate= F, transform= T)
k7grd <- gelman.diag(k7coda, autoburnin= T, multivariate= F, transform= T)
k8grd <- gelman.diag(k8coda, autoburnin= T, multivariate= F, transform= T)
k9grd <- gelman.diag(k9coda, autoburnin= T, multivariate= F, transform= T)
k10grd <- gelman.diag(k10coda, autoburnin= T, multivariate= F, transform= T)
k11grd <- gelman.diag(k11coda, autoburnin= T, multivariate= F, transform= T)
k12grd <- gelman.diag(k12coda, autoburnin= T, multivariate= F, transform= T)
k13grd <- gelman.diag(k13coda, autoburnin= T, multivariate= F, transform= T)
k14grd <- gelman.diag(k14coda, autoburnin= T, multivariate= F, transform= T)



par(mfrow= c(2, 4))
boxplot(k2grd$psrf[,1], main= 'k=2')

median(k8grd$psrf[,1])   # 1.057059
mean(k8grd$psrf[,1])     # 1.082184

#inds[which(k8grd$psrf[1:79,1] > 1.1)]
#"FW516"  "JB1275" "JB1587" "JB377"  "JB382"  "MS11"   "MS165"  "MS18"  "MS283"  "MS286"  "MS298"  "MS302"  "MS413"  "MS422"  "MS425"  "MS426"  "MS444"  "MS465"  "MS473"  "MS488"  "MS554"  "MS556"  "MS69"   "MS79"  "MS80"   "MS94"  



#k8grd$psrf[which(k8grd$psrf[1:79,1] > 1.1)]

psrf <- as.data.frame(matrix(nrow= 5, ncol= 2))
psrf$V1 <- seq(5, 9, 1)
psrf <- list(k2grd$psrf, k3grd$psrf, k4grd$psrf, k5grd$psrf, k6grd$psrf, k7grd$psrf, k8grd$psrf, k9grd$psrf, k10grd$psrf, k11grd$psrf, k12grd$psrf, k13grd$psrf, k14grd$psrf)

lapply(psrf, median)
boxplot(psrf)
a <- c()
for (i in 1:length(psrf)){
	a[i] <- psrf[[i]]
}

median(a)
mean(a)
par(mfrow= c(2,7))
boxplot(k2grd$psrf[,1], main= 'k=2')
for (i in 1:length(psrf)){
	boxplot(i)
}
boxplot(k2grd$psrf[,1])
boxplot(k3grd$psrf[,1])
boxplot(k4grd$psrf[,1])
boxplot(k5grd$psrf[,1])
boxplot(k6grd$psrf[,1], main= 'k=6')
boxplot(k7grd$psrf[,1])
boxplot(k8grd$psrf[,1])
boxplot(k9grd$psrf[,1])
boxplot(k10grd$psrf[,1], main= 'k=10')
boxplot(k11grd$psrf[,1])
boxplot(k12grd$psrf[,1])
boxplot(k13grd$psrf[,1])
boxplot(k14grd$psrf[,1])

plot(dic, type= 'l')

#start <- seq(1, 8001, 2000)
#stop <- seq(2000, 10000, 2000)
#chainnames <- paste("c", seq(1, 5, 1), sep= '')
#for(i in 1:5){
#	dfnew <- mcmc(t(df[, start[i]:stop[i]]), thin= 5)
#	assign(chainnames[i], dfnew)
#	#dfchain <- t(df[, start[i]:stop[i]])
#	#return(mcmc(dfchain), thin= thin)
#}



######################################################################################################

#entr2list <- function(df, k= 5, nind= 107, nchains= 6, iter= 2000){
#	kqmat <- as.matrix(df[,2:(iter*nchains+1)])
#	start <- seq(1, iter*nchains-1999, iter)
#	stop <- seq(iter, nchains*iter, iter)
#	startK <- seq(1, k*nind-106, nind)
#	stopK <- seq(nind, k*nind, nind)
#	chainnames <- paste("c", seq(1, nchains, 1), sep= '')
#	for(i in 1:nchains){
#		coldf <- data.frame(colMeans(t(kqmat[, start[i]:stop[i]])))
#		dfnew <- as.data.frame(matrix(nrow= nind, ncol= k))
#		for(j in 1:k){
#			dfnew[,j] <- data.frame(coldf[startK[j]:stopK[j],])
#		}
#		assign(chainnames[i], dfnew, envir= .GlobalEnv)
#		#dfchain <- t(df[, start[i]:stop[i]])
#		#return(mcmc(dfchain), thin= thin)
#	}
#	return(list(c1, c2, c3, c4, c5, c6))
#}
#####
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


##
# k3 
k3q_list <- entr2list(df = aek3q, k = 3)

### 

plot_q_per_chain <- function(kqlist, xlabel, ...){
	cols <- c("#FFC1D9", "#167527", "#B24200", "#822C97", "#461B07", "#00675A", "#756A34", "#8C184E", "#331D48", "#293621", "#C5313E", "#FAF0CF", "#4E538C", "#6D4650", "#D8A851", "#3C5B24")
	par(mfrow= c(length(kqlist),1), mar=c(1.5,2,1,1) + 0.1, oma= c(5,0,0,0), mgp= c(0,1,0))
	chain <- seq(1, length(kqlist), 1) 
	for(i in 1:length(kqlist)){
		barplot(t(kqlist[[i]]), beside= F, col= cols, las= 2, axisnames= T, cex.name= 1, cex.axis= 1.2, border= NA, space= c(0.05,0.05), yaxt= 'n', ylab= paste("chain", chain[i], sep= ' '), cex.lab= 2, names.arg= xlabel)
		axis(2, at= c(0, 0.5, 1), cex.axis= 2, las= 2, pos= -0.2)
	}
}

############# need to have pops loaded for this
pops <- read.csv("~/Desktop/boechera/lasio/popI107.csv", header= F)

plot_q_per_chain(k5qlist, pops$V2)



###########################################################################
###########################################################################

###### pca on gprobs
#  
cmnk6gprob <- read.table("k6gprob.txt", header= T, sep= ',')

cmnk11gprob <- read.table("k11gprob.txt", header= T, sep= ',')
k11 <- read.csv("k11estdf", header= F, sep= ' ')


#########   drp from above - 105 inds
#cmn6 <- prcomp(cov(as.matrix(t(cmnk6gprob[,2:13100]))), center= T, scale.= F)
cmn11 <- prcomp(cov(as.matrix(t(cmnk11gprob[drp,2:13100]))), center = T, scale.= F)
#maxprob11 <- apply(k11, 1, which.max)



####
#library(ggbiplot)
#g <- ggbiplot(cmn11, obs.scale = 0, ellipse = T, var.axes= F, groups=as.character(pop$V2))
#g <- g + scale_color_discrete(name= ' ')#h= c(0, 500) + 30, name = '')
#print(g)

#######################
colpca <- col14[c(10,6,8,4,14,5)]
pop$col <- rep(NA, 105)
pop$col[which(pop$V2 == 'lol')] <- "#D2C948"
pop$col[which(pop$V2 == 'skn')] <- "#CA4B87"
pop$col[which(pop$V2 == 'red')] <- "#79D958"
pop$col[which(pop$V2 == 'blo')] <- "#6386CA"
pop$col[which(pop$V2 == 'pro')] <- "#405043"
pop$col[which(pop$V2 == 'pow')] <- "#5A8E45"

legcol <- c("#D2C948", "#CA4B87", "#79D958", "#6386CA", "#405043", "#5A8E45")
# pc1 & pc2
plot(cmn11$x[,1], cmn11$x[,2], col= pop$col, xlab= "PC1 (52.6%)", ylab= "PC2 (17.9%)", pch= '+', main= "common variants (n = 13,099)", cex= 1.8)
#legend(-0.4,0.5, legend= c("lcs", "skn", "red", "blo", "pro", "pow"), col= legcol)
legend(-0.4,0.57, legend= c("lcs", "skn", "red", "blo", "pro", "pow"), col= legcol, pch= '+', cex= 1.6)
# pc2 & pc3
plot(cmn11$x[,2], cmn11$x[,3], col= pop$col, xlab= "PC2 (17.9%)", ylab= "PC3 (11.9%)", pch= '+', cex= 1.3)
#legend(-0.4,0.57, legend= c("lcs", "skn", "red", "blo", "pro", "pow"), col= legcol, pch= '+', cex= 1.2)

### only lcs pca
lcsc <- prcomp(cov(as.matrix(t(gprobz))), center = T, scale.= F)
lcsr <- prcomp(cov(as.matrix(t(gprobzra))), center = T, scale.= F)

par(mfrow= c(2,2))
plot(lcsc$x[,1], lcsc$x[,2])
plot(lcsc$x[,2], lcsc$x[,3])
plot(lcsr$x[,1], lcsr$x[,2])
plot(lcsr$x[,2], lcsr$x[,3])

# maybe color them in according to the two (?) clusters from admix probs?

#######################



### cor of PCs with sequence coverage ?
cover <- read.table("lasio107cmn_cov.txt", header= T, sep= ' ')
cover <- cover[,drp]

pluscov <- colSums(cover)

cor.test(pluscov, cmn11$x[,1])
cor.test(pluscov, cmn11$x[,2])

# mean coverage per SNV per individual 
mn_cov <- apply(cover, 1, mean)    # mean and sd 

###############
par(mfrow= c(3,1), mar=c(1.5,2,1,1) + 0.1, oma= c(5,0,0,0), mgp= c(0,1,0))

## heterozygosity for individuals
hets <- read.table("k11gprob_hets.txt", header= F)
hets <- hets$V1

# 1 inds (see drp)
hets <- hets[drp]

# sort 

barplot(hets[ultim_ord], ylim= c(0,1), las= 1, cex.names= 1.4, axes= F, axisnames= T, names.arg= seq(1, 105, 1))#inds_drop[ultim_ord]
axis(2, at= c(0, 0.25, 0.5, 0.75, 1), cex.axis= 1.8, las= 2, pos= -0.2)
segments(x0= 0, y0= 0.25, x1= 126, lty= 2)

###
barplot(t(k11d[ultim_ord,]), beside= F, col= col14[c(3,2,1,4,9,6,5,8,7,10,11,12:13)], las= 1, axisnames= T, cex.name= 1.4, cex.axis= 1.2, border= NA, space= 0.14, yaxt= 'n', ylab= "k = 11", cex.lab= 2, names.arg= seq(1, 105, 1))#pop$V1[ultim_ord])

axis(2, at= c(0, 0.5, 1), cex.axis= 1.8, las= 2, pos= -0.2)


#### check difference in means for hets common and rare:
# ssh trs
# in ~/Desktop/boechera/lasio/  (workspace saved)
la105 <- read.csv("lasio105.txt", header= F, sep= ' ')
drp <- inds %in% la105$V1
hetsr <- read.csv("rare/ntrpy/k14gprob_hets.txt", header= F, sep= ' ')
hetsc <- read.csv("common/ntrpy/k11gprob_hets.txt", header= F, sep= ' ')
hetsa <- cbind(hetsr$V1, hetsc$V1)

library(BEST)
hetsmcmc <- BESTmcmc(y1= hetsa[drp,1], y2= hetsa[drp,2])


#######
# take subset of 56 inds (?) from lcs and plot hets and potentially the admixture props.

# this could indicate whether sex/selfing was predominant in the pop substructure. 

lcs <- pop$V2 == "lol"

inds_drop[lcs]

lcs_ord <- order(-wmax[lcs], maxprob[lcs])   

#par(mfrow= c(2,1))
par(mfrow= c(2,1), mar=c(1.5,2,1,1) + 0.1, oma= c(5,0,0,0), mgp= c(0,1,0))


barplot(hets[lcs], ylim= c(0,1), las= 2, cex.names= 1.4, axes= F, axisnames= T, names.arg= inds_drop[lcs]) #seq(1, 54, 1))#
axis(2, at= c(0, 0.25, 0.5, 0.75, 1), cex.axis= 1.8, las= 2, pos= -0.2)
segments(x0= 0, y0= 0.25, x1= 126, lty= 2)

barplot(t(k11d[lcs,]), beside= F, col= col14[c(3,2,1,4,9,6,5,8,7,10,11,12:13)], las= 2, axisnames= T, cex.name= 1.4, cex.axis= 1.2, border= NA, space= 0.14, yaxt= 'n', ylab= "k = 11", cex.lab= 2, names.arg= inds_drop[lcs])
axis(2, at= c(0, 0.5, 1), cex.axis= 1.8, las= 2, pos= -0.2)

##########################

# compare admix props to ploidy (from g2p)

pl <- read.csv("~/Desktop/boechera/ploidy/lasio/PLUS/g2p/pp.txt", header= F, sep= ' ')
#plids <- pl[,1]
#pl <- pl[,2:4]
#
pl$V1 <- as.character(pl$V1)
pll <- pl[pl$V1 %in% inds_drop[ultim_ord],]
#plidsdrp <- plids[plids %in% inds_drop]
library(RColorBrewer)
cols4 <- brewer.pal(8, "Set3")[c(7,4,5)]


#poppl <- pll[order(pops$V2[pll$ids %in% pops$V1]),]
#poppl <- poppl[c(1:62, 69:107),]
#pl <- read.csv("~/Desktop/boechera/ploidy/lasio/PLUS/g2p/assProbs.csv", header= T)
#poppl <- merge(poppl, pops, by.x= "ids", by.y= "V1")
#poppl <- poppl[order(poppl$V2),]

pll <- pll[order(pll$V1),]      # same order as inds_drop, so order with [ultim_ord]

barplot(t(pll[ultim_ord, 2:4]), las= 2, cex.names= 0.8, col= cols4, axisnames= F, axes= F, names.arg= pll$V1[ultim_ord])
axis(2, at= c(0, 0.5, 1), cex.axis= 1.8, las= 2, pos= -0.2)


# fst (from entropy)
library(Hmisc)
fst <- read.table("k11fst.txt", header= T, sep= ',')

#fstcolcmn <- col14cmn ### NOTE: these are not correct... 
fstcol <- col14[c(3,2,1,4,9,6,5,8,7,10,11,12:13)]
barplot(fst$mean, width= rep(0.835, 15), col= col14cmn, xlab= "admixture groups", ylab= "Fst", ylim= c(0,1))
errbar(x= seq(0.6, 10.6, 1), y= fst$mean, yminus= fst$ci_0.950_LB, yplus= fst$ci_0.950_UB, add= T, cap= 0.04)

# fst sorted by means
barplot(fst$mean[order(fst$mean, decreasing=T)], width= rep(0.835, 15), col= col14cmn[order(fst$mean, decreasing=T)], xlab= "admixture groups", ylab= "Fst", ylim= c(0,1))
errbar(x= seq(0.6, 10.6, 1), y= fst$mean[order(fst$mean, decreasing=T)], yminus= fst$ci_0.950_LB[order(fst$mean, decreasing=T)], yplus= fst$ci_0.950_UB[order(fst$mean, decreasing=T)], add= T, cap= 0.04)
box()

###########################################################################
###########################################################################
# get ranges of elevations for each pop
elev <- read.table("~/Desktop/boechera/lasio/manuscript/data/pops_gps_elev.txt", header= F, sep= '\t')
elev_split <- split(elev, elev[,1])

for(i in 1:7){
	print(min(elev_split[[i]][,5]))
	print(max(elev_split[[i]][,5]))
}

names(elev_split)

# BCO 		2744-2762
# BLO		2326-2347
# CVL		2574-2660
# LOL		2309-2396
# POW		2512-2534
# PRO		2544-2646
# RED		2266-2271
# SKN		2387-2511



###########################################################################
###########################################################################
# calculate Fstats (on gprobs cmn & rare) with locality as pops 
# FIT is the inbreeding coefficient of an individual (I) relative to the total (T) population, as above; FIS is the inbreeding coefficient of an individual (I) relative to the subpopulation (S), using the above for subpopulations and averaging them; and FST is the effect of subpopulations (S) compared to the total population (T), and is calculated by solving the equation

source("~/Desktop/boechera/lasio/popGenfuncs.r")

genoCMN <- t(round(gprobs[,1:13099]))
genoRAR <- t(round(gprobsra[drp,2:2052]))
colnames(genoCMN) <- inds_drop
colnames(genoRAR) <- inds_drop

subpop <- as.character(pop$V2)
subpop[subpop == 'lol'] <- 'lcs'



snp.statsCMN <- calc_snp_stats(genoCMN)
snp.statsRAR <- calc_snp_stats(genoRAR)

# re-estimate stats for subpops
snp.stats.lcsC <- calc_snp_stats(genoCMN[,which(subpop=='lcs')])
snp.stats.lcsR <- calc_snp_stats(genoRAR[,which(subpop=='lcs')])

# Fis
FistotC <- calc_neiFis_onepop(genoCMN)   # average across loci = 0.01312119
FistotR <- calc_neiFis_onepop(genoRAR)   # 0.324881

vioplot(na.omit(FistotC$perloc), na.omit(FistotR$perloc), col= "grey70", names= c("common", "rare"), ylim= c(0,1))

#
neiFis.allpopsC <- calc_neiFis_multispop(genoCMN, subpop)
#         blo         lcs         pow         pro         red         skn      total     average 
# -0.31326164 -0.10303681 -0.15087531 -0.23101908 -0.44947514 -0.07333981 0.01312119 -0.20397902
neiFis.allpopsR <- calc_neiFis_multispop(genoRAR, subpop)
#        blo         lcs         pow         pro         red         skn 	   total     average 
#-0.20622185  0.02915132 -0.19260672 -0.23752495  0.08916479  0.54639018  0.32488096  0.11347776


neiFisC <- neiFis.allpopsC$perloc
neiFisR <- neiFis.allpopsR$perloc

# vioplot of Fis for common and rare vars per locus and locality
namesvio <- c("blo", "blo", "lcs", "lcs", "pow", "pow", "pro", "pro", "red", "red", "skn", "skn")
vioplot(na.omit(neiFisC[,1]), na.omit(neiFisR[,1]), na.omit(neiFisC[,2]), na.omit(neiFisR[,2]), na.omit(neiFisC[,3]), na.omit(neiFisR[,3]), na.omit(neiFisC[,4]), na.omit(neiFisR[,4]), na.omit(neiFisC[,5]), na.omit(neiFisR[,5]), na.omit(neiFisC[,6]), na.omit(neiFisR[,6]), col= col12, ylim= c(-1,1), names= namesvio)

#####
### get average across loci per locality for barplot 
Fisperpop <- rbind(neiFis.allpopsC$aveloc, neiFis.allpopsR$aveloc)

#             blo         lcs        pow        pro         red         skn
# [1,] -0.3132616 -0.10303681 -0.1508753 -0.2310191 -0.44947514 -0.07333981
# [2,] -0.2062218  0.02915132 -0.1926067 -0.2375250  0.08916479  0.54639018
#           total    average
# [1,] 0.01312119 -0.2039790
# [2,] 0.32488096  0.1134778



# positive Fis: individuals in a population more related than expected under random mating.
# negative Fis: individuals in a population less related than expected under random mating.
barplot(Fisperpop, beside= T, ylim= c(-1, 1), col= c("grey20", "grey70"))
legend(19, 0.9, legend= c("common", "rare"), col= c("grey20", "grey70"), cex= 1.3, pch = 15)

# same barplot, without total & average
barplot(Fisperpop[,1:6], beside= T, ylim= c(-1, 1), col= c("grey20", "grey70"))
legend(14, 0.9, legend= c("common", "rare"), col= c("grey20", "grey70"), cex= 1.3, pch = 15)

#################
# Fis for subpops, which more closely correspond to admixture pops
ntrpop <- subpop#[ultim_ord]
ntrpop <- cbind(ntrpop, seq(1, 105,1))
ntrpop_ultord <- as.data.frame(ntrpop[ultim_ord,])
ntrpop_ultord <- cbind(ntrpop_ultord, ntrpop_ultord[,1])
ntrpop_ultord[,3] <- as.character(ntrpop_ultord[,3])

ntrpop_ultord[c(23:38, 71:77),3] <- "lcs-pow"
ntrpop_ultord[c(39:52),3] <- "lcs-sub1"
ntrpop_ultord[c(57:66, 78:87),3] <- "lcs-pow-pro"
ntrpop_ultord[c(98,104:105),3] <- "skn2"

ntrpop <- ntrpop_ultord[order(ntrpop_ultord[,2]),3]


###
neiFis.ntrpopsC <- calc_neiFis_multispop(genoCMN, ntrpop)
neiFis.ntrpopsR <- calc_neiFis_multispop(genoRAR, ntrpop)

FisNTRPYpop <- rbind(neiFis.ntrpopsC$aveloc, neiFis.ntrpopsR$aveloc)

#               blo         lcs     lcs-pow lcs-pow-pro   lcs-sub1        pow
#CMN     -0.1016040 -0.01694984 -0.14754616  0.02957272 0.08160429 -0.2707144
#RAR      0.1511803  0.35850539 -0.08722679  0.18339372 0.65362334 -0.2708703

# cont.
#            red        skn       skn2 		     total     average
#     -0.1479274 -0.1566446 -0.1390652 		0.01312119 -0.07821983
#     -0.1571738 -0.1717172 -0.1984436 		0.32488096  0.20991209

barplot(FisNTRPYpop[,1:9], beside= T, las= 2, col= c("grey20", "grey70"), ylim= c(-1,1))
legend(24, 0.9, legend= c("common", "rare"), col= c("grey20", "grey70"), cex= 2, pch = 15)



##
neiFisCntr <- neiFis.ntrpopsC$perloc
neiFisRntr <- neiFis.ntrpopsR$perloc

# vioplot of Fis for common and rare vars per locus and locality
ntrnamesvio <- c("blo", "blo", "lcs", "lcs", "lcs-pow", "lcs-pow", "lcs-sub1", "lcs-sub1", "lcs-pow-pro", "lcs-pow-pro", "pow", "pow", "red", "red", "skn2", "skn2", "skn", "skn")

vioplot(na.omit(neiFisCntr[,1]), na.omit(neiFisRntr[,1]), na.omit(neiFisCntr[,2]), na.omit(neiFisRntr[,2]), na.omit(neiFisCntr[,3]), na.omit(neiFisRntr[,3]), na.omit(neiFisCntr[,4]), na.omit(neiFisRntr[,4]), na.omit(neiFisCntr[,5]), na.omit(neiFisRntr[,5]), na.omit(neiFisCntr[,6]), na.omit(neiFisRntr[,6]), na.omit(neiFisCntr[,7]), na.omit(neiFisRntr[,7]), na.omit(neiFisCntr[,8]), na.omit(neiFisRntr[,8]), na.omit(neiFisCntr[,9]), na.omit(neiFisRntr[,9]), col= "grey20", ylim= c(-1,1), names= ntrnamesvio)

#######################################

# Fis for randomnly sampled genotypes from the genotype probabilities (obtained with hdfview ("Export to text..." for gprob))
# NOTE: did not average across chains, simply took the first chain for each cmn & rare

RARgprob0 <- read.table("~/Desktop/boechera/lasio/rare/ntrpy/hdf/gprob_c1_0.txt", header= F, sep= '\t')[,drp]
RARgprob1 <- read.table("~/Desktop/boechera/lasio/rare/ntrpy/hdf/gprob_c1_1.txt", header= F, sep= '\t')[,drp]
RARgprob2 <- read.table("~/Desktop/boechera/lasio/rare/ntrpy/hdf/gprob_c1_2.txt", header= F, sep= '\t')[,drp]

CMNgprob0 <- read.table("~/Desktop/boechera/lasio/common/ntrpy/hdf/gprob_c1_0.txt", header= F, sep= '\t')[,drp]
CMNgprob1 <- read.table("~/Desktop/boechera/lasio/common/ntrpy/hdf/gprob_c1_1.txt", header= F, sep= '\t')[,drp]
CMNgprob2 <- read.table("~/Desktop/boechera/lasio/common/ntrpy/hdf/gprob_c1_2.txt", header= F, sep= '\t')[,drp]

#

RARgprob <- list(RARgprob0, RARgprob1, RARgprob2)
CMNgprob <- list(CMNgprob0, CMNgprob1, CMNgprob2)

##############

sampGeno <- function(x,...){
	gtlist <- list()
	m <- matrix(nrow= dim(x[[1]])[1], ncol= dim(x[[1]])[2])
	for(i in 1:dim(x[[1]])[1]){            # rows i.e. loci
	    for(j in 1:dim(x[[1]])[2]){         # columns i.e. inds
		    gtlist[[1]] <- x[[1]][i,j]
			gtlist[[2]] <- x[[2]][i,j]
			gtlist[[3]] <- x[[3]][i,j]
			m[i,j] <- which.max(rmultinom(1,1, unlist(gtlist)))-1
		}
	}
	return(m)
}


# for RAR vars, there are around 4000 (out of 215355) that differ between sampGeno draws

# e.g.
# FALSE   TRUE 
#  3902 211453 

#############
# RAR
# Fis onepop
fislst_snglR <- list()
for(i in 1:100){
	fislst_snglR[[i]] <- calc_neiFis_onepop(sampGeno(RARgprob))
}


# Fis with localities  (multispop)
fislst_spopR <- list()
for(i in 1:100){
	fislst_spopR[[i]] <- calc_neiFis_multispop(sampGeno(RARgprob), subpop)
}


# get avg across all reps (for aveloc)
fisRspop <- matrix(nrow= 100, ncol= 8)
fisRspopSDs <- matrix(nrow= 100, ncol= 8)
for(i in 1:length(fislst_spopR)){
	fisRspop[i,] <- fislst_spopR[[i]]$aveloc
	fisRspopSDs[i,] <- apply(na.omit(fislst_spopR[[i]]$perloc), 2, sd)
}
colnames(fisRspop) <- names(fislst_spopR[[1]]$aveloc)
fisRspopAVG <- apply(fisRspop, 2, mean)
fisRspopSD <- apply(fisRspop, 2, sd)

meanSDspopR <- apply(fisRspopSDs, 2, mean)
# 		 blo        lcs        pow        pro        red        skn 	 total    average
# 0.15835084 0.04211591 0.06556256 0.12446097 0.11452134 0.26394112 0.04535311 0.06641841

####
# Fis with pops (ntrpy-ish)
fislst_ntrpopR <- list()
for(i in 1:100){
	fislst_ntrpopR[[i]] <- calc_neiFis_multispop(sampGeno(RARgprob), ntrpop)
}

# get avg across all reps (for aveloc)
fisRntrp <- matrix(nrow= 100, ncol= 11)
for(i in 1:length(fislst_ntrpopR)){
	fisRntrp[i,] <- fislst_ntrpopR[[i]]$aveloc
}
colnames(fisRntrp) <- names(fislst_ntrpopR[[1]]$aveloc)
fisRntrpAVG <- apply(fisRntrp, 2, mean)
fisRntrpSD <- apply(fisRntrp, 2, sd)


################# cmn ;  1 comparison between 2 sampGeno runs
#  FALSE    TRUE 
#  63266 1312129 

#############
# CMN
# Fis onepop
fislst_snglC <- list()
for(i in 1:100){
	fislst_snglC[[i]] <- calc_neiFis_onepop(sampGeno(CMNgprob))
}


# Fis with localities  (multispop)
fislst_spopC <- list()
for(i in 1:100){
	fislst_spopC[[i]] <- calc_neiFis_multispop(sampGeno(CMNgprob), subpop)
}
# avg & sd across all reps (for aveloc)
fisCspop <- matrix(nrow= 100, ncol= 8)
fisCspopSDs <- matrix(nrow= 100, ncol= 8)
for(i in 1:length(fislst_spopC)){
	fisCspop[i,] <- fislst_spopC[[i]]$aveloc
	fisCspopSDs[i,] <- apply(na.omit(fislst_spopC[[i]]$perloc), 2, sd)
}
colnames(fisCspop) <- names(fislst_spopC[[1]]$aveloc)
fisCspopAVG <- apply(fisCspop, 2, mean)
fisCspopSD <- apply(fisCspop, 2, sd)

meanSDspopC <- apply(fisCspopSDs, 2, mean)
# 		blo       lcs       pow       pro       red       skn 	  total   average
# 0.3304313 0.3607869 0.3804027 0.4505293 0.3792219 0.3322688 0.3269755 0.2884044

##########
# Fis with pops (ntrpy-ish)
fislst_ntrpopC <- list()
for(i in 1:100){
	fislst_ntrpopC[[i]] <- calc_neiFis_multispop(sampGeno(CMNgprob), ntrpop)
}
# avg & sd across all reps (for aveloc)
fisCntrp <- matrix(nrow= 100, ncol= 11)
for(i in 1:length(fislst_ntrpopC)){
	fisCntrp[i,] <- fislst_ntrpopC[[i]]$aveloc
}
colnames(fisCntrp) <- names(fislst_ntrpopC[[1]]$aveloc)
fisCntrpAVG <- apply(fisCntrp, 2, mean)
fisCntrpSD <- apply(fisCntrp, 2, sd)



# values
#                     blo         lcs        pow        pro         red
# fisCspopAVG -0.23167291 -0.11399144 -0.1541111 -0.2487747 -0.42431997
# fisRspopAVG -0.09684095  0.03265681 -0.1625100 -0.2140754  0.08380496

#                    skn      total    average
# fisCspopAVG 0.09506468 0.01180813 -0.1639895
# fisRspopAVG 0.54371699 0.31321645  0.1332761
#


######### NOTE: these ones aren't correct, currently re-running!!!   (ntrpop was messed up...)
##
#                    blo        lcs     lcs-pow lcs-pow-pro  lcs-sub1         pow
# fisCntrpAVG -0.1144741 -0.0225935 -0.16321359  0.01300507 0.1337267 -0.05458270
# fisRntrpAVG  0.1300040  0.3518161 -0.07258304  0.17420905 0.6362916  0.01320088

#                    red        skn       skn2      total     average
# fisCntrpAVG -0.1425230 -0.1495593 -0.1155188 0.01176441 -0.06064747
# fisRntrpAVG -0.1306033 -0.1286263 -0.1491314 0.31353655  0.21409815



# plots
# cmn rar global values
par(mfrow= c(10,10), mar=c(1.5,2,1,1) + 0.1, oma= c(5,0,0,0), mgp= c(0,1,0))
for(i in 1:length(fislst_snglR)){
	vioplot(na.omit(fislst_snglC[[i]]$perloc), na.omit(fislst_snglR[[i]]$perloc), col= c("grey70", "grey20"))
}

# Fis by locality
par(mfrow= c(10,10), mar=c(1.5,2,1,1) + 0.1, oma= c(5,0,0,0), mgp= c(0,1,0))
for(i in 1:length(fislst_spopC)){
	barplot(t(cbind(fislst_spopC[[i]]$aveloc, fislst_spopR[[i]]$aveloc)), beside= T, las= 2, ylim= c(-1,1), names.arg= c("blo", "lcs", "pow", "pro", "red", "skn", "total", "avg"))
}

# Fis by pops (ntrpy-ish)
par(mfrow= c(10,10), mar=c(1.5,2,1,1) + 0.1, oma= c(5,0,0,0), mgp= c(0,1,0))
for(i in 1:length(fislst_ntrpopC)){
	barplot(t(cbind(fislst_ntrpopC[[i]]$aveloc, fislst_ntrpopR[[i]]$aveloc)), beside= T, las= 2, ylim= c(-1,1))
}


vioplot(na.omit(fislst_snglC[[1]]$perloc), na.omit(fislst_snglR[[1]]$perloc), col= c("grey70", "grey20"))


#### func for sd to barplot
error.bar <- function(x, y, upper, lower=upper, length=0.1,...){
if(length(x) != length(y) | length(y) !=length(lower) | length(lower) != length(upper))
stop("vectors must be same length")
arrows(x,y+upper, x, y-lower, angle=90, code=3, length=length, ...)
}

# plots for avg values across the 100 reps

# fisXspopAVG
spopAVG <- rbind(fisCspopAVG, fisRspopAVG)
spopSD <- rbind(fisCspopSD, fisRspopSD)

# barplot as used in the supplement (Fis_aveloc_locality.pdf)
# bar1 <- barplot(spopAVG[,c(1:7)], beside= T, las= 2, ylim= c(-1,1)) #, names.arg= c("blo", "lcs", "pow", "pro", "red", "skn", "total", "avg"))
bar1 <- barplot(spopAVG[,c(1:7)], beside= T, las= 2, ylim= c(-1,1), cex.axis= 1.3, cex.names= 1.3)
legend(0, 1, legend= c("common", "rare"), col= c("grey20", "grey70"), cex= 1.5, pch = 15)
error.bar(bar1, spopAVG[,c(1:7)], spopSD[,c(1:7)], length= 0.07)
box()


# vioplots for per-locus Fis values (avg across 100 reps)

# with fisXperloc from below!

fisperlC <- apply(fisCperloc, 1, mean)
fisperlR <- apply(fisRperloc, 1, mean)

vioplot(na.omit(fisperlC), na.omit(fisperlR), col= c("grey70", "grey20"))







# fisCntrpAVG 
ntrpAVG <- rbind(fisCntrpAVG, fisRntrpAVG)
ntrpSD <- rbind(fisCntrpSD, fisRntrpSD)

bar2 <- barplot(ntrpAVG, beside= T, las= 2, ylim= c(-1,1))
legend(28, 1, legend= c("common", "rare"), col= c("grey20", "grey70"), cex= 1.7, pch = 15)
error.bar(bar2, ntrpAVG, ntrpSD, length= 0.07)





#####################

# Fis as a function of maf

###

# 

# get average Fis per locus and spop over all 100 reps. 

# rar
fisRlst <- list()
for(i in 1:7){
	fisRperloc <- matrix(nrow= 2051, ncol= 100) 
	for(j in 1:length(fislst_spopR)){
		fisRperloc[,j] <- fislst_spopR[[j]]$perloc[,i]
	}
	fisRlst[[i]] <- fisRperloc
}

spop <- colnames(fislst_spopR[[1]]$perloc)[1:7]

fisRmean_spop_perloc <- list()
for(i in 1:7){
	xa <- apply(fisRlst[[i]], 1, mean)
	fisRmean_spop_perloc[[i]] <- xa
}


# cmn
fisClst <- list()
for(i in 1:7){
	fisCperloc <- matrix(nrow= 13099, ncol= 100) 
	for(j in 1:length(fislst_spopC)){
		fisCperloc[,j] <- fislst_spopC[[j]]$perloc[,i]
	}
	fisClst[[i]] <- fisCperloc
}

# spopC <- colnames(fislst_spopC[[1]]$perloc)[1:7] same as in RAR

fisCmean_spop_perloc <- list()
for(i in 1:7){
	xa <- apply(fisClst[[i]], 1, mean)
	fisCmean_spop_perloc[[i]] <- xa
}


# combine both CMN and RAR fisXmean_spop_perloc
fis_mean_spop_perloc <- list()
for(i in 1:length(fisRmean_spop_perloc)){
	fis_mean_spop_perloc[[i]] <- c(fisRmean_spop_perloc[[i]], fisCmean_spop_perloc[[i]])
}



vioplot(na.omit(fisCmean_spop_perloc[[1]]), na.omit(fisRmean_spop_perloc[[1]]), na.omit(fisCmean_spop_perloc[[2]]), na.omit(fisRmean_spop_perloc[[2]]), na.omit(fisCmean_spop_perloc[[3]]), na.omit(fisRmean_spop_perloc[[3]]), na.omit(fisCmean_spop_perloc[[4]]), na.omit(fisRmean_spop_perloc[[4]]), na.omit(fisCmean_spop_perloc[[5]]), na.omit(fisRmean_spop_perloc[[5]]), na.omit(fisCmean_spop_perloc[[6]]), na.omit(fisRmean_spop_perloc[[6]]), na.omit(fisCmean_spop_perloc[[7]]), na.omit(fisRmean_spop_perloc[[7]]))





# par(mfrow= c(2,3))
# for(i in 1:dim(fisRlst[[7]])[2]){
# 	vioplot(na.omit(fisRlst[[7]][,i]))
# }

# check: how many NaNs do we have in each respective set
table(is.na(apply(fisRperloc, 1, mean)))
# FALSE 
#  2051 
table(is.na(apply(fisCperloc, 1, mean)))
# FALSE  TRUE 
#  9562  3537     # thus, all NaNs are in the cmn vars

# fisperloc <- rbind(fisRperloc, fisCperloc)

# fisperl <- apply(fisperloc, 1, mean)


########################
# get allele frequencies (from entropy) 
cmn11p <- read.table("~/Desktop/boechera/lasio/common/ntrpy/k11pestdf", header= F, sep= ' ')
rar14p <- read.table('~/Desktop/boechera/lasio/rare/ntrpy/k14pestdf', header= F, sep= ' ')

#
cmnP <- apply(cmn11p, 1, mean)
rarP <- apply(rar14p, 1, mean)

# calculate TOTAL MAFs
mafR <- integer()
for(i in 1:length(rarP)){
	pp <- rarP[i]
	qq <- 1- pp
	mafR[i] <- min(c(pp, qq))
}

mafC <- integer()
for(i in 1:length(cmnP)){
	pp <- cmnP[i]
	qq <- 1- pp
	mafC[i] <- min(c(pp, qq))
}

maff <- c(mafR, mafC)


# p <- c(rarP, cmnP)



# get gprobs and allele freqs per spop averaged across 100 rep runs
# RAR
RARsGlst <- list()       ###### DO NOT RUN THIS! ALREADY IN .RData
for(i in 1:100){
	x <- sampGeno(RARgprob)
	RARsGlst[[i]] <- x
}

# CMN
CMNsGlst <- list()       ###### DO NOT RUN THIS! ALREADY IN .RData
for(i in 1:100){
	x <- sampGeno(CMNgprob)
	CMNsGlst[[i]] <- x
}



###############

getMAF <- function(geno){
	maf <- list()
	nAA <- apply(geno==0,1,sum,na.rm=T)
    nAa <- apply(geno==1,1,sum,na.rm=T)
    naa <- apply(geno==2,1,sum,na.rm=T)
    n <- nAA + nAa + naa
	p <- ((2*nAA)+nAa)/(2*n)
	qq <- 1 - p
	for(i in 1:length(p)){
		maf[[i]] <- min(c(p[i], qq[i]))
	}
	return(unlist(maf))
}




maf_perspopR <- list()
popXR <- matrix(nrow= 2051, ncol= 100)

for(i in 1:length(spop)){
	for(j in 1:length(RARsGlst)){      # 6 pops + total 
		if(spop[i] == "total"){
			maf <- getMAF(round(RARsGlst[[j]]))
			#gprob <- apply(RARsGlst[[j]], 1, mean)
			popXR[,j] <- maf
		}
		else {
			dfGp <- RARsGlst[[j]][, which(subpop == spop[i])]
			maf <- getMAF(round(dfGp))
			popXR[,j] <- maf
		}
		maf_perspopR[[i]] <- apply(popXR, 1, mean)
	}
}

#for(i in 1:length(gprobs_perspopR)){







#
maf_perspopC <- list()
popXC <- matrix(nrow= 13099, ncol= 100)

for(i in 1:length(spop)){
	for(j in 1:length(CMNsGlst)){      # 6 pops + total 
		if(spop[i] == "total"){
			maf <- getMAF(round(CMNsGlst[[j]]))
			popXC[,j] <- maf
		}
		else {
			dfGp <- CMNsGlst[[j]][, which(subpop == spop[i])]
			maf <- getMAF(round(dfGp))			
			gprob <- apply(CMNsGlst[[j]][, which(subpop == spop[i])], 1, mean)
			popXC[,j] <- maf
		}
		maf_perspopC[[i]] <- apply(popXC, 1, mean)
	}
}




### combine CMN and RAR 
maf_perspop <- list()
for(i in 1:length(gprobs_perspopR)){
	maf_perspop[[i]] <- c(maf_perspopR[[i]], maf_perspopC[[i]])
}




# hist of mean maf values per spop
par(mfrow= c(3,3))
for(i in 1:length(spop)){
	hist(maf_perspop[[i]], main= spop[i])
}


# and now to the actual regression

### lm 
mafsp <- maf_perspop
fisperls <- fis_mean_spop_perloc





for(i in 1:length(fisperls)){
	print(paste(spop[i], cor(na.omit(fisperls[[i]]), mafsp[[i]][!is.na(fisperls[[i]])]), sep= ' ')) # change to cov for cov :) 
}

# cor: 

# blo -0.517409140288177
# lcs -0.491148878281113
# pow -0.485390237875695
# pro -0.583141680742004
# red -0.554948701925559
# skn -0.0470023308727715
# total -0.429207616786024

######

# cov:

# blo -0.0320601074848683
# lcs -0.0419449949887849
# pow -0.0410542070823362
# pro -0.0464012142021418
# red -0.0412791558133612
# skn -0.00232074390028977
# total -0.0351068503989772

# Adj.r.squared:

# blo    0.2675
# lcs    0.2411
# pow    0.2355
# pro    0.3399
# red    0.3078
# skn    0.002
# tot    0.1841



#
fisfreqlst <- list()
for(i in 1:length(fisperls)){
	fisfreqlst[[i]] <- lm(fisperls[[i]] ~ mafsp[[i]])
}


for(i in 1:length(fisperls)){
	print(summary(fisfreqlst[[i]]))
}


par(mfrow= c(3,3))
for(i in 1:length(fisfreqlst)){
	plot(mafsp[[i]], fisperls[[i]], main= spop[i], ylab= expression(F[IS]), xlab= "MAF")
	abline(fisfreqlst[[i]], col= 'red')
	abline(v= 0.05)
	points(mafsp[[i]], fis_scld[[i]], cex= 0.1, col= 'blue', pch= '.')
}

# Fis_scaled    # Fis is 1-(2*p/(2*p*q)) or (simplified) Fis = 1 - (1/q); where q = major allele freq

fis_scld <- list()
for(i in 1:length(mafsp)){
	qq <- 1- mafsp[[i]]
	fis_scld[[i]] <- 1-(1/qq)
}

#  only negative values scaled   (we're dividing by the max negative Fis value per locus for every Fis < 0)
#fisNegScld <- list()
fisNew <- fisperls
for(i in 1:length(mafsp)){
	qq <- 1- mafsp[[i]]
	for(j in 1:length(qq)){
		if( is.na(fisNew[[i]][j]) == TRUE){
		}
		else if(fisNew[[i]][j] < 0){
			fisNew[[i]][j] <- fisNew[[i]][j]/(abs(fis_scld[[i]][j]))}
	}
}



# plot scaled Fis 
# par(mfrow= c(3,3))
# for(i in length(fis_scld)){
# 	plot(mafsp[[i]], fis_scld[[i]])
# }


fisScalelst <- list()
for(i in 1:length(fis_scld)){
	fisScalelst[[i]] <- lm(fisNew[[i]]~mafsp[[i]])
}

for(i in 1:length(fisScalelst)){
	print(summary(fisScalelst[[i]]))
}


library(MASS)


par(mfrow= c(3,3))
for(i in 1:length(fisScalelst)){
	plot(mafsp[[i]], fisNew[[i]], main= spop[i], ylab= expression(paste("scaled ", F[IS], sep= '')), xlab= "MAF", pch= '.')
	abline(fisScalelst[[i]], col= 'red')
	abline(v= 0.05)
	d <- kde2d(mafsp[[i]][!is.na(fisNew[[i]])], na.omit(fisNew[[i]]))
	contour(d, add= T)

	#points(mafsp[[i]], fis_scld[[i]], cex= 0.1, col= 'blue', pch= '.')
}

###############   
# plot Fis values ordered by scaffolds (& bp) 

cmnScaff <- read.table("~/Desktop/boechera/lasio/lasioCMNscaffbp.txt", header= F, sep= ' ')
rarScaff <- read.table("~/Desktop/boechera/lasio/lasioRARscaffbp.txt", header= F, sep= ' ')


scaffbp <- rbind(rarScaff, cmnScaff)


#### formatting 
scaf <- substring(scaffbp$V1, 1, 8)
scafnum <- substring(scaffbp$V1, 9, nchar(as.character(scaffbp$V1)))

scafnum5 <- formatC(as.integer(scafnum), width= 5, flag= "0")

bp7 <- formatC(as.integer(scaffbp$V2), width= 7, flag= "0")

scafNum005 <- paste(scaf, scafnum5, sep= '')

scaffbpFC <- cbind(scafNum005, bp7)
####

# 446 scaffolds 

# summary(as.numeric(table(scaffbpFC[ordScaffbp,1])))
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#   1.00    2.00    4.00   33.97   20.00  796.00

###############

# scaffbpFC[order(scaffbpFC[,1], scaffbpFC[,2]),]
ordScaffbp <- order(scaffbpFC[,1], scaffbpFC[,2])
scafN5ord <- scaffbpFC[ordScaffbp,1]

cols = c("red", " green", "blue", "orange") #, "black", "green")

cols2 <- c("grey20", "grey70")

aa <- as.numeric(scafnum5[ordScaffbp])   %% 4    # (modulus operator)   (if use 2, then it will only group into two categories)

# plot Fis sorted by scaffbp position
par(mfrow= c(7,1), mar=c(1.5,2,1,1) + 0.1, oma= c(5,0,0,0), mgp= c(0,1,0))
for(i in 1:length(fisNew)){
	barplot(fisNew[[i]][ordScaffbp], main= spop[i], col= cols[aa+1], border=NA, space= 0)
}



#############################################################
#############################################################

# total Ho and He 
hoheR <- calc_HoHe(sampGeno(RARgprob))
lapply(hoheR, mean)
# $Ho
# [1] 0.05926553
# 
# $He
# [1] 0.07033227

hoheC <- calc_HoHe(sampGeno(CMNgprob), subpop)
lapply(hoheC, mean)
# $Ho
# [1] 0.1799159
# 
# $He
# [1] 0.1580163

barplot(cbind(unlist(lapply(hoheC, mean)), unlist(lapply(hoheR, mean))), beside= T, names.arg= c("cmn", "rar"))

###############
# RAR
outR <- calc_HoHe_rep_subpop(RARgprob, reps= 100)

outRmeanSD <- matrix(ncol= 4, nrow= length(outR), dimnames= list(NULL,c("meanHo", "meanHe", "sdHo", "sdHe")))
for(i in 1:length(outR)){
	meanHoHeRep <- lapply(outR[[i]], mean)
	sdHoHeRep <- lapply(outR[[i]], sd)
	outRmeanSD[i,1:2] <- unlist(meanHoHeRep)
	outRmeanSD[i, 3:4] <- unlist(sdHoHeRep)
}

# CMN
outC <- calc_HoHe_rep_subpop(CMNgprob, reps= 100)

outCmeanSD <- matrix(ncol= 4, nrow= length(outC), dimnames= list(NULL,c("meanHo", "meanHe", "sdHo", "sdHe")))
for(i in 1:length(outC)){
	meanHoHeRep <- lapply(outC[[i]], mean)
	sdHoHeRep <- lapply(outC[[i]], sd)
	outCmeanSD[i,1:2] <- unlist(meanHoHeRep)
	outCmeanSD[i, 3:4] <- unlist(sdHoHeRep)
}


# apply(outCmeanSD, 2, mean)
#    meanHo    meanHe      sdHo      sdHe 
# 0.1905937 0.1928514 0.2709031 0.1908027 

###
# apply(outRmeanSD, 2, mean)
#     meanHo     meanHe       sdHo       sdHe 
# 0.06291690 0.09162406 0.18266322 0.09393724
##############

######    with   subpop

calc_HoHe_rep_subpop <- function(x, spop, reps= 100){
	outlist <- list()
	if(missing(spop)){
		gproblst <- x
		replist <- list()
		for(j in 1:reps){
			replist[[j]] <- calc_HoHe(sampGeno(gproblst))
		}
		return(replist)

	}
		else {
			for(i in 1:length(unique(spop))){
				replist <- list()
				gprob0 <- x[[1]][, which(spop == unique(spop)[i])]
				gprob1 <- x[[2]][, which(spop == unique(spop)[i])]
				gprob2 <- x[[3]][, which(spop == unique(spop)[i])]
				gproblst <- list(gprob0, gprob1, gprob2)
				for(j in 1:reps){
					replist[[j]] <- calc_HoHe(sampGeno(gproblst))
				}
				outlist[[i]] <- replist}
	}
	return(outlist)
}



# RAR
outRspop <- calc_HoHe_rep_subpop(RARgprob, spop= subpop, reps= 100)

#
outRmeanSDspoplst <- list()
outRmeanSDspop <- matrix(ncol= 4, nrow= length(outRspop[[1]]), dimnames= list(NULL,c("meanHo", "meanHe", "sdHo", "sdHe")))
for(i in 1:length(outRspop)){
	for(j in 1:length(outRspop[[i]])){
		meanHoHeRep <- lapply(outRspop[[j]], mean)
		sdHoHeRep <- lapply(outRspop[[j]], sd)
		outRmeanSDspop[j,1:2] <- unlist(meanHoHeRep)
		outRmeanSDspop[j, 3:4] <- unlist(sdHoHeRep)
	}
	outRmeanSDspoplst[[i]] <- outRmeanSDspop
}

matRspop <- matrix(nrow= 6, ncol= 4, dimnames= list(unique(subpop), c("meanHo", "meanHe", "sdHo", "sdHe")))
for(i in 1:length(outRmeanSDspoplst)){
	matRspop[i,] <- apply(na.omit(outRmeanSDspoplst[[i]]), 2, mean)
}


# CMN
outCspop <- calc_HoHe_rep_subpop(CMNgprob, spop= subpop, reps= 100)

#
outCmeanSDspoplst <- list()
outCmeanSDspop <- matrix(ncol= 4, nrow= length(outCspop[[1]]), dimnames= list(NULL,c("meanHo", "meanHe", "sdHo", "sdHe")))
for(i in 1:length(outCspop)){
	for(j in 1:length(outCspop[[i]])){
		meanHoHeRep <- lapply(outCspop[[i]], mean)
		sdHoHeRep <- lapply(outCspop[[i]], sd)
		outCmeanSDspop[j,1:2] <- unlist(meanHoHeRep)
		outCmeanSDspop[j, 3:4] <- unlist(sdHoHeRep)
	}
	outCmeanSDspoplst[[i]] <- outCmeanSDspop
}

matCspop <- matrix(nrow= 6, ncol= 4, dimnames= list(unique(subpop), c("meanHo", "meanHe", "sdHo", "sdHe")))
for(i in 1:length(outCmeanSDspoplst)){
	matCspop[i,] <- apply(na.omit(outCmeanSDspoplst[[i]]), 2, mean)
}




#RARgprob[[1]][which(subpop == unique(subpop)[1]),]


#################################################################
#################################################################

# Fst 


wcFC <- calc_wcFstats(genoCMN, subpop)   # Fst = 0.19547419    (theta_hat)
wcFR <- calc_wcFstats(genoRAR, subpop)   # Fst = 0.37285342     -->> compare these to Fst values for ntrpy frequencies per pop
# global gives Fit, Fst and Fis across loci
# Fst > 0 : individuals are less variable than expected for level of allelic variation seen in total population

sapply(wcFC, head)
sapply(wcFR, head)

par(mfrow= c(2,1))
vioplot(na.omit(wcFC$perloc[,5]), na.omit(wcFR$perloc[,5]), col= "grey70", names= c("common", "rare"), ylim= c(0,1))
vioplot(na.omit(wcFC$perloc[,4]), na.omit(wcFR$perloc[,4]), col= "grey70", names= c("common", "rare"), ylim= c(0,1))


# 
pwFC <- calc_wcFst_spop_pairs(genoCMN, subpop, plot.nj= T)
pwFR <- calc_wcFst_spop_pairs(genoRAR, subpop, plot.nj= T)

# > pwFC
#     blo       lcs        pow        pro       red       skn
# blo  NA 0.2377669 0.30008839 0.35535777 0.4245636 0.3028030
# lcs  NA        NA 0.01194027 0.04313996 0.2655452 0.1580915
# pow  NA        NA         NA 0.03141220 0.3233298 0.2211073
# pro  NA        NA         NA         NA 0.3928950 0.2965903
# red  NA        NA         NA         NA        NA 0.3684895
# skn  NA        NA         NA         NA        NA        NA
# > pwFR
#     blo       lcs         pow          pro       red       skn
# blo  NA 0.2522758 0.308682970  0.293194096 0.6190117 0.5095057
# lcs  NA        NA 0.007043445 -0.027195259 0.5198401 0.4782358
# pow  NA        NA          NA  0.004837293 0.5851614 0.4984917
# pro  NA        NA          NA           NA 0.5516595 0.3561171
# red  NA        NA          NA           NA        NA 0.6106356
# skn  NA        NA          NA           NA        NA        NA
nj.pwFC <- nj(as.dist(t(pwFC)))
nj.pwFR <- nj(as.dist(t(pwFR)))


plot.phylo(nj.pwFC, tip.color= legcol[c(4,1,6,5,3,2)], type='unroot', cex= 1.5, lab4ut= "axial")
add.scale.bar(length= 0.1)
plot.phylo(nj.pwFR, tip.color= legcol[c(4,1,6,5,3,2)], type='unroot', cex= 1.5, lab4ut= "axial", rotate.tree= 180)
add.scale.bar(length= 0.1)
add.scale.bar()    #   guess what that does...

rotate.tree= 
[c(2,6,5,1,4,3)]

###
###############
# allele sharing (see Gao & Stramer 2007 BMC Genetics 8:34)



asCMN <- genoCMN[, ultim_ord]
asRAR <- genoRAR[, ultim_ord]
colnames(asCMN) <- seq(1, 105, 1)
colnames(asRAR) <- seq(1, 105, 1)


ASdist.allpopC <- calc_allele_sharing(asCMN)
ASdist.allpopR <- calc_allele_sharing(asRAR)

#rownames(ASdist.allpopC) <- colnames(ASdist.allpop) <- colnames(geno)	#Note that calc_allele_sharing does not preserve marker labels. 
colpca <- col14[c(10,6,8,4,14,5)]

pop$col <- rep(NA, 105)
pop$col[which(pop$V2 == 'lol')] <- "#D2C948"
pop$col[which(pop$V2 == 'skn')] <- "#CA4B87"
pop$col[which(pop$V2 == 'red')] <- "#79D958"
pop$col[which(pop$V2 == 'blo')] <- "#6386CA"
pop$col[which(pop$V2 == 'pro')] <- "#405043"
pop$col[which(pop$V2 == 'pow')] <- "#5A8E45"



#To use ALLELE-SHARING distance matrix  for NJ Tree: 
library(ape)	

ASdist.allpop.njC <- nj(ASdist.allpopC)
ASdist.allpop.njR <- nj(ASdist.allpopR)

# need to sort the inds so that numbers correspond to manuscript (la105) numbers !!!
par(mfrow= c(1,2))
plot.phylo(ASdist.allpop.njC, tip.color= pop$col[ultim_ord], type='unroot' )
plot.phylo(ASdist.allpop.njR, tip.color= pop$col[ultim_ord], type='unroot' )
# legend(-0.4,0.57, legend= c("lcs", "skn", "red", "blo", "pro", "pow"), col= legcol, pch= '+', cex= 1.2)

# for dendrogram:
# plot(allele.sharing.hclust <- hclust(as.dist(ASdist.allpopC), method="ward.D")) # or

# par(mfrow= c(1,2))
# plot(allele.sharing.hclust <- hclust(as.dist(ASdist.allpopC), method="ward.D2"))
# plot(allele.sharing.hclust <- hclust(as.dist(ASdist.allpopR), method="ward.D2"))


##########################
# LD
# ldC <- calc_LD(genoCMN)
# ldR <- calc_LD(genoRAR)

####################################
# Fstats (Fst) by populations (from ntrpy frequencies)

#cmn11p <- scan('k11p.txt', what= 'character', nlines= 144089)
#rar14p <- scan('rare/ntrpy/k14p.txt', nlines= 28714, what= 'character', sep= ',')
cmn11p <- read.table('k11pestdf', header= F, sep= ' ')
rar14p <- read.table('~/Desktop/boechera/lasio/rare/ntrpy/k14pestdf', header= F, sep= ' ')



# plot freqs per pop    NOTE: need to have colC and colR 
par(mfrow= c(3,4))
for(i in 1:dim(cmn11p)[2]){
	hist(cmn11p[,i], main= i, xlim= c(0,1))
	points(0.5, 2000, pch= 16, cex= 4, col= colC[i]) 
}

par(mfrow= c(2,7))
for(i in 1:dim(rar14p)[2]){
	hist(rar14p[,i], main= i, xlim= c(0,1))
	points(0.5, 500, pch= 16, cex= 4, col= colR[i])
}

# NOTE: insert little pch=16 with the respective color for the cluster!


#####
###############    Fst     from posterior freq estimates
#####

# pbar<-apply(p,2,mean)
# vp<-apply(p,2,var)
# fst<-mean(vp)/mean(pbar * (1 - pbar)) ## ratio of averages

# Fst = var/(pq)

# rare
pbaR <- apply(rar14p, 1, mean)
pqR <- pbaR * (1- pbaR)
vpR <- apply(rar14p, 1, var)
fstR <- mean(vpR)/mean(pqR)    # 0.5189201

# cmn
pbaC <- apply(cmn11p, 1, mean)
pqC <- pbaC * (1- pbaC)
vpC <- apply(cmn11p, 1, var)
fstC <- mean(vpC)/mean(pqC)    # 0.1743196

###################
###### pairwise Fst

# CMN    

library(gtools)

# with 
colC <- col14cmn[c(2,1,5,6,8,4,7,3,9,10,11,12,13,14)]
colC <- colC[c(3,2,1,4,9,6,5,8,7,10,11)]
# and 
plot(seq(1, 11,1), rep(1, 11), col= colC, pch= 16, cex= 3, main= "CMN")

# columns:

# 1 - lcs - pow - pro
# 2 - lcs - skn  (subpop)  sand 
# 3 - lcs (subpop)  purple
# 4 - blo
# 5 - lcs (subpop)- blo
# 6 - skn - blo (<<)
# 7 - lcs - pow - blo
# 8 - red
# 9 - lcs - blo (<<)
# 10 - lcs - pow
# 11 - pow (n=1) - blo (n=3)

#
perm11 <- permutations(n = 11, r = 2, v = 1:11)

# cmn11pwFst <- list()
# for(i in 1:dim(perm11)[1]){
# 	tmp <- cmn11p[, c(perm11[i,1], perm11[i,2])]
# 	pbar_tmp <- apply(tmp, 1, mean)
# 	vp_tmp <- apply(tmp, 1, var)
# 	fst_tmp <- mean(vp_tmp)/mean(pbar_tmp * (1 - pbar_tmp))
# 	cmn11pwFst[[i]] <- fst_tmp
# }
# 
# perm11fst <- cbind(perm11, unlist(cmn11pwFst))	


cmn11pwFst <- matrix(0, nrow= 11, ncol= 11)
for(i in 1:dim(perm11)[1]){
	tmp <- cmn11p[, c(perm11[i,1], perm11[i,2])]
	pbar_tmp <- apply(tmp, 1, mean)
	vp_tmp <- apply(tmp, 1, var)
	fst_tmp <- mean(vp_tmp)/mean(pbar_tmp * (1 - pbar_tmp))
	cmn11pwFst[perm11[i,1], perm11[i,2]] <- fst_tmp
}

nj.CMNfst <- nj(cmn11pwFst)

#############

# RAR 

# with
colR <- c("#CDBA8F", "#B862D3", "#79D958", "#CA4B87", "#D2C948", "#6386CA", "#D1543B", "#7ECDBA", "#6F3636", "#5A8E45", "#583C6D", "#9F7734", "#BDA3BB", "#405043")
colR <- colR[c(7,2,4,9,5,1,11,12,13,10,6,8,3,14)]
# and 
plot(seq(1, 14, 1), rep(1, 14), col= colR, cex= 3, pch= 16, main= "RAR")

# columns:

# 1 - lcs (subpop) (<)  red
# 2 - lcs (subpop)  purple 
# 3 - skn
# 4 - lcs       red 
# 5 -  lcs - pow - pro - blo
# 6 -  skn
# 7 -  lcs - pow - pro
# 8 -  lcs - pow (<<)
# 9 -  lcs - pow - pro
# 10 -  lcs - pow (n=3)
# 11 -  blo - skn (n=1)
# 12 -  lcs (subpop) (<)  teal
# 13 -  red
# 14 -  lcs - pow

#
perm14 <- permutations(n = 14, r = 2, v = 1:14)

# rar14pwFst <- list()
# for(i in 1:dim(perm14)[1]){
# 	tmp <- rar14p[, c(perm14[i,1], perm14[i,2])]
# 	pbar_tmp <- apply(tmp, 1, mean)
# 	vp_tmp <- apply(tmp, 1, var)
# 	fst_tmp <- mean(vp_tmp)/mean(pbar_tmp * (1 - pbar_tmp))
# 	rar14pwFst[[i]] <- fst_tmp
# }
# 
# perm14fst <- cbind(perm14, unlist(rar14pwFst))	


rar14pwFst <- matrix(0, nrow= 14, ncol= 14)
for(i in 1:dim(perm14)[1]){
	tmp <- rar14p[, c(perm14[i,1], perm14[i,2])]
	pbar_tmp <- apply(tmp, 1, mean)
	vp_tmp <- apply(tmp, 1, var)
	fst_tmp <- mean(vp_tmp)/mean(pbar_tmp * (1 - pbar_tmp))
	rar14pwFst[perm14[i,1], perm14[i,2]] <- fst_tmp
}

nj.RARfst <- nj(rar14pwFst)

# plot nj trees 

par(mfrow= c(1,2))
plot.phylo(nj.CMNfst, tip.color= colC, type='unroot', cex= 1.5)
add.scale.bar()
plot.phylo(nj.RARfst, tip.color= colR, type='unroot', cex= 1.5)
add.scale.bar()



###########################################################################
###########################################################################

# maps
library(maps)
library(scales)
library(raster)

# for the composite plot, load PLUS and rare (in resp. script) in here and plot the 3 maps

gps <- read.table("~/Desktop/boechera/lasio/manuscript/data/ids188dipl.txt", header= T, sep= '\t')


############################ PLUS 
### merge k15c and gps; and split based on X
k15q <- read.csv("~/Desktop/boechera/lasio/PLUS/ntrpy/k15q.txt", sep= ',', header=F)
k15qlist <- entr2listlast(k15q, k= 15, nind= 192)    # in /PLUS/ntrpy/scrpt.r
k15ch <- k15qlist[[4]]
ids188 <- read.table("~/Desktop/boechera/lasio/manuscript/data/ids188dipl.txt", header= T, sep= '\t')

drp188 <- inds192 %in% ids188$idshort
k15c <- k15ch[drp188,]

k15c$ids <- inds192[drp188]
a188 <- gps[order(gps$ids),]
a188$ids <- as.character(a$ids)

apgps188 <- merge(a188, k15c, by= "ids")

localsplit188 <- split(apgps, apgps$localsh)

# jitter for subsequent plots
jitterlong13 <- jitter(apgps$long[grep("-13", apgps$id)], factor= 0.0002, amount= 0.0002)
jitterlat13 <- jitter(apgps$lat[grep("-13", apgps$id)], factor= 0.0002, amount= 0.0002)

#lat188 <- lcs188[,8]
#long188 <- lcs188[,9]
#### logan canyon sinks 

lcs188 <- localsplit188$lcs
col17 <- c("#813a2d", "#6ed55a", "#653e8c", "#ccd34a", "#6f74c9", "#b75af8", "#c64776", "#423048", "#ff7b61", "#7ba3bf", "#c68d39", "#c8d0cd", "#c0d69b", "#3ba289", "#c19581", "#d093c6", "#567033")
col188 <- col17[c(1,2,3,13,5,6,7,8,9,10,11,12,4,14,15,16,17)]
lcs188$long[grep("-13", lcs188$id)] <- jitterlong13
lcs188$lat[grep("-13", lcs188$id)] <- jitterlat13

plot(localsplit188$lcs$long, localsplit188$lcs$lat, type= 'n', main= '', xlab= "longitude", ylab= "latitude")

for(i in 1:dim(lcs)[1]){
	#add.pie(z= as.numeric(lcs188[i,13:27]), x= jitter(lcs188[i, 9], factor= 0.0001, amount= 0.0001), y= jitter(lcs188[i,8], factor= 0.0001, amount= 0.0001), labels= '', col= alpha(col188, 0.7), radius= 0.0001)
	add.pie(z= as.numeric(lcs188[i,13:27]), x= lcs188[i, 9], y= lcs188[i,8], labels= '', col= alpha(col188, 0.8), radius= 0.0001)
}
scalebar(0.1, lonlat= T, type= 'line', below= "km")



########### common

### merge k11d and gps; and split based on X

k11d$ids <- inds_drop
a <- gps[order(gps$ids),]
a$ids <- as.character(a$ids)

apgps <- merge(a, k11d, by= "ids")
localsplit <- split(apgps, apgps$localsh)

#latcmn <- lcs[,8]
#long <- lcs[,9]
#### logan canyon sinks 

lcs <- localsplit$lcs
cols <- col14[c(3,2,1,4,9,6,5,8,7,10,11,12:13)]
# NOTE: this changes the original vector!
lcs$long[grep("-13", lcs$id)] <- jitterlong13
lcs$lat[grep("-13", lcs$id)] <- jitterlat13


plot(localsplit$lcs$long, localsplit$lcs$lat, type= 'n', main= '', xlab= "longitude", ylab= "latitude")

for(i in 1:dim(lcs)[1]){
	#add.pie(z= as.numeric(lcs[i,13:23]), x= jitter(lcs[i, 9], factor= 0.0001, amount= 0.0001), y= jitter(lcs[i,8], factor= 0.0001, amount= 0.0001), labels= '', col= alpha(cols, 0.8), radius= 0.0001)
	add.pie(z= as.numeric(lcs[i,13:23]), x= lcs[i, 9], y= lcs[i,8], labels= '', col= alpha(cols, 0.8), radius= 0.0001)
}
scalebar(0.1, lonlat= T, type= 'line', below= "km")


##################   rare 
k14rare <- read.csv("~/Desktop/boechera/lasio/rare/ntrpy/k14estdf", header= F, sep= ' ')
k14d <- k14rare[drp,]

### merge k11d and gps; and split based on X

k14d$ids <- inds_drop
ara <- gps[order(gps$ids),]
ara$ids <- as.character(ara$ids)

apgpsra <- merge(ara, k14d, by= "ids")

localsplitra <- split(apgpsra, apgpsra$localsh)

#### logan canyon sinks 

lcsra <- localsplitra$lcs
col14ra<- c("#CDBA8F", "#B862D3", "#79D958", "#CA4B87", "#D2C948", "#6386CA", "#D1543B", "#7ECDBA", "#6F3636", "#5A8E45", "#583C6D", "#9F7734", "#BDA3BB", "#405043")
colsra <- col14ra[c(7,2,4,9,5,1,11,12,13,10,6,8,3,14)]

# use sub-jittered version   NOTE: this changes the original vector
lcsra$long[grep("-13", lcsra$id)] <- jitterlong13
lcsra$lat[grep("-13", lcsra$id)] <- jitterlat13



plot(localsplitra$lcs$long, localsplitra$lcs$lat, type= 'n', main= '', xlab= "longitude", ylab= "latitude")

for(i in 1:dim(lcsra)[1]){
	#add.pie(z= as.numeric(lcsra[i,13:23]), x= jitter(lcsra[i, 9], factor= 0.0001, amount= 0.0001), y= jitter(lcsra[i,8], factor= 0.0001, amount= 0.0001), labels= '', col= alpha(colsra, 0.8), radius= 0.0001)
	add.pie(z= as.numeric(lcsra[i,13:23]), x= lcsra[i, 9], y= lcsra[i,8], labels= '', col= alpha(colsra, 0.8), radius= 0.0001)
}
scalebar(0.1, lonlat= T, type= 'line', below= "km")



###################

# calculate Moran's I within lcs

# library(ape)

gps <- read.table("~/Desktop/boechera/lasio/manuscript/data/ids188dipl.txt", header= T, sep= '\t')
gps_ord <- gps[order(gps$ids),]
gps_ord$ids <- as.character(gps_ord$ids)

# rare 



gprobsra <- read.csv("~/Desktop/boechera/lasio/rare/ntrpy/k14gprob.txt", header= T, sep= ',')
gprobra <- gprobsra[drp,2:2052]
#gprobz <- gprob[,apply(gprobra, 2, var, na.rm=TRUE) != 0]   # 13074 vars (cmn)

gprobra$ids <- inds_drop
gprobsgpsra <- merge(gps_ord, gprobra, by= "ids")
localsplitcmnra <- split(gprobsgpsra, gprobsgpsra$localsh)
gplcsra <- localsplitcmnra$lcs

#gplcsra <- lcsra
gplcsra14 <- gplcsra[grep("-14", gplcsra$id),]
lcsids <- gplcsra14$ids

dists <- as.matrix(dist(cbind(gplcsra14$lon, gplcsra14$lat)))
diag(dists) <- 0

dists.inv <- 1/dists
diag(dists.inv) <- 0

gprobzra <- gplcsra14[,13:2063]
# loop through variants; calc Moran's I for each locus (Zach used pops, and had allele freqs; we use individual genotype probs?)
# " We tested for significant deviations from random spatial patterns in each distance class using a randomization test with 1000 permutations of population labels." (from Gompert2014) 

# "We calculated the sample allele frequency for each population and locus by summing the expected genotypic values and dividing by twice the number of sampled individuals."raredists <- as.matrix(dist(cbind(gplcsra14$lon, gplcsra14$lat)))

cmnk11gprob <- read.table("k11gprob.txt", header= T, sep= ',')

#gprobs <- cmnk11gprob[drp,2:13100]
gprobs <- cmnk11gprob[drp,2:13100]

#lasio_apgps <- apgps[which(apgps$localsh == "lcs"),]

#lasio14_apgps <- lasio_apgps[grep("-14", lasio_apgps$id),]


gprobs$ids <- inds_drop
#ara$ids <- as.character(ara$ids)

gprobsgps <- merge(gps_ord, gprobs, by= "ids")
localsplitcmn <- split(gprobsgps, gprobsgps$localsh)
gplcs <- localsplitcmn$lcs

gplcs14 <- gplcs[grep("-14", gplcs$id),]
#lcsids <- gplcs14$ids

# common
#cmndists <- as.matrix(dist(cbind(gplcs14$lon, gplcs14$lat)))
#cmndists.inv <- 1/cmndists
#diag(cmndists.inv) <- 0

gprob <- gplcs14[,14:13111]
gprobz <- gprob[,apply(gprob, 2, var, na.rm=TRUE) != 0]   # 13074 vars (cmn)


# site frequency spectra 
cmnG <- gprobs
rareG <- gprobsra[drp,]

lasioG <- cbind(cmnG[,1:13099], rareG[,2:2052])


# gprobsgps$localsh  has the localsh (pops)
lasioGsplt <- split(lasioG, as.character(gprobsgps$localsh))

lasioGsplt_allcnt <- list()
loci_list <- list()
for(i in 1:length(lasioGsplt)){
	for(j in 1:dim(lasioGsplt[[i]])[2]){   # columns (i.e. loci)
		allele_count <- 0
		for(k in 1:dim(lasioGsplt[[i]])[1]){    # rows (i.e. inds)
			locus_k <- round(lasioGsplt[[i]][k, j])
			if(locus_k == 1){
				allele_count <- allele_count + 1}
			else if(locus_k == 2){
				allele_count <- allele_count + 2}
			
			loci_list[[j]] <- allele_count	
		}
		
	}
	lasioGsplt_allcnt[[i]] <- unlist(loci_list)
}

# barplot(table(factor(lasioGsplt_allcnt[[2]], levels= 1:130)))

# marginal allele frequency spectra per locality
par(mfrow= c(2,3))
for(i in 1:length(lasioGsplt_allcnt)){
	barplot(table(factor(lasioGsplt_allcnt[[i]], levels= 0:length(table(lasioGsplt_allcnt[[i]])))))
}


###################################

library(OpenStreetMap)
library(rgdal)

gps <- read.table("~/Desktop/boechera/lasio/manuscript/data/tab105.txt", sep= '\t', header= T)
noPro <- gps[which(gps$localsh != "pro"),]

map <- openmap(c(lat= 40.60, lon= -112.3), c(lat= 42, lon= -111.0), type= "stamen-terrain", minNumTiles= 4)
plot(map)

pts <- as.data.frame(cbind(lat= gps$lat, lon= gps$long))
plot(pts, add= T, pch= '+')

#pts <- SpatialPoints(cbind(lat= noPro$lat, lon= noPro$long), proj4string=P4S.latlon)

#subscr <- as.data.frame(cbind(lat= noPro$lat, lon= noPro$long))
#coordinates(subscr)<-~lat+lon


#P4S.latlon <- CRS("+proj=longlat +datum=WGS84")

###############
# now the mapquest-aerial  (from their API)

ul <- c(40.6, -112.3)
lr <- c(42, -111)
url <- "https://a.tiles.mapbox.com/v4/mapquest.satellitenolabels/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwcXVlc3QiLCJhIjoiY2Q2N2RlMmNhY2NiZTRkMzlmZjJmZDk0NWU0ZGJlNTMifQ.mPRiEubbajc6a5y9ISgydg"

map <- openmap(ul, lr, minNumTiles= 4, type= url)
plot(map)
plot(pts, add= T)   # not working



# upper left; then lower right
#nm <- "nps"
#
#map = openmap(c(lat= 38.05025395161289,   lon= -123.03314208984375),
#			c(lat= 36.36822190085111,   lon= -120.69580078125),
#			minNumTiles=9,type=nm[i])
#	plot(map)
#	title(nm,cex.main=4)
#
#plot(gps$long, gps$lat, add = T, pch= '+')
#
#
#
#ul <- c(40.9,-74.5)
#lr <- c(40.1,-73.2)
#par(mfrow=c(2,3))
#url <- "https://a.tiles.mapbox.com/v4/mapquest.streets-mb/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwcXVlc3QiLCJhIjoiY2Q2N2RlMmNhY2NiZTRkMzlmZjJmZDk0NWU0ZGJlNTMifQ.mPRiEubbajc6a5y9ISgydg"
#map <- openmap(ul,lr,minNumTiles=4, type=url)
#plot(map)



#url <- "https://a.tiles.mapbox.com/v4/mapquest.satellitenolabels/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwcXVlc3QiLCJhIjoiY2Q2N2RlMmNhY2NiZTRkMzlmZjJmZDk0NWU0ZGJlNTMifQ.mPRiEubbajc6a5y9ISgydg"
#map <- openmap(ul,lr,minNumTiles=1, type=url)
#plot(map)
#
#
#
##nm = c("osm", "maptoolkit-topo",
#"waze", "mapquest", "mapquest-aerial",
#"bing", "stamen-toner", "stamen-terrain",
#"stamen-watercolor", "osm-german", "osm-wanderreitkarte",
#"mapbox", "esri", "esri-topo",
#"nps", "apple-iphoto", "skobbler",
# "opencyclemap", "osm-transport",
#"osm-public-transport", "osm-bbike", "osm-bbike-german")
#
#png(width=1200,height=2200)
#par(mfrow=c(6,4))
#for(i in 1:length(nm)){
#	print(nm[i])
#	map = openmap(c(lat= 38.05025395161289,   lon= -123.03314208984375),
#			c(lat= 36.36822190085111,   lon= -120.69580078125),
#			minNumTiles=9,type=nm[i])
#	plot(map)
#	title(nm[i],cex.main=4)
#}
#dev.off()

###################################

#g2<-read.table("~/Desktop/evoGeno/assignments/03_coal/data2.txt",header=FALSE)
#acnt2<-apply(g2,2,sum)
#barplot(table(factor(acnt2,levels=1:30)),xlab="allele count",ylab="frequency")
			

###########################

###################################

library(spdep)

coords <- cbind(gplcsra14$lon, gplcsra14$lat)
coords[,1] <- coords[,1] *(-1)
#cell2nb(coords)
distco <- mat2listw(as.matrix(dist(coords)))

lasioG <- rbind(cmnG, rareG)

######### rare variants
#ty <- moran.test(gprobzra[,1], distco, na.action= na.omit, zero.policy= T, rank= T, adjust.n = 7)
tymc <- moran.mc(gprobzra[,1], distco, na.action= na.omit, zero.policy= T, adjust.n = 7, nsim= 999)


# create nb (neighbor) object with euclidean distances
lcsnb <- dnearneigh(coords, 0, 0.1, row.names= lcsids, longlat= T)

#lcscorr <- sp.correlogram(lcsnb, gprobzra[,1], order= 6, method= "I", zero.policy= T)
#lcscorr <- sp.correlogram(lcsnb, gprobzra[,3], order= 7, method= "I", zero.policy= T, style= 'W', randomisation= F)
###

rare_corr <- list()
rare_corrp <- list()
for(i in 1:dim(gprobzra)[2]){
	iracor <- sp.correlogram(lcsnb, gprobzra[,i], order= 7, method= "I", zero.policy= T, randomisation= F)
	rare_corr[[i]] <- iracor
	pval <- print(iracor)
	rare_corrp[[i]] <- pval[,5] # this works, but it prints all of the shit to the screen...    NOTE: to be done for cmn...
} 
#"bonferroni"
###
rare_tstI <- list()
rare_tstp <- list()
for(i in 1:dim(gprobzra)[2]){
	itest <- moran.test(gprobzra[,i], distco, na.action= na.omit, zero.policy= T, rank= T, adjust.n = T)
	rare_tstI[[i]] <- itest$statistic
	rare_tstp[[i]] <- itest$p.value
}

#print(x, p.adj.method="none", ...)
#lapply(df, function(x) x[!is.na(x)])


###
rare_mcI <- list()
rare_mcp <- list()
for(i in 1:dim(gprobzra)[2]){
	imc <- moran.mc(gprobzra[,i], distco, na.action= na.omit, zero.policy= T, adjust.n = T, nsim= 999)
	rare_mcI[[i]] <- imc$statistic
	rare_mcp[[i]] <- imc$p.value
}



######### and now for common 

cmn_corrI <- list()
cmn_corrp <- list()
for(i in 1:dim(gprobz)[2]){
	icmncorr <- sp.correlogram(lcsnb, gprobz[,i], order= 7, method= "I", zero.policy= T, randomisation= F)
	cmn_corrI[[i]] <- icmncorr
	pval <- print(icmncorr)
	cmn_corrp[[i]] <- pval[,5]
}

###
cmn_tstI <- list()
cmn_tstp <- list()

for(i in 1:dim(gprobz)[2]){
	itest <- moran.test(gprobz[,i], distco, na.action= na.omit, zero.policy= T, rank= T, adjust.n = T, randomisation= F)
	cmn_tstI[[i]] <- itest$statistic
	cmn_tstp[[i]] <- itest$p.value
}

###
cmn_mcI <- list()
cmn_mcp <- list()
for(i in 1:dim(gprobz)[2]){
	imc <- moran.mc(gprobz[,i], distco, na.action= na.omit, zero.policy= T, adjust.n = T, nsim= 999)
	cmn_mcI[[i]] <- imc$statistic
	cmn_mcp[[i]] <- imc$p.value
}

### get all estimated values and sd for 
# rare 
rarest <- as.data.frame(matrix(nrow= 7))
raresd <- as.data.frame(matrix(nrow= 7))
rarep <- as.data.frame(matrix(nrow= 7))
for(i in 1:length(rare_corr)){
	rarest[,i] <-rare_corr[[i]]$res[,1]
	raresd[,i] <- rare_corr[[i]]$res[,3]
	rarep[,i] <- rare_corrp[[i]]
	}

# common
cmnest <- as.data.frame(matrix(nrow= 7))
cmnsd <- as.data.frame(matrix(nrow= 7))
cmnp <- as.data.frame(matrix(nrow= 7))
for(i in 1:length(cmn_corr)){
	cmnest[,i] <- cmn_corrI[[i]]$res[,1]
	cmnsd[,i] <- cmn_corrI[[i]]$res[,3]
	cmnp[,i] <- cmn_corrp[[i]]
}


# plot correlogram
#library(Hmisc)
#
#plot(seq(0.9,6.9,1), apply(cmnest,1, median), lty= 2, cex= 0.7, col= 'black', xlim= c(0.7, 7.3), ylim= c(-0.15, 0.15), type= 'l', xlab= "Distance", ylab= "Moran's I", cex.labels= 1.3, cex.names= 1.4)    #main= "common (n = 13,099)", 
#points(seq(0.9,6.9,1), apply(cmnest, 1, median), pch= 17)
#abline(h= 0)
#errbar(x= seq(0.9, 6.9, 1), y= apply(cmnest, 1, mean), yminus= apply(cmnest, 1, mean) - apply(cmnest, 1, sd), yplus= apply(cmnest, 1, mean) + apply(cmnest, 1, sd), add= T, cap= 0.01)
#
#
##
##plot(apply(dfest,1, median), lty= 2, cex= 0.7, main= "rare (n = 2,051)", ylim= c(-0.15, 0.15), type= 'l', xlab= "Distance", ylab= "Moran's I")
##abline(h= 0)
#errbar(x= seq(1.1, 7.1, 1), y= apply(dfest, 1, mean), yminus= apply(dfest, 1, mean) - apply(dfest, 1, sd), yplus= apply(dfest, 1, mean) + apply(dfest, 1, sd), add= T, cap= 0.01, col= 'red', errbar.col= "red")
#lines(seq(1.1, 7.1, 1), apply(dfest, 1, median), lty= 2, col= 'red')
#points(seq(1.1,7.1,1), apply(dfest, 1, median), pch= 17, col= 'red')
#legend(5.8, 0.15, legend= c("common", "rare"), col= c("black", "red"), cex= 1.3, lty= c(1,1), lwd= c(2.5, 2.5))

################# 
# violin plot

library(vioplot)

#x <- apply(cmnest, 1, mean)
x <- cmnest
xp <- cmnp
y <- t(apply(rarest, 1, na.omit))    # 2027 variants (w/o NAs)
yp <- t(apply(rarep, 1, na.omit))	 #       " 
#
par(mfrow= c(2,2))
vioplot(as.numeric(x[1,]), as.numeric(x[2,]), as.numeric(x[3,]), as.numeric(x[4,]), as.numeric(x[5,]), as.numeric(x[6,]), as.numeric(x[7,]), col= "grey70", ylim= c(-0.6, 0.6))
abline(h= 0, lty= 2)
vioplot(as.numeric(xp[1,]), as.numeric(xp[2,]), as.numeric(xp[3,]), as.numeric(xp[4,]), as.numeric(xp[5,]), as.numeric(xp[6,]), as.numeric(xp[7,]), col= "grey70")
abline(h= 0.05, lty= 2)


#
vioplot(as.numeric(y[1,]), as.numeric(y[2,]), as.numeric(y[3,]), as.numeric(y[4,]), as.numeric(y[5,]), as.numeric(y[6,]), as.numeric(y[7,]), col= "grey70", ylim= c(-0.6, 0.6))
abline(h= 0, lty= 2)
vioplot(as.numeric(yp[1,]), as.numeric(yp[2,]), as.numeric(yp[3,]), as.numeric(yp[4,]), as.numeric(yp[5,]), as.numeric(yp[6,]), as.numeric(yp[7,]), col= "grey70")
abline(h= 0.05, lty= 2)

axis(2, at= c(0, 0.5, 1), cex.axis= 2, las= 2, pos= -0.2)



#do.call(vioplot, lapply(y, na.omit))


#################
# plots for tst and mc 

# tst
par(mfrow= c(2,2))
hist(as.numeric(cmn_tstI), main= '', xlab= "Moran's I", xlim= c(-10, 2), breaks= 20)
hist(as.numeric(cmn_tstp), main= '', xlab= "p-values", xlim= c(0,1))
abline(v= 0.05, lty= 2)
#
hist(as.numeric(rare_tstI), main= '', xlab= "Moran's I", xlim= c(-10, 2))
hist(as.numeric(rare_tstp), main= '', xlab= "p-values", xlim= c(0,1), breaks= 15)
abline(v= 0.05, lty= 2)


# mc

par(mfrow= c(2,2))
hist(as.numeric(cmn_mcI), main= '', xlab= "Moran's I", xlim= c(-0.15, 0))
hist(as.numeric(cmn_mcp), main= '', xlab= "p-values")
abline(v= 0.05, lty= 2)
#
hist(as.numeric(rare_mcI), main= '', xlab= "Moran's I", xlim= c(-0.15, 0))
hist(as.numeric(rare_mcp), main= '', xlab= "p-values", breaks= 15)
abline(v= 0.05, lty= 2)

###############################
# vioplot(x1, x2, x3, x4, h=0.05, names= c('unfiltered', 'TF', 'AF', 'MAFF'), col= 'grey80')
# abline(h=0.05)
# text(0.8, 0.82, label= '80%')
# text(1.8, 0.82, label= '79%')
# text(2.8, 0.82, label= '95%')
# text(3.8, 0.82, label= '57%')

###################
# get tests and mc for both rare and common

## rare 
#raretst <- as.data.frame(matrix(nrow= 7))
##dfsd <- as.data.frame(matrix(nrow= 7))
#for(i in 1:length(rare_tsts)){
#	raretst[,i] <- rare_tsts[[i]]       #$res[,1]
#}
#
#raremc <- 
#for(i in 1:length(rare_mc)){
#	raremc[,i] <- rare_mc[[i]]       #$res[,1]
#}




# common
cmntst <- as.data.frame(matrix(nrow= 7))
#cmnsd <- as.data.frame(matrix(nrow= 7))
for(i in 1:length(cmn_tsts)){
	cmntst[,i] <- cmn_tsts[[i]]         #$res[,1]
}

cmnmc <- 
for(i in 1:length(cmn_mc)){
	raremc[,i] <- rare_mc[[i]]       #$res[,1]
}

#####################################################################
#####################################################################

example(nc.sids)
ft.SID74 <- sqrt(1000)*(sqrt(nc.sids$SID74/nc.sids$BIR74) +
sqrt((nc.sids$SID74+1)/nc.sids$BIR74))
tr.SIDS74 <- ft.SID74*sqrt(nc.sids$BIR74)
cspc <- sp.correlogram(ncCC89_nb, tr.SIDS74, order=8, method="corr",
zero.policy=TRUE)
print(cspc)
plot(cspc)
Ispc <- sp.correlogram(ncCC89_nb, tr.SIDS74, order=8, method="I",
zero.policy=TRUE)





example(columbus)
coordsx <- coordinates(columbus)
rn <- sapply(slot(columbus, "polygons"), function(x) slot(x, "ID"))
k1 <- knn2nb(knearneigh(coordsx))
all.linked <- max(unlist(nbdists(k1, coordsx)))
col.nb.0.all <- dnearneigh(coordsx, 0, all.linked, row.names=rn)
summary(col.nb.0.all, coordsx)
plot(columbus, border="grey")
plot(col.nb.0.all, coordsx, add=TRUE)
title(main=paste("Distance based neighbours 0-",  format(all.linked),
 " distance units", sep=""))


#####################################################################







#gplist <- list()
#gpexp <- list()
#gsd <- list()
#gpval <- list()
#nloc <- integer()
#for(i in 1:dim(gprobz)[2]){
#	nloc <- nloc+1 
#	gplist[i] <- Moran.I(gprobzra[,i], cmndists.inv)$observed
#	gpexp[i] <- Moran.I(gprobz[,i], cmndists.inv)$expected
#	gsd[i] <- Moran.I(gprobz[,i], cmndists.inv)$sd
#	gpval[i] <- Moran.I(gprobz[,i], cmndists.inv)$p.value
#}
#
#
#
#conclst <- function(x,...){
#	y <- c()
#	for (i in 1:length(x)){
#		y[i] <- x[[i]]
#	}
#	return(y)
#}
#
#obscmn <- conclst(gplist)
#expcmn <- conclst(gpexp)
#sdcmn <- conclst(gsd)
#pcmn <- conclst(gpval)
#
#
#cmn <- list(obscmn, expcmn, sdcmn, pcmn)
#lapply(cmn, mean)
#
############################
#
#
#
#library(ade4)
#
##cmnd <- as.data.frame(cmndists)
##cmnincmat <- neig2mat(
#
#gm1 <- gearymoran(bilis= cmndists, X= gprobz, nrepet= 999)
#
#gm2 <- gearymoran(bilis= raredists, X= gprobzra, nrepet= 999)
#
#par(mfrow= c(1,2))
#boxplot(gm1$obs, main= "common", ylim= c(-0.16, 0))
#boxplot(gm2$obs, main= "rare", ylim= c(-0.16, 0))
#
#
#colnames(dists) <- lcsids
#rownames(dists) <- lcsids
############################
#### bins 
#m <- dists
#m[dists <= 0.001] <- 1
#m[dists > 0.001] <- 2
#m[dists > 0.002] <- 3
#m[dists > 0.003] <- 4
#m[dists > 0.004] <- 5
#m[dists > 0.005] <- 6
#m[dists > 0.006] <- 7
#diag(m) <- 0
#
##gm3 <- gearymoran(bilis= m, X= gprobz, nrepet= 999)
##gm4 <- gearymoran(bilis= m, X= gprobzra, nrepet= 999)
#
############################
#
#mat1 <- matrix(data= NA, nrow= 48, ncol= 48, dimnames = list(lcsids, lcsids))
#mat2 <- matrix(data= NA, nrow= 48, ncol= 48, dimnames = list(lcsids, lcsids))
#mat3 <- matrix(data= NA, nrow= 48, ncol= 48, dimnames = list(lcsids, lcsids))
#mat4 <- matrix(data= NA, nrow= 48, ncol= 48, dimnames = list(lcsids, lcsids))
#mat5 <- matrix(data= NA, nrow= 48, ncol= 48, dimnames = list(lcsids, lcsids))
#mat6 <- matrix(data= NA, nrow= 48, ncol= 48, dimnames = list(lcsids, lcsids))
#mat7 <- matrix(data= NA, nrow= 48, ncol= 48, dimnames = list(lcsids, lcsids))
#lst <- list(mat1, mat2, mat3, mat4, mat5, mat6, mat7)
####
#id1 <- vector(mode= "character")
#id2 <- vector(mode= "character")
#id3 <- vector(mode= "character")
#id4 <- vector(mode= "character")
#id5 <- vector(mode= "character")
#id6 <- vector(mode= "character")
#id7 <- vector(mode= "character")
#lst <- list(id1, id2, id3, id4, id5, id6, id7)
####
#dst1 <- as.data.frame(matrix(ncol= 3))
#dst2 <- as.data.frame(matrix(ncol= 3))
#dst3 <- as.data.frame(matrix(ncol= 3))
#dst4 <- as.data.frame(matrix(ncol= 3))
#dst5 <- as.data.frame(matrix(ncol= 3))
#dst6 <- as.data.frame(matrix(ncol= 3))
#dst7 <- as.data.frame(matrix(ncol= 3))
#lst <- list(dst1, dst2, dst3, dst4, dst5, dst6, dst7)
#
#
#matNA <- function(...){
#	for(i in 1:dim(m)[1]){
#		for(j in 1:dim(m)[2]){
#			val <- m[i, j]
#			if(val== 1){
#				lst[[val]][i, j] <- dists[i,j]}		#lst[[val]][dim(lst[[val]])+1] <- dists[i, j]}
#			else if (val == 2){
#				lst[[val]][i, j] <- dists[i,j]}
#			else if (val == 3){
#				lst[[val]][i, j] <- dists[i,j]}
#			else if (val == 4){
#				lst[[val]][i, j] <- dists[i,j]}
#			else if (val == 5){
#				lst[[val]][i, j] <- dists[i,j]}
#			else if (val == 6){
#				lst[[val]][i, j] <- dists[i,j]}
#			else if (val == 7){
#				lst[[val]][i, j] <- dists[i,j]}
#	}}
#	return(lst)
#}
#
#
###################
#
#
#
#
#for(i in 1:dim(m)[1]){
#	for(j in 1:dim(m)[2]){
#	val <- m[i, j]
#		if(val== 1){
#			lst[[val]][dim(lst[[val]])[1]+1,1] <- lcsids[i]
#			lst[[val]][dim(lst[[val]])[1]+1,1] <- lcsids[j]}
#		#lst[[val]][length(lst[[val]])] <- lcsids[i]
#		#lst[[val]][length(lst[[val]])] <- lcsids[j]}
#		#lst[[val]][i, j] <- dists[i,j]}		#lst[[val]][dim(lst[[val]])+1] <- dists[i, j]}
#		#print(paste(lcsids[i], lcsids[j], val, dists[i,j], sep= " "))}
#		else if (val == 2){
#			lst[[val]][dim(lst[[val]])[1]+1,1] <- lcsids[i]
#			lst[[val]][dim(lst[[val]])[1]+1,1] <- lcsids[j]}
#		#lst[[val]][i, j] <- dists[i,j]}
#		#print(paste(lcsids[i], lcsids[j], val, dists[i,j], sep= " "))}
#		else if (val == 3){
#			lst[[val]][dim(lst[[val]])[1]+1,1] <- lcsids[i]
#			lst[[val]][dim(lst[[val]])[1]+1,1] <- lcsids[j]}
#
#		#lst[[val]][i, j] <- dists[i,j]}
#		#print(paste(lcsids[i], lcsids[j], val, dists[i,j], sep= " "))}
#		else if (val == 4){
#			lst[[val]][dim(lst[[val]])[1]+1,1] <- lcsids[i]
#			lst[[val]][dim(lst[[val]])[1]+1,1] <- lcsids[j]}
#
#		#lst[[val]][i, j] <- dists[i,j]}
#		#print(paste(lcsids[i], lcsids[j], val, dists[i,j], sep= " "))}
#		else if (val == 5){
#			lst[[val]][dim(lst[[val]])[1]+1,1] <- lcsids[i]
#			lst[[val]][dim(lst[[val]])[1]+1,1] <- lcsids[j]}
#
#		#lst[[val]][i, j] <- dists[i,j]}
#		#print(paste(lcsids[i], lcsids[j], val, dists[i,j], sep= " "))}
#		else if (val == 6){
#			lst[[val]][dim(lst[[val]])[1]+1,1] <- lcsids[i]
#			lst[[val]][dim(lst[[val]])[1]+1,1] <- lcsids[j]}
#
#		#lst[[val]][i, j] <- dists[i,j]}
#		#print(paste(lcsids[i], lcsids[j], val, dists[i,j], sep= " "))}
#		else if (val == 7){
#			lst[[val]][dim(lst[[val]])[1]+1,1] <- lcsids[i]
#			lst[[val]][dim(lst[[val]])[1]+1,1] <- lcsids[j]}
#
#		#lst[[val]][i, j] <- dists[i,j]}
#		#print(paste(lcsids[i], lcsids[j], val, dists[i,j], sep= " "))}
#	}
#}
#
#
#data[rowSums(is.na(data)) != ncol(data),]
#
#as.dist(xtabs(df[, 3] ~ df[, 2] + df[, 1]))
#
#
#
##distsbin7 <- split(dists, m)
#
#
####################################
#groupdists <- function(...){
#	dst1 <- as.data.frame(matrix(ncol= 4))
#	dst2 <- as.data.frame(matrix(ncol= 4))
#	dst3 <- as.data.frame(matrix(ncol= 4))
#	dst4 <- as.data.frame(matrix(ncol= 4))
#	dst5 <- as.data.frame(matrix(ncol= 4))
#	dst6 <- as.data.frame(matrix(ncol= 4))
#	dst7 <- as.data.frame(matrix(ncol= 4))
#	for(i in 1:dim(m)[1]){
#		for(j in 1:dim(m)[2]){
#			val <- m[i, j]
#			if(val== 1){
#				#lst[[val]] <- matrix(nrow= 48, ncol= 48)
#				#lst[[val]][dim(lst[[val]])+1] <- dists[i, j]}
#				dst1[i,] <- c(lcsids[i], lcsids[j], as.numeric(dists[i,j]), val)}
#				#print(paste(lcsids[i], lcsids[j], val, dists[i,j], sep= " "))}
#			else if (val == 2){
#				dst2[i,] <- c(lcsids[i], lcsids[j], as.numeric(dists[i,j]), val)}
#				#print(paste(lcsids[i], lcsids[j], val, dists[i,j], sep= " "))}
#			else if (val == 3){
#				dst3[i,] <- c(lcsids[i], lcsids[j], as.numeric(dists[i,j]), val)}
#				#print(paste(lcsids[i], lcsids[j], val, dists[i,j], sep= " "))}
#			else if (val == 4){
#				dst4[i,] <- c(lcsids[i], lcsids[j], as.numeric(dists[i,j]), val)}
#				#print(paste(lcsids[i], lcsids[j], val, dists[i,j], sep= " "))}
#			else if (val == 5){
#				dst5[i,] <- c(lcsids[i], lcsids[j], as.numeric(dists[i,j]), val)}
#				#print(paste(lcsids[i], lcsids[j], val, dists[i,j], sep= " "))}
#			else if (val == 6){
#				dst6[i,] <- c(lcsids[i], lcsids[j], as.numeric(dists[i,j]), val)}
#				#print(paste(lcsids[i], lcsids[j], val, dists[i,j], sep= " "))}
#			else if (val == 7){
#				dst7[i,] <- c(lcsids[i], lcsids[j], as.numeric(dists[i,j]), val)}
#				#print(paste(lcsids[i], lcsids[j], val, dists[i,j], sep= " "))}
#}}
#return(list(dst1, dst2, dst3, dst4, dst5, dst6, dst7))}
#
#
#
#
