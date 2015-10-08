function [priorValue, dropDraw] = evaluatePrior(state, settings)
    dropDraw = 0;
    if ~dropDraw
        priorValue = 0;
        if state.ps > 0
            priorAR = settings.priorsARMA.priorAR(state.arPacs);
            priorValue = sum(log(priorAR));
        else
            priorAR = 1/0;
        end;
        if state.qs > 0
            priorMA = settings.priorsARMA.priorMA(state.maPacs);
            priorValue = priorValue + sum(log(priorMA));
        else
            priorMA = 1/0;
        end;             
        if (min(priorAR) > 0) && (min(priorMA) > 0) && (settings.priorsARMA.priorSigmaE(state.sigmaEs) > 0)
            priorValue = priorValue + ...
                    log(settings.priorsARMA.priorP(state.ps));
            priorValue = priorValue + ...
                    log(settings.priorsARMA.priorQ(state.qs));
            priorValue = priorValue +  ...
                    log(settings.priorsARMA.priorSigmaE(state.sigmaEs));
        else
            dropDraw = 1;
        end;
    end;
end