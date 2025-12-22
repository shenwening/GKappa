function  MSE = get_RMSE_col(values)
    %Calculate MAE and MSE for each column
    % MAE: Mean Absolute Error
    % MSE: Mean Squared Error

    %Initialize MAE and MSE
    mae = zeros(1, size(values, 2)); %MAE for each column
    mean_data = zeros(1, size(values, 2)); %MEAN for each column

    %Iterate over each column to calculate MAE and MSE
    for col = 1:size(values, 2)
        column = values(:, col); %current column
        column_mean = mean(column); %mean of current column
        mae(col) = mean(abs(column - column_mean).^2); %Calculate MAE
        mean_data(col)=column_mean;
        %mse(col) = mean(abs(column - column_mean).^2); % Calculate MSE
    end

    %Returns MAE and MSE for each column
   MSE=sqrt(mae);
end