function [states, accepted] = doRJMCMC(settings)

    %Create struct to save state of chain
    %Structure:
    %.arPacs: AR Partial Autocorrelations
    %.maPacs: MA Inverse Partial Autocorrelations
    %.logPosterior:  Value of Log-Posterior at state
    %.p: AR order
    %.q: MA order
    %.sigmaEs: Shock standard deviation
    %.arParameters: Column vector of AR-Parameters
    %.maParameters: Column vector of MA-Parameters

    global PROPOSALS_GLOBAL
    clear states;

    %Initialize states
    states(settings.draws) = getEmptyStateStruct();
    draw = getEmptyDrawStruct();

    accepted=0;

    %Iterate until settings.draws is reached
    for cntrDraws = 2:settings.draws   
        [state, draw] = RJMCMCStep(states(cntrDraws-1), draw, settings);
        if settings.saveProposals
            PROPOSALS_GLOBAL(cntrDraws) = draw;
        end;

        accepted = accepted + draw.accepted;
        states(cntrDraws) = state; 

        %Report every 10000th draw
        if mod(cntrDraws,10000) == 0
            disp(['Iteration ' num2str(cntrDraws) '; Acceptance rate ' num2str(accepted/cntrDraws) ]);
        end;
    end;
end
