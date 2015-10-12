%Displays and plots the results as well as some convergence diagnostics

    cumsums = cumsum(ones(1,settings.draws));
    disp('Unconditional Posterior Estimates AR Coefficients')
    for i = 1:settings.pMax
        disp(['Order: ', num2str(i)]);
        if i <= size(arParametersSeries,1)
            temp=arParametersSeries(i,:);
            if settings.doPlots
                figure;
                temp2 = temp;
                temp2(isnan(temp2))= 0;                
                plot(cumsum(temp2) ./ cumsums);
                title(['Unconditional Recursive Mean AR Parameter ' num2str(i)]);
            end;
            temp = temp(settings.burnIn+1:end);
            disp(['Mean:        ' num2str(mean(temp(isfinite(temp)==1)))]);
            disp(['Median:      ' num2str(median(temp(isfinite(temp)==1)))]);
        else
            disp('NaN');
        end;
    end;

    disp('Unconditional Posterior Estimates MA Coefficients')
    for i = 1:settings.qMax
        disp(['Order: ', num2str(i)]);
        if i <= size(maParametersSeries,1)
            temp=maParametersSeries(i,:);
            if settings.doPlots
                figure;
                temp2 = temp;
                temp2(isnan(temp2))= 0;                
                plot(cumsum(temp2) ./ cumsums);
                title(['Unconditional Recursive Mean MA Parameter ' num2str(i)]);
            end;
            temp = temp(settings.burnIn+1:end);
            disp(['Mean:        ' num2str(mean(temp(isfinite(temp)==1)))]);
            disp(['Median:      ' num2str(median(temp(isfinite(temp)==1)))]);
        else
            disp('NaN');
        end;
    end;
    
    disp('Unconditional Mean and Median Sigma');
    temp = sigmaESeries(settings.burnIn+1:end);
    if settings.doPlots
        figure;
        plot(cumsum(temp) ./ cumsums);
        title(['Unconditional Recursive Mean Sigma']);
    end;
    disp(['Mean: ' num2str(mean(temp))]);
    disp(['Median: ' num2str(median(temp))]);

   
    pqMatrix = [pSeries(settings.burnIn+1:end) qSeries(settings.burnIn+1:end)];
    
    x = 0:1:settings.pMax;
    z = 0:1:settings.qMax;

    bintest = cell(1);
    bintest{1} = x;
    bintest{2} = z;

    [nelements, centers] = hist3(pqMatrix,'Edges',bintest);
    [maxPQ, ind] = max(nelements(:));
    [m,n] = ind2sub(size(nelements),ind);

    pPostMax = m-1;
    qPostMax = n-1;

    pqSieve = ((pqMatrix(:,1) == pPostMax) & (pqMatrix(:,2) == qPostMax));
    
    disp('Conditional Means and Medians AR');
    for i = 1:settings.pMax
        disp(['Order: ', num2str(i)]);
        if i <= size(arParametersSeries,1)
            temp=arParametersSeries(i,settings.burnIn+1:end);
            if settings.doPlots & (i <= pPostMax)
                figure;
                plot(transpose(cumsum(temp(pqSieve))) ./ cumsum(pqSieve(pqSieve == 1)));
                title(['Conditional Recursive Mean AR Parameter ' num2str(i)]);
            end;
            temp = temp(pqSieve);
            disp(['Mean: ' num2str(mean(temp))]);
            disp(['Median: ' num2str(median(temp))]);
        else
            disp('NaN');
        end;
    end;
    
    disp('Conditional Means and Medians MA');
    for i = 1:settings.qMax
        disp(['Order: ', num2str(i)]);
        if i <= size(maParametersSeries,1)
            temp=maParametersSeries(i,settings.burnIn+1:end);
            if settings.doPlots & (i <= qPostMax)
                figure;
                plot(transpose(cumsum(temp(pqSieve))) ./ cumsum(pqSieve(pqSieve == 1)));
                title(['Conditional Recursive Mean MA Parameter ' num2str(i)]);
            end;
            temp = temp(pqSieve);
            disp(['Mean: ' num2str(mean(temp))]);
            disp(['Median: ' num2str(median(temp))]);
        else
            disp('NaN');
        end;
    end;
    
    disp('Conditional Mean and Median Sigma');
    temp = sigmaESeries(settings.burnIn+1:end);
    if settings.doPlots
        figure;
        plot(cumsum(temp(pqSieve)) ./ cumsum(pqSieve(pqSieve == 1)));
        title(['Conditional Recursive Mean Sigma']);
    end;
    temp = temp(pqSieve);
    disp(['Mean: ' num2str(mean(temp))]);
    disp(['Median: ' num2str(median(temp))]);
    
    x = 0:1:settings.pMax;
    z = 0:1:settings.qMax;
    figure;
    hist(pSeries(settings.burnIn:end),x);
    figure;
    hist(qSeries(settings.burnIn:end),z);

    figure;
    bintest = cell(1);
    bintest{1} = x;
    bintest{2} = z;
    hist3(pqMatrix,'Edges',bintest);