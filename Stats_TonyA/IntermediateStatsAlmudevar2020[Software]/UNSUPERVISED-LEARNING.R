
### START

### For the gene expression example below, we will
### need tools from bioconductor.org

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = "3.12")

library(BiocManager)
BiocManager::install("GEOquery")

###############################################

#################
### EXAMPLE 1 ###
#################

###
### We will make use of Fisher's iris data
###

library(MASS)

data(iris)
help(iris)

# Reset graphics window

my.col = rep(c(1,2,3),each=50)
pairs(iris[,1:4],col=my.col)

# Calculate principal components

prc<-prcomp(iris[,1:4], scale=T)

# can distinguish 2 groups of species quite clearly without class knowledge

# Do pairwise plots of principal components

# Reset graphics window

pairs(prc$x)

# add class knowledge by coloring each species separately

# Reset graphics window

pairs(prc$x,col=my.col)

#### We can create two versions of a biplot

# Make room for 2 plots.

par(mfrow=c(1,2))

# Use a specialized R function

biplot(prc,scale=F)

# Create one directly from the prcomp object

# This gives the loading:

prc$rotation

# Plot the 1st vs. 2nd principal components

plot(prc$x[,1],prc$x[,2],pch=19)

# Add loading vectors for each feature

arrows(0,0, prc$rotation[1,1], prc$rotation[1,2],col='red',length=0.1)
arrows(0,0, prc$rotation[2,1], prc$rotation[2,2],col='red',length=0.1)
arrows(0,0, prc$rotation[3,1], prc$rotation[3,2],col='red',length=0.1)
arrows(0,0, prc$rotation[4,1], prc$rotation[4,2],col='red',length=0.1)

# Add feature labels

text(prc$rotation[,1],prc$rotation[,2],rownames(prc$rotation),col='red')

# Note that the biplot() plot used multiple axes

#################
### EXAMPLE 2 ###
#################

###
### gene expression data
###

###
### Gene expression differences between adenocarcinoma and 
### squamous cell carcinoma in human NSCLC
### https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE10245
###

library(GEOquery)

#### Download the data from GEO

gg = getGEO('GSE10245',GSEMatrix=TRUE)
gene.names = pData(featureData(gg[[1]]))[,11]
cancer.type = pData(phenoData(gg[[1]]))[,34]
gem = as.matrix(assayData(gg)[[1]])

### There are 54675 genes

length(gene.names)
gene.names[1:50]

### There are 58 tissue samples from two cancer types

length(cancer.type)
cancer.type

### This means the gene expressions are stored in a 54675 x 58 matrix  

dim(gem)

### Examine gene expressions for the first gene
### Do separate boxplots for each cancer type

# Make room for 2 plots

par(mfrow=c(1,2))

gene.names[1]
boxplot(gem[1,]~cancer.type)

### Extract the first 500 genes

gem1 = gem[1:500,]

### Calculate principal components

prc = prcomp(t(gem1))

### Scree plot

plot(prc)

### Pairwise scatterplots of the first 4 
### principal components

### Indicate cancer types with separate colors
### The following expression will assign black 
### to "squamous cell carcinoma" and red to
### "adenocarcinoma"

# Reset graphics window

my.col = 1+(cancer.type=="adenocarcinoma")
pairs(prc$x[,1:4],col=my.col,pch=19)

# Some clustering structure by cancer type is 
# evident. 

#################
### EXAMPLE 3 ###
#################

### Hierarchical Clustering 

### Use the iris data from MASS

library(MASS)

data(iris)
help(iris)

my.col = rep(c(1,2,3),each=50)
hfit = hclust(dist(iris[,1:4]))
plot(hfit)
plot(hfit,labels=my.col)

### methods can give very different results

# Make room for 3 plots.

par(mfrow=c(3,1))

hfit = hclust(dist(iris[,1:4]), method="single")
plot(hfit,labels=my.col,main='single')
hfit = hclust(dist(iris[,1:4]), method="complete")
plot(hfit,labels=my.col,main='complete')
hfit = hclust(dist(iris[,1:4]), method="average")
plot(hfit,labels=my.col,main='average')


#################
### EXAMPLE 4 ###
#################

### Hierarchical clustering on simulated data

### simulate data

set.seed(123)

my.col = rep(c(1,2,3),each=50)

# case 1 - not very good at clustering

xm = matrix(NA, 150, 2)
xm[,2] = rnorm(150,sd=10)
xm[1:50,1] = rnorm(50,sd=0.1) + 1
xm[51:100,1] = rnorm(50,sd=0.1) + 2
xm[101:150,1] = rnorm(50,sd=0.1) + 3

# Have a direct look at the data

par(mfrow=c(1,1))
plot(xm[,1],xm[,2],col=my.col,pch=19)

par(mfrow=c(3,1))
hfit = hclust(dist(xm), method="single")
plot(hfit,labels=my.col,main='single',col=my.col)
hfit = hclust(dist(xm), method="complete")
plot(hfit,labels=my.col,main='complete')
hfit = hclust(dist(xm), method="average")
plot(hfit,labels=my.col,main='average')

# case 2 - better, for single link clustering

xm = matrix(NA, 150, 2)
xm[,2] = rnorm(150,sd=1)
xm[1:50,1] = rnorm(50,sd=0.1) + 1
xm[51:100,1] = rnorm(50,sd=0.1) + 2
xm[101:150,1] = rnorm(50,sd=0.1) + 3

# Have a direct look at the data

par(mfrow=c(1,1))
plot(xm[,1],xm[,2],col=my.col,pch=19)

par(mfrow=c(3,1))
hfit = hclust(dist(xm), method="single")
plot(hfit,labels=my.col,main='single')
hfit = hclust(dist(xm), method="complete")
plot(hfit,labels=my.col,main='complete')
hfit = hclust(dist(xm), method="average")
plot(hfit,labels=my.col,main='average')

# case 3 - standardized data from case 2

xm2 = xm
xm2[,1] = (xm[,1]-mean(xm[,1]))/sd(xm[,1])
xm2[,2] = (xm[,2]-mean(xm[,2]))/sd(xm[,2])

# Have a direct look at the data

par(mfrow=c(1,1))
plot(xm2[,1],xm2[,2],col=my.col,pch=19)

par(mfrow=c(3,1))
hfit = hclust(dist(xm2), method="single")
plot(hfit,labels=my.col,main='single')
hfit = hclust(dist(xm2), method="complete")
plot(hfit,labels=my.col,main='complete')
hfit = hclust(dist(xm2), method="average")
plot(hfit,labels=my.col,main='average')

### case 4 - a more challenging example 

xm3 = matrix(NA,150,2)
xm3[,1] = rnorm(150)+rep(c(5,10,15),each=50)
xm3[,2] = (xm3[,1]+rnorm(150,sd=0.25))/sqrt(1+0.25^2)

# Have a direct look at the data

par(mfrow=c(1,2))
plot(xm3[,1],xm3[,2],col=my.col,pch=19)

par(mfrow=c(3,1),las=0)
hfit = hclust(dist(xm3), method="single")
plot(hfit,labels=my.col,main='single')
hfit = hclust(dist(xm3), method="complete")
plot(hfit,labels=my.col,main='complete')
hfit = hclust(dist(xm3), method="average")
plot(hfit,labels=my.col,main='average')

# We can use horizontal thresholds 
# to define specific custerings. 

abline(h=9,col='red')
abline(h=5,col='green')

### can extract clusters

pr = cutree(hfit,k=3)
table(my.col,pr)

pr = cutree(hfit,k=6)
table(my.col,pr)


pr = cutree(hfit,h=5)
table(my.col,pr)

pr = cutree(hfit,h=9)
table(my.col,pr)

### example - cophenetic distance

# Reset graphics window

par(mfrow=c(1,1))
xy = cbind(c(2,3,2,4,3),c(3,2,4,5,5))
dist(xy)
hfit = hclust(dist(xy))
plot(hfit)
cphz = cophenetic(hfit)
cphz
hfit$height


#################
### EXAMPLE 5 ###
#################

### K-means clustering 

### Use the Fisher iris data from MASS

library(MASS)

data(iris)
help(iris)

# Pairwise feature plots

# Reset graphics window

my.col = rep(c(1,2,3),each=50)
pairs(iris[,1:4],col=my.col)

# Calculate 3 K-means cluster

# Note that this algorithm relies 
# on randomization.

set.seed(848851)

fit = kmeans(iris[,1:4],centers=3,nstart=100)

table(fit$cluster,my.col)

#
# Exchange 2 and 3. Remember, this is unsupervised learning, 
# so the actual classifications are not used in the algorithm.
# Matching an actual clustering to one produced by 
# a clustering algorithm must be done separately.
#

my.col = rep(c(1,3,2),each=50)

table(fit$cluster,my.col)

# Pairwise feature plots

# Reset graphics window

pairs(iris[,1:4],col=1+(fit$cluster!=my.col),pch=19)

# Observations which do not match the K-means solution
# are colored red.

#
# We can can examine the centers produced by the K-means algorithm,
# by superimposing them on a pairwise plot of the features.
#

fit$centers

# Reset graphics window

x = rbind(iris[,1:4],fit$centers)
colv=c(rep(1,150),rep(2,3))
pchv=c(rep(3,150),rep(19,3))
pairs(x,col=colv,pch=pchv)

###
### Try with 2-5 means
###

set.seed(938845)

nc = 2

my.col = rep(c(1,2,3),each=50)
pairs(iris[,1:4],col=my.col)
fit = kmeans(iris[,1:4],centers=nc,nstart=100)
x = rbind(iris[,1:4],fit$centers)
colv=c(rep(1,150),rep(2,nc))
pchv=c(rep(3,150),rep(19,nc))
pairs(x,col=colv,pch=pchv)

fit$totss
fit$betweenss
fit$tot.withinss
fit$withinss

sum(fit$withinss)+fit$betweenss
fit$totss

nc = 3

my.col = rep(c(1,2,3),each=50)
pairs(iris[,1:4],col=my.col)
fit = kmeans(iris[,1:4],centers=nc,nstart=100)
x = rbind(iris[,1:4],fit$centers)
colv=c(rep(1,150),rep(2,nc))
pchv=c(rep(3,150),rep(19,nc))
pairs(x,col=colv,pch=pchv)

fit$totss
fit$betweenss
fit$tot.withinss
fit$withinss

sum(fit$withinss)+fit$betweenss
fit$totss

nc = 4

my.col = rep(c(1,2,3),each=50)
pairs(iris[,1:4],col=my.col)
fit = kmeans(iris[,1:4],centers=nc,nstart=100)
x = rbind(iris[,1:4],fit$centers)
colv=c(rep(1,150),rep(2,nc))
pchv=c(rep(3,150),rep(19,nc))
pairs(x,col=colv,pch=pchv)

fit$totss
fit$betweenss
fit$tot.withinss
fit$withinss

sum(fit$withinss)+fit$betweenss
fit$totss


nc = 5

my.col = rep(c(1,2,3),each=50)
pairs(iris[,1:4],col=my.col)
fit = kmeans(iris[,1:4],centers=nc,nstart=100)
x = rbind(iris[,1:4],fit$centers)
colv=c(rep(1,150),rep(2,nc))
pchv=c(rep(3,150),rep(19,nc))
pairs(x,col=colv,pch=pchv)

fit$totss
fit$betweenss
fit$tot.withinss
fit$withinss

sum(fit$withinss)+fit$betweenss
fit$totss

# make room for 2 plots

par(mfrow=c(1,2))

### Plot SSE against K

sse = rep(0,10)
for (i in 1:10) {
  fit = kmeans(iris[,1:4],centers=i)
  sse[i] = fit$totss-fit$betweenss
}
plot(sse,type='b',pch=19)

### Plot R^2 against K

r2 = rep(0,10)
for (i in 1:10) {
  fit = kmeans(iris[,1:4],centers=i)
  r2[i] = fit$betweenss/fit$totss
}
plot(r2,type='b',pch=19)

# 
# A good choice for K would be the point at which SSE starts to decrease 
# marginally, or at which R^2 starts to increase marginally. 
# 
# From SSE we might select K = 3 or 4, from R^2 we might select K = 3.
# Of course, the correct answer is K = 3.
#

### STOP



