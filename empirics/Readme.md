On the Empirics1 file, I apply High-Dimensional Forecasting techniques on the McCracken dataset.The McCracken dataset consists of 243 quarterly observations of 205 variables (after having removed those that contain missing values). 
The observations start at the third quarter of 1959 and end at the first quarter of 2020. After I have applied all of the necessary stationarity transformations, I proceed with the one-step ahead forecasting exercises. The various models will be compared with an AR(4).
The first forecasting exercise concerns GDP and it starts at  2001-12-01. 
In other words , the data available up to 2001-12-01 is used to obtain the GDP forecast for the next period (the first quarter of 2002), then, the predicted GDP value is then compared with the actual GDP value and so forth until the end of the dataset. The Mean Squared error is subsequently calculated.
The first model, which will be used as a benchmark, is a simple AR(4) of GDP. 


Those other files are required: Transformation of time series, own.ridge, lars-lasso,recursive prediction, Squared-Principal-Components,lars-lasso-selection.

The current_copy_2 excel file contains the McCracke dataset. The last observation on this dataset is the 
transformatio codes, the observation is removed after the transformations.