#Attempt to enrich functions with list output

#Functions for Monte Carlo

#Rolling Prediction



#Function with More arguments

#ols rolling forecast


roll.forecast.ols=function(X.pred,y.target,df,t.start,t.end){
  rolling=c()
  for (t in 0:(t.end-1)){
    lm1=lm(y.target[1:(t.start+t)]~X.pred[1:(t.start+t),],data = df)
    nea.data=df$X.pred[(t.start+t):(t.start+t+1),]
    pred=predict(lm1,newdata=nea.data)
    rolling[t+1]=pred[length(pred)]
  }
  mse=mean((rolling-y.target[(t.start+1):(t.end+t.start)])^2)
  output=list('mse'=mse,'predicted.y'=rolling)
}






#SOS!!auth h sunarthsh pasxei apo kapoia xontrh malakia
roll.forecast.mse.2=function(X.pred,y.target,t.start,t.end,n.factors){
  rolling=c()
  for (t in 0:t.end-1){
    plsr1=plsr(y.target[1:(t.start+t)]~X.pred[1:(t.start+t),],ncomp=n.factors)
    pred=predict(plsr1,newdata=X.pred[(t.start+t):(t.start+t+1),],type='response',ncomp=n.factors)
    rolling[t+1]=pred[length(pred)]
  }
  mse=mean((rolling-y.target[(t.start+1):(t.end+t.start)])^2)
  output=list('mse'=mse,'predicted.y'=rolling)
  
}





#Bayesian shrinkage forecasting
#auth h sunarthsh einai malakia giati kanei n fold cv





mse.bayesian.forecast=function(X.pred,y.target,t.start,t.end,Lambda=NULL,Alpha){
  rolling=c()
  for (t in 0:(t.end-1)){
    bayes=cv.glmnet(X.pred[1:(t.start+t),],y.target[1:(t.start+t)],type.measure = 'mse',alpha=Alpha,lambda = Lambda )
    pred=predict(bayes,newx=X.pred[(t.start+t):(t.start+t+1),],s=bayes$lambda.min)
    rolling[t+1]=pred[length(pred)]
  }
  mse=mean((rolling-y.target[(t.start+1):(t.end+t.start)])^2)
  output=list('mse'=mse,'predicted.y'=rolling)
  
}






#3PRF



roll.forecast.mse.prf=function(X.pred,y.target,t.start,t.end,n.proxies=2,Z.proxies=NULL){
  rolling=c()
  for (t in 0:t.end-1){
    threeprf=TPRF(X.pred[1:(t.start+t),],y.target[1:(t.start+t)],L=n.proxies,Z=Z.proxies)
    pred=predict(threeprf,newdata=X.pred[(t.start+t):(t.start+t+1),])
    rolling[t+1]=pred[length(pred)]
  }
  mse=mean((rolling-y.target[(t.start+1):(t.end+t.start)])^2)
  output=list('mse'=mse,'predicted.y'=rolling)
  
}




#PCR 

pcr.rolling=function(X.pred,y.target,n.pcs,t.start,t.end,pcr.scale=TRUE){
  rolling=c()
  for (t in 0:t.end-1){
    pc.obj=prcomp(X.pred[1:(t.start+t),],scale = pcr.scale)
    pc.comp=pc.obj$x[,1:n.pcs]
    lm.obj=lm(y.target[1:(t.start+t)]~pc.comp)
    pc.obj2=prcomp(X.pred[1:(t.start+t+1),],scale = pcr.scale)
    pc.comp2=pc.obj$x[,1:n.pcs]
    pred=predict(lm.obj,newdata = data.frame(pc.comp2))
    rolling[t+1]=pred[length(pred)]
  }
  mse=mean((rolling-y.target[(t.start+1):(t.end+t.start)])^2)
  output=list('mse'=mse,'predicted.y'=rolling)
}




 
#Arima 

roll.forecast.arima=function(series,t.start,t.end,horizon=1,p,q,k){
  rolling=c()
  for (t in 0:t.end-1){
    model=Arima(series[1:(t.start+t)],order=c(p,q,k))
    pred=forecast(model,h=horizon)
    rolling[t+1]=pred$mean[1]
  }
  mse=mean((rolling-series[(t.start+1):(t.end+t.start)])^2)
  output=list('mse'=mse,'predicted.y'=rolling)
  
}









