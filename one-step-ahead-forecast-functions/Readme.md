This file contains several one-step ahead functions. Those functions are used in analysis of the McCracken dataset.

The common arguments among all functions are the t.start and t.end arguments, which indicate the start
of the one-step ahead forecast exercise (t.start) and the end of the forecast exercise (t.start+t.end).
The function's output includes the predicted values and the MSE.

The roll.forecast.mse.2 relies on the pls package. The extra argument is number of factors.
The 3PRF based function relies on IshmaelBengazi's code on github. 
roll.forecast.arima uses the forecast package. The extra arguments are p,q and k which denote the order of the ARIMA fit.