#Squared Principal Components



#Squared Principal Components is done by creating a new X matrix and then
#doing usual PCA to the new matrix.
#The new matrix has thise elements
#X_it={X_it^2,X_it}



  
SPC=function(X,f.scale){
  
T=dim(X)[1]
N=dim(X)[2]
X_2=matrix(nrow=T,ncol=N)

for (n in 1:N){
  for (t in 1:T){
    X_2[t,n]=(X[t,n])^2
  }
}


X_new=cbind(X_2,X)
dimensions=dim(X_new)
prc=prcomp(X_new,scale. = f.scale)

output=list('sdev'=prc$sdev,'rotation'=prc$rotation,'x'=prc$x,'center'=prc$center,'new.dimensions'=dimensions)
return(output)
}




#Squared Principal Components Regression (SPCR)




SPCR=function(X.pred,y.target,n.spcs,spcr.scale=TRUE){
  spc.obj=SPC(X.pred,f.scale = spcr.scale)
  spc.comp=spc.obj$x[,1:n.spcs]
  spcr.obj=lm(y.target~spc.comp)
  return(spcr.obj)
}





#SPCR recursive one-step ahead forecast function
#X.pred is the predictors matrix and y.target the target variable
#n.spcs is the number of principal components to be used in the regression
#t.start is the point at which the forecasting procedure begins, t.end denotes for how many periods after t.start
#should the forecasting procedure be applied.
#In other words, the forecasting exercise begins at t.start and ends at t.start+t.end

spcr.rolling=function(X.pred,y.target,n.spcs,t.start,t.end,spcr.scale=TRUE){
  rolling=c()
  for (t in 0:t.end-1){
  spc.obj=SPC(X.pred[1:(t.start+t),],f.scale = spcr.scale)
  spc.comp=spc.obj$x[,1:n.spcs]
  lm.obj=lm(y.target[1:(t.start+t)]~spc.comp)
  spc.obj2=SPC(X.pred[1:(t.start+t+1),],f.scale = spcr.scale)
  spc.comp2=spc.obj$x[,1:n.spcs]
  pred=predict(lm.obj,newdata = data.frame(spc.comp2))
  rolling[t+1]=pred[length(pred)]
  }
  mse=mean((rolling-y.target[(t.start+1):(t.end+t.start)])^2)
  output=list('mse'=mse,'predicted.y'=rolling)
}



#the output is the vector of fitted y values, as well as the mean square error of the forecast

