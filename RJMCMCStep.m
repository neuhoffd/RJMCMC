function [newState, draw] = RJMCMCStep(oldState, settings)    
    newState = oldState;
    
    %Get draw
    draw = settings.getDrawARMA(oldState, settings);    

    %Evaluate joint log posterior
    [draw.logPosterior] = evaluatePosterior(draw, settings);

    %Compute log acceptance probability
    alpha = draw.logPosterior - oldState.logPosterior + evaluateProposalRatio(oldState, draw, settings);
   
    %Accept draw with probability alpha
    if rand <= exp(min(alpha,0))
       % Accept the candidate
        newState.logPosterior = draw.logPosterior; 
        newState.logProposal = draw.logProposal;
        if draw.ps > 0
            newState.arParameters = draw.arParameters;
            newState.arPacs = draw.arPacs;
        else
            newState.arParameters = [];
            newState.arPacs = [];
        end;
        if draw.qs > 0
            newState.maParameters = draw.maParameters;
            newState.maPacs = draw.maPacs;
        else
            newState.maParameters = [];
            newState.maPacs = [];
        end;
        newState.ps = draw.ps;
        newState.qs = draw.qs;
        draw.accepted = 1;                % Note the acceptance
        newState.sigmaEs = draw.sigmaEs;
    else
        %reject the candidate
        draw.accepted  = 0;                % Note the rejection
    end;
end

