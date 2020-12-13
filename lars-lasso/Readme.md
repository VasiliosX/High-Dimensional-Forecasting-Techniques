Functions for Lars/lasso based on the lars package.
There is a function for determining the optimal value for the shrinkage parameter through end of sample
cross-validation. This function can be combined with the lars/lasso variable selection functions.

There are also two one-step ahead forecast functions. One that chooses a different value for lambda at each step
and one that uses one value for lambda throughout the forecasting exercise.
