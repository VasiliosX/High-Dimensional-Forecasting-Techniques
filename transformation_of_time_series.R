library(dplyr)
library(tidyr)
library(forecast)
library(lattice)
library(lubridate)
library(ggplot2)
library(zoo)
library(xts)
library(factoextra)
library(pls)
library(nowcasting)
library(readxl)
library(glmnet)
library(lars)

library(remotes)




setwd("D:/Desktop/programming/r/R/mcracken")


current_copy_2 <- read_excel("current_copy_2.xlsx")


current_copy_2=current_copy_2%>%
  mutate(sasdate=ymd(sasdate))





variables_names=colnames(current_copy_2)
new_vars=c()





for (i in variables_names){
  j=paste('ts',sep="_",i)
  print(j)
  new_vars=c(new_vars,j)
}



for (j in 2:dim(current_copy_2)[1]){
  assign(new_vars[j],xts(current_copy_2[,j],order.by = current_copy_2$sasdate))
  
}

rm(ts_NONBORRES)
ts_AAA[1:length(ts_AAA)-1]




trans_function=function(ts){
  num=0 
  if (is.xts(ts)){
    num=as.numeric(ts[length(ts)])
    ts=ts[1:length(ts)-1]
    
    if (num==2){
      ts_tel<-diff(ts)
    } else if (num==3){
      ts_tel<-diff(ts,differences = 2)
      
    } else if (num==4){
      ts_tel=log(ts)
    } else if (num==5){
      ts_tel=diff(log(ts))
    } else if (num==6){
      ts_tel=diff(log(ts),differences = 2)
    } else if (num==1){
      ts_tel=ts
    }
    return(ts_tel)}
  else {
    print('not a time series object')
  }
  
}











results = lapply(setNames(ls(), ls()), function(i) {
  x = get(i)
  if(is.xts(x)) {
    trans_function(x)
  }
})

results = results[!sapply(results, is.null)]



df=data.frame(results)


df=df[3:dim(df)[1],]


df=df%>%
  select_if(~!any(is.na(.)))

rownames(df)=ymd(rownames(df))

#Delete everything starting with ts_
rm(list = ls()[grep("^ts", ls())])




vector_y=matrix(df$GDPC1,ncol=1,nrow=243)
matrix_X=as.matrix(df[,-grep('GDPC1',colnames(df))])

