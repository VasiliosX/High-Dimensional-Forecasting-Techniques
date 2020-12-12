The 'own ridge' file is a set of functions for applying ridge regression on a dataset.
 Besides the functions for ridge regression and prediction , there is a function for generating a set of values for the shrinkage parameter (lambda or v) and a function for end of sample cross-validation.
 End of sample CV is preferable to K-fold when dealing with Time-series. 
There are also two function for recursive one-step ahead forecast, one that searches for the optimal lambda (or v) at each iteration and another one that uses one value of lambda for all iterations.