Seasonal Autoregressive Integrated Moving-Average with eXogenous regressors (SARIMAX)

The SARIMAX class is an example of a fully fledged model created using the statespace backend for estimation. SARIMAX can be used very similarly to tsa models, but works on a wider range of models by adding the estimation of additive and multiplicative seasonal effects, as well as arbitrary trend polynomials.

Seasonal ARIMA captures historical values, shock events and seasonality. 

SARIMAX(y, order = (5, 4, 2), seasonal_order=(2,2,2,12))


Time Series Analysis by State Space Methods statespace (https://www.statsmodels.org/dev/statespace.html#seasonal-autoregressive-integrated-moving-average-with-exogenous-regressors-sarimax)


Different types of the model


Autoregressive Moving Average (ARMA)

The term “autoregressive” in ARMA means that the model uses past values to predict future ones. Specifically, predicted values are a weighted linear combination of past values. This type of regression method is similar to linear regression, with the difference being that the feature inputs here are historical values. 

SARIMAX(y, order = (1, 0, 1))

Moving average refers to the predictions being represented by a weighted, linear combination of white noise terms, where white noise is a random signal. The idea here is that ARMA uses a combination of past values and white noise in order to predict future values. Autoregression models market participant behavior like buying and selling BTC. The white noise models shock events like wars, recessions and political events. 


Autoregressive Integrated Moving Average (ARIMA)

ARIMA(y, order = (2, 2, 2))

An ARIMA task has three parameters. The first parameter corresponds to the lagging (past values), the second corresponds to differencing (this is what makes non-stationary data stationary), and the last parameter corresponds to the white noise (for modeling shock events). 


