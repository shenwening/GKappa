addpath("../utils/")
addpath("../metrics/")
%%% 1. Environment initialization and path configuration
%clear; clc; close all; % clear variables/command line/close old figures to avoid interference
%addpath("utils\"); % Add tool function path
%addpath("D:\matlibprojects\tmpOC_new"); % Add custom function path
% 
%%% 2. Core parameter settings (key modifications: N from 10 to 1000, K fixed to 20, number of iterations fixed)
%K = 10; % number of categories (fixed)
%fixed_iter = 20; % fixed number of repetitions (customizable, such as 10/50/100)
%N_vec = 10:1000; % sample/sequence length: from 10 to 1000 (core modification)
%metricName = {'GKappa'}; % unique metric: GKappa
%outputDir = 'data/kn/data/'; % output directory
% 
%% Output path adaptation N range (10-1000), fixed K=20 and fixed number of iterations
% outputFilePath = fullfile(outputDir, sprintf('K%d_N10-1000_Iter%d_GKappa_Results.xlsx', K, fixed_iter)); 
% imgFilePath = fullfile(outputDir, sprintf('K%d_N10-1000_Iter%d_GKappa_Fit_Curve.png', K, fixed_iter)); 
%bool_first = true; % Whether to write to Excel for the first time (overwrite mode)
% 
%% Create the output directory (to avoid errors if the path does not exist)
% if ~exist(outputDir, 'dir')
%     mkdir(outputDir);
% end
% 
%%% 3. Calculate the mean GKappa value when N=10 to 1000 (fixed number of iterations)
%gk_mean = zeros(length(N_vec), 1); % stores the GKappa mean (column vector) of each N value
%max_N = max(N_vec); % Dynamically obtain the maximum value of N (1000) to avoid hard coding
% for idx = 1:length(N_vec)
%curr_N = N_vec(idx); % current sequence length N
%gk_sum = 0; % initialize accumulated value
% 
%% Inner loop: Calculate GKappa cumulative value a fixed number of times
%     for i = 1:fixed_iter
%% Generate 2 sets of random sequences (adapted to the current N value)
%         a = generateSequence(1, K, curr_N);
%         b = generateSequence(1, K, curr_N);
%% Calculate GKappa (parameter adaptation to current N value)
%         gk_val = MS_GK(a, b, 1, K, 1, K);
%         gk_sum = gk_sum + gk_val;
%     end
% 
%% Calculate the mean under the current N value and store it
%     gk_mean(idx) = gk_sum / fixed_iter;
% 
%% Printing progress of every 50 N values ​​(10-1000, 991 values ​​in total, reducing screen refresh)
%     if mod(idx, 50) == 0
%progress_pct = round(idx/length(N_vec)*100, 1); % keep 1 decimal place
%disp(['Current progress: N=', num2str(curr_N), '/', num2str(max_N), ' | Completed', num2str(progress_pct), '%']);
%     end
% end
% 
%abs_gk_mean = abs(gk_mean); % Extract the absolute value (column vector: 991×1, 10-1000, a total of 991 N values)
%disp(['N=10 to', num2str(max_N), ', fixed', num2str(fixed_iter), 'The GKappa mean calculation of repeated repetitions is completed!']);
% 
%%% 4. Write to Excel file (save the results of all N values)
% if bool_first
%writecell([{'sequence lengthN'}, metricName], outputFilePath, 'WriteMode', 'overwrite'); % header: N + GKappa
% end
%% Write N values ​​(column vector) + mean (column vector)
% writematrix([N_vec', gk_mean], outputFilePath, 'Range', 'A2'); 
%disp(['Key data has been saved to: ', outputFilePath]);
% 
%%% 5. Nonlinear fitting (exponential decay model: y = a*exp(-b*x) + c, x is the N value)
%% Model description: a=initial value, b=attenuation coefficient, c=convergence benchmark (approaching 0)
% fitModel = @(params, x) params(1) .* exp(-params(2)*x) + params(3);
%initialGuess = [max(abs_gk_mean), 0.001, 0]; % initial guess (N range is large, b is adjusted small)
% 
%% Fitting input dimension alignment (N_vec converted to column vector)
%N_col = N_vec'; % column vector (991×1)
%% Nonlinear least squares fitting
% nlm = fitnlm(N_col, abs_gk_mean, fitModel, initialGuess);
% 
%% Extract fitting parameters
% fitParams = nlm.Coefficients.Estimate;
%a_fit = fitParams(1); % initial amplitude
%b_fit = fitParams(2); % attenuation coefficient
%c_fit = fitParams(3); % convergence benchmark
% 
%% Generate the y value of the fitted curve (dimensional alignment: column vector)
%y_fit = (a_fit * exp(-b_fit * N_vec) + c_fit)'; % Calculate the row vector first and transpose it into a column vector
%% Eliminate abnormal negative numbers of the fitted value (the absolute value cannot be negative)
% y_fit(y_fit < 0) = 0;
% 
%disp('Fitting parameters:');
%disp(['Initial amplitude a = ', num2str(a_fit)]);
%disp(['attenuation coefficient b = ', num2str(b_fit)]);
%disp(['Convergence benchmark c = ', num2str(c_fit)]);
% 
%%% 6. Draw the fitting curve + original data (x-axis is N value, 10 to 1000)
%figure('Position', [100, 100, 1000, 600]); % widen the figure window (fit the X-axis of 1000)
% hold on; grid on; box on;
% 
%% 1. Draw the original data (light gray, thin lines, as reference)
% plot(N_vec, abs_gk_mean, 'Color', [0.7,0.7,0.7], 'LineWidth', 1, 'DisplayName', 'Original data'); 
%% 2. Draw the fitting curve (dark blue, bold, core display)
% plot(N_vec, y_fit, 'Color', [0.1,0.4,0.7], 'LineWidth', 2.5, 'DisplayName', 'Fitted curve'); 
% 
%%% 7. Chart beautification (adapt N value to x-axis, display in full English)
%% Global font settings (English is preferred, Arial font is more suitable)
% set(0, 'DefaultAxesFontName', 'Arial');
% set(0, 'DefaultTextFontName', 'Arial');
% set(0, 'DefaultUicontrolFontName', 'Arial');
% 
%% X-axis settings (logarithmic scale, amplify low N range, adapt to span 10-1000)
%xlabel('Sequence length (N)', 'FontSize', 25, 'FontWeight', 'bold'); % X-axis: sequence length N
%set(gca, 'XScale', 'log'); % logarithmic scale (adapted to the span of 10-1000)
%% Automatically generate logarithmic scale (key: adapt 10-1000)
%xticks_auto = logspace(log10(min(N_vec)), log10(max_N), 5); % 5 logarithmic equally spaced ticks
%xticks_auto = round(xticks_auto); % rounding
% xticks(xticks_auto);
%xticklabels(cellstr(num2str(xticks_auto'))); % Convert to string label
% 
%% Y-axis settings (forced to start from 0, strengthen convergence vision)
% y_min = 0;
%y_max = max([abs_gk_mean; y_fit]) * 1.1; % covers the maximum value of the original + fitted data
% ylim([y_min, y_max]);
% ylabel(sprintf('Absolute value of GKappa mean '), ...
%'FontSize', 20, 'FontWeight', 'bold'); % Y-axis: GKappa mean absolute value of a fixed number of times
% 
%% title (including N range 10-1000, fixed K=20, fixed number of iterations, fitting model)
% % title(sprintf('Exponential convergence fitting of |GKappa| with sequence length N (K=%d, 10-%d, %d repeats) \n (y=%.3f·e^{-%.5f·x}+%.3f)', ...
%               % K, max_N, fixed_iter, a_fit, b_fit, c_fit), 'FontSize', 15, 'FontWeight', 'bold'); 
% 
% title(sprintf('GKappa Convergence (R=%d, n=10-%d,Rn=%d) \n y=%.3f·e^{-%.5f·x}+%.3f', ...
%               K, max_N, fixed_iter, a_fit, b_fit, c_fit), 'FontSize', 15, 'FontWeight', 'bold');
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
%% Vector image (journal submission, suitable for N range):
% % print(gcf, fullfile(outputDir, sprintf('K%d_N10-%d_Iter%d_GKappa_Fit_Curve.eps', K, max_N, fixed_iter)), '-depsc', '-r300');
% 
%% English prompt information
% disp(['Fitted curve image saved to: ', imgFilePath]);
% disp('All operations completed!'); 


%%% 1. Environment initialization and path configuration
clear; clc; close all; %Clear variables/command line/close old figures to avoid interference
addpath("utils\");     %Add tool function path
addpath("D:\matlibprojects\tmpOC_new"); %Add custom function path

%% 2. Core parameter settings (key: split K into K1/K2, N from 10 to 1000, fixed number of iterations)
K1_fixed = 5;               %Number of categories in a sequence (fixed value, customizable such as 15/30)
K2_fixed = 10;               %The number of categories of b sequence (fixed value, customizable such as 20/40, supports K1≠K2)
fixed_iter = 20;             %Fixed number of repetitions
N_vec = 10:1000;             %Sample/sequence length: from 10 to 1000
metricName = {'GKappa'};     %Unique indicator: GKappa
outputDir = 'data/kn/datak';      %Output directory

%Output path adaptation: reflects K1/K2, N range, number of iterations
outputFilePath = fullfile(outputDir, sprintf('K1_%d_K2_%d_N10-1000_Iter%d_GKappa_Results.xlsx', K1_fixed, K2_fixed, fixed_iter)); 
imgFilePath = fullfile(outputDir, sprintf('K1_%d_K2_%d_N10-1000_Iter%d_GKappa_Fit_Curve.png', K1_fixed, K2_fixed, fixed_iter)); 
bool_first = true;           %Whether to write to Excel for the first time (overwrite mode)

%Create an output directory (to avoid errors if the path does not exist)
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

%% 3. Calculate the mean GKappa when N=10 to 1000 (K1/K2 is fixed, fixed number of iterations)
gk_mean = zeros(length(N_vec), 1); %Store the GKappa mean for each N value (column vector)
max_N = max(N_vec); %Dynamically obtain the maximum value of N (1000) to avoid hard coding
for idx = 1:length(N_vec)
    curr_N = N_vec(idx);  %Current sequence length N
    gk_sum = 0;           %Initialize accumulated value

    %Inner loop: Calculate GKappa cumulative value a fixed number of times
    for i = 1:fixed_iter
        %Generate 2 sets of random sequences: K1 for a, K2 for b, and the sequence length adapts to the current N
        a = generateSequence(1, K1_fixed, curr_N); %a sequence: number of categories K1, length curr_N
        b = generateSequence(1, K2_fixed, curr_N); %b sequence: number of categories K2, length curr_N

        %Calculate GKappa: fit K1 of a and K2 of b (core modification)
        gk_val = MS_GK(a, b, 1, K1_fixed, 1, K2_fixed);
        gk_sum = gk_sum + gk_val;
    end

    %Calculate the mean under the current N value and store it
    gk_mean(idx) = gk_sum / fixed_iter;

    %Printing progress of every 50 N values ​​(10-1000, 991 values ​​in total, reducing screen refresh)
    if mod(idx, 50) == 0
        progress_pct = round(idx/length(N_vec)*100, 1); %Keep 1 decimal place
        disp(['当前进度: N=', num2str(curr_N), '/', num2str(max_N), ' | K1=', num2str(K1_fixed), ', K2=', num2str(K2_fixed), ' | 已完成', num2str(progress_pct), '%']);
    end
end

abs_gk_mean = abs(gk_mean); %Extract absolute values ​​(column vector: 991×1, 991 N values ​​in total from 10-1000)
disp(['N=10到', num2str(max_N), '、K1=', num2str(K1_fixed), ', K2=', num2str(K2_fixed), '、固定', num2str(fixed_iter), '次重复的GKappa均值计算完成！']);

%% 4. Write to Excel file (save K1/K2, N, GKappa mean)
if bool_first
    %Header: Add columns K1/K2 to clarify the meaning
    writecell([{'固定类别数K1'}, {'固定类别数K2'}, {'序列长度N'}, metricName], outputFilePath, 'WriteMode', 'overwrite'); 
    %Write a fixed value of K1/K2 (the entire column is filled, consistent with the length of N)
    writematrix(repmat(K1_fixed, length(N_vec), 1), outputFilePath, 'Range', 'A2');
    writematrix(repmat(K2_fixed, length(N_vec), 1), outputFilePath, 'Range', 'B2');
end
%Write N values ​​(column vector) + mean (column vector)
writematrix([N_vec', gk_mean], outputFilePath, 'Range', 'C2'); 
disp(['关键数据已保存至: ', outputFilePath]);

%% 5. Nonlinear fitting (exponential decay model: y = a*exp(-b*x) + c, x is the N value)
%Model description: a=initial value, b=attenuation coefficient, c=convergence benchmark (approaching 0)
fitModel = @(params, x) params(1) .* exp(-params(2)*x) + params(3);
initialGuess = [max(abs_gk_mean), 0.001, 0]; %Initial guess (N range is large, b key is small)

%Fitting input dimension alignment (N_vec converted to column vector)
N_col = N_vec'; %Column vector (991×1)
%Nonlinear least squares fitting
nlm = fitnlm(N_col, abs_gk_mean, fitModel, initialGuess);

%Extract fitting parameters
fitParams = nlm.Coefficients.Estimate;
a_fit = fitParams(1); %initial amplitude
b_fit = fitParams(2); %Attenuation coefficient
c_fit = fitParams(3); %Convergence benchmark

%Generate y values ​​for the fitted curve (dimensional alignment: column vector)
y_fit = (a_fit * exp(-b_fit * N_vec) + c_fit)'; %First calculate the row vector and transpose it into a column vector
%Eliminate abnormal negative numbers of the fitted value (the absolute value cannot be negative)
y_fit(y_fit < 0) = 0;

disp('拟合参数：');
disp(['初始幅值 a = ', num2str(a_fit)]);
disp(['衰减系数 b = ', num2str(b_fit)]);
disp(['收敛基准 c = ', num2str(c_fit)]);

%% 6. Draw the fitting curve + original data (x-axis is N value, 10 to 1000)
figure('Position', [100, 100, 1000, 600]); %Widen the figure window (to fit the X-axis of 1000)
hold on; grid on; box on;

%1. Draw the original data (light gray, thin lines, as reference)
plot(N_vec, abs_gk_mean, 'Color', [0.7,0.7,0.7], 'LineWidth', 1, 'DisplayName', 'Original data'); 
%2. Draw the fitting curve (dark blue, bold, core display)
plot(N_vec, y_fit, 'Color', [0.1,0.4,0.7], 'LineWidth', 2.5, 'DisplayName', 'Fitted curve'); 

%% 7. Chart beautification (adapt N value to x-axis, mark K1/K2, display in full English)
%Global font settings (English is preferred, Arial font is more suitable)
set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');
set(0, 'DefaultUicontrolFontName', 'Arial');

%X-axis settings (logarithmic scale, amplify low N range, adapt to span 10-1000)
xlabel('Sequence length (N)', 'FontSize', 25, 'FontWeight', 'bold'); %X-axis: sequence length N
set(gca, 'XScale', 'log'); %Logarithmic scale (adapts to the span of 10-1000)
%Automatically generate logarithmic scale (key: adapt 10-1000)
xticks_auto = logspace(log10(min(N_vec)), log10(max_N), 5); %5 logarithmic equally spaced scales
xticks_auto = round(xticks_auto); %Round
xticks(xticks_auto);
xticklabels(cellstr(num2str(xticks_auto'))); %Convert to string label

%Y-axis settings (forced to start from 0, strengthen convergence vision)
y_min = 0;
y_max = max([abs_gk_mean; y_fit]) * 1.1; %Override the maximum value of the original + fitted data
ylim([y_min, y_max]);
ylabel(sprintf('Absolute value of GKappa mean '), ...
       'FontSize', 20, 'FontWeight', 'bold'); %Y-axis: GKappa mean absolute value for a fixed number of times

%Title (including K1/K2, N range, number of iterations, fitting model)
% title(sprintf('Exponential convergence fitting of |GKappa| with sequence length N (K1=%d, K2=%d, 10-%d, %d repeats) \n (y=%.3f·e^{-%.5f·x}+%.3f)', ...
%               K1_fixed, K2_fixed, max_N, fixed_iter, a_fit, b_fit, c_fit), 'FontSize', 13, 'FontWeight', 'bold'); 

title(sprintf('GKappa convergence (N=%d, M=%d, 10-%d, Rn=%d ) \n (y=%.3f·e^{-%.5f·x}+%.3f)', ...
  K1_fixed, K2_fixed, max_N, fixed_iter, a_fit, b_fit, c_fit), 'FontSize', 15, 'FontWeight', 'bold'); 
%Legend settings (English)
legend('Location', 'best', 'FontSize', 20); 
%Coordinate axis + grid optimization
set(gca, 'FontSize', 20);
set(gca, 'GridAlpha', 0.2); %Reduce mesh transparency
set(gca, 'Box', 'on');
set(gca, 'TickLabelInterpreter', 'none'); %Make sure scale/formula symbols are displayed properly

%% 8. Save high-resolution images
print(gcf, imgFilePath, '-dpng', '-r300'); %300dpi HD PNG
%Vector image (journal submission, suitable for N range):
% print(gcf, fullfile(outputDir, sprintf('K1_%d_K2_%d_N10-%d_Iter%d_GKappa_Fit_Curve.eps', K1_fixed, K2_fixed, max_N, fixed_iter)), '-depsc', '-r300');

%English prompt information
disp(['Fitted curve image saved to: ', imgFilePath]);
disp(['All operations completed! (K1=', num2str(K1_fixed), ', K2=', num2str(K2_fixed), ')']);












%clear; clc; close all; % clear variables/command line/close old figures to avoid interference
%addpath("utils\"); % Add tool function path
%addpath("D:\matlibprojects\tmpOC_new"); % Add custom function path
% 
%%% 2. Core parameter settings (only need to modify N_vec, the rest will be automatically adapted!)
%K1_fixed = 5; % the number of categories of a sequence (fixed value)
%K2_fixed = 15; % number of categories of b sequence (fixed value)
%fixed_iter = 10; % fixed number of repetitions
%N_vec = 10:1000; % The N range can be modified arbitrarily (such as 20:500/5:200), and the rest will be automatically adapted
%metricName = {'GKappa'}; % unique metric: GKappa
%outputDir = 'data/kn/data/'; % output directory
% 
%% ========== Core: Automatically identify the range of N (no need to change it manually!) ==========
%min_N = min(N_vec); % automatically obtain the starting value of N
%max_N = max(N_vec); % automatically obtain the end value of N
% 
%% Output path adaptation: automatically embed the actual range of N (replacing the hard-coded 10-1000)
% outputFilePath = fullfile(outputDir, sprintf('K1_%d_K2_%d_N%d-%d_Iter%d_GKappa_Results.xlsx', ...
%     K1_fixed, K2_fixed, min_N, max_N, fixed_iter)); 
% imgFilePath = fullfile(outputDir, sprintf('K1_%d_K2_%d_N%d-%d_Iter%d_GKappa_Fit_Curve.png', ...
%     K1_fixed, K2_fixed, min_N, max_N, fixed_iter)); 
%bool_first = true; % Whether to write to Excel for the first time (overwrite mode)
% 
%% Create the output directory (to avoid errors if the path does not exist)
% if ~exist(outputDir, 'dir')
%     mkdir(outputDir);
% end
% 
%%% 3. Calculate the mean GKappa within the N range (K1/K2 is fixed, fixed number of iterations)
%gk_mean = zeros(length(N_vec), 1); % stores the GKappa mean (column vector) of each N value
% for idx = 1:length(N_vec)
%curr_N = N_vec(idx); % current sequence length N
%gk_sum = 0; % initialize accumulated value
% 
%% Inner loop: Calculate GKappa cumulative value a fixed number of times
%     for i = 1:fixed_iter
%% Generate 2 sets of random sequences: a uses K1, b uses K2, and the sequence length adapts to the current N
%a = generateSequence(1, K1_fixed, curr_N); % a sequence: number of categories K1, length curr_N
%b = generateSequence(1, K2_fixed, curr_N); % b sequence: number of categories K2, length curr_N
% 
%% Calculate GKappa: adapt K1 of a and K2 of b
%         gk_val = MS_GK(a, b, 1, K1_fixed, 1, K2_fixed);
%         gk_sum = gk_sum + gk_val;
%     end
% 
%% Calculate the mean under the current N value and store it
%     gk_mean(idx) = gk_sum / fixed_iter;
% 
%% Printing progress of every 50 N values ​​(automatically adapt to the total length of N, no hard coding)
%     if mod(idx, 50) == 0
%progress_pct = round(idx/length(N_vec)*100, 1); % keep 1 decimal place
%disp(['Current progress: N=', num2str(curr_N), '/', num2str(max_N), ...
%             ' | K1=', num2str(K1_fixed), ', K2=', num2str(K2_fixed), ...
%' | Completed', num2str(progress_pct), '%']);
%     end
% end
% 
%abs_gk_mean = abs(gk_mean); % extract absolute value
%% Completion tip: automatically display the actual range of N (replacing the hard-coded 10)
%disp(['N=', num2str(min_N), 'to', num2str(max_N), ', K1=', num2str(K1_fixed), ', K2=', num2str(K2_fixed), ...
%', fixed', num2str(fixed_iter), 'The calculation of the GKappa mean of repeated repetitions is completed!']);
% 
%%% 4. Write to Excel file (save K1/K2, N, GKappa mean)
% if bool_first
%% Header: add columns K1/K2 to clarify the meaning
%writecell([{'Fixed number of categories K1'}, {'Fixed number of categories K2'}, {'Sequence length N'}, metricName], ...
%         outputFilePath, 'WriteMode', 'overwrite'); 
%% Write K1/K2 fixed value (fill the entire column, consistent with N length)
%     writematrix(repmat(K1_fixed, length(N_vec), 1), outputFilePath, 'Range', 'A2');
%     writematrix(repmat(K2_fixed, length(N_vec), 1), outputFilePath, 'Range', 'B2');
% end
%% Write N values ​​(column vector) + mean (column vector)
% writematrix([N_vec', gk_mean], outputFilePath, 'Range', 'C2'); 
%disp(['Key data has been saved to: ', outputFilePath]);
% 
%%% 5. Nonlinear fitting (exponential decay model: y = a*exp(-b*x) + c, x is the N value)
%% Model description: a=initial value, b=attenuation coefficient, c=convergence benchmark (approaching 0)
% fitModel = @(params, x) params(1) .* exp(-params(2)*x) + params(3);
%initialGuess = [max(abs_gk_mean), 0.001, 0]; % initial guess (automatically adapt to N range)
% 
%% Fitting input dimension alignment (N_vec converted to column vector)
%N_col = N_vec'; % column vector
%% Nonlinear least squares fitting
% nlm = fitnlm(N_col, abs_gk_mean, fitModel, initialGuess);
% 
%% Extract fitting parameters
% fitParams = nlm.Coefficients.Estimate;
%a_fit = fitParams(1); % initial amplitude
%b_fit = fitParams(2); % attenuation coefficient
%c_fit = fitParams(3); % convergence benchmark
% 
%% Generate the y value of the fitted curve (dimensional alignment: column vector)
%y_fit = (a_fit * exp(-b_fit * N_vec) + c_fit)'; % Calculate the row vector first and transpose it into a column vector
%% Eliminate abnormal negative numbers of the fitted value (the absolute value cannot be negative)
% y_fit(y_fit < 0) = 0;
% 
%disp('Fitting parameters:');
%disp(['Initial amplitude a = ', num2str(a_fit)]);
%disp(['attenuation coefficient b = ', num2str(b_fit)]);
%disp(['Convergence benchmark c = ', num2str(c_fit)]);
% 
%%% 6. Draw the fitting curve + original data (the x-axis is the N value, automatic adaptation range)
%figure('Position', [100, 100, 1000, 600]); % widen the figure window
% hold on; grid on; box on;
% 
%% 1. Draw the original data (light gray, thin lines, as reference)
% plot(N_vec, abs_gk_mean, 'Color', [0.7,0.7,0.7], 'LineWidth', 1, 'DisplayName', 'Original data'); 
%% 2. Draw the fitting curve (dark blue, bold, core display)
% plot(N_vec, y_fit, 'Color', [0.1,0.4,0.7], 'LineWidth', 2.5, 'DisplayName', 'Fitted curve'); 
% 
%%% 7. Chart beautification (fully automated adaptation to N range, no hard coding)
%% Global font settings (English is preferred, Arial font is more suitable)
% set(0, 'DefaultAxesFontName', 'Arial');
% set(0, 'DefaultTextFontName', 'Arial');
% set(0, 'DefaultUicontrolFontName', 'Arial');
% 
%% X-axis settings (logarithmic scale, automatically adapt to the actual range of N)
%xlabel('Sequence length (N)', 'FontSize', 25, 'FontWeight', 'bold'); % X-axis: sequence length N
%set(gca, 'XScale', 'log'); % Logarithmic scale adaptation to N span
%% Automatically generate a logarithmic scale (fully adapted to the min/max of N)
%xticks_auto = logspace(log10(min_N), log10(max_N), 5); % 5 logarithmic equally spaced ticks
%xticks_auto = round(xticks_auto); % rounding
% xticks(xticks_auto);
%xticklabels(cellstr(num2str(xticks_auto'))); % Convert to string label
% 
%% Y-axis settings (forced to start from 0, strengthen convergence vision)
% y_min = 0;
%y_max = max([abs_gk_mean; y_fit]) * 1.1; % covers the maximum value of the original + fitted data
% ylim([y_min, y_max]);
% ylabel(sprintf('Absolute value of GKappa mean (%d repeats)', fixed_iter), ...
%'FontSize', 14, 'FontWeight', 'bold'); % Y-axis: GKappa mean absolute value of a fixed number of times
% 
%% header: automatically embed the actual range of N (replaces the hardcoded 10-%d)
% title(sprintf('Exponential convergence fitting of |GKappa| with sequence length N (K1=%d, K2=%d, %d-%d, %d repeats) \n (y=%.3f·e^{-%.5f·x}+%.3f)', ...
%               K1_fixed, K2_fixed, min_N, max_N, fixed_iter, a_fit, b_fit, c_fit), ...
%       'FontSize', 13, 'FontWeight', 'bold'); 
% 
%% Legend settings (English)
% legend('Location', 'best', 'FontSize', 12); 
%% Coordinate axis + grid optimization
% set(gca, 'FontSize', 12);
%set(gca, 'GridAlpha', 0.2); % Reduce grid transparency
% set(gca, 'Box', 'on');
%set(gca, 'TickLabelInterpreter', 'none'); % ensure that scale/formula symbols are displayed normally
% 
%%% 8. Save high-resolution images (the file name automatically adapts to the N range)
%print(gcf, imgFilePath, '-dpng', '-r300'); % 300dpi HD PNG
%% Vector image (journal submission, automatically adapting to N range):
% % print(gcf, fullfile(outputDir, sprintf('K1_%d_K2_%d_N%d-%d_Iter%d_GKappa_Fit_Curve.eps', ...
% %     K1_fixed, K2_fixed, min_N, max_N, fixed_iter)), '-depsc', '-r300');
% 
%% Final tip: Supplement N range information to facilitate traceability
% disp(['Fitted curve image saved to: ', imgFilePath]);
% disp(['All operations completed! (K1=', num2str(K1_fixed), ', K2=', num2str(K2_fixed), ', N=', min_N, '-', max_N, ')']);
% 
% disp("$A_1$")