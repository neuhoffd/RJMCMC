function y = discreteLaplacePDF(k_max,lambda)
    %Returns a matrix of values from the log-PDF of the discretized Laplace
    %distribution following ehlers brooks (2004) and Troughton Goodsill
    %going from k to k' where k' gives the row and k the column
     
    y = zeros(k_max+1,k_max+1);
    vecKPrime = transpose(0:1:k_max);
    
    for cntrK = 1:k_max+1
        vecK = ones(k_max+1,1)*(cntrK-1);
        pdfVal = abs(vecKPrime-vecK); %abs(k'-k)
        pdfVal = -lambda * pdfVal; %-lambda*(abs(k'-k))
        pdfVal = exp(pdfVal);%exp(-lambda*(abs(k'-k)))
        constant = sum(pdfVal);
        
        y(:,cntrK) = log(pdfVal/constant);
    end;    
end