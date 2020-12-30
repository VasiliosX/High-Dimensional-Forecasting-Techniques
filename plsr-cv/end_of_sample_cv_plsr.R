
#End-of-sample cross validation algorithm for partial least squares 
#regression
#X is the argument for the matrix of predictors, y the regressed variable
#eval.obs is the number of observations at the end of the 
#sample that shall be taken into account when computing the MSE's
#algorithm
#factor_n takes a vector of integers. The algorithm produces the 
#MSE of one-step ahead forecasts for PLS regression over each of the
#number of factors included in the factor_n vector. The 
#The optimal number of factors can be chosen with which.min(opt)!!!


end_of_sample_cv_plsr=function(X,y,eval.obs,factor_n){
  T=dim(X)[1]
  
  mres=c()
  for (i in 1:length(factor_n)){
    v1=factor_n[i]
    
    
    
    
    
    j=0
    rolling=c()
    for (t in (T-(eval.obs+1)):(T-1)){
      j=j+1
      pr1=plsr(y[1:t]~X[1:t,],ncomp=v1)
      pred=predict(pr1,newdata=X[t:(t+1),],ncomp=v1)
      rolling[j]=pred[length(pred)]
    }
    
    mres[i]=mean((rolling-y[(T-eval.obs):(T)])^2)
    
  }
  
  return(mres)
  
  
  
}