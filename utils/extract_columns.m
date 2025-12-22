function data = extract_columns(file_path)
    % Check if file exists
    if ~isfile(file_path)
        error('File does not exist: %s', file_path);
    end
    
    % Read specified columns data
    try
        data = readmatrix(file_path, 'Range', 'A:C'); % Read columns 2 to 4
    catch ME
        error('Error reading file: %s', ME.message);
    end
end