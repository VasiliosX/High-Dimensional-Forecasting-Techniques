This file has three functions.
The first function (SPC) does Squared Principal Components on a dataset using the prcomp function of R base. 
The function creates a new matrix that has the twice the columns of the dataset matrix. The new columns
contain the elements of the original matrix squared.
The function returns all the arguments that prcomp does, as well as the dimensions of the new matrix.
The scale argument (as in prcomp) indicates whether the variables should be scaled to have unit variance.
 
The second function is called SPCR (Squared Principal Components Regression) and it is an extension of the first function. It uses SPC to extract 
squared principal components from a dataset and then uses those squared principal components as regressors.
The arguments are the target variable (y.target), the predictors matrix or dataset and the number of components.

The third function does recursive, one step ahead forecast using Squared Principal Component regression. The
arguments are the target, the predictors matrix, the period at which the forecasting exercise starts (t.start) and the number of periods
after t.start at which it ends (t.end). The user also chooses the number of squared principal components to be used.
The predicted target values, as well as the mean square error of the forecast is returned.

For more information on Squared Principal Components, See Bai,Ng (2008), 'Forecasting economic time series using targeted predictors'