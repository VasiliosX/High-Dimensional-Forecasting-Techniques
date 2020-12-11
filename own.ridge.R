



#Ridge regression


ridge=function(y,X,v){
N=dim(X)[2]
a_ridge=(solve(t(X)%*%X+v*diag(N),tol = 1e-28))%*%(t(X)%*%y)
y_hat=X%*%a_ridge
output_list=list('y_hat'=y_hat,'coef'=a_ridge)
return(output_list)
}



#Ridge prediction function


ridge.predict=function(model,newx){
  y_new=newx%*%model$coef
  return(y_new)
}


#end of sample cv of ridge regression
#The values of the shrinkage parameter that are considered are
# entered by the user through the lambdapath function (hastie,  tibshirani)
#Last last.eval observations are used to for out of sample one step
#ahead forecasting, the shrinkage parameter that results in the
#least mse is chosen


#Function for creating lambda path
lambdapath=function(X,y,K,epsilon,mult.max.lambda=1){

#Compute maximum lambda

sx <- as.matrix(scale(X))
sy <- as.vector(scale(y))
lambda_max=mult.max.lambda*max(abs(colSums(sx*sy)))/100

#create sequence of lambdas

lambdapath <- round(exp(seq(log(lambda_max), log(lambda_max*epsilon), 
                            length.out = K)), digits = 10)
return(lambdapath)
}

end_of_sample_cv_ridge=function(X,y,eval.obs,v_param){
T=dim(X)[1]

mres=c()
for (i in 1:length(v_param)){
v1=v_param[i]





j=0
rolling=c()
for (t in (T-(eval.obs+1)):(T-1)){
  j=j+1
  fit=ridge(y[1:t],X[1:t,],v=v1)
  pred=ridge.predict(fit,newx =X[(t+1),] )
  rolling[j]=pred
}

mres[i]=mean((rolling-y[(T-eval.obs):(T)])^2)

}

return(v_param[which.min(mres)])



}






#Function that combines end of sample cv and ridge so that it picks the best
#value of the shrinkage parameter and then does the regression

cv.ridge=function(y,X,v_param,eval.obs){
  optimal.v=end_of_sample_cv_ridge(y=y,X=X,v_param = v_param,eval.obs = eval.obs)
  fit=ridge(y=y,X=X,v=optimal.v)
  return(list('fit'=fit,'optimal.v'=optimal.v))
}




#Recursive one step ahead ridge forecast with end of sample cv




ridge.forecast=function(X.pred,y.target,t.start,t.end,eval.obs,v_param ){
  rolling=c()
  for (t in 0:(t.end-1)){
    ridge.reg=cv.ridge(X=X.pred[1:(t.start+t),],y=y.target[1:(t.start+t)],v_param =v_param ,eval.obs = eval.obs)
    pred=ridge.predict(ridge.reg$fit,newx=X.pred[(t.start+t+1),])
    rolling[t+1]=pred
  }
  mse=mean((rolling-y.target[(t.start+1):(t.end+t.start)])^2)
  output=list('mse'=mse,'predicted.y'=rolling)
  
}


#Recursive one step ahead ridge forecast with one lambda

ridge.forecast.b=function(X.pred,y.target,t.start,t.end,v ){
  rolling=c()
  for (t in 0:(t.end-1)){
    ridge.reg=ridge(X=X.pred[1:(t.start+t),],y=y.target[1:(t.start+t)],v =v)
    pred=ridge.predict(ridge.reg,newx=X.pred[(t.start+t+1),])
    rolling[t+1]=pred
  }
  mse=mean((rolling-y.target[(t.start+1):(t.end+t.start)])^2)
  output=list('mse'=mse,'predicted.y'=rolling)
  
}



#same function as above but returns the set of mses

end_of_sample_cv_ridge.b=function(X,y,eval.obs,v_param){
  T=dim(X)[1]
  
  mres=c()
  for (i in 1:length(v_param)){
    v1=v_param[i]
    
    
    
    
    
    j=0
    rolling=c()
    for (t in (T-(eval.obs+1)):(T-1)){
      j=j+1
      fit=ridge(y[1:t],X[1:t,],v=v1)
      pred=ridge.predict(fit,newx =X[(t+1),] )
      rolling[j]=pred
    }
    
    mres[i]=mean((rolling-y[(T-eval.obs):(T)])^2)
    
  }
  
  return(mres)
  
  
  
}
  
  
  
  
  





















