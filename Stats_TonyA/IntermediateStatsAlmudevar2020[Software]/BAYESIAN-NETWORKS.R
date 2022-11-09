
### START

### We will use the bnlearn package

library(bnlearn)

### 'bn' is an S3 class

help('bn class')
help(package='bnlearn')


#################
### EXAMPLE 1 ###
#################


### Make room for 2 plots 

par(mfrow=c(1,2))

### It is fairly easy to construct a directed graph using bnlearn

# Define nodes as a vector of labels

node.names = c("A","B","C","D","E","F","G")


# A bn object can be constructed this way:

graph1 = empty.graph(node.names)
class(graph1)
attributes(graph1)
graph1$learning
nodes(graph1)
arcs(graph1)

# It is, at this point, a graph with no edges

plot(graph1,main='Empty Graph')

### We can define arcs in matrix form

arc.matrix = matrix(c("A", "B","C","D"),ncol = 2, byrow = TRUE,
  dimnames = list(c(), c("from", "to")))

# Then update the arcs attribute of the bn object graph1 

arcs(graph1, check.cycles = TRUE) = arc.matrix

arcs(graph1)
plot(graph1, main="DAG with 2 edges")


#################
### EXAMPLE 2 ###
#################

###
### Fitting a Bayesian network usually requires data in tabular form
### There are N observations, consisting of vectors labelled by node.
###

###
### The following code simulates 200 observations data from the model
### model x1 -> x2 -> x3
###

### Here, we will use the hc() functions

help(hc)

# Make room for four plots 

n=200
x2 = rnorm(n)
x1 = (x2 + rnorm(n))/sqrt(2)
x3 = (x2 + rnorm(n))/sqrt(2)
data1 = data.frame(x1,x2,x3)
bn1 = hc(data1)
plot(bn1,main='x1 -> x2 -> x3')
round(cor(data1),2)

# As we would expect, the correlation of pairs (x1,x2) and (x2,x3) 
# is larger than for (x1,x3), although x1 and x3 are still positively correlated. 
# The fitted graph correctly identifies the model. 
#
# However, some caution is needed. Consider the three models
#
# x1 -> x2 -> x3
# x1 <- x2 <- x3
# x1 <- x2 -> x3
#
# These have the same topology, and no v-structure.
# In other words, they have the same (ie none) v-structures
# and so are equivalent. 
# 
# That means that if a Bayesian network fitting algorithm fit any of the above models
# then we would regard it as correct. 
#

###
### The cpdag() function produces a single graph representing an equivalence  class.
### It has both directed and undirected edges. The topology is the same as the 
### original graph. However, an edge is represented as undirected if there are two
### graphs in the equivalence class with possessing that edge in opposing directions. 
###

plot(cpdag(bn1),main='x1 -> x2 -> x3 using cpdag()')

### Note that in the plotted graph, both edges are undirected.

###
### model x1 -> x2 <- x3
###

x1 = rnorm(n)
x3 = rnorm(n)
x2 = (x1 + x3)/sqrt(2)
data2 = data.frame(x1,x2,x3)
bn2 = iamb(data2)
plot(bn2,main='x1 -> x2 <- x3')
round(cor(data2),2)

# As we would expect, the correlation of pairs (x1,x2) and (x2,x3) 
# is large, but x1 are uncorrelated. This should be expected, 
# given the model.
#
# The fitted graph correctly identifies the model. 
# Furthermore, no other graph that is equivalent 
# to model x1 -> x2 <- x3, so to regard 
# a Bayesian network fitting algorithm   
# as having identified the correct model, 
# this must be the graph output. 


### Here, there is only one graph in the equivalence class, so the cpdag() 
### function will produce that graph. 

plot(cpdag(bn2), main='x1 -> x2 <- x3 using cpdag()')


#################
### EXAMPLE 3 ###
#################

### We will use the Cars93 dataset of the MASS library

library(MASS)
data(Cars93)
help(Cars93)

### Make room for 2 plots 

par(mfrow=c(1,2))

### Select the following variables from the 
### Cars93 dataset

vi = c(3,5,7,12,13,14,19)
xm = Cars93[,vi]
xm = na.omit(xm)

names(xm)

### Integer types should be converted 

xm$MPG.city =  as.numeric(xm$MPG.city)
xm$Horsepower =  as.numeric(xm$Horsepower)
xm$RPM =  as.numeric(xm$RPM)
xm$Length =  as.numeric(xm$Length)

### Fit Bayesian network using hc

help(hc)
bn.obj = hc(xm)

### Plot the fitted graph

plot(bn.obj, main= 'Fitted Model')
plot(cpdag(bn.obj),main= 'Fitted Model (Equivalence Class Representation)')

### Where to the to plotted graphs differ?

### STOP
