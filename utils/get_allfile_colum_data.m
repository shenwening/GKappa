function data_matrix=get_allfile_colum_data(folder_path)
    
    files = dir(fullfile(folder_path, '*.xlsx'));
     full_path = fullfile(folder_path, files(1).name);
     data=get_xlsx_columdata(full_path);
     num=length(data);
    %Initialize data matrix
    data_matrix = zeros(length(files),num);

    %Iterate through each file
    for i = 1:length(files)
        %Get full file path
        full_path = fullfile(folder_path, files(i).name);
        current_data=get_xlsx_columdata(full_path);
        data_matrix(i,:)=current_data';
    end
end 



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
end