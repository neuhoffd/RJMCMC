function kprime = sampleDiscreteLaplace(k, CDF)
%Sample from discretized Laplace distribution following Troughton,
%Goodsill, Ehlers and Brooks 2004 
        
    u = rand(1);
    
    kprime = find(CDF(:,k+1)>u,1,'first')-1;
    
end
