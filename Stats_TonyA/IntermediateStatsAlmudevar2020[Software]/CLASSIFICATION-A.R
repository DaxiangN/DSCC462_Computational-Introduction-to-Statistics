
### START

#################
### EXAMPLE 1 ###
#################

### Make room for 2 plots 

par(mfrow=c(2,2))

###
### Bayes classifier for two classes
###
### Specify two conditional densities (normally distributed)
### and prior probabilitys pi1 = p12 - 0.5
###

mu1 = 10
var1 = 1.2
pi1 = 0.5
mu2 = 15
var2 = 3.7
pi2 = 0.5

xgrid = seq(0,25,0.1)

plot(xgrid,dnorm(xgrid,mean=mu1,sd=sqrt(var1)),col='green',type='l')
lines(xgrid,dnorm(xgrid,mean=mu2,sd=sqrt(var2)),col='red')

f0 = function(x,mu1,var1,mu2,var2,pi1,pi2) {
  (pi2/pi1)*dnorm(x,mean=mu2,sd=sqrt(var2))/dnorm(x,mean=mu1,sd=sqrt(var1))
}

plot(xgrid,log(f0(xgrid,mu1,var1,mu2,var2,pi1,pi2)),type='l')
abline(h=0)

sort.list(log(f0(xgrid,mu1,var1,mu2,var2,pi1,pi2))^2)[1:10]

# boundaries at indices 121, 33

plot(xgrid,dnorm(xgrid,mean=mu1,sd=sqrt(var1)),col='green',type='l')
lines(xgrid,dnorm(xgrid,mean=mu2,sd=sqrt(var2)),col='red')
abline(v=xgrid[33],lty=2)
abline(v=xgrid[121],lty=2)

###
### The plot gives the classification rule for this classifier.
### Between the dashed lines we classify green.
### That we would  classify red for VERY small observations
### is due to the fact that the 'red' variance is larger
### that the 'green' variance.
###


#################
### EXAMPLE 2 ###
#################

###
### KNN classifier applied to Fisher's iris data
###

library(class)

library(MASS)
data(iris)
help(iris)

# pairwise plots of the four features

iris.col <- c(rep(2,50), rep(3,50), rep(4,50))
pairs(iris[,1:4],col=iris.col,pch=19)


### Make room for 1 plot 

par(mfrow=c(1,1))

# Split data into training and test data

train <- rbind(iris3[1:25,,1], iris3[1:25,,2], iris3[1:25,,3])
test <- rbind(iris3[26:50,,1], iris3[26:50,,2], iris3[26:50,,3])

# Vary K parameter from 1 to 50. 
# Replicate each classifier 500 times,
# then take average. This averages over
# randomized tie-breaking rules. 

errv0 = rep(0,40) 
klist = c(1:40)
errv = rep(NA, 40)
for (iii in 1:500) {
  for (i in 1:40) {
    cl <- factor(c(rep("s",25), rep("c",25), rep("v",25)))
    pr = knn(train, test, cl, k = klist[i], prob=F)
    errv[i] = mean(cl!=pr)
  }
  errv0 = errv0 + errv
}
errv0 = errv0 / 500

# For which value of K is cross-validated error minimized?

plot(klist,errv0,type='b', ylab='Classification Error',xlab='K')

### STOP
