
library(lars)


#End of sample CV for LARS/LASSO
#This function does end of sample cross-validation for either LARS or LASSO
#and it is based on the lars package.
#In particular, the function calculates the MSE of an one-step ahead forecast for 
#the last eval.obs observations of the dataset X on the target y. Then the lambda that results
#in the least MSE is chosen.
#The function takes as arguments the dataset X, the target y, and the 
#the number of observations in the end of the sample that will be used
#in the evaluation. The set of lambdas that will be evaluated is 
#given by the user
#The type argument is as in the lars function, lasso or lars can be chosen.

end_of_sample_cv_lars=function(X,y,eval.obs,lambdas,type){

T=dim(X)[1]

mres=c()
for (h in 1:length(lambdas)){
  
  lmbd=lambdas[h]
   rolling=c()
   j=0
for (t in (T-(eval.obs+1)):(T-1)){
  j=j+1
  
  lars.fit=lars(X[1:t,],y[1:t],type=type)
  
  lars.pred=predict(lars.fit,type='fit',mode='lambda',s=lmbd,newx=X[t:(t+1),])
  rolling[j]=lars.pred$fit[length(lars.pred$fit)]
}

mres[h]=mean((rolling-y[(T-eval.obs):T])^2)


}
list_output=list('optimal.lambda'=lambdas[which.min(mres)],'MSEs'=mres)

return(list_output)


}




#Lars recursive forecast function with end of sample CV at each period
#The arguments are the predictors matrix, the target, the time period where the 
#the forecasting exercise begins (t.start) and the number of periods after the start that will be 
#included in the exercise (t.end). The user also provides the function with a 
#set of lambdas (with a value for lambda chosen at each period) and the number of observations
#that the end of sample cv alrogithm uses to choose a value for lambda



lars.forecast=function(X.pred,y.target,t.start,t.end,lambdas,type_1='lasso',eval.obs){
  rolling=c()
  for (t in 0:(t.end-1)){
    optimal.lambda=end_of_sample_cv_lars(X.pred[1:(t.start+t),],y.target[1:(t.start+t)],lambdas=lambdas,type=type_1,eval.obs=eval.obs)
    fit=lars(X.pred[1:(t.start+t),],y.target[1:(t.start+t)],type = type_1)
    pred=predict(fit,newx=X.pred[(t.start+t):(t.start+t+1),],s=optimal.lambda,mode='lambda')
    rolling[t+1]=pred$fit[length(pred$fit)]
  }
  mse=mean((rolling-y.target[(t.start+1):(t.end+t.start)])^2)
  output=list('mse'=mse,'predicted.y'=rolling)
  
}





#Lars forecast function where lambda is not chosen at each period
#The whole out one-step ahead forecast is done with the same value for lambda. 
#Far less computionally demanding than the above function.




lars.forecast.b=function(X.pred,y.target,t.start,t.end,lambda,type_1='lasso'){
  rolling=c()
  for (t in 0:(t.end-1)){
    
    fit=lars(X.pred[1:(t.start+t),],y.target[1:(t.start+t)],type = type_1)
    pred=predict(fit,newx=X.pred[(t.start+t):(t.start+t+1),],s=lambda,mode='lambda')
    rolling[t+1]=pred$fit[length(pred$fit)]
  }
  mse=mean((rolling-y.target[(t.start+1):(t.end+t.start)])^2)
  output=list('mse'=mse,'predicted.y'=rolling)
  
}



#The output of both forecast functions is the vector of predicted 
#y values and the corresponding Mean Square Error.