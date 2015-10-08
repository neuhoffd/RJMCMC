function x = vectorizedRTNorm(a,b,mu,sigma)
    %Wraps rtnorm for truncated normal for vectorization
    %Returns a column vector of size(mu,1) independent draws from truncated normal
    %a,b are taken to be scalars, mu/sigma are column vectors
    x = zeros(size(mu,1),1);
    
    for cntr = 1:size(mu,1)
        x(cntr) = rtnorm(a,b,mu(cntr),sigma(cntr));
    end;
end