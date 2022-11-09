
library(parallel)

### test function

f0 = function(nv) {
  mat = matrix(runif(prod(nv)),nv[1],nv[2])
  return(apply(mat,1,median)) 
  
}

### A simulation task is split into two jobs

### set up parallel input

in.list = list(c(800,100000), c(800,100000))

### We can time the jobs separately

# Job 1

system.time(junk1 <- f0(in.list[[1]]))

# Job 2

system.time(junk2 <- f0(in.list[[2]]))

### the lapply function does the 2 jobs in series

system.time(junk12s <- lapply(in.list,f0))

# The time needed to complete both jobs in series
# is about the sum of the time taken to do 
# the jobs separately


### With parallel processing the jobs are done in parallel

# Use 2 clusters

mc = 2
cl = makeCluster(mc)
clusterSetRNGStream(cl,1234)
system.time(junk12p <- parLapply(cl,in.list,f0))
stopCluster(cl)

# The time taken to do both jobs in parallel using 2 clusters is about 1/2 
# the time taken to do them in series, as we would expect. 

