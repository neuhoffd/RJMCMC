function data = getData(settings)
    %Reads data from mat file according to settings and returns it as column
    %vector

    data = load(settings.dataFile, settings.varName);
    
    fieldname = fieldnames(data);
    data = data.(fieldname{1});
    
    [row, col] = size(data);

    if (row > 1) && (col < 1)
        baseException = MException('getData:BadData','Your data seems to be a Matrix. This is not allowed. Terminating.');
        throw(baseException);
    end;
end