library(pls)
library(nowcasting)
library(factoextra)
library(zoo)
library(xts)


#PCA in the data


vector_y=matrix(df$GDPC1,ncol=1,nrow=243)
matrix_X=as.matrix(df[,-grep('GDPC1',colnames(df))])

pc1=prcomp(matrix_X,scale. = TRUE)



fviz_eig(pc1, addlabels=TRUE)+ylim(c(0,23))


#Estimated number of factors is 7
ICfactors(matrix_X,type = 2)


#Percentage of explained variance of those 7 factors.
get_eig(pc1)[1:6,]

#Get the Principal Components
p.components=pc1$x[,1:6]

#Strenth of factor structure
rsquares=c()
for (i in 1:N){
  rsquares[i]=summary(lm(matrix_X[,i]~p.components))$r.squared
}

print(median(rsquares))

#AR(4)
#Create an AR for GDP 



gdpc=as.xts(df$GDPC1,order.by = current_copy_2$sasdate[3:245])




#Forecasting exercise

ar_4=roll.forecast.arima(gdpc,t.start = 170,t.end=70,p=4,q=0,k=0,horizon=1)

ar_4$mse


date=ymd(rownames(matrix_X)[171:240])

zoo1=ar_4$predicted.y
zoo2=vector_y[171:240]

plot.zoo(cbind(zoo1, zoo2), 
         plot.type = "single", 
         col = c("red", "blue"),main='AR(4)',ylab='GDP Growth',xlab='')

legend("topright", inset=c(0,0), y.intersp = 1, legend = c("Predicted", "Observed"),  lty = 1, bty = "n", col = c("red", "blue"), cex = .5)






  
#PLSR
plsr=roll.forecast.mse.2(X.pred=matrix_X,y.target = vector_y,t.start = 170,t.end=70,n.factors  =7)


plsr$mse/ar_4$mse


#3PRF

prf1=roll.forecast.mse.prf(X.pred=matrix_X,y.target=vector_y,t.start = 170,t.end=70,n.proxies=2)

prf1$mse/ar_4$mse



spcr=spcr.rolling(X.pred=data.frame(matrix_X),y.target=vector_y,t.start = 170,t.end=70,n.spcs=5)

spcr$mse/ar_4$mse





prcr=pcr.rolling(X.pred=data.frame(matrix_X),y.target=vector_y,t.start = 170,t.end=70,n.pcs=5)

prcr$mse/ar_4$mse


#Ridge regression

vpms=lambdapath(matrix_X,vector_y,K=50,epsilon = 0.0002405036*(1/100),mult.max.lambda = 0.0002405036*100)

ridgemres=end_of_sample_cv_ridge.b(matrix_X[1:170,],vector_y[1:170],eval.obs = 20,v_param = vpms)

plot(ridgemres)
best.lambda=vpms[which.min(ridgemres)]




bayes2=ridge.forecast.b(X.pred=matrix_X,y.target=vector_y,t.start=170,t.end=70,v = best.lambda)

print(bayes2$mse/ar_4$mse)
bayes2$mse




zoo1=vector_y[171:240]
zoo2=bayes2$predicted.y
plot.zoo(cbind(zoo1, zoo2), 
         plot.type = "single", 
         col = c("red", "blue"),main='Ridge',ylab='GDP Growth',xlab='')




#with lars selection
#ols with top 5
matrix_x5=lars.selection.b(matrix_X,vector_y,lambda = 0.002405036,n.vars = 2,type1='lasso')

df1=data.frame(vector_y,matrix_x5)



ols1=roll.forecast.ols(X.pred=matrix_x5,y.target=vector_y,df=df1,t.start=170,t.end=70)

print(ols1$mse/ar_4$mse)


#lars pcr 30

matrix_x30=lars.selection.b(matrix_X,vector_y,lambda = 0.0002093577,n.vars = 50,type1='lasso')

for (l in 1:10){
prcr30=pcr.rolling(X.pred=data.frame(matrix_x30),y.target=vector_y,t.start = 170,t.end=70,n.pcs=l)

print(prcr30$mse/ar_4$mse)
}


#lasso with end of sample cv



vpms=lambdapath(matrix_X[1:90,],vector_y[1:90],K=200,epsilon=10^(-8),mult.max.lambda=10)



lasso.fit=end_of_sample_cv_lars(matrix_X[1:90,],vector_y[1:90],eval.ob = 10,lambdas =vpms,type = 'lasso' )


plot(lasso.fit$MSEs)

lopt=vpms[which.min(lasso.fit$MSEs)]

#Generate lambda values again based on the end of sample cv above
vpms2=sort(runif(n=100,lopt*0.05,20*lopt),decreasing = TRUE)

lasso.fit2=end_of_sample_cv_lars(matrix_X[1:90,],vector_y[1:90],eval.ob = 10,lambdas =vpms2,type = 'lasso' )

plot(lasso.fit2$MSEs)
lopt2=vpms2[which.min(lasso.fit2$MSEs)]

las=lars.forecast.b(X.pred=matrix_X,y.target=vector_y,t.start=170,t.end=70,lambda=lopt,type_1='lasso')


las$mse/ar_4$mse

zoo1=vector_y[171:240]
zoo2=las$predicted.y
plot.zoo(cbind(zoo1, zoo2), 
         plot.type = "single", 
         col = c("red", "blue"),main='LASSO',ylab='GDP Growth',xlab='')















