# High-Dimensional-Forecasting-Techniques
I apply high-dimensional forecasting techniques on McCracken's large macroeconomic dataset.

The 'transformation of time series' file applies all the appropriate transformations in the series in order to achieve stationarity. Those transformations are as in McCracken's website. The excel file has the transformations code as a last time series observation, which is then removed.
The 'own ridge' file is a set of functions for applyng ridge regression on a dataset. Besides the functions for ridge regression and prediction , there is a function for generating a set of values for the shrinkage parameter (lambda or v) and a function for end of sample cross-validation. End of sample CV is preferable to K-fold when dealing with Time-series. There are also two function for recursive one-step ahead forecast, one that searches for the optimal lambda (or v) at each iteration and another one that uses one value of lambda for all iterations.
