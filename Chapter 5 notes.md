
# **Chapter 5 - Distributions** <!-- omit in toc -->

Notes for Chapter 5 of DSCC 462

Daxiang Na

2022-10-03

- [1. **General Knowledge**](#1-general-knowledge)
  - [1.1. Expectation -  the population mean](#11-expectation----the-population-mean)
  - [1.2. Variance - measure the dispersion of values from the expectation(mean)](#12-variance---measure-the-dispersion-of-values-from-the-expectationmean)
  - [1.3. Probability Distribution](#13-probability-distribution)
  - [1.4. Covariance](#14-covariance)
  - [1.5. Correlation](#15-correlation)
  - [1.6. Linear transformation](#16-linear-transformation)
  - [1.7. General transformation](#17-general-transformation)
- [2. **Theoretical Distributions**](#2-theoretical-distributions)
  - [2.1. Bernoulli Distribution 伯努利分布](#21-bernoulli-distribution-伯努利分布)
  - [2.2. Binomial Distribution 二项分布](#22-binomial-distribution-二项分布)


# 1. **General Knowledge**
## 1.1. Expectation -  the population mean

**Expected value** of X, denoted $E(X)$, represents a theoretical average of an infinitely large sample

for discrete variable
$E(X) = \sum_{x \in S_X} x \cdot Pr(X = x)$

for continuous variable 
$\int_{-\infty}^{\infty} Xf_X (X) \; dX$

## 1.2. Variance - measure the dispersion of values from the expectation(mean)

$var(X) = \sigma^2 = E((X - \mu)^2) = E(X^2) - E(X)^2 $

for the case of continuous variable 
$\int_{-\infty}^{\infty} (X - \mu)^2f_X(X) \; dX$

## 1.3. Probability Distribution
For any 
$E\subseteq S_{X}$, we can define 
${p}_{X}(E) = Pr(X \in E)$, 
Then 
$\displaystyle \sum_{x \subseteq S_{X}} Pr(X = x) = 1$

## 1.4. Covariance

$cov(X, Y) = E(XY) - E(X)E(Y)$

how to get that (hint: $\mu_X = E(X)$ and $\mu_Y = E(Y)$, and they are considered as constant):

$cov(X, Y) = E((X - \mu_X)(Y - \mu_Y)) \\
= E((XY - Y\mu_X - X\mu_Y + \mu_X \cdot \mu_Y))\\
= E(XY) - \mu_X E(Y) - \mu_Y E(X) + E((\mu_X \mu_Y))\\
= E(XY) - E(X)E(Y) - E(X)E(Y) + E(X)E(Y)\\
= E(XY) - E(X)E(Y)$

## 1.5. Correlation
$corr(X, Y) = \frac{cov(X, Y)} {\sigma_{X}\sigma_{Y}} = \frac {E(XY) - E(X)E(Y)} {\sigma_{X}\sigma_{Y}}$

## 1.6. Linear transformation
Let 
$Z = aX + bY$

Then the mean of Z is 
$\mu_{Z} = a\mu_X + b\mu_Y = aE(X) + bE(Y)$

The variance of Z is 
$\sigma^2_{Z} = a^2\sigma^2_{X} + b^2\sigma^2_{Y} + 2ab\sigma_{X}\sigma_{Y}$

The standard deviation of Z is 
$\sigma_{Y} = \sqrt {a^2\sigma^2_{X} + b^2\sigma^2_{Y} + 2ab\sigma_{X}\sigma_{Y}}$

## 1.7. General transformation
1. If 
$Y = g(X)$, 
$f(X) = p_X$
then 
$E(Y) = E(g(X)) = \int {g(X)}\cdot{f(X)} \;dX$
2. if $Y = g(X)$, we **don't** necessarily get 
$E(g(X)) = g(E(X))$

# 2. **Theoretical Distributions**

## 2.1. Bernoulli Distribution 伯努利分布
1. Let $Y$ be a dichotomous random variable (takes one of two mutually exclusive values) 

2. Successes (= 1) occur with probability $p$ and failures (= 0) occur with probability $1-p$, for constant $p \in [0,1]$

3. Notation: $Y \sim Bern(p)$

4. Let Y be a dichotomous random variable representing a coin flip
   - $Y = 1$: heads, success
   - $Y = 0$: tails, fail
   - If the coin has a 60% chance to get the head/success
   - $E(Y) = 1\cdot p + 0\cdot(1-p) = p$
   - $E(Y^2) = 1^2\cdot(p) + 0^2\cdot(1-p) = p$
   - $var(Y) = \sigma^2_{Y} = E(Y^2) - E(Y)^2 = p - p^2 = p(1-p)$

## 2.2. Binomial Distribution 二项分布
1. Definition: If we have a sequence of $n$ Bernoulli variables, each with a probability of success $p$, then the total number of successes is a binomial random variable.
   - Assumptions: fixed number of trials, independent, constant p
2. Notation: $X \sim Bin(n,p)$
3. Note for *Combination* and *Permutation*
   1. Combination: $C(n,k)$ or $\mathrm(^n_k)$
   2. Permutation: $P(n,k)$
4. Probability Mass Function:
   1. $Pr(X = x) = \mathrm(^n_x) \cdot p^{x} \cdot (1-p)^{n-x}$
   2. $Pr(X = x) = C(n,k) \cdot p^{x} \cdot (1-p)^{n-x}$
5. Then if you flip coin for 100 times, $n = 100$, the probability to get head for k times is $Pr(X = x) = C(100, k) \cdot p^{k} (1-p)^{100-k}$
6. How do you calculate it in ***R***?
   1. Calculate the probability of x successes $Pr(X = x)$ using <span style="color:yellow">dbinom(x, n, p)</span>
   2. Calculate $Pr(X \le x)$ using <span style="color:yellow">pbinom(x, n, p)</span>
   3. Calculate $Pr(X \ge x)$ using <span style="color:yellow">1 - pbinom(x - 1, n, p)</span>
7. Summary measures
   1. Expection $E(X) = np$
   2. Variance $var(X) = \sigma^2_X = np(1-p)$
   3. Stdev $\sigma_X = \sqrt {np(1-p)}$
8. How do you get those above:
   1. Consider Binomial Distribution as the sum of n times of Bernoulli Experiments
   2. When $X \sim Bern(p)$
      1. $E(X) = p$
      2. $\sigma^2_X = p(1-p)$
   3. Then let $Y \sim Bin(n,p)$
      1. $E(Y) = np$
      2. $\sigma^2_Y = n\sigma^2_X = np(1-p)$
9. Main take-away points from the binomial distribution: 
   1.  Fixed number of independent Bernoulli trials, n
   2.  Constant probability of success, p (Bernoulli parameter)
   3.  Interested in the total number of successes in n trials (not order)
   4.  Mean: $\mu_X = np$
   5.  Variance: $\sigma^2 = np(1 − p)$
10.  









