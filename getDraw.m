function draw = getDraw(oldState, settings)
%Return proposal based on current state and proposal distributions from
%settings

draw = getEmptyDrawStruct();
    
draw.ps = settings.proposalsARMA.proposalP(oldState.ps);
draw.qs = settings.proposalsARMA.proposalQ(oldState.qs);

%Draw new PACs and compute Parameters
%AR Proposals
if draw.ps ~= oldState.ps
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               Between Model Move in p                       %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if draw.ps > 0
        if draw.ps > oldState.ps
            %Up move 
            if oldState.ps > 0
                draw.arPacs = settings.proposalsARMA.proposalARBetween([oldState.arPacs; zeros(draw.ps - oldState.ps,1)]);
            else
                draw.arPacs = settings.proposalsARMA.proposalARBetween(zeros(draw.ps - oldState.ps,1));
            end;
            draw.arParameters = getParametersFromPACs(draw.arPacs,draw.ps);
        else
            %Down move 
            draw.arPacs = [draw.arPacs settings.proposalsARMA.proposalARBetween(oldState.arPacs(1:draw.ps))];
            draw.arParameters = getParametersFromPACs(draw.arPacs,draw.ps);
        end;
    else
        %"eradication move" 
        draw.arPacs = [];
        draw.arParameters = [];
    end;
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               Within Model Move in p                        %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if draw.ps > 0
        draw.arPacs = settings.proposalsARMA.proposalAR(oldState.arPacs(1:draw.ps));
        draw.arParameters = getParametersFromPACs(draw.arPacs,draw.ps);
    else
        draw.arPacs = [];
        draw.arParameters = [];
    end;
end;


%MA Proposals
if draw.qs ~= oldState.qs
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               Between Model Move in q                       %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if draw.qs > 0
        if draw.qs > oldState.qs
            %Up move 
            if oldState.qs > 0
                draw.maPacs = settings.proposalsARMA.proposalMABetween([oldState.maPacs; zeros(draw.qs - oldState.qs,1)]);
            else
                draw.maPacs = settings.proposalsARMA.proposalMABetween(zeros(draw.qs - oldState.qs,1));
            end;
            draw.maParameters = -getParametersFromPACs(draw.maPacs,draw.qs);
        else
            %Down move 
            draw.maPacs = settings.proposalsARMA.proposalMABetween(oldState.maPacs(1:draw.qs));
            draw.maParameters = -getParametersFromPACs(draw.maPacs,draw.qs);
        end;
    else
        %"eradication move" 
        draw.maPacs = [];
        draw.maParameters = [];
    end;
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               Within Model Move in p                        %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if draw.qs > 0
        draw.maPacs = settings.proposalsARMA.proposalMA(oldState.maPacs(1:draw.qs));
        draw.maParameters = -getParametersFromPACs(draw.maPacs,draw.qs);
    else
        draw.maPacs = [];
        draw.maParameters = [];
    end;
end;

draw.sigmaEs = settings.proposalsARMA.proposalSigmaE(oldState.sigmaEs);
end