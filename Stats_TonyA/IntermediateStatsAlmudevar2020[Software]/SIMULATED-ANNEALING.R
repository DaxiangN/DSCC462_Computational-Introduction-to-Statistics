
### START

###
### Use simulated annealing to solve a 20 city travelling salesman problem.
###
### Find the shortest route that visits each city exactly once, then returns to 
### the initial city.
###
### (This code contains a single example)
###

library(rgl)

### generate route proposal

proposal = function(route) {
  n = length(route)
  swp = sample(2:n,2)
  route[swp] = route[swp[2:1]]
  return(route)
}

### calculate route distance

scr = function(dxy,route) {
  
  n = length(route)
  sm = dxy[route[1],1]
  for (i in 1:(n-1)) {sm = sm + dxy[route[i],route[i+1]]}
  return(sm)
}

### Generate problem (a randomly generated map of 20 cities on a Euclidean plane).
### The number of cities can be changed by assigninG a new number to ncities.

set.seed(1234)

ncities = 20
xy = matrix(sample(1:1000,size=2*ncities,replace=T),ncol=2)
dxy = as.matrix(dist(xy))

### algorithm parameters

ntrace = 10000000
scrv = rep(NA, ntrace)

### initial and final temperatures (these can be changed)

t0 = 5000
tn = 1

### initial solution

route = 1:ncities
scr0 = scr(dxy,route)

### plot initial solution

par(mfrow=c(2,2))

maxn = ntrace/10000 + 1
scr.plot = scr0
scr.init = scr0
t.plot = t0


scr.min = scr0
route.min = route

max.trace = c(1,scr.min)

### start algorithm 

for (i in 1:ntrace) {
  
  # get proposal and route distance
  
  route.new = proposal(route)
  scr1 = scr(dxy,route.new)
  
  # update temperature
  
  temp = t0*(tn/t0)^(i/ntrace)
  
  # calculate acceptance probability
  
  alpha = exp((scr0-scr1)/temp)
  
  # accept or reject proposal
  
  if (runif(1) <= alpha)
  {
    
    # accept proposal
    
    route = route.new
    scr0 = scr1
    
  }
  
  # keep distance 
  
  scrv[i] = scr0
  
  if (scr0 < scr.min) {
    scr.min = scr0
    route.min = route
    max.trace = rbind(max.trace,c(i,scr.min))
  }
  
  # update plot once every 10000 iterations
    
  if (i %% 10000 == 0) {
   
    scr.plot = c(scr.plot,scr0)
    t.plot = c(t.plot,temp)
    
    plot(xy[c(route,1),1],xy[c(route,1),2],type='l',main=paste(round(scr0,1),' [',round(100*i/ntrace,0),'%]',sep=''),xlab='X',ylab='Y')  
    points(xy[c(route,1),1],xy[c(route,1),2],type='p',pch=19,col='red',cex=1.5)  
    plot(1:length(scr.plot),scr.plot,type='b',xlab='x 10000 iterations',ylab='Total Distance',xlim=c(1,maxn),ylim=c(0,1.5*scr.init),pch=20)  
    points(max.trace[,1]/10000,max.trace[,2],pch=20,col='green')
    legend('topright',legend=c('Current Solutions','Best Solutions'),pch=20,col=c('black','green'),lty=0,cex=0.75,bty='n', 
            y.intersp =0.75, adj = c(0, 0.6))
    plot(xy[c(route.min,1),1],xy[c(route.min,1),2],type='l',main=paste('Best solution so far = ',round(scr.min,1),sep=''),xlab='X',ylab='Y')  
    points(xy[c(route.min,1),1],xy[c(route.min,1),2],type='p',pch=19,col='red',cex=1.5)  
    plot(1:length(t.plot),t.plot,type='l',xlab='x 10000 iterations',ylab='Temperature',xlim=c(1,maxn),ylim=c(0,t0))  
    
  }  
       
}

###
### It can be proven mathematically that an optimal path for a Euclidean travelling 
### salesman problem cannot cross itself. Does this solution satisfy this condition? 
### A well designed simulated annealing algorithm will generally give a VERY GOOD solution, 
### but it is difficult to verify that any given solution is strictly optimal.
###

### STOP


