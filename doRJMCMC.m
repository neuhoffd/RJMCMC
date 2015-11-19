function [states, accepted] = doRJMCMC(settings)

    global PROPOSALS_GLOBAL
    clear states;

    %Initialize states
    states(settings.draws) = getEmptyStateStruct();
    
    states(1) = getInitialState(settings);

    accepted = 0;
    
%     progressbar;

    %Iterate until settings.draws is reached
    for cntrDraws = 2:settings.draws   
        [state, draw] = RJMCMCStep(states(cntrDraws-1), settings);
%         progressbar(cntrDraws/settings.draws);
        if settings.saveProposals
            PROPOSALS_GLOBAL(cntrDraws) = draw;
        end;

        accepted = accepted + draw.accepted;
        states(cntrDraws) = state; 

%       Report every 10000th draw 
        if mod(cntrDraws,10000) == 0
            disp(['Iteration ' num2str(cntrDraws) '; Acceptance rate ' num2str(accepted/cntrDraws) ]);
        end;
    end;
    
%     progressbar(1);
end
