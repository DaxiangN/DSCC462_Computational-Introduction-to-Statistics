# Power Calculation template
library(tidyverse)
# parameters and a sequence of mu1 values
mu <- 0
s <- 2
n <- 5
alpha <- 0.1

n1 <- seq(1,100, by=5)
# function to get power

f <- function(x, n) {
    cutoff <- mu + qnorm(1-aplha)*s/sqrt(n)
    y <- 1-(pnorm((cutoff - x)/(s/sqrt(n))))
    return(y)
}

# plot power curve
    # labs(x = expression(mu[1]), y = "Power", title = "Power Curve when mu = 124 and s = 26")

p1 <- ggplot(data.frame(n = n1), aes(x = n))
p1 + geom_function(aes(colour = "red"), fun = f, args = list(x = 1))