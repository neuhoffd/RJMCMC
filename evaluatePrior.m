function [priorValue] = evaluatePrior(state, settings)
    priorValue = 0;
    if state.ps > 0 %Only evaluate if at least one AR lag exists
        priorAR = settings.priorsARMA.priorAR(state.arPacs);
        if settings.priorsARMA.isLog
            priorValue = priorValue + sum(priorAR);
        else
            priorValue = priorValue + sum(log(priorAR));
        end;
    end;
    
    if state.qs > 0 %Only evaluate if at least one MA lag exists
        priorMA = settings.priorsARMA.priorMA(state.maPacs);
        if settings.priorsARMA.isLog
            priorValue = priorValue + sum(priorMA);
        else
            priorValue = priorValue + sum(log(priorMA));
        end;
    end;

    if settings.priorsARMA.isLog
        priorValue = priorValue + ...
                        settings.priorsARMA.priorP(state.ps);
        priorValue = priorValue + ...
                        settings.priorsARMA.priorQ(state.qs);
        priorValue = priorValue +  ...
                        settings.priorsARMA.priorSigmaE(state.sigmaEs);
    else
        priorValue = priorValue + ...
                        log(settings.priorsARMA.priorP(state.ps));
        priorValue = priorValue + ...
                        log(settings.priorsARMA.priorQ(state.qs));
        priorValue = priorValue +  ...
                        log(settings.priorsARMA.priorSigmaE(state.sigmaEs));
    end;
end