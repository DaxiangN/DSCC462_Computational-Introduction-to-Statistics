
### START

#################
### EXAMPLE 1 ###
#################

###
### The Nadarayaâ-Watson kernel regression estimate
###

# Test functional relationship we wish to estimate

f0 = function(x) {1 - exp(-0.75*x)}
x = seq(0,8,0.1)
plot(x,f0(x),type='l')

# Add noise

y = f0(x)+rnorm(length(x),sd=0.1)

band.list = c(0.125,0.25,0.5,1,2,4,8,16)

# Vary bandwidth of smoother

# Make room for 8 plots 

par(mfrow=c(2,4))

for (bnd in band.list) {
  plot(x,y,pch=20)
  lines(x,f0(x),col='blue',lwd=2)
  lines(ksmooth(x,y,band=bnd,kernel='box'),col='red',lwd=2)
  title(paste('Bandwidth =',bnd))
}

### note kernel quartiles are +/- 0.25*bandwidth


#################
### EXAMPLE 2 ###
#################

###
### Use Default dataset from ISLR
###

library(ISLR)

data(Default)
help(Default)

head(Default)

###
### We use logistic regression in this example
###

# Make room for 5 plots

par(mfrow=c(2,3))

### Model Default ~ Balance

# plot data

plot(Default$balance, Default$default)

# Default is categorical, but can still be plotted
# Plot doesn't say much

### ksmooth is a good way to see the shape of the response curve

plot(Default$balance, (Default$default=='Yes'), pch=3)
lines(ksmooth(Default$balance, (Default$default=='Yes'),band=200),col='red')

### to do logistic regression

fit = glm(default=='Yes' ~ balance,data = Default, family = binomial)
summary(fit)
points(Default$balance, fit$fitted.values, col='green',pch=20)

### be careful of smoother bias
### rule of thumb: a smoothed function should exhibit variation over most of the range

lines(ksmooth(Default$balance, (Default$default=='Yes'),band=500),col='black')
lines(ksmooth(Default$balance, (Default$default=='Yes'),band=750),col='black')
lines(ksmooth(Default$balance, (Default$default=='Yes'),band=1000),col='black')

### does Income improve the model?

# take a look at predictors 

hist(Default$balance)
hist(Default$income)
plot(Default$balance,Default$income)
cor.test(Default$balance,Default$income,method='pearson')
cor.test(Default$balance,Default$income,method='spearman')
cor.test(Default$balance,Default$income,method='kendall')

# Pay attention to warning messages. But they don't necessarily 
# pose a problem for the analysis. 

### null model is in fit0, reduced model in fit1, full model in fit2

fit0 = glm(default=='Yes' ~ 1,data = Default, family = binomial)
fit1 = glm(default=='Yes' ~ balance,data = Default, family = binomial)
fit2 = glm(default=='Yes' ~ balance + income,data = Default, family = binomial)

summary(fit0)
summary(fit1)
summary(fit2)

### We can get the deviances from the fit, but also from anova()

anova(fit2)

#################
### EXAMPLE 3 ###
#################

###
### In this example we use  LDA/QDA 
###


###
### Use the Fisher iris dataset
###

library(MASS)
data(iris)
help(iris)

boxplot(Sepal.Length ~ Species, data = iris)

# Can we classify species from the feature data?
# First use Sepal.Length alone.

### use LDA

# reset graphics window

par(mfrow=c(1,1))

lda.fit = lda(Species ~ Sepal.Length, data = iris)
plot(lda.fit)
pr = predict(lda.fit)
confusion.table = table(pr$class, iris$Species)
confusion.table
round(sum(diag(confusion.table))/sum(confusion.table),2)

# The confuson table cross-tabulates true and predicted classifications. 

### try QDA

qda.fit = qda(Species ~ Sepal.Length, data = iris)
pr = predict(qda.fit)
confusion.table = table(pr$class, iris$Species)
confusion.table
round(sum(diag(confusion.table))/sum(confusion.table),2)

### Introduce two features

# reset graphics window

par(mfrow=c(1,1))

lda.fit = lda(Species ~ Sepal.Length + Sepal.Width, data = iris)
plot(lda.fit)
pr = predict(lda.fit)
confusion.table = table(pr$class, iris$Species)
confusion.table
round(sum(diag(confusion.table))/sum(confusion.table),2)


# reset graphics window

par(mfrow=c(1,1))

my.pch = rep(c(1,2,3),each=50)
plot(iris$Sepal.Length, iris$Sepal.Width, pch = my.pch, col=1+(pr$class!=iris$Species))
table(pr$class, iris$Species)

### introduce all features

lda.fit = lda(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width,  data = iris)
pr = predict(lda.fit)
confusion.table = table(pr$class, iris$Species)
confusion.table
round(sum(diag(confusion.table))/sum(confusion.table),2)


# reset graphics window

par(mfrow=c(1,1))

my.pch = rep(c(1,2,3),each=50)
pairs(iris[,1:4], pch = my.pch, col=1+(pr$class!=iris$Species))
table(pr$class, iris$Species)

### Now try QDA

qda.fit = qda(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width,  data = iris)
pr = predict(qda.fit)
confusion.table = table(pr$class, iris$Species)
confusion.table
round(sum(diag(confusion.table))/sum(confusion.table),2)

# reset graphics window

par(mfrow=c(1,1))

# Identify incorrect classifications with color red

my.pch = rep(c(1,2,3),each=50)
pairs(iris[,1:4], pch = my.pch, col=1+(pr$class!=iris$Species))
table(pr$class, iris$Species)

###
### We can also assess the level of certainty of the prediction
### Posterior probabilities are available from the QDA fit
###

# reset graphics window

par(mfrow=c(1,1))

max.posterior = apply(pr$posterior,1,max)
boxplot(max.posterior)

### the less confident predictions are largely near the boundaries between classes


# reset graphics window

par(mfrow=c(1,1))

###
### Identify classifications with posterior probability < 0.95
###

my.pch = rep(c(1,2,3),each=50)
pairs(iris[,1:4], pch = my.pch, col=1+(max.posterior < 0.95))
table(pr$class, iris$Species)


#################
### EXAMPLE 4 ###
#################

###
### ROC and Precision/Recall Curves
###


# Make room for 3 plots 

par(mfrow=c(2,2))

# recall logistic regression model for Default data (EXAMPLE 2, rerun if needed).

fit2 = glm(default=='Yes' ~ balance + income,data = Default, family = binomial)

pr = fit2$fitted.values
boxplot(pr~Default$default)
title('Estimated probability of default')

# we might make a decision based on a threshold pr > 0.5

pred.default = pr > 0.5
confusion.table = table(pred.default, Default$default)
confusion.table

sens1 = confusion.table[2,2]/sum(confusion.table[,2])
spec1 = confusion.table[1,1]/sum(confusion.table[,1])
ppv1 = confusion.table[2,2]/sum(confusion.table[2,])
npv1 = confusion.table[1,1]/sum(confusion.table[1,])
c(sens1,spec1,ppv1,npv1)

# or pr > 0.25

pred.default = pr > 0.25
confusion.table = table(pred.default, Default$default)
confusion.table

sens2 = confusion.table[2,2]/sum(confusion.table[,2])
spec2 = confusion.table[1,1]/sum(confusion.table[,1])
ppv2 = confusion.table[2,2]/sum(confusion.table[2,])
npv2 = confusion.table[1,1]/sum(confusion.table[1,])
c(sens2,spec2,ppv2,npv2)

#### ROC and PR graphs

# We have TP,FP,TN,FN

# SENSITIVITY = TPR = TP/(TP+FN)
# SPECIFICITY = TNR = TN/(FP+TN)

# RECALL = SENSITIVITY 
# PRECISION = PPV = TP/(TP+FP)

library(ROCR)

pred <- prediction( pr, Default$default )

### ROC curve

perf <- performance(pred,"tpr","fpr")
plot(perf)
points(1-spec1,sens1,col='red',pch=19)
points(1-spec2,sens2,col='red',pch=19)

### Precision/Recall curve

perf1 <- performance(pred, "prec", "rec")
plot(perf1)
points(sens1,ppv1,col='red',pch=19)     
points(sens2,ppv2,col='red',pch=16)     

### The values spec1, sens1, ppv1 were 
### produced by threshold pr > 0.5

### The values spec2, sens2, ppv2 were 
### produced by threshold pr > 0.25

### Note their location on the ROC and Precision/Recall 
### curve (the red dots)

### STOP


