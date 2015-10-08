function [logPosterior] = evaluatePosterior(state, settings)
    %Returns the log posterior as sum of the log prior as well as the log likelihood
    %as supplied
    [logPrior] = evaluatePrior(state, settings);
    [logLikelihood] = settings.likelihoodFunction(state, settings);

    logPosterior = logPrior + logLikelihood;
end