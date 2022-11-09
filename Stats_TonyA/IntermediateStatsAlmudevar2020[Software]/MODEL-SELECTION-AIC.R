
### START

### For the gene expression example below, we will
### need tools from bioconductor.org

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = "3.12")

library(BiocManager)
BiocManager::install("GEOquery")

###############################################

### This code contains a single example. 

library(GEOquery)
library(MuMIn)
library(MASS)

###
### Leukocyte gene expression as a function of perceived 
### social isolation (PSI).
### https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE65213
###

#
# perceived social isolation (PSI)
# UCLA Loneliness Scale
#
# PSI psychometric scale available for 98 subjects
#

psi = c(32,33,40,23,41,39,44,32,39,33,NA,36,23,37,39,30,29,NA,42,NA,34,41,35,54,33,55,40, 
35, 45, 41, 42, 31, 30, 37, 27, 25, 27, 46, 62, 32, 45, 35, 39, 40, 43, 42,50, 38, 
33, NA, 31, 32, 49, 35, 34, 25, 42, 31, 30, 33, 37, 35, 35, 36, 30, 30, 37, 49, NA, 
58, 23, 22, 38, 33, 38, 45, 36, 57, 45, 47, 36, 47, 28, 31, 28, 35, 37, 26, 35, 37, 
40, NA, 46, 43, NA, 27, 20, 34)

# we can download data from GEO with the following commands:

gse65213.fn = getGEOfile("GSE65213")[[1]]
gse65213 = getGEO(filename = gse65213.fn, GSEMatrix = TRUE)


# Make room for 3 plots

par(mfrow=c(2,2))

# junk will be a list of length 98, one element for each subject

junk = gse65213@gsms
names(junk)

# j1 will contain gene expression levels and gene names for the first subject
# We can extract the gene names from j1

j1 = junk[[1]]@dataTable@table
gnames = j1[,1]

# Then construct a gene expression matrix from the elements of junk

ge = sapply(junk, function(obj) {as.double(obj@dataTable@table[,2])})

# add gene names to data

rownames(ge) = gnames

# there seems to be unusual values in subject in = 69
# We will delete this subject 

#par(mfrow=c(2,1))
boxplot(ge[1:15,])
which(ge[1,] > 2000)
ge2 = ge[,-69]
psi2 = psi[-69]
boxplot(ge2[1:15,])

# remove missing values

ind = !is.na(psi2)
psi3 = psi2[ind]
ge3 = ge2[,ind]

# look for correlated genes using Spearman (rank) correlation 

f0 = function(x) {cor.test(x,psi3,method='spearman')$p.value}
pv = apply(ge3, 1, f0)

# Use command warnings() to learn why warnings were given

# Look at a histogram of the p-values. 
# There does not seem to be an over-representation
# of p-values near zero. 

hist(pv,nclass=250)


# Select 10 most correlated (+ve or -ve)
# Examine the functional relationship 
# between PSI and gene expression

gene.sel = sort.list(pv)[1:10]

# Reset plot window

par(mfrow=c(2,5),mar=c(4,4,2,2))
for (i in 1:10) {
  x = ge3[gene.sel[i],]
  plot(x,psi3,xlab=rownames(ge3)[gene.sel[i]],ylab='PSI',pch=20,cex=0.5)
  
  xy = na.omit(cbind(x,psi3))
  xy = xy[sort.list(xy[,1]),]
  lines(ksmooth(xy[,1],xy[,2],bandwidth=IQR(xy[,1]),kernel='normal'),col='red')
}

### remove anomaly ADAMDEC1

gene.sel2 = gene.sel[-7]

# Reset plot window

par(mfrow=c(2,5),mar=c(4,4,2,2))
for (i in 1:9) {
  x = ge3[gene.sel2[i],]
  plot(x,psi3,xlab=rownames(ge3)[gene.sel2[i]],ylab='PSI',pch=20,cex=0.5)
  
  xy = na.omit(cbind(x,psi3))
  xy = xy[sort.list(xy[,1]),]
  lines(ksmooth(xy[,1],xy[,2],bandwidth=IQR(xy[,1]),kernel='normal'),col='red')
}

# Create gene expression matrix for the 9 remaining genes and 91 remaining subjects

ge4 = ge3[gene.sel2,]

main.data = data.frame(psi3, t(ge4))
names(main.data)[1] = 'psi'
head(main.data)

# check distributional assumptions

# Reset plot window

par(mfrow=c(3,3),mar=c(4,4,2,2))
for (i in 1:9) { boxplot(main.data[,i]) }

###
### Use all subset model selection
###


# Fit full model

fit = lm(psi ~ .,data=main.data,na.action=na.fail)
summary(fit)$coef 

#
# 5 genes have significant contributions 
# at a 0.05 significance level 
# HNRPAB, KCNE4, KDELR2, ORMDL1,SOX21  
#

# AICc = AIC +2(k+1)(k+2)/(n-k-2)

# All subsets model selection using the MuMIn package. 
# Use AIC, AICc and BIC methods.

junk = dredge(fit, rank = "BIC")
fit.bic = get.models(junk, 1)[[1]]
junk = dredge(fit, rank = "AIC")
fit.aic = get.models(junk, 1)[[1]]
junk = dredge(fit, rank = "AICc")
fit.aicc = get.models(junk, 1)[[1]]
fit

# also use stepwise model selection

st1 = system.time(fit.stepaicf <- stepAIC(fit,direction='forward'))
st2 = system.time(fit.stepaicb <- stepAIC(fit,direction='backward'))

st1
st2

summary(fit.aic)$coef
summary(fit.aicc)$coef
summary(fit.bic)$coef
summary(fit.stepaicf)$coef
summary(fit.stepaicb)$coef

# The BIC model contains exactly the 5 significant genes given above

# Compare the various scores across models.
# They will select similar but not identical models. 

# Reset plot window

pm = cbind(predict(fit.aic), predict(fit.aicc), predict(fit.bic), predict(fit.stepaicf), predict(fit.stepaicb))
colnames(pm) = c('AIC','AICc','BIC','AICf', 'AICb')
pairs(pm)

### To investigate the stability of the analysis 
### split data and repeat

set.seed(1)

n = dim(main.data)[1]

samp = sample(n)
samp

# Groups will be subjects 1-45 and subjects 46-91.

main.data3 = main.data[samp[1:45],]
main.data4 = main.data[samp[46:91],]

fitA = lm(psi ~ .,data=main.data3,na.action=na.fail)
summary(fitA)$coef 
junk = dredge(fitA, rank = "AIC")
fitA.aic = get.models(junk, 1)[[1]]
junk = dredge(fitA, rank = "AICc")
fitA.aicc = get.models(junk, 1)[[1]]
junk = dredge(fitA, rank = "BIC")
fitA.bic = get.models(junk, 1)[[1]]

fitA.stepaicf = stepAIC(fitA,direction='forward')
fitA.stepaicb = stepAIC(fitA,direction='backward')


fitB = lm(psi ~ .,data=main.data4,na.action=na.fail)
summary(fitB)$coef 
junk = dredge(fitB, rank = "AIC")
fitB.aic = get.models(junk, 1)[[1]]
junk = dredge(fitB, rank = "AICc")
fitB.aicc = get.models(junk, 1)[[1]]
junk = dredge(fitB, rank = "BIC")
fitB.bic = get.models(junk, 1)[[1]]

fitB.stepaicf = stepAIC(fitB,direction='forward')
fitB.stepaicb = stepAIC(fitB,direction='backward')


summary(fitA.bic)$coef
summary(fitB.bic)$coef

## How do these fits differ? 

#######################

###
### is the gene selection reliable?
###

### original selection

f0 = function(x) {cor.test(x,psi3,method='spearman')$p.value}
pv0= apply(ge3, 1, f0)

### split data and repeat gene selection for each training data set          

f0 = function(x) {cor.test(x,psi3[1:45],method='spearman')$p.value}
pv1= apply(ge3[,1:45], 1, f0)
f0 = function(x) {cor.test(x,psi3[46:91],method='spearman')$p.value}
pv2= apply(ge3[,46:91], 1, f0)

### capture gene names of 10 most significant genes 

sort(pv0)[1:10]
gene.names0 = names(sort(pv0)[1:10])
sort(pv1)[1:10]
gene.names1 = names(sort(pv1)[1:10])
sort(pv2)[1:10]
gene.names2 = names(sort(pv2)[1:10])

### what selected genes are common?

intersect(gene.names0,gene.names1)
intersect(gene.names0,gene.names2)
intersect(gene.names1,gene.names2)

###
### To what degree do the gene selections match?
###
### Conclusion: Any analysis, especially complex ones, must 
### be thoroughly tested and validated. 
###

### STOP

