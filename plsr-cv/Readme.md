
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