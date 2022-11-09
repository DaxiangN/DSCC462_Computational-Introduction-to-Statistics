
### START


#################
### EXAMPLE 1 ###
#################

###
### Collinearity and VIF
###

###
### Load Credit dataset from ISLR
###

library(ISLR)

data(Credit)
help(Credit)

tab = Credit

Income = tab$Income
Limit = tab$Limit
Rating = tab$Rating
Cards = tab$Cards
Age = tab$Age
Education = tab$Education
Balance = tab$Balance

# Reset graphics window

par(mfrow=c(1,1))

# With a pairwise plot, collinearity can be anticipated (Limit and Rating, for example)

pairs(cbind(Balance,Age,Cards,Education,Income,Limit,Rating),pch=20,cex=0.5,col='navyblue')

### Model Balance = Age + Rating + Limit

fit = lm(Balance ~ Age + Rating + Limit)
summary(fit)

cor(cbind(Age,Rating,Limit))

# Calculate VIF for age, rating and limit

vif.age = (1-summary(lm(Age ~ Rating + Limit))$r.squared)^-1
vif.rating = (1-summary(lm(Rating ~ Age + Limit))$r.squared)^-1
vif.limit = (1-summary(lm(Limit ~ Age + Rating))$r.squared)^-1

vif.age
vif.rating
vif.limit

# The high values for Limit and Rating could 
# be anticipated from the pairwise plot above.

### Drop limit

fit = lm(Balance ~ Age + Rating)
summary(fit)

vif.age = (1-summary(lm(Age ~ Rating))$r.squared)^-1
vif.rating = (1-summary(lm(Rating ~ Age))$r.squared)^-1

vif.age
vif.rating

### Now, the VIFs are not red flags. 


#################
### EXAMPLE 2 ###
#################

###
### Leverage
###

###
### advertising data
###

### 
### This example makes use of the Advertising.csv dataset 
### from https://trevorhastie.github.io/ISLR/data.html
###

### Read .csv file (comma delimited)

tab = read.csv("Advertising.csv")

# Create new variables

Sales = log10(tab$sales)
TV = tab$TV
Radio = tab$radio
Newspaper = tab$newspaper


# Make room for 6 plots

par(mfrow=c(2,3))

### plot data

plot(TV,Sales,col='red')
cf = lm(Sales ~ TV)$coef
abline(cf,col='blue',lwd=2)

plot(Radio,Sales,col='red')
cf = lm(Sales ~ Radio)$coef
abline(cf,col='blue',lwd=2)

plot(Newspaper,Sales,col='red')
cf = lm(Sales ~ Newspaper)$coef
abline(cf,col='blue',lwd=2)

### calculate leverage statistics 

fit = lm(Sales~TV + Radio + Newspaper)

hii = hatvalues(fit)
sum(hii)

### Show high leverage points (in red)

plot(TV,Sales,col=3-(hii>0.04))
cf = lm(Sales ~ TV)$coef
abline(cf,col='blue',lwd=2)

plot(Radio,Sales,col=3-(hii>0.04))
cf = lm(Sales ~ Radio)$coef
abline(cf,col='blue',lwd=2)

plot(Newspaper,Sales,col=3-(hii>0.04))
cf = lm(Sales ~ Newspaper)$coef
abline(cf,col='blue',lwd=2)

### High leverage points are better seen in predictor x predictor scatter plots.

# Reset graphics window

pairs(cbind(TV,Radio,Newspaper),col=3-(hii>0.04),pch=19)

## or use Cooks's distance

cookd = cooks.distance(fit) 

# Reset graphics window

pairs(cbind(TV,Radio,Newspaper),col=3-(cookd>4/200),pch=19)

# Reset graphics window

# Show high Cook's distance within regression model

# Reset graphics window

par(mfrow=c(1,1))
plot(TV,Sales,col=3-(cookd>4/200),pch=19)
cf = lm(Sales ~ TV)$coef
abline(cf,col='blue',lwd=2)

### STOP
