
## read in data

dtafile=as.matrix(read.table("cepheid.dta",header=T))
x=dtafile[,1]
y=dtafile[,2]
#hist(x)
N<- length(x)


## hyperparameters

a <- 1 # 1/sig2 ~ Ga(1,1) s.t. E(1/sig2) = 1
b <- 1
lenda <- 5

#############################################
## Gibbs sampler
#############################################
sample.beta <- function(K,sig2)
{ ## sample s[i] from p(s[i] | ...)
#sig2=.5
V=solve(diag(2*K+1)+(1/sig2)*t(xx)%*%(xx))
M=V%*%((1/sig2)*t(xx)%*%y)
#dim(m)=c(2*K+1,1)
  L <- chol(V)
  beta <- M + t(rnorm(2*K+1) %*% L)
  return(beta)
}

################################################
sample.sig2=function(beta)
  {S2=sum((y-xx%*%beta)^2)
   a1=a+N/2
   b1=b+S2/2
   sig2=1.0/rgamma(1,shape=a1,rate=b1)
  return(sig2)
   }

#################################################
pth1 <- function(beta,sig2,xxx,K)
{ # return log posterior
lpbeta <- -sum(beta*beta)/(2)

lpsig2 <- -(a-1)*log(sig2) - b/sig2
## px = p(x | th) = prod{ sum[ w[j]*N(x[i]; mu[j],sig2)
logpy=-log(sum(abs(y-xxx%*%beta)))

lPoi=(-5)+K*log(5)-lfactorial(K)
p <- lpbeta+lpsig2+logpy+lPoi
return(p)
}


###############################################
#######RJ#########  
  sample.K=function(beta,sig2,K)
 {  ##########compute the parameter for the split########  
    regressor1 <-function(N,K)
  {
    XX1= matrix(0,nrow=N,ncol=2)
   for(n in 1:N)
    {
      XX1[n,]=c(sin(2*pi*(K+1)*x[n]),cos(2*pi*(K+1)*x[n]))
    }
     return(XX1)
   }
  xx1=regressor1(N,K)
   xx2=cbind(xx,xx1)
   fit=lm((y-xx%*%beta) ~ xx1)       
    m <- fit$coef
    V <- summary(fit)$cov.unscaled
    L <- chol(V)
    b <- m + rnorm(3) %*% L
    dim(b)=c(3,1)
    beta1=rbind(beta,b[2,1],b[3,1])
 
 
###########compute the parameter for the merge#############
 beta2=as.matrix(beta[-(2*K+1),],ncol=1)
 beta2=as.matrix(beta2[-(2*K),],ncol=1)
 xx3=xx[,-(2*K+1)]
 xx3=xx3[,-(2*K)]


########################################################
if(K==1){#must going up to J+1
beta <-beta1 # update parameter by proposal
xx=xx2
K=K+1
}else{
##########compute acceptance alpha#####

lp=pth1(beta,sig2,xx,K)+log((1/J)*(1/delta))

lp0=pth1(beta1,sig2,xx2,K+1)+log(2*w[g]/(J+1))

lp1=pth1(beta2,sig2,xx3,K-1)+log((1/(2*w[g1]*(J-1)))*(1/delta))
if(lp0<lp-10){
 }else{
u<- runif(1)
if ( log(u)< lp0-lp){ # move to J+1
w <-w1 # update parameter by proposal
mu=mu1
J=J+1
}
}
if(lp1<lp-10){
 }else{ u<- runif(1)
if (lp1-lp>log(u) ){ # move to J-1
w <-w2 # update parameter by proposal
mu=mu2
J=J-1
}
}

 }
 
return(list(w,mu,J))
}

##########################################
f <- function(xi, w,mu,sig2)
{
y <- 0
for(j in 1:J){
y <- y+w[j]*dnorm(xi,m=mu[j],sd=sqrt(sig2))
}
return(y)
}
###################################

  regressor <-function(N,K)
  {
    XX= matrix(0,nrow=N,ncol=2*K)
   for(n in 1:N)
    {for(k in 1:K) 
      {XX[n,(2*k-1):(2*k)]=c(sin(2*pi*k*x[n]),cos(2*pi*k*x[n]))
      }
    }
     return(XX)
   }

#############################
init <- function(){
    K=3
    xx=NULL   
   xx<-regressor(N,K)
   xx=cbind(1,xx)
    fit=lm(y ~ xx-1)       
    m <- fit$coef
    V <- summary(fit)$cov.unscaled
    L <- chol(V)
    b <- m + rnorm(7) %*% L




## use some exploratory data analyssi
## for initial values of the parameters  
hc <- hclust(dist(x), "ave") # initialize s with a
s <- cutree(hc,k=J) # hierarchical tree, cut for J=5 clusters
## this is not important -- you could instead initialize arbitrarily..
## google "hierarchical clustering" to learn more.
mu <- lapply(split(x,s), mean) # iniatialize mu as mean
## for each cluster
mu <- unlist(mu) # to make it a vector
sig2 <- var(x-mu[s])
w <- table(s)/n
w <- c(w)
return(th=list(s=s,mu=mu,sig2=sig2,w=w))
}


















## grid for evaluating p(beta[j] | y)
## will use in sample.b() to build up plots
b1grid <- seq(from= -0.1, to= 0.05, length=100)
b2grid <- seq(from= -0.01, to= 0.03, length=100)
## grid for evaluating p(y[n+1]=1 | x[n+1,1]=x1, x[n+1,2]=100, y)
## will use in sample.z() to build up marginal prob estimate
x1grid <- seq(from= 10,to=100,length=100)
XX <- cbind(1,x1grid,100) ## corresponding design matrix
n.iter <- 1000
gibbs <- function(n.iter=1000)
{
blist <- NULL # save all simulated b values (for plots)
pb1 <- rep(0,100) # for sum p(beta[j] | z,y)
pb2 <- rep(0,100)
py1 <- rep(0,100) # for p(y[n+1]=1 | x[n+1,1], x[n+2,2]=100,y)
b <- c(0,0,0) # initialize beta
## need b as a column vector below
for(iter in 1:n.iter){
sz <- sample.z(b) # z ~ p(z | b,y)
z <- sz$z
sb <- sample.b(z) # b ~ p(b | z,y)
b <- sb$b
## housekeeping -- update cumulative sums and list of beta values
pb1 <- pb1 + sb$p1 # update sum p(beta[j] | z,y)
pb2 <- pb2 + sb$p2
py1 <- py1 + sz$py # update sum p(y[n+1]=1 | ...)
blist <- rbind(blist,b) # collect simulations
}
return(list(blist=blist,
pb1=pb1/n.iter,pb2=pb2/n.iter, py1=py1/n.iter))
}
sample.z <- function(b)
{ # sample z ~ p(z | b,y)
bvec <- as.matrix(c(b),nrow=3,ncol=1)
## i had trouble forcing b to be a column vector
## this is making sure :-)

my <- X %*% bvec # vector of xi'*b
n <- length(y)
lower <- ifelse(y==0,-Inf,0 )
upper <- ifelse(y==0,0, Inf)
z <- rtnorm(n,m=my,sd=1,lower=lower,upper=upper)
## p(y[n+1]=1 | x[n+1], b, y)
mx <- XX %*% bvec
py <- 1 - pnorm(0, mx, sd=1)
return(list(z=z,py=py))
}
sample.b <- function(z)
{ # sample b ~ p(b | z,y)
fit <- lm(z ~ X -1)
## "-1" for "no intercept". It's already in X
## since we use a constant prior, p(b | ..) = N(m,V)
## with m=LS fit and V=var of LS fit.
m <- fit$coef
V <- summary(fit)$cov.unscaled
L <- chol(V)
b <- m + rnorm(3) %*% L
## p(beta[j] | z,Y) for later estiamte
## p(beta[j] | y) = 1/T sum_{t=1..T} p(beta[j] | z^t, v)
p1 <- dnorm(b1grid,m=m[2],sd=sqrt(V[2,2]))
p2 <- dnorm(b2grid,m=m[3],sd=sqrt(V[3,3]))
return(list(b=b,p1=p1,p2=p2))
}
example <- function()
{ # run it all..
g <- gibbs()
blist <- g$blist
## p(beta1 | y)
hist(blist[,2],xlab="BETA1",bty="l",main="",prob=T)
lines(b1grid, g$pb1, type="l",lwd=3)
## p(beta2 | y)
hist(blist[,3],xlab="BETA2",bty="l",main="",prob=T,ylim=c(0,90))
lines(b2grid, g$pb2, type="l", lwd=3)
## p(beta | y)
plot(blist[,2:3], pch=19,bty="l", xlab="BETA1", ylab="BETA2")
## p(y[n+1]=1 | x[n+1], data)
plot(x1grid, g$py, type="l", bty="l", xlab="x[n+1,1]",
ylab="P(y[n+1]=1 | x[n+1], y)", ylim=c(0,1))
