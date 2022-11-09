
### START

#################
### EXAMPLE 1 ###
#################

library(ISLR)
library(ROCR)

### This example uses the Weekly dataset from the ISLR package

data(Weekly)
help(Weekly)


#### Complex formula intended to predict S&P 500 stock index

myFormula = Direction == 'Up'~Lag1 + Lag2 + Lag3 + Lag4 + Lag5

fit = glm(myFormula,data=Weekly, family='binomial')
pr = predict(fit)

#

par(mfrow=c(2,2))

### draw AUC

boxplot(pr ~ Weekly$Direction)
title(paste('P = ', signif(wilcox.test(pr ~ Weekly$Direction)$p.value,3), " Without Cross-Validation"))
pred <- prediction(pr,  Weekly$Direction  == "Up")
perf <- performance(pred,"tpr","fpr")
plot(perf)
perf <- performance(pred,"auc")
title(paste('AUC = ', signif(as.numeric(perf@y.values),3), " Without Cross-Validation"))
abline(a=0,b=1,col='green')

### looks pretty good

### remove one observation

fit = glm(myFormula,data=Weekly[-1,], family='binomial')
fit$coef
fit = glm(myFormula,data=Weekly[-2,], family='binomial')
fit$coef

### make prediction for test observation

new.pred = predict(fit, newdata = Weekly)[1]
new.pred

### do this for each observation

n = dim(Weekly)[1]
new.pred = numeric(n)
for (i in 1:n) {
  fit = glm(myFormula, data=Weekly[-i,],family='binomial')
  new.pred[i] = predict(fit, newdata = Weekly)[i]
}

### Redo ROC analysis

pr = new.pred
boxplot(pr ~ Weekly$Direction)
title(paste('P = ', signif(wilcox.test(pr ~ Weekly$Direction)$p.value,3), " With Cross-Validation"))
pred <- prediction( new.pred,  Weekly$Direction == "Up")
perf <- performance(pred,"tpr","fpr")
plot(perf)
perf <- performance(pred,"auc")
title(paste('AUC = ', signif(as.numeric(perf@y.values),3), " With Cross-Validation"))
abline(a=0,b=1,col='green')

#
# Unfortunately, the predictive ability of model is not supported by cross-validation:
#    Without cross-validation P = 0.00204
#    With cross-validation P = 0.193
#

#################
### EXAMPLE 2 ###
#################

####
#### CV and model selection
####

#### variable selection (we will need the boot package)

library(boot)

###
### advertising data
###

### 
### This example makes use of the Advertising.csv dataset 
### from https://trevorhastie.github.io/ISLR/data.html
###

tab = read.csv("Advertising.csv")

# Create new variables

TV = tab$TV
Sales = tab$sales
Radio = tab$radio
Newspaper = tab$newspaper

f1 = Sales ~ TV + Radio
f2 = Sales ~ TV + Radio + Newspaper
  
fit1 = glm(f1,data = tab)
fit2 = glm(f2,data = tab)
  
aov(fit1)
aov(fit2)

# We'll need to make sure the names used in tab
# match the names used in the formulae (remember, names are case-specific)

names(tab) = c('X','TV','Sales','Radio','Newspaper')

cv.glm(tab,fit1)$delta
cv.glm(tab,fit2)$delta
sqrt(cv.glm(tab,fit1)$delta)
sqrt(cv.glm(tab,fit2)$delta)
  
# both fitted MSE and CV error give similar conclusions.    
  
#### determine degree of polynomal regression fit 
  
# Make room for 2 plots

par(mfrow=c(1,2))
  
set.seed(1)

# simulate 3rd order polynomial model
    
f0 = function(x) {1 + 2*x + 0.1*x^2 - 0.05*x^3}
x = sort(rep(seq(1,25,1),1))
y = f0(x) + rnorm(length(x),sd=25.75)
  
plot(x,f0(x),ylim=range(y),type='l')
points(x,y)
  
yx = data.frame(y,x)
  
# calculate both MSE and CV error
  
msev = numeric(20)
msecv = numeric(20)

for (i in 1:20) {
  fit = glm(y~poly(x,i), data = yx)
  msev[i] = summary(aov(fit))[[1]][2,3]
  msecv[i] = cv.glm(yx,fit)$delta[1]
}
  
summary(fit)
msev
msecv
  
matplot(cbind(msev,msecv),log='y',type='b')
legend('topright',c('Fit','CV'),pch=c('1','2'),bg='transparent')
  
###
### Without cross-validation, the fit appears 
### to improve with complexity, but this is explainable by "over-fitting".
### Cross-validated error is not affected by over-fitting.
###


#################
### EXAMPLE 3 ###
#################
  
#### CV is sometimes an option in modelling modeling and classification applications   
  
library(MASS)

### Use the Fisher iris data from the MASS package

data(iris)
help(iris)

lda.fit = lda(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width,  data = iris)
pr = predict(lda.fit)
confusion.table = table(pr$class, iris$Species)
confusion.table
round(sum(diag(confusion.table))/sum(confusion.table),2)
  
### Note the CV=T option

lda.fit = lda(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width,  data = iris, CV=T)
confusion.table = table(lda.fit$class, iris$Species)
confusion.table
round(sum(diag(confusion.table))/sum(confusion.table),2)
  
qda.fit = qda(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width,  data = iris)
pr = predict(qda.fit)
confusion.table = table(pr$class, iris$Species)
confusion.table
round(sum(diag(confusion.table))/sum(confusion.table),2)
  
### Note the CV=T option

qda.fit = qda(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width,  data = iris, CV=T)
confusion.table = table(qda.fit$class, iris$Species)
confusion.table
round(sum(diag(confusion.table))/sum(confusion.table),2)

# To what degree does cross-validation affect our conclusion?

### STOP
