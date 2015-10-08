function [ state ] = getInitialState( settings )
    state = getEmptyStateStruct();

%Return initial state as defined in settings
    state.arPacs = settings.initialState.arPacs;
    state.maPacs = settings.initialState.maPacs;
    state.sigmaEs = settings.initialState.sigmaEs;
    state.ps = length(settings.initialState.arPacs);
    state.qs = length(settings.initialState.maPacs);

    if state.ps > 0
        state.arParameters = getParametersFromPACs(state.arPacs, state.ps);
    else
        state.arParameters = [];
    end;
    if state.qs > 0
        state.maParameters = -getParametersFromPACs(state.maPacs, state.qs);
    else
        state.maParameters = [];
    end;

    state.logPosterior = evaluatePosterior(state, settings);
end

