
### START

#################
### EXAMPLE 1 ###
#################

#### step functions

library(MASS)

data(Boston)
head(Boston)
help(Boston)

# Make room for 4 plots

par(mfrow=c(2,2))


plot(Boston$nox, Boston$medv)

### identify range 

range(Boston$nox)

### create cutpoints 

br = seq(0.3,0.9,by=0.1)
br
nox.steps = cut(Boston$nox,br)

new.frame = data.frame(nox.steps,medv = Boston$medv)
fit = lm(medv~nox.steps, data=new.frame)

#### construct predictor data.frame

nox.rng = seq(0.3,0.9,by = 0.001)
predict.frame = data.frame(nox.rng, nox.steps=cut(nox.rng,br))
pr = predict(fit,newdata=predict.frame)

#### various ways to represent fitted curve, some better than others (note the 3rd plot)

plot(Boston$nox, Boston$medv)
points(Boston$nox, fit$fitted.value,col='green')
plot(Boston$nox, Boston$medv)
lines(Boston$nox, fit$fitted.value,col='green')
plot(Boston$nox, Boston$medv)
lines(nox.rng, pr,col='green',lwd=3,pty='s')



#################
### EXAMPLE 2 ###
#################

# Make room for 12 plots

par(mfrow=c(3,4))

#### splines as basis functions

library(splines)
help(package='splines')

x = seq(1,100,by=1)

x.cubic.spline = ((x - 50)^3)*(x > 50)
x.1 = (x-25)*(x>25)
x.2 = (x-75)*(x>75)

### examine basis functions

plot(x, x.cubic.spline)
plot(x, x.1)
plot(x, x.2)

### simulate test model (a quadratic response curve)

y = rnorm(100)+(x-50)^2/500
plot(x,y)

#### Piecwise linear spline

bs1 = bs(x,knots = c(25,75),degree=1)
matplot(x,bs1)

#### fit models

fit1 = lm(y ~ x+x.1+x.2)
fit2 = lm(y ~ bs1)
summary(fit1)
summary(fit2)

plot(x,y)
lines(x,predict(fit1),col='red',lwd=5)
lines(x,predict(fit2),col='green',lwd=2)
plot(predict(fit1),predict(fit2))
abline(0,1,col='red')

# Both base systems produce identical fits

#### Cubic spline

bs2 = bs(x,knots = c(50))
matplot(x,bs2)

fit1 = lm(y ~ poly(x,3)+x.cubic.spline)
fit2 = lm(y ~ bs2)
summary(fit1)
summary(fit2)

plot(x,y)
lines(x,predict(fit1),col='red',lwd=5)
lines(x,predict(fit2),col='green',lwd=2)
plot(predict(fit1),predict(fit2))
abline(0,1,col='red')

# Both base systems produce identical fits

#################
### EXAMPLE 3 ###
#################

# various splines and smoothers

library(ISLR)

### Weekly S&P Stock Market Data from ISLR package

data(Weekly)
help(Weekly)

year = Weekly$Year
volume = Weekly$Volume

# Make room for 5 plots

par(mfrow=c(2,3))

# Look at data 

plot(year, volume)
logVolume = log10(volume)
plot(year,logVolume)

# We need the range 

rng = range(year)

# Create basis cutpoints

br = seq(1985,2015,by=2.5)
br
year.steps = cut(year,br)
new.frame = data.frame(year,year.steps,logVolume)

# fit model with step function

fit = lm(logVolume~year.steps, data=new.frame)
year.rng = seq(1989,2010,by = 0.01)
predict.frame = data.frame(year.rng, year.steps=cut(year.rng,br))
pr = predict(fit,newdata=predict.frame)
plot(year, logVolume)
lines(year.rng, pr,col='green',lwd=3,pty='s')

# now fit a linear spline

kn = c(1994, 2002,2004,2008)
xb = bs(year,knot=kn, degree=1)
fit = lm(logVolume ~ xb)
plot(year, logVolume)
lines(year,fit$fitted.values,col='green',lwd=3)

### fit smoothing splines

fit = smooth.spline(year,logVolume)
plot(year,logVolume)
lines(predict(fit),col='green',lwd=3)
fit$lambda
fit$df

# use 10 degrees of freedom (df)

fit2 = smooth.spline(year,logVolume,df=10)
lines(predict(fit2),col='red',lwd=3)

#################
### EXAMPLE 4 ###
#################

###
### return to advertising data, fit a B-spline
### 
### This example makes use of the Advertising.csv dataset 
### from https://trevorhastie.github.io/ISLR/data.html
###

tab = read.csv("Advertising.csv")

TV = tab$TV
Sales = tab$sales

# Define a single knot at TV = 25

# Make room form one plot

par(mfrow=c(1,1))

TV.grid = seq(min(TV),max(TV),by=1)
plot(TV, log(Sales))
fit = lm(log(Sales) ~ bs(TV,knots=c(25),degree=3))
lines(TV.grid, predict(fit,newdata=list(TV=TV.grid)),col='green',lwd=3)

# Very effect method for this data

#################
### EXAMPLE 5 ###
#################

### LOESS fit, using Boston Housing (EXAMPLE 1) 

# Use one plot 

par(mfrow=c(1,1))

head(Boston)
help(Boston)

plot(Boston$nox, Boston$medv,pch=20)

# Create several LOESS fits, then superimpose on 
# a single plot

fit1 = loess(medv ~ nox, data=Boston,span=0.75,degree=2)
fit2 = loess(medv ~ nox, data=Boston,span=0.25,degree=2)
fit3 = loess(medv ~ nox, data=Boston,span=0.5,degree=1)
fit4 = loess(medv ~ nox, data=Boston,span=0.25,degree=1)

nox.rng = seq(0.3,0.9,by = 0.001)

lines(nox.rng,predict(fit1,nox.rng),col='green',lwd=3)
lines(nox.rng,predict(fit2,nox.rng),col='red',lwd=3)
lines(nox.rng,predict(fit3,nox.rng),col='blue',lwd=3)
lines(nox.rng,predict(fit4,nox.rng),col='orange',lwd=3)
legend('topright',legend=c("sp = 0.75, deg = 2", "sp = 0.25, deg = 2","sp = 0.75, deg = 1","sp = 0.25, deg = 1"),
       lty=1,col=c('green','red','blue','orange'))

# Fits are very sensitive to parameter choices


#################
### EXAMPLE 6 ###
#################

# Use one plot 

par(mfrow=c(1,1))

### Advertising Data of EXAMPLE 4
### Try a LOESS fit

TV.grid = seq(min(TV),max(TV),by=1)
plot(TV, log(Sales))
fit = loess(log(Sales) ~ TV,span=0.25)
lines(TV.grid,predict(fit,TV.grid),col='green',lwd=3)
fit = loess(log(Sales) ~ TV,span=0.5)
lines(TV.grid,predict(fit,TV.grid),col='red',lwd=3)
fit = loess(log(Sales) ~ TV,span=0.75)
lines(TV.grid,predict(fit,TV.grid),col='orange',lwd=3)
legend('bottomright',legend=c("sp = 0.25", "sp = 0.5","sp = 0.75"),
       lty=1,col=c('green','red','orange'))


#################
### EXAMPLE 7 ###
#################

### Generalized Additive Models (GAM) - Advertising Data of EXAMPLE 4
### Splines with standard errors

library(gam)
library(ISLR)
library(MASS)
library(splines)

tab = read.csv("Advertising.csv")

# Make room for 2 plots 

par(mfrow=c(2,1))

# Create new variables

TV = tab$TV
Sales = tab$sales

plot(TV, log(Sales),pch=20)
fit.gam = gam(log(Sales) ~ bs(TV,3), data=tab)

TV.grid = seq(min(TV),max(TV),by=1)
pr = predict(fit.gam,list(TV=TV.grid))
lines(TV.grid,pr,col='green',lwd=3)

### We can construct confidence bands

pr = predict(fit.gam,list(TV=TV.grid),se=T)
names(pr)

plot(TV, log(Sales),pch=20)
lines(TV.grid,pr$fit,col='green',lwd=3)
lines(TV.grid,pr$fit-2*pr$se.fit,col='green',lwd=3,lty=3)
lines(TV.grid,pr$fit+2*pr$se.fit,col='green',lwd=3,lty=3)

### STOP









