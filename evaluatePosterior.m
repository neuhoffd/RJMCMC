function [logPosterior, estimatedVariance, dropDraw] = evaluatePosterior(state, settings)
    %Returns the log posterior evaluating the prior as well as the likelihood
    %as supplied
    [logPrior, dropDraw] = evaluatePrior(state, settings);
    if ~dropDraw
        [logLikelihood] = settings.likelihoodFunction(state, settings);

        logPosterior = logPrior + logLikelihood;
    else
        disp('Draw dropped due to exclusion by prior distribution!');
        logPosterior = (-1/0);
    end;
end