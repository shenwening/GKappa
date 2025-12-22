%% 1. Environment initialization and path configuration
clear; clc; close all; %Clear variables/command line/close old figures to avoid interference
addpath("utils\");     %Add tool function path
addpath("D:\matlibprojects\tmpOC_new"); %Add custom function path

%% 2. Core parameter settings
K = 10;                      %Number of categories
N = 50;                     %Sample/sequence length
testIters = 1:1000;         %1-1000 experiments (row vectors, subsequently uniformly transposed to column vectors)
metricName = {'GKappa'};    %Unique indicator: GKappa
outputDir = 'data/kn/data/';     %Output directory
outputFilePath = fullfile(outputDir, sprintf('K%d_N%d_GKappa_Results.xlsx', K, N)); % Excel path
imgFilePath = fullfile(outputDir, sprintf('K%d_N%d_GKappa_Fit_Curve.png', K, N)); % Fitting curve picture path
bool_first = true;          %Whether to write to Excel for the first time (overwrite mode)

%Create an output directory (to avoid errors if the path does not exist)
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

%% 3. Calculate the mean GKappa value of 1-1000 experiments (optimizing cycle efficiency)
gk_mean = zeros(length(testIters), 1); %Store the GKappa mean of each time (column vector)
for idx = 1:length(testIters)
    curr_iter = testIters(idx); %Current number of repetitions
    gk_sum = 0;                 %Initialize accumulated value

    %Inner loop: Calculate the cumulative GKappa value of the current number of times
    for i = 1:curr_iter
        %Print progress every 200 times (reduce screen refresh, 1000 experiments need to be monitored)
        % if mod(i, curr_iter) == 0
        %disp(['Current total progress: ', num2str(idx), '/1000 | Inner progress: ', num2str(i), '/', num2str(curr_iter)]);
        % end
        %Generate 2 sets of random sequences
        a = generateSequence(1, K, N);
        b = generateSequence(1, K, N);
        %Calculate GKappa (assuming MS_GK returns a single numeric value)
        gk_val = MS_GK(a, b, 1, K, 1, K);
        gk_sum = gk_sum + gk_val;
    end
    if mod(idx,100)==0
        disp(i)
    end
    %Calculate mean and store (column vector)
    gk_mean(idx) = gk_sum / curr_iter;
end
abs_gk_mean = abs(gk_mean); %Extract absolute value (column vector: 1000×1)
disp('1-1000次GKappa均值计算完成！');

%% 4. Write to Excel file (optional: save only key data to avoid excessive file size)
%The amount of data 1-1000 times is large, you can choose to save the data every 10 times (reduce the size of Excel)
saveIters = 1:10:1000; %Save a data point every 10 times
saveGkMean = gk_mean(saveIters);
if bool_first
    writecell([{'重复次数'}, metricName], outputFilePath, 'WriteMode', 'overwrite'); %Added "Number of repetitions" column
end
writematrix([saveIters', saveGkMean], outputFilePath, 'Range', 'A2'); %Number of writes + mean (both column vectors)
disp(['关键数据已保存至: ', outputFilePath]);

%% 5. Nonlinear fitting (exponential decay model: y = a*exp(-b*x) + c, converges to 0)
%Model description: a=initial value, b=attenuation coefficient, c=convergence benchmark (approaching 0)
fitModel = @(params, x) params(1) .* exp(-params(2)*x) + params(3);
initialGuess = [max(abs_gk_mean), 0.005, 0]; %Initial guess: a=maximum, b=0.005, c=0

%Key correction: Convert testIters to column vectors to ensure consistent fitting input dimensions
testIters_col = testIters'; %Row vector to column vector (1000×1)
%Nonlinear least squares fitting (input x is a column vector)
nlm = fitnlm(testIters_col, abs_gk_mean, fitModel, initialGuess);

%Extract fitting parameters
fitParams = nlm.Coefficients.Estimate;
a_fit = fitParams(1); %initial amplitude
b_fit = fitParams(2); %Attenuation coefficient
c_fit = fitParams(3); %Convergence benchmark

%Generate y values ​​of the fitted curve (key correction: transpose to column vector, consistent with abs_gk_mean dimension)
y_fit = (a_fit * exp(-b_fit * testIters) + c_fit)'; %Calculate the row vector first and then transpose it into a column vector (1000×1)
%Eliminate abnormal negative numbers of the fitted value (the absolute value cannot be negative)
y_fit(y_fit < 0) = 0;

disp('拟合参数：');
disp(['初始幅值 a = ', num2str(a_fit)]);
disp(['衰减系数 b = ', num2str(b_fit)]);
disp(['收敛基准 c = ', num2str(c_fit)]);

%% 6. Draw the fitting curve + original data (highlight the fitting curve)
figure('Position', [100, 100, 900, 600]); %Enlarge the figure window to improve readability
hold on; grid on; box on;

%1. Draw the original data (light gray, thin lines, as reference)
plot(testIters, abs_gk_mean, 'Color', [0.7,0.7,0.7], 'LineWidth', 1, 'DisplayName', 'Original data'); %English legend
%2. Draw the fitting curve (dark blue, bold, core display)
plot(testIters, y_fit, 'Color', [0.1,0.4,0.7], 'LineWidth', 2.5, 'DisplayName', 'Fitted curve'); %English legend

%% 7. Chart beautification (all displayed in English, adapted to English reading habits)
%Global font settings (English is preferred, Arial font is more suitable)
set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');
set(0, 'DefaultUicontrolFontName', 'Arial');

%X-axis settings (logarithmic scale, zoom in to low-rep range)
xlabel('Number of repeated experiments(Rn)', 'FontSize', 25, 'FontWeight', 'bold'); %English X-axis labels
set(gca, 'XScale', 'log'); %Logarithmic scale adapts to span 1-1000
xticks([1,10,100,500,1000]); %critical tick
xticklabels({'1','10','100','500','1000'}); %digital retention

%Y-axis settings (forced to start from 0, strengthen convergence vision)
y_min = 0;
%Correction: abs_gk_mean and y_fit are both column vectors and can be concatenated directly vertically
y_max = max([abs_gk_mean; y_fit]) * 1.1; %Override the maximum value of the original + fitted data
ylim([y_min, y_max]);
ylabel('Absolute value of GKappa mean', 'FontSize', 20, 'FontWeight', 'bold'); %English Y-axis label

%Title (English professional expression, including fitting model)
% title(sprintf('Exponential convergence fitting of |GKappa| with repeated experiments (K=%d, N=%d) \n (y=%.3f·e^{-%.5f·x}+%.3f)', ...
%               K, N, a_fit, b_fit, c_fit), 'FontSize', 15, 'FontWeight', 'bold'); 
title(sprintf('GKappa Convergence (R=%d, n=%d) \n y=%.3f·e^{-%.5f·x}+%.3f', ...
              K, N, a_fit, b_fit, c_fit), 'FontSize', 15, 'FontWeight', 'bold');
%Title line wrapping (\n) optimizes long text display and adds K/N parameters to the title to make it clearer

%Legend settings (English)
legend('Location', 'best', 'FontSize', 20); 
%Coordinate axis + grid optimization
set(gca, 'FontSize', 20);
set(gca, 'GridAlpha', 0.2); %Reduce mesh transparency
set(gca, 'Box', 'on');
set(gca, 'TickLabelInterpreter', 'none'); %Make sure scale/formula symbols are displayed properly

%% 8. Save high-resolution images
print(gcf, imgFilePath, '-dpng', '-r300'); %300dpi HD PNG
%Vector diagram (journal submission):
% print(gcf, fullfile(outputDir, sprintf('K%d_N%d_GKappa_Fit_Curve.eps', K, N)), '-depsc', '-r300');

%English prompt information (optional, keep the same language style as the picture)
disp(['Fitted curve image saved to: ', imgFilePath]);
disp('All operations completed!');


%%% 1. Environment initialization and path configuration
%clear; clc; close all; % clear variables/command line/close old figures to avoid interference
%addpath("utils\"); % Add tool function path
%addpath("D:\matlibprojects\tmpOC_new"); % Add custom function path
% 
%%% 2. Core parameter settings (key modification: split K into K1 and K2, support different values)
%K1 = 5; % the number of categories of a sequence (can be customized, such as 20)
%K2 = 10; % The number of categories of b sequence (can be customized, such as 30, which can be different from K1)
%N = 50; % sample/sequence length
%testIters = 1:1000; % 1-1000 experiments (row vector, subsequently transposed to column vector)
%metricName = {'GKappa'}; % unique metric: GKappa
%outputDir = 'data/kn/datak/'; % output directory
% 
%% Output path adaptation K1/K2 (core modification: reflect two K values)
% outputFilePath = fullfile(outputDir, sprintf('K1_%d_K2_%d_N%d_GKappa_Results.xlsx', K1, K2, N)); 
% imgFilePath = fullfile(outputDir, sprintf('K1_%d_K2_%d_N%d_GKappa_Fit_Curve.png', K1, K2, N)); 
%bool_first = true; % Whether to write to Excel for the first time (overwrite mode)
% 
%% Create the output directory (to avoid errors if the path does not exist)
% if ~exist(outputDir, 'dir')
%     mkdir(outputDir);
% end
% 
%%% 3. Calculate the mean GKappa value of 1-1000 experiments (optimizing cycle efficiency)
%gk_mean = zeros(length(testIters), 1); % stores the GKappa mean of each time (column vector)
% for idx = 1:length(testIters)
%curr_iter = testIters(idx); % current number of repetitions
%gk_sum = 0; % initialize accumulated value
% 
%% Inner loop: Calculate the cumulative GKappa value of the current number of times
%     for i = 1:curr_iter
%% Generate 2 sets of random sequences (core modification: use K1 for a and K2 for b)
%a = generateSequence(1, K1, N); % a number of sequence categories = K1
%b = generateSequence(1, K2, N); % b number of sequence categories = K2
% 
%% Calculate GKappa (core modification: adapt K1 of a and K2 of b)
%gk_val = MS_GK(a, b, 1, K1, 1, K2); % The previous K is K1 (a) and the next K is K2 (b)
%         gk_sum = gk_sum + gk_val;
%     end
% 
%% Printing progress every 100 times (monitoring 1000 experiments)
%     if mod(idx,100)==0
%disp(['Current number of completed repetitions: ', num2str(curr_iter)]);
%     end
% 
%% Calculate the mean and store it (column vector)
%     gk_mean(idx) = gk_sum / curr_iter;
% end
% 
%abs_gk_mean = abs(gk_mean); % extract absolute value (column vector: 1000×1)
%disp(['1-1000 GKappa average calculations completed! (K1=', num2str(K1), ', K2=', num2str(K2), ')']);
% 
%%% 4. Write to Excel file (optional: save only key data to avoid excessive file size)
%% The amount of data for 1-1000 times is large, you can choose to save the data every 10 times (reduce the size of Excel)
%saveIters = 1:10:1000; % Save a data point every 10 times
% saveGkMean = gk_mean(saveIters);
% 
% if bool_first
%% Add K1/K2 description to the header
%writecell([{'Number of repetitions'}, metricName, {'K1'}, {'K2'}], outputFilePath, 'WriteMode', 'overwrite');
%% Write the fixed value of K1/K2 (fill the entire column)
%     writematrix(repmat(K1, length(saveIters), 1), outputFilePath, 'Range', 'C2');
%     writematrix(repmat(K2, length(saveIters), 1), outputFilePath, 'Range', 'D2');
% end
% 
%% Number of writes + mean (both column vectors)
% writematrix([saveIters', saveGkMean], outputFilePath, 'Range', 'A2'); 
%disp(['Key data has been saved to: ', outputFilePath]);
% 
%%% 5. Nonlinear fitting (exponential decay model: y = a*exp(-b*x) + c, converges to 0)
%% Model description: a=initial value, b=attenuation coefficient, c=convergence benchmark (approaching 0)
% fitModel = @(params, x) params(1) .* exp(-params(2)*x) + params(3);
%initialGuess = [max(abs_gk_mean), 0.005, 0]; % initial guess: a=maximum value, b=0.005, c=0
% 
%% Key correction: Convert testIters into column vectors to ensure consistent fitting input dimensions
%testIters_col = testIters'; % Convert row vector to column vector (1000×1)
%% Nonlinear least squares fitting (input x is a column vector)
% nlm = fitnlm(testIters_col, abs_gk_mean, fitModel, initialGuess);
% 
%% Extract fitting parameters
% fitParams = nlm.Coefficients.Estimate;
%a_fit = fitParams(1); % initial amplitude
%b_fit = fitParams(2); % attenuation coefficient
%c_fit = fitParams(3); % convergence benchmark
% 
%% Generate the y value of the fitted curve (key correction: transpose to column vector, consistent with abs_gk_mean dimension)
%y_fit = (a_fit * exp(-b_fit * testIters) + c_fit)'; % Calculate the row vector first, and then transpose it into a column vector (1000×1)
%% Eliminate abnormal negative numbers of the fitted value (the absolute value cannot be negative)
% y_fit(y_fit < 0) = 0;
% 
%disp('Fitting parameters:');
%disp(['Initial amplitude a = ', num2str(a_fit)]);
%disp(['attenuation coefficient b = ', num2str(b_fit)]);
%disp(['Convergence benchmark c = ', num2str(c_fit)]);
% 
%%% 6. Draw the fitting curve + original data (highlight the fitting curve)
%figure('Position', [100, 100, 900, 600]); % Enlarge the figure window to improve readability
% hold on; grid on; box on;
% 
%% 1. Draw the original data (light gray, thin lines, as reference)
%plot(testIters, abs_gk_mean, 'Color', [0.7,0.7,0.7], 'LineWidth', 1, 'DisplayName', 'Original data'); % English legend
%% 2. Draw the fitting curve (dark blue, bold, core display)
%plot(testIters, y_fit, 'Color', [0.1,0.4,0.7], 'LineWidth', 2.5, 'DisplayName', 'Fitted curve'); % English legend
% 
%%% 7. Chart beautification (all displayed in English, adapted to English reading habits)
%% Global font settings (English is preferred, Arial font is more suitable)
% set(0, 'DefaultAxesFontName', 'Arial');
% set(0, 'DefaultTextFontName', 'Arial');
% set(0, 'DefaultUicontrolFontName', 'Arial');
% 
%% X-axis settings (logarithmic scale, amplify low-number range)
%xlabel('Number of repeated experiments', 'FontSize', 25, 'FontWeight', 'bold'); % English X-axis label
%set(gca, 'XScale', 'log'); % Logarithmic scale adaptation 1-1000 span
%xticks([1,10,100,500,1000]); % key ticks
%xticklabels({'1','10','100','500','1000'}); % numbers reserved
% 
%% Y-axis settings (forced to start from 0, strengthen convergence vision)
% y_min = 0;
%% Correction: abs_gk_mean and y_fit are both column vectors and can be directly connected vertically.
%y_max = max([abs_gk_mean; y_fit]) * 1.1; % covers the maximum value of the original + fitted data
% ylim([y_min, y_max]);
%ylabel('Absolute value of GKappa mean', 'FontSize', 20, 'FontWeight', 'bold'); % English Y-axis label
% 
%% title (core modification: reflect K1 and K2, professional expression in English)
% % title(sprintf('Exponential convergence fitting of |GKappa| with repeated experiments (K1=%d, K2=%d, N=%d) \n (y=%.3f·e^{-%.5f·x}+%.3f)', ...
% %               K1, K2, N, a_fit, b_fit, c_fit), 'FontSize', 13, 'FontWeight', 'bold'); 
% 
% title(sprintf('GKappa convergence  (N=%d, M=%d, n=%d) \n (y=%.3f·e^{-%.5f·x}+%.3f)', ...
%               K1, K2, N, a_fit, b_fit, c_fit), 'FontSize', 15, 'FontWeight', 'bold'); 
%% Title line wrapping (\n) optimizes long text display and adds K1/K2/N parameters to the title to make it clearer
% 
%% Legend settings (English)
% legend('Location', 'best', 'FontSize', 20); 
%% Coordinate axis + grid optimization
% set(gca, 'FontSize', 20);
%set(gca, 'GridAlpha', 0.2); % Reduce grid transparency
% set(gca, 'Box', 'on');
%set(gca, 'TickLabelInterpreter', 'none'); % ensure that scale/formula symbols are displayed normally
% 
%%% 8. Save high-resolution images
%print(gcf, imgFilePath, '-dpng', '-r300'); % 300dpi HD PNG
%% Vector diagram (journal submission):
% % print(gcf, fullfile(outputDir, sprintf('K1_%d_K2_%d_N%d_GKappa_Fit_Curve.eps', K1, K2, N)), '-depsc', '-r300');
%% Function: Save the GKappa fitting curve as a journal-level SVG vector image (resolution 300dpi)
%% Input parameters: N (number of small-scale categories), M (number of large-scale categories), n (sequence length), outputDir (output path)
% print(gcf, fullfile(outputDir, sprintf('K1_%d_K2_%d_N%d_GKappa_Fit_Curve.svg',K1, K2, N)), '-dsvg', '-r300');
% 
%% English prompt information (optional, keep the same language style as the picture)
% disp(['Fitted curve image saved to: ', imgFilePath]);
% disp(['All operations completed! (K1=', num2str(K1), ', K2=', num2str(K2), ')']);