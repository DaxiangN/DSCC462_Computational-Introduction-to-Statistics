
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

# Make room for 4 plots

par(mfrow=c(2,2))

# Create new variables

TV = tab$TV
Sales = tab$sales
Radio = tab$radio
Newspaper = tab$newspaper

### Plot separate fits

plot(TV,Sales,col='red')
cf = lm(Sales ~ TV)$coef
abline(cf,col='blue',lwd=2)

plot(Radio,Sales,col='red')
cf = lm(Sales ~ Radio)$coef
abline(cf,col='blue',lwd=2)

plot(Newspaper,Sales,col='red')
cf = lm(Sales ~ Newspaper)$coef
abline(cf,col='blue',lwd=2)

### Look at the numerical fits

summary(lm(Sales ~ TV))$coef
summary(lm(Sales ~ Radio))$coef
summary(lm(Sales ~ Newspaper))$coef

### Multiple fit using all 3 predictors

summary(lm(Sales ~ TV+Radio+Newspaper))$coef

### Look at correlation of the predictors (ie. look for collinearity)

cor(cbind(TV, Radio, Newspaper))

### Why is Newspaper alone a significant predictor, but not when included 
### in the multiple regression fit?


plot(Radio,Newspaper,col=1+(Sales > median(Sales)))
abline(h=quantile(Newspaper,0.75),lty=2)
abline(v=quantile(Radio,0.75),lty=2)

###
### High sales (> median) are colored red.
### Quadrants are defined by 75th precentiles of each axis.
###
### Large newspaper budgets imply large radio budgets, which imply high 
### sales (there are few points in the Low Radio/High Newspaper quadrant).
### This will contribute to correlation between Newspaper and Radio variables.
###

### STOP

