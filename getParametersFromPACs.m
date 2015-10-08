function arParameters = getParametersFromPACs(pacs, p)
    %returns ARParameters corresponding to a set of partial
    %autocorrelations. The function takes any vector and uses the first p
    %components to return p AR- (or MA respectively) Parameters in a column
    %vector.

    temporal = zeros(max(size(pacs)), max(size(pacs)));
    temporal(1,1) = pacs(1);
    for cntrK = 2:p
        for cntrI = 1:(cntrK - 1)
            temporal(cntrK,cntrI) = temporal(cntrK-1,cntrI) - pacs(cntrK)*temporal(cntrK-1,cntrK - cntrI);
        end;
        temporal(cntrK, cntrK) = pacs(cntrK);
    end;
    arParameters = temporal(p,:)';
end