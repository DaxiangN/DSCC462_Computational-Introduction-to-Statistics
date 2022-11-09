
### START

# This code contains a single example

###
### advertising data
###

### 
### This example makes use of the Advertising.csv dataset 
### from https://trevorhastie.github.io/ISLR/data.html
###

### Read .csv file (comma delimited)

tab = read.csv("Advertising.csv")

# Make room for 6 plots

par(mfrow=c(2,3))

# Create new variables

TV = tab$TV
Sales = tab$sales
Radio = tab$radio
Newspaper = tab$newspaper

plot(TV,Sales,xlim=c(0,310))
cf = lm(Sales ~ TV)$coef
abline(cf,lwd=2)
title("Original Data")

### residual plot

fit1 = lm(Sales ~ TV)
plot(TV, fit1$residuals)
abline(h=0)
title("Original Data")

# log tranform of response

fit1 = lm(log(Sales) ~ TV)
plot(TV, log(Sales))
points(TV,predict(fit1),col='green',pch=20)
title("Log Transform of Response")
plot(TV, fit1$residuals)
abline(h=0)
title("Log Transform of Response")

fit2 = lm(log(Sales) ~ poly(TV,3))
plot(TV, log(Sales))
points(TV,predict(fit2),col='green',pch=20)
title("Log Transform of Response with Polynomial Regression of Order 3")
plot(TV, fit2$residuals)
abline(h=0)
title("Log Transform of Response with Polynomial Regression of Order 3")

summary(fit1)$coef
summary(fit2)$coef
summary(fit3)$coef

###
### A log transformation makes the variance somewhat more stable.
### Polynomial regression is able to capture the curvative
### of the regression function, to a point. 
### However, the final model is not entirely satisfactory with 
### respect to either problem. 
###

### STOP


