%--------------------------------------------------------------------------
% Name of Quantlet: TSARMARJMCMC
%--------------------------------------------------------------------------
% Published in: Univariate Time Series
%--------------------------------------------------------------------------
% Description: Estimate univariate, stationary Autoregressive Moving 
%               Average (ARMA) models using Reversible Jump Markov Chain 
%               Monte Carlo
%--------------------------------------------------------------------------
% Keywords: Kalman filter, Markov, PACF, arma, stationary, univariate
%--------------------------------------------------------------------------
% See also: -
%--------------------------------------------------------------------------
% Author: Daniel Neuhoff, Alexander Meyer-Gohde
%--------------------------------------------------------------------------
% Submitted: Mon, October 12 2015 by neuhoffd
%--------------------------------------------------------------------------
% Datafile: -
%--------------------------------------------------------------------------
% Input: Any zero-mean stationary univariate time series
%--------------------------------------------------------------------------
% Output: Posterior distribution of parameters and orders of lag polynomials
%           Mean and median estimates for parameters
%--------------------------------------------------------------------------


clear all; 
close all; home; format long g;  rng('shuffle');

settings = getSettings();

datum = date;
if settings.saveProposals
    global PROPOSALS_GLOBAL;
    PROPOSALS_GLOBAL = getEmptyDrawStruct();
    PROPOSALS_GLOBAL(settings.draws) = getEmptyDrawStruct();
end;

tic;
[states, accepted] = doRJMCMC(settings);
disp('Time elapsed for sampling'); toc;
        
arParametersSeries = padcat(states.arParameters);
maParametersSeries = padcat(states.maParameters);
sigmaESeries = cat(1,states.sigmaEs);
pSeries = cat(1,states.ps);
qSeries = cat(1,states.qs);
arPacsSeries = padcat(states.arPacs);
maPacsSeries = padcat(states.maPacs);
logPosteriorSeries = cat(1,states.logPosterior);
        
if settings.saveProposals
    arParametersSeries_PROPOSAL = padcat(PROPOSALS_GLOBAL.arParameters);
    maParametersSeries_PROPOSAL = padcat(PROPOSALS_GLOBAL.maParameters);
    sigmaESeries_PROPOSAL = cat(1,PROPOSALS_GLOBAL.sigmaEs);
    pSeries_PROPOSAL = cat(1,PROPOSALS_GLOBAL.ps);
    qSeries_PROPOSAL = cat(1,PROPOSALS_GLOBAL.qs);
    arPacsSeries_PROPOSAL = padcat(PROPOSALS_GLOBAL.arPacs);
    maPacsSeries_PROPOSAL = padcat(PROPOSALS_GLOBAL.maPacs);
end;

if settings.saveProposals
    save(settings.resultsFile,'arParametersSeries', 'maParametersSeries', 'sigmaESeries', 'pSeries', 'qSeries', 'arPacsSeries','maPacsSeries',...
        'arParametersSeries_PROPOSAL', 'maParametersSeries_PROPOSAL', 'sigmaESeries_PROPOSAL', 'pSeries_PROPOSAL', 'qSeries_PROPOSAL', 'arPacsSeries_PROPOSAL','maPacsSeries_PROPOSAL',...
        'logPosteriorSeries', 'accepted', 'settings');
else            
    save(settings.resultsFile,'arParametersSeries', 'maParametersSeries', 'sigmaESeries', 'pSeries', 'qSeries', 'arPacsSeries',...
    'maPacsSeries', 'logPosteriorSeries', 'accepted',  'settings');
end;  

displayResults;