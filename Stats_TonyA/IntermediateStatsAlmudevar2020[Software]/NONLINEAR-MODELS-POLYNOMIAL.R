
### START

#################
### EXAMPLE 1 ###
#################

### Retrieve Auto dataset from ISLR

library(ISLR)

data(Auto)
help(Auto)

auto = Auto[sort.list(Auto$displacement),]

### variable order polynomial function

my.lm = function(x,y,pd=1,xl="X",yl="Y",mtitle=NA) {
  
  if (pd ==1) {
    fit = lm(y~x)
  } else
  {
    fit = lm(y~poly(x,pd))
  }
  plot(x,y,xlab=xl,ylab=yl)
  title(mtitle)
  ind = sort.list(x)
  lines(x[ind],fit$fitted.values[ind],col='green',lwd=2)
  plot(fit$fitted.values,fit$residuals,xlab="Fitted Values",ylab="Residuals")
  title(mtitle)
  abline(h=0,col='green',lwd=2)
  return(fit)
}

# Use horsepower (HP) to predict miles-per-gallon (MPG)


# make room for 8 plots

par(mfrow=c(2,4))

### examine log transformation

my.lm(auto$horsepower, auto$mpg,1,"HP","MPG","MPG - Order 1")
auto2 = data.frame(auto,log10(auto$mpg))
names(auto2) = c(names(auto),'logmpg')
my.lm(auto2$horsepower, auto2$logmpg,1,"HP","log MPG","log MPG - Order 1")

###### polynomial regression

my.lm(auto$horsepower, auto$mpg,2,"HP","MPG","MPG - Order 2")
my.lm(auto2$horsepower, auto2$logmpg,2,"HP","log MPG","log MPG - Order 2")

# Seems to work well


#################
### EXAMPLE 2 ###
#################

### Encephalization quotient
### Snells equation W = K (BW)^r

library(MASS)
data(mammals)
help(mammals)

head(mammals)

# Make room for 2 plots

par(mfrow=c(1,2))

boxplot(log10(mammals$body))

### data is approximately linear on a double logarithmic scale

plot(mammals,log='xy')

### r will be the fitted gradient. 

lm(log(brain) ~ log(body), data = mammals)
lm(log(brain) ~ log(body), data = mammals, subset = (log10(body) > 2))
lm(log(brain) ~ log(body), data = mammals, subset = (log10(body) < -1))


#################
### EXAMPLE 3 ###
#################

#### Forbes' Data on Boiling Points in the Alps (from library MASS)

library(MASS)
data(forbes)
help(forbes)
head(forbes)

# Regress boiling point against pressure

# Make room for 6 plots

par(mfrow=c(3,2))

fit1 = my.lm(forbes$pres,forbes$bp,1,"Pressure","Boiling Point","Order 1 Polynomial")

# eliminate outlier

forbes2 = forbes[-which(fit1$residual < -1),]

fit1 = my.lm(forbes2$pres, log(forbes2$bp),1,"Pressure","log Boiling Point","Log transform of Response with Order 1 Polynomial")
fit1 = my.lm(forbes2$pres, forbes2$bp,2,"Pressure","Boiling Point","Order 2 Polynomial")

# 
# The residuals of the untransformed model exhibit clear curvature.
# This is eliminated with 2nd order polynomial regression, but not with 
# a log transformation of the response.  
#

#################
### EXAMPLE 4 ###
#################

###
### advertising data
###

### 
### This example makes use of the Advertising.csv dataset 
### from https://trevorhastie.github.io/ISLR/data.html
###

tab = read.csv("Advertising.csv")

# Make room for 14 plots

par(mfrow=c(4,4))

# Create new variables

TV = tab$TV
Sales = tab$sales
Radio = tab$radio
Newspaper = tab$newspaper

plot(TV,Sales,col='red',xlim=c(0,310))
cf = lm(Sales ~ TV)$coef
abline(cf,col='blue',lwd=2)

### residual plot

fit = lm(Sales ~ TV)
plot(TV, fit$residuals)
abline(h=0)

# polynomial regression with log transform of response

my.lm(TV,log(Sales))
title('TV - Order 1')
my.lm(TV,log(Sales),2)
title('TV - Order 2')
my.lm(TV,log(Sales),3)
title('TV - Order 3')

# polynomial regression with log transform of response and predictor

my.lm(log(TV),log(Sales))
title('log TV - Order 1')
my.lm(log(TV),log(Sales),2)
title('log TV - Order 2')
my.lm(log(TV),log(Sales),3)
title('log TV - Order 3')

### STOP





