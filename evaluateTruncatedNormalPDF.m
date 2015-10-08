function p = evaluateTruncatedNormalPDF(x,a,b,mu,sigma)
    %Returns a column vector of values of the truncated normal pdf. a,b are
    %taken to be scalars and the same for each probability. mu, sigma are
    %taken to be column vectors of the same size.
    
    %pdf taken from Wickedpedia
    
    %Logical Arrays are MAGIC! :)
    logicalMagic = (a*ones(size(x)) <= x) & (x <= b*ones(size(x)));

    standardizedX = (x-mu)./sigma;
    standardizedA = (ones(size(mu))*a - mu)./sigma;
    standardizedB = (ones(size(mu))*b - mu)./sigma;

    enumerator = normpdf(standardizedX)./sigma;
    denominator = normcdf(standardizedB) - normcdf(standardizedA);

    p = logicalMagic .* enumerator ./ denominator;
end