function prob = evaluateDiscreteLaplacePDF(k,kprime,logPDF)
    %Returns Value of PDF for going from some scalar k to kprime for Discrete Laplacian
    %PDF as defined by discreteLaplacePDF function
    prob = logPDF(kprime+1,k+1);
end