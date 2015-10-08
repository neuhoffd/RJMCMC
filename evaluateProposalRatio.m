function proposalRatio = evaluateProposalRatio( oldState, draw, settings)
%Evaluates and returns the log proposal ratio
    proposalRatio = 0;

    if settings.proposalsARMA.isLogOrders
        proposalRatio = settings.proposalsARMA.evaluateProposalP([draw.ps(1) oldState.ps(1)]) + settings.proposalsARMA.evaluateProposalQ([draw.qs(1) oldState.qs(1)])) ...
                            - (settings.proposalsARMA.evaluateProposalP([oldState.ps(1) draw.ps(1)]) + settings.proposalsARMA.evaluateProposalQ([oldState.qs(1) draw.qs(1)])); 
    else
        proposalRatio = log(settings.proposalsARMA.evaluateProposalP([draw.ps(1) oldState.ps(1)])) + log(settings.proposalsARMA.evaluateProposalQ([draw.qs(1) oldState.qs(1)]))) ...
                            - (log(settings.proposalsARMA.evaluateProposalP([oldState.ps(1) draw.ps(1)])) + log(settings.proposalsARMA.evaluateProposalQ([oldState.qs(1) draw.qs(1)]))); 
    end;
    
    if settings.proposalsARMA.isLogPACs
        switch logical(true)
            case draw.ps > oldState.ps %draw.ps always > 0
                if oldState.ps > 0
                    muEnumerator        = draw.arPacs(1:oldState.ps);
                    muDenominator       = [oldState.arPacs; zeros(draw.ps - oldState.ps,1)];

                    logContributionAR   = sum(settings.proposalsARMA.evaluateProposalARBetween(oldState.arPacs, muEnumerator)) -...
                                            sum(settings.proposalsARMA.evaluateProposalARBetween(draw.arPacs,     muDenominator));
                else
                    muDenominator       = zeros(size(draw.arPacs));                    
                    logContributionAR   = - sum(settings.proposalsARMA.evaluateProposalARBetween(draw.arPacs,   muDenominator));
                end;

            case draw.ps == oldState.ps
                if draw.ps > 0 %then also oldState.ps > 0
                    muEnumerator        = draw.arPacs;
                    muDenominator       = oldState.arPacs;

                    logContributionAR   = sum(settings.proposalsARMA.evaluateProposalAR(oldState.arPacs, muEnumerator)) -...
                                            sum(settings.proposalsARMA.evaluateProposalAR(draw.arPacs,     muDenominator));
                else %draw.ps == oldState.ps == 0
                    logContributionAR   = 0;
                end;

            case draw.ps < oldState.ps %thus oldState.ps > 0 in any case
                if draw.ps > 0 
                    muEnumerator        = [draw.arPacs; zeros(oldState.ps - draw.ps,1)];
                    muDenominator       = oldState.arPacs(1:draw.ps);   

                    logContributionAR   = sum(settings.proposalsARMA.evaluateProposalARBetween(oldState.arPacs, muEnumerator)) -...
                                            sum(settings.proposalsARMA.evaluateProposalARBetween(draw.arPacs,     muDenominator));
                else 
                    muEnumerator        = zeros(size(oldState.arPacs));                    
                    logContributionAR   = sum(settings.proposalsARMA.evaluateProposalARBetween(oldState.arPacs, muEnumerator));
                end;
        end;

        %MA Proposals        
        switch logical(true)
            case draw.qs > oldState.qs %draw.qs always > 0
                if oldState.qs > 0
                    muEnumerator        = draw.maPacs(1:oldState.qs);
                    muDenominator       = [oldState.maPacs; zeros(draw.qs - oldState.qs,1)];

                    logContributionMA   = sum(settings.proposalsARMA.evaluateProposalMABetween(oldState.maPacs, muEnumerator)) -...
                                            sum(settings.proposalsARMA.evaluateProposalMABetween(draw.maPacs,     muDenominator));
                else
                    muDenominator       = zeros(size(draw.maPacs));

                    logContributionMA   = - sum(settings.proposalsARMA.evaluateProposalMABetween(draw.maPacs,   muDenominator));
                end;

            case draw.qs == oldState.qs
                if draw.qs > 0 %then also oldState.qs > 0
                    muEnumerator        = draw.maPacs;
                    muDenominator       = oldState.maPacs;

                    logContributionMA   = sum(settings.proposalsARMA.evaluateProposalMA(oldState.maPacs, muEnumerator)) -...
                                            sum(settings.proposalsARMA.evaluateProposalMA(draw.maPacs,     muDenominator));
                else %draw.qs == oldState.qs == 0
                    logContributionMA   = 0;
                end;

            case draw.qs < oldState.qs %thus oldState.qs > 0 in any case
                if draw.qs > 0 
                    muEnumerator        = [draw.maPacs; zeros(oldState.qs - draw.qs,1)];
                    muDenominator       = [oldState.maPacs(1:draw.qs)];   

                    logContributionMA   = sum(settings.proposalsARMA.evaluateProposalMABetween(oldState.maPacs, muEnumerator)) -...
                                            sum(settings.proposalsARMA.evaluateProposalMABetween(draw.maPacs,     muDenominator));
                else 
                    muEnumerator        = zeros(size(oldState.maPacs));

                    logContributionMA   = sum(settings.proposalsARMA.evaluateProposalMABetween(oldState.maPacs, muEnumerator));
                end;
        end;
        logContributionSigmaE = ...
            settings.proposalsARMA.evaluateProposalSigmaE(oldState.sigmaEs, draw.sigmaEs) - ...
            settings.proposalsARMA.evaluateProposalSigmaE(draw.sigmaEs, oldState.sigmaEs);
    else
        switch logical(true)
            case draw.ps > oldState.ps %draw.ps always > 0
                if oldState.ps > 0
                    muEnumerator        = draw.arPacs(1:oldState.ps);
                    muDenominator       = [oldState.arPacs; zeros(draw.ps - oldState.ps,1)];

                    logContributionAR   = sum(log(settings.proposalsARMA.evaluateProposalARBetween(oldState.arPacs, muEnumerator))) -...
                                            sum(log(settings.proposalsARMA.evaluateProposalARBetween(draw.arPacs,     muDenominator)));
                else
                    muDenominator       = zeros(size(draw.arPacs));                    
                    logContributionAR   = - sum(log(settings.proposalsARMA.evaluateProposalARBetween(draw.arPacs,   muDenominator)));
                end;

            case draw.ps == oldState.ps
                if draw.ps > 0 %then also oldState.ps > 0
                    muEnumerator        = draw.arPacs;
                    muDenominator       = oldState.arPacs;

                    logContributionAR   = sum(log(settings.proposalsARMA.evaluateProposalAR(oldState.arPacs, muEnumerator))) -...
                                            sum(log(settings.proposalsARMA.evaluateProposalAR(draw.arPacs,     muDenominator)));
                else %draw.ps == oldState.ps == 0
                    logContributionAR   = 0;
                end;

            case draw.ps < oldState.ps %thus oldState.ps > 0 in any case
                if draw.ps > 0 
                    muEnumerator        = [draw.arPacs; zeros(oldState.ps - draw.ps,1)];
                    muDenominator       = oldState.arPacs(1:draw.ps);   

                    logContributionAR   = sum(log(settings.proposalsARMA.evaluateProposalARBetween(oldState.arPacs, muEnumerator))) -...
                                            sum(log(settings.proposalsARMA.evaluateProposalARBetween(draw.arPacs,     muDenominator)));
                else 
                    muEnumerator        = zeros(size(oldState.arPacs));                    
                    logContributionAR   = sum(log(settings.proposalsARMA.evaluateProposalARBetween(oldState.arPacs, muEnumerator)));
                end;
        end;

        %MA Proposals        
        switch logical(true)
            case draw.qs > oldState.qs %draw.qs always > 0
                if oldState.qs > 0
                    muEnumerator        = draw.maPacs(1:oldState.qs);
                    muDenominator       = [oldState.maPacs; zeros(draw.qs - oldState.qs,1)];

                    logContributionMA   = sum(log(settings.proposalsARMA.evaluateProposalMABetween(oldState.maPacs, muEnumerator))) -...
                                            sum(log(settings.proposalsARMA.evaluateProposalMABetween(draw.maPacs,     muDenominator)));
                else
                    muDenominator       = zeros(size(draw.maPacs));

                    logContributionMA   = - sum(log(settings.proposalsARMA.evaluateProposalMABetween(draw.maPacs,   muDenominator)));
                end;

            case draw.qs == oldState.qs
                if draw.qs > 0 %then also oldState.qs > 0
                    muEnumerator        = draw.maPacs;
                    muDenominator       = oldState.maPacs;

                    logContributionMA   = sum(log(settings.proposalsARMA.evaluateProposalMA(oldState.maPacs, muEnumerator))) -...
                                            sum(log(settings.proposalsARMA.evaluateProposalMA(draw.maPacs,     muDenominator)));
                else %draw.qs == oldState.qs == 0
                    logContributionMA = 0;
                end;

            case draw.qs < oldState.qs %thus oldState.qs > 0 in any case
                if draw.qs > 0 
                    muEnumerator        = [draw.maPacs; zeros(oldState.qs - draw.qs,1)];
                    muDenominator       = [oldState.maPacs(1:draw.qs)];   

                    logContributionMA   = sum(log(settings.proposalsARMA.evaluateProposalMABetween(oldState.maPacs, muEnumerator))) -...
                                            sum(log(settings.proposalsARMA.evaluateProposalMABetween(draw.maPacs,     muDenominator)));
                else 
                    muEnumerator        = zeros(size(oldState.maPacs));

                    logContributionMA   = sum(log(settings.proposalsARMA.evaluateProposalMABetween(oldState.maPacs, muEnumerator)));
                end;
        end;
        logContributionSigmaE = ...
            log(settings.proposalsARMA.evaluateProposalSigmaE(oldState.sigmaEs, draw.sigmaEs)) - ...
            log(settings.proposalsARMA.evaluateProposalSigmaE(draw.sigmaEs, oldState.sigmaEs));
    end;

    proposalRatio = proposalRatio + logContributionMA + logContributionAR + logContributionSigmaE;    
end

