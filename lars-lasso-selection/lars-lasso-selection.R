
library(lars)


#lars/lasso variable selection
#The function chooses the most important predictors out of a predictors
#matrix using lars or lasso. The chosen variables are sorted based on their importance
#lambda is the value of the shrinkage parameter and it is entered
#by the user.
#n.vars is how many variables should be extracted.
#The output of the function is the matix of the chosen variables.



lars.selection.b=function(X.pred,y.target,lambda,n.vars,type1='lar'){
  
  lar.fit=lars(X.pred,y.target,type=type1)
  
  lar.pred=predict(lar.fit,s=lambda,mode='lambda',type='coefficients',newx=X.pred)
  
  lar.coef=lar.pred$coefficients[lar.pred$coefficients!=0]
  
  epil.names=names(sort(lar.coef,decreasing = TRUE)[1:n.vars])
  
  return(X,pred[,epil.names])
  
  
}




lars.selection.c=function(X.pred,y.target,lambda,n.vars,type1='lar'){
  
  lar.fit=lars(X.pred,y.target,type=type1)
  
  lar.pred=predict(lar.fit,s=lambda,mode='lambda',type='coefficients',newx=X.pred)
  
  lar.coef=lar.pred$coefficients[lar.pred$coefficients!=0]
  
  epil.names=names(sort(lar.coef,decreasing = TRUE)[1:n.vars])
  
  return(epil.names)
  
  
}
