function data = get_xlsx_columdata(inputfile)
    %Use readmatrix instead of xlsread
    try
        data = readmatrix(inputfile);
        %Get only the first column
        data = data(:,1);
    catch
        %If readmatrix fails, try using readtable
        T = readtable(inputfile);
        data = table2array(T(:,1));
    end
    
    %% Convert data to positive integer
    %data = round(data); % round first
    %data = abs(data); % ensure it is a positive number
    %data = uint32(data); % Convert to unsigned integer type
end