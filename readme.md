# Reversible Jump Markov Chain Monte Carlo (RJMCMC) Sampler for Autoregressive Moving Average (ARMA) Time Series Models

This quantlet contains a small suite enabling the user to estimate ARMA time series models using Reversible Jump Markov Chain Monte Carlo (RJMCMC) (See e.g. Green 1995, Brooks and Ehlers 2003). RJMCMC enables the sampling from posteriors over not only the parameter space for a particular model, but also several models.

The sampler provided here assumes zero-mean stationary ARMA models with normal disturbances as in Neuhoff (2015) or Meyer-Gohde and Neuhoff (2015). Stationarity is ensured by reparametrizing the lag polynomials in terms of (inverse) partial autocorrelations as described in Monahan 1984. Thus, priors and proposals have to be supplied in these terms. The supplied code evaluates the likelihood by means of the Kalman filter.

The sampler settings and data source can be set in the file "getSettings.m". It is also possible to replace all prior distributions, proposal distributions, as well as the Likelihood functions via setting the appropriate function handles in this file. This framework can thus be also employed to estimate ARMA models with non-normal disturbances. Furthermore, any proposal distribution can be used. For further information please refer to the comments in "getSettings.m".

In order to run the sampler, set the desired options in "getSettings.m" and run "estimateARMA.m". To display the results, run "displayResults.m". Depending on the value of the variable settings.doPlots to be set in "getSettings.m", this script will also plot the conditional and unconditional posterior averages for the parameters. Some synthetic data for testing is provided in testdata.mat. The data was generated from an AR(1) process with the standard deviation of the error term set to 0.9. The sample size is 250.

The plots are displayed as follows:

* Posterior distribution of lag polynomial orders

![Posterior for lag polynomial orders] (SamplePosteriorOrders.png)

* Recursive means for parameters

![Recursive mean for parameters] (ConditionalMeanARParameterSample.png)

* Prior posterior plots

![Prior Posterior Plot] (PriorCondPosteriorARPAC1FILTERED.png)

To install the sampler, you can download all necessary files by clicking on "Download ZIP" on the right. Extract the files to a directory of your choosing, navigate there within Matlab or add it to the Matlab path, set the preferences in getSettings.m to your liking and run estimateARMA.m.

Tested on Matlab R2015a running on Windows Server 2014 and Windows 7 Professional. Utilizes the Statistics Toolbox. Note that the sampler requires significant amounts of RAM depending on the number of draws. At least 8 GB are recommended!
