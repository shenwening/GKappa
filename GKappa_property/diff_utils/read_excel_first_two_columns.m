function data = read_excel_first_two_columns(filePath)
    %Read the first two columns of data from the Excel table
    %enter:
    %filePath - the path to the Excel file
    %Output:
    %data - the matrix containing the first two columns of data

    %Check if the file exists
    if ~isfile(filePath)
        error('文件不存在: %s', filePath);
    end

    %Read the first two columns of data from the Excel file
    try
        data = readmatrix(filePath, 'Range', 'A:B');
    catch ME
        error('读取Excel文件失败: %s', ME.message);
    end
end