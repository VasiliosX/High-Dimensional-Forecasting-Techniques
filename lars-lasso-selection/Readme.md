This funtion does variable selection out of a matrix of predictors.
The function is based on the lars package.
The arguments are the matrix of predictosr, the target variable y, the number of variables to
be extracted and the value of the shrinkage parameter lambda to be used. There are end-of-sample-CV functions that
come up with an optimal value of lambda.
The output is a a new matrix consisting of the chosen subset of variables.

There are a few issues with the function that shall be fixed.
1st issue:The function only works when the variables are named. 
2nd issue: The function discards all the variables that have slope coefficients equalized to zero by lasso or lars.
This might cause a problem if n.vars is larger than the number of the non-zero variables.
