function [ state ] = getInitialState( settings )
%Return initial state as defined in settings
    state = getEmptyDrawStruct();

    state.arPacs = settings.initialState.arPacs;
    state.maPacs = settings.initialState.maPacs;
    state.sigmaEs = settings.initialState.sigmaEs;
    state.ps = length(settings.initialState.arPacs);
    state.qs = length(settings.initialState.maPacs);

    if state.ps > 0
        state.arParameters = getARParametersFromPACs(state.arPacs, state.ps);
    else
        state.arParameters = [];
    end;
    if state.qs > 0
        state.maParameters = -getARParametersFromPACs(state.maPacs, state.qs);
    else
        state.maParameters = [];
    end;
    state.logProposal = log(0.0000000000000000000000005);
    if settings.useSolver == 1
        state.logPosterior = evaluatePosterior(y,state,priorsARMA,settings, modelinfo, parameters);
    else
        state.logPosterior = evaluatePosteriorARMA(y,state,priorsARMA,settings);
    end;
end

