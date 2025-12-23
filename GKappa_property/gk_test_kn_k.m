addpath("../utils/")
addpath("../metrics/")

%%% 1. Environment initialization and path configuration
%clear; clc; close all; % clear variables/command line/close old figures to avoid interference
%addpath("utils\"); % Add tool function path
%addpath("D:\matlibprojects\tmpOC_new"); % Add custom function path
% 
%%% 2. Core parameter settings (key modification: K is variable 3-200, the number of repetitions is fixed at 10 times)
%K_vec = 3:200; % K increases from 3 to 200 (variable sequence)
%fixed_iter = 20; % fixed number of repetitions: 10 times
%N = 50; % sample/sequence length (remains the same)
%metricName = {'GKappa'}; % unique metric: GKappa
%outputDir = 'data/kn/data/'; % output directory
% 
%% The output path is adapted to the K range (3-200) and fixed to 10 repetitions
% outputFilePath = fullfile(outputDir, sprintf('K3-200_N=2K_Iter%d_GKappa_Results.xlsx', fixed_iter)); 
% imgFilePath = fullfile(outputDir, sprintf('K3-200_N=2K_Iter%d_GKappa_Fit_Curve.png', fixed_iter)); 
%bool_first = true; % Whether to write to Excel for the first time (overwrite mode)
% 
%% Create the output directory (to avoid errors if the path does not exist)
% if ~exist(outputDir, 'dir')
%     mkdir(outputDir);
% end
% 
%%% 3. Calculate the mean GKappa when K=3 to 200 (fixed 10 repetitions)
%gk_mean = zeros(length(K_vec), 1); % stores the GKappa mean (column vector) of each K value
% for idx = 1:length(K_vec)
%curr_K = K_vec(idx); % current K value (number of categories)
%gk_sum = 0; % initialize accumulated value
% 
%% Inner loop: Fixed 10 repeated calculations of GKappa
%     for i = 1:fixed_iter
%% Generate 2 sets of random sequences (adapted to the current K value)
%         % a = generateSequence(1, curr_K, N);
%         % b = generateSequence(1, curr_K, N);
%         a = generateSequence(1, curr_K, curr_K);
%         b = generateSequence(1, curr_K, curr_K);
%% Calculate GKappa (parameter adaptation to current K value)
%         gk_val = MS_GK(a, b, 1, curr_K, 1, curr_K);
%         gk_sum = gk_sum + gk_val;
%     end
% 
%% Calculate the mean under the current K value and store it
%     gk_mean(idx) = gk_sum / fixed_iter;
% 
%% Printing progress every 20 K values ​​(monitoring the cycle of 3-200)
%     if mod(idx, 20) == 0
%disp(['Current progress: K=', num2str(curr_K), '/200 | Completed', num2str(idx/length(K_vec)*100), '%']);
%     end
% end
% 
%abs_gk_mean = abs(gk_mean); % Extract the absolute value (column vector: 198×1, 3-200, 198 K values ​​in total)
%disp('K=3 to 200, GKappa mean calculation for fixed 10 repetitions is completed!');
% 
%%% 4. Write to Excel file (save the results of all K values)
% if bool_first
%writecell([{'number of categories K'}, metricName], outputFilePath, 'WriteMode', 'overwrite'); % header: K + GKappa
% end
%% Write K value (column vector) + mean (column vector)
% writematrix([K_vec', gk_mean], outputFilePath, 'Range', 'A2'); 
%disp(['Key data has been saved to: ', outputFilePath]);
% 
%%% 5. Nonlinear fitting (exponential decay model: y = a*exp(-b*x) + c, x is the K value)
%% Model description: a=initial value, b=attenuation coefficient, c=convergence basis
% fitModel = @(params, x) params(1) .* exp(-params(2)*x) + params(3);
%initialGuess = [max(abs_gk_mean), 0.005, 0]; % initial guess: a=maximum value, b=0.005, c=0
% 
%% Fitting input dimension alignment (K_vec converted to column vector)
%K_col = K_vec'; % column vector (198×1)
%% Nonlinear least squares fitting
% nlm = fitnlm(K_col, abs_gk_mean, fitModel, initialGuess);
% 
%% Extract fitting parameters
% fitParams = nlm.Coefficients.Estimate;
%a_fit = fitParams(1); % initial amplitude
%b_fit = fitParams(2); % attenuation coefficient
%c_fit = fitParams(3); % convergence benchmark
% 
%% Generate the y value of the fitted curve (dimensional alignment: column vector)
%y_fit = (a_fit * exp(-b_fit * K_vec) + c_fit)'; % Calculate the row vector first and transpose it into a column vector
%% Eliminate abnormal negative numbers of the fitted value (the absolute value cannot be negative)
% y_fit(y_fit < 0) = 0;
% 
%disp('Fitting parameters:');
%disp(['Initial amplitude a = ', num2str(a_fit)]);
%disp(['attenuation coefficient b = ', num2str(b_fit)]);
%disp(['Convergence benchmark c = ', num2str(c_fit)]);
% 
%%% 6. Draw the fitting curve + original data (x-axis is K value, 3 to 200)
%figure('Position', [100, 100, 900, 600]); % Enlarge the figure window to improve readability
% hold on; grid on; box on;
% 
%% 1. Draw the original data (light gray, thin lines, as reference)
% plot(K_vec, abs_gk_mean, 'Color', [0.7,0.7,0.7], 'LineWidth', 1, 'DisplayName', 'Original data'); 
%% 2. Draw the fitting curve (dark blue, bold, core display)
% plot(K_vec, y_fit, 'Color', [0.1,0.4,0.7], 'LineWidth', 2.5, 'DisplayName', 'Fitted curve'); 
% 
%%% 7. Chart beautification (Adapt K value to x-axis, display in full English)
%% Global font settings (English is preferred, Arial font is more suitable)
% set(0, 'DefaultAxesFontName', 'Arial');
% set(0, 'DefaultTextFontName', 'Arial');
% set(0, 'DefaultUicontrolFontName', 'Arial');
% 
%% X-axis settings (linear scale, K from 3 to 200)
%xlabel('Number of categories (R)', 'FontSize', 25, 'FontWeight', 'bold'); % X-axis: Number of categories K
%xticks([3,50,100,150,200]); % key ticks
%xticklabels({'3','50','100','150','200'}); % numbers reserved
% 
%% Y-axis settings (forced to start from 0, strengthen convergence vision)
% y_min = 0;
%y_max = max([abs_gk_mean; y_fit]) * 1.1; % covers the maximum value of the original + fitted data
% ylim([y_min, y_max]);
%ylabel('Absolute value of GKappa mean ', 'FontSize', 20, 'FontWeight', 'bold'); % Y-axis: Absolute value of GKappa mean for 10 repetitions
% 
%% title (including K range, fixed 10 repetitions, fitting model)
% % title(sprintf('Exponential convergence fitting of |GKappa| with K (3-200, N=2K, %d repeats) \n (y=%.3f·e^{-%.5f·x}+%.3f)', ...
% %               fixed_iter, a_fit, b_fit, c_fit), 'FontSize', 13, 'FontWeight', 'bold'); 
% 
% % title(sprintf('Exponential convergence fitting of |GKappa| with K (3-200, N=2K, %d repeats) \n (y=%.3f·e^{-%.5f·x}+%.3f)', ...
% %               fixed_iter, a_fit, b_fit, c_fit), 'FontSize', 15, 'FontWeight', 'bold'); 
% 
% title(sprintf('GKappa Convergence (R=3-200, n=2R, Rn=%d ) \n y=%.3f·e^{-%.5f·x}+%.3f', ...
%               fixed_iter, a_fit, b_fit, c_fit), 'FontSize', 15, 'FontWeight', 'bold');
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
% % print(gcf, fullfile(outputDir, sprintf('K3-200_N%d_Iter10_GKappa_Fit_Curve.eps', N)), '-depsc', '-r300');
% 
%% English prompt information
% disp(['Fitted curve image saved to: ', imgFilePath]);
% disp('All operations completed!'); 


%% --------------------------increase to 1000 times
% 
%%% 1. Environment initialization and path configuration
%clear; clc; close all; % clear variables/command line/close old figures to avoid interference
%addpath("utils\"); % Add tool function path
%addpath("D:\matlibprojects\tmpOC_new"); % Add custom function path
% 
%%% 2. Core parameter settings (key modification: K range changed to 3-1000, number of repetitions fixed at 10 times)
%K_vec = 3:1000; % K increased from 3 to 1000 (variable sequence, core modification)
%fixed_iter = 20; % fixed number of repetitions: 10 times
%N = 20; % sample/sequence length
%metricName = {'GKappa'}; % unique metric: GKappa
%outputDir = 'data/kn/'; % output directory
% 
%% The output path is adapted to the K range (3-1000) and fixed 10 repetitions (core modification: 200→1000)
% outputFilePath = fullfile(outputDir, sprintf('K3-1000_N%d_Iter10_GKappa_Results.xlsx', N)); 
% imgFilePath = fullfile(outputDir, sprintf('K3-1000_N%d_Iter10_GKappa_Fit_Curve.png', N)); 
%bool_first = true; % Whether to write to Excel for the first time (overwrite mode)
% 
%% Create the output directory (to avoid errors if the path does not exist)
% if ~exist(outputDir, 'dir')
%     mkdir(outputDir);
% end
% 
%%% 3. Calculate the mean GKappa when K=3 to 1000 (fixed 10 repetitions)
%gk_mean = zeros(length(K_vec), 1); % stores the GKappa mean (column vector) of each K value
%max_K = max(K_vec); % Dynamically obtain the maximum value of K (1000) to avoid hard coding
% for idx = 1:length(K_vec)
%curr_K = K_vec(idx); % current K value (number of categories)
%gk_sum = 0; % initialize accumulated value
% 
%% Inner loop: Fixed 10 repeated calculations of GKappa
%     for i = 1:fixed_iter
%% Generate 2 sets of random sequences (adapted to the current K value)
%         % a = generateSequence(1, curr_K, N);
%         % b = generateSequence(1, curr_K, N);
%         a = generateSequence(1, curr_K, curr_K*2);
%         b = generateSequence(1, curr_K, curr_K*2);
%% Calculate GKappa (parameter adaptation to current K value)
%         gk_val = MS_GK(a, b, 1, curr_K, 1, curr_K);
%         gk_sum = gk_sum + gk_val;
%     end
% 
%% Calculate the mean under the current K value and store it
%     gk_mean(idx) = gk_sum / fixed_iter;
% 
%% Printing progress every 50 K values ​​(3-1000, 998 K in total, every 50 is more efficient)
%     if mod(idx, 50) == 0
%progress_pct = round(idx/length(K_vec)*100, 1); % keep 1 decimal place
%disp(['Current progress: K=', num2str(curr_K), '/', num2str(max_K), ' | Completed', num2str(progress_pct), '%']);
%     end
% end
% 
%abs_gk_mean = abs(gk_mean); % Extract the absolute value (column vector: 998×1, 3-1000, 998 K values ​​in total)
%disp(['K=3 to', num2str(max_K), ', fixed', num2str(fixed_iter), 'The GKappa mean calculation of repeated repetitions is completed!']);
% 
%%% 4. Write to Excel file (save the results of all K values)
% if bool_first
%writecell([{'number of categories K'}, metricName], outputFilePath, 'WriteMode', 'overwrite'); % header: K + GKappa
% end
%% Write K value (column vector) + mean (column vector)
% writematrix([K_vec', gk_mean], outputFilePath, 'Range', 'A2'); 
%disp(['Key data has been saved to: ', outputFilePath]);
% 
%%% 5. Nonlinear fitting (exponential decay model: y = a*exp(-b*x) + c, x is the K value)
%% Model description: a=initial value, b=attenuation coefficient, c=convergence basis
% fitModel = @(params, x) params(1) .* exp(-params(2)*x) + params(3);
%initialGuess = [max(abs_gk_mean), 0.001, 0]; % adjust the initial guess (K range is larger, b is adjusted smaller)
% 
%% Fitting input dimension alignment (K_vec converted to column vector)
%K_col = K_vec'; % column vector (998×1)
%% Nonlinear least squares fitting
% nlm = fitnlm(K_col, abs_gk_mean, fitModel, initialGuess);
% 
%% Extract fitting parameters
% fitParams = nlm.Coefficients.Estimate;
%a_fit = fitParams(1); % initial amplitude
%b_fit = fitParams(2); % attenuation coefficient
%c_fit = fitParams(3); % convergence benchmark
% 
%% Generate the y value of the fitted curve (dimensional alignment: column vector)
%y_fit = (a_fit * exp(-b_fit * K_vec) + c_fit)'; % Calculate the row vector first and transpose it into a column vector
%% Eliminate abnormal negative numbers of the fitted value (the absolute value cannot be negative)
% y_fit(y_fit < 0) = 0;
% 
%disp('Fitting parameters:');
%disp(['Initial amplitude a = ', num2str(a_fit)]);
%disp(['attenuation coefficient b = ', num2str(b_fit)]);
%disp(['Convergence benchmark c = ', num2str(c_fit)]);
% 
%%% 6. Draw the fitting curve + original data (x-axis is K value, 3 to 1000)
%figure('Position', [100, 100, 1000, 600]); % widen the figure window (fit the X-axis of 1000)
% hold on; grid on; box on;
% 
%% 1. Draw the original data (light gray, thin lines, as reference)
% plot(K_vec, abs_gk_mean, 'Color', [0.7,0.7,0.7], 'LineWidth', 1, 'DisplayName', 'Original data'); 
%% 2. Draw the fitting curve (dark blue, bold, core display)
% plot(K_vec, y_fit, 'Color', [0.1,0.4,0.7], 'LineWidth', 2.5, 'DisplayName', 'Fitted curve'); 
% 
%%% 7. Chart beautification (Adapt K value to x-axis, display in full English)
%% Global font settings (English is preferred, Arial font is more suitable)
% set(0, 'DefaultAxesFontName', 'Arial');
% set(0, 'DefaultTextFontName', 'Arial');
% set(0, 'DefaultUicontrolFontName', 'Arial');
% 
%% X-axis settings: automatically adapt to the scale of 3-1000 (core optimization to avoid manual hard coding)
%xlabel('Number of categories (K)', 'FontSize', 14, 'FontWeight', 'bold'); % X-axis: Number of categories K
%num_ticks = 6; % number of custom ticks (adapted to the range of 1000, 6 is clearer)
%xticks_auto = linspace(min(K_vec), max_K, num_ticks); % generate equally spaced ticks
%xticks_auto = round(xticks_auto); % rounded to an integer (in line with the physical meaning of K)
% xticks(xticks_auto);
%xticklabels(cellstr(num2str(xticks_auto'))); % Convert to string label
% 
%% Y-axis settings (forced to start from 0, strengthen convergence vision)
% y_min = 0;
%y_max = max([abs_gk_mean; y_fit]) * 1.1; % covers the maximum value of the original + fitted data
% ylim([y_min, y_max]);
%ylabel('Absolute value of GKappa mean (10 repeats)', 'FontSize', 14, 'FontWeight', 'bold'); % Y-axis: Absolute value of GKappa mean (10 repeats)
% 
%% title (including K range 3-1000, fixed 10 repetitions, fitting model, core modification: 200→1000)
% title(sprintf('Exponential convergence fitting of |GKappa| with K (3-%d, N=%d, 10 repeats) \n (y=%.3f·e^{-%.5f·x}+%.3f)', ...
%               max_K, N, a_fit, b_fit, c_fit), 'FontSize', 13, 'FontWeight', 'bold'); 
% 
%% Legend settings (English)
% legend('Location', 'best', 'FontSize', 12); 
%% Coordinate axis + grid optimization
% set(gca, 'FontSize', 12);
%set(gca, 'GridAlpha', 0.2); % Reduce grid transparency
% set(gca, 'Box', 'on');
%set(gca, 'TickLabelInterpreter', 'none'); % ensure that scale/formula symbols are displayed normally
% 
%%% 8. Save high-resolution images
%print(gcf, imgFilePath, '-dpng', '-r300'); % 300dpi HD PNG
%% Vector image (journal submission, suitable for the K range of 3-1000):
% % print(gcf, fullfile(outputDir, sprintf('K3-%d_N%d_Iter10_GKappa_Fit_Curve.eps', max_K, N)), '-depsc', '-r300');
% 
%% English prompt information
% disp(['Fitted curve image saved to: ', imgFilePath]);
% disp('All operations completed!'); 

















%% 1. Environment initialization and path configuration
clear; clc; close all; %Clear variables/command line/close old figures to avoid interference
addpath("utils\");     %Add tool function path
addpath("D:\matlibprojects\tmpOC_new"); %Add custom function path

%% 2. Core parameter settings (key: K1 growth, K2 matching K1, fitting x=K1)
%========== Customized K1 growth rule (core fitting object, can be modified as needed) ==========
K1_vec = 3:200;               %K1 grows from 3 to 200 (step size 1, fitting x-axis object)
K2_vec = K1_vec + 10;         %K2 matches the growth of K1 (example: K2 is 10 larger than K1, the rules can be changed)
%K2_vec = K1_vec * 2; % Example 2: K2 is 2 times of K1
%K2_fixed = 50; K2_vec = repmat(K2_fixed,size(K1_vec)); % Example 3: K2 fixed
% ======================================================
fixed_iter = 20;             %Fixed number of repetitions
N_rule = 'K1';               %Sequence length rule: follow K1 (fitting core associated variables)
metricName = {'GKappa'};      %Unique indicator: GKappa
outputDir = 'data/kn/datak/'; %Output directory

%Verify that the lengths of K1/K2 are consistent (to avoid index errors)
if length(K1_vec) ~= length(K2_vec)
    error('K1增长序列与K2序列长度必须一致！请调整K1_vec/K2_vec的定义');
end
vec_len = length(K1_vec);     %total sequence length
min_K1 = min(K1_vec); max_K1 = max(K1_vec);
min_K2 = min(K2_vec); max_K2 = max(K2_vec);

%Output path: Mark K1 growth characteristics (core fitting object)
outputFilePath = fullfile(outputDir, sprintf('K1_%d-%d_K2_%d-%d_Iter%d_GKappa_Results.xlsx', ...
    min_K1, max_K1, min_K2, max_K2, fixed_iter)); 
imgFilePath = fullfile(outputDir, sprintf('K1_%d-%d_K2_%d-%d_Iter%d_GKappa_Fit_Curve.png', ...
    min_K1, max_K1, min_K2, max_K2, fixed_iter)); 
bool_first = true;            %Whether to write to Excel for the first time (overwrite mode)

%Create an output directory (to avoid errors if the path does not exist)
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

%% 3. Calculate the mean GKappa value during the growth of K1 (with K1 as the core variable)
gk_mean = zeros(vec_len, 1);  %Store the GKappa mean (column vector) of each K1/K2 combination
for idx = 1:vec_len
    curr_K1 = K1_vec(idx);    %Current K1 value (core growth variable, fitted x-axis)
    curr_K2 = K2_vec(idx);    %Current K2 value (variable matching K1)
    gk_sum = 0;               %Initialize accumulated value

    %Inner loop: Calculate GKappa with fixed number of repetitions
    for i = 1:fixed_iter
        %Determine the sequence length N: follow the core variable K1 (make sure it is associated with the fitting object)
        if strcmp(N_rule, 'K1')
            curr_N = curr_K1;
        elseif strcmp(N_rule, 'K2')
            curr_N = curr_K2;
        else
            curr_N = curr_K1 * 2; %Follow K1 by default
        end

        %Generate 2 sets of random sequences: a uses the core variable K1, and b uses the matching variable K2
        a = generateSequence(1, curr_K1, curr_N); %Core sequence (K1 growth)
        b = generateSequence(1, curr_K2, curr_N); %Match sequence (K2 association)

        %Calculating GKappa: Adapting core K1 and matching K2
        gk_val = MS_GK(a, b, 1, curr_K1, 1, curr_K2);
        gk_sum = gk_sum + gk_val;
    end

    %Calculate the mean under the current K1 combination and store it
    gk_mean(idx) = gk_sum / fixed_iter;

    %Printing progress every 20 combinations (monitoring the cycle of K1=3-200)
    if mod(idx, 20) == 0
        progress_pct = round(idx/vec_len*100, 1);
        disp(['当前进度: K1=', num2str(curr_K1), ', K2=', num2str(curr_K2), ' | 已完成', num2str(progress_pct), '%']);
    end
end

abs_gk_mean = abs(gk_mean); %Extract the absolute value (the length is consistent with the K1 sequence)
disp(['K1=', num2str(min_K1), '-', num2str(max_K1), '、K2=', num2str(min_K2), '-', num2str(max_K2), ...
    '、固定', num2str(fixed_iter), '次重复的GKappa均值计算完成！']);

%% 4. Write to Excel file (core K1 + matching K2 + GKappa mean)
if bool_first
    %Header: core variable K1 + matching variable K2 + GKappa
    writecell([{'核心类别数K1'}, {'匹配类别数K2'}, metricName], outputFilePath, 'WriteMode', 'overwrite'); 
end
%Write K1 (column) + K2 (column) + mean (column)
writematrix([K1_vec', K2_vec', gk_mean], outputFilePath, 'Range', 'A2'); 
disp(['关键数据已保存至: ', outputFilePath]);

%% 5. Nonlinear fitting (core: x=K1, y=|GKappa|)
%Model description: a=initial value, b=attenuation coefficient, c=convergence basis
fitModel = @(params, x) params(1) .* exp(-params(2)*x) + params(3);
initialGuess = [max(abs_gk_mean), 0.005, 0]; %initial guess

%Fitting input: x is the column vector of core variable K1
x_fit = K1_vec'; 
nlm = fitnlm(x_fit, abs_gk_mean, fitModel, initialGuess);

%Extract fitting parameters
fitParams = nlm.Coefficients.Estimate;
a_fit = fitParams(1); %initial amplitude
b_fit = fitParams(2); %Attenuation coefficient
c_fit = fitParams(3); %Convergence benchmark

%Generate y values ​​for the fitted curve (aligned with the K1 dimension)
y_fit = (a_fit * exp(-b_fit * K1_vec) + c_fit)'; 
y_fit(y_fit < 0) = 0; %Eliminate negative numbers

disp('拟合参数（x=K1）：');
disp(['初始幅值 a = ', num2str(a_fit)]);
disp(['衰减系数 b = ', num2str(b_fit)]);
disp(['收敛基准 c = ', num2str(c_fit)]);

%% 6. Draw the fitting curve + original data (x-axis = K1)
figure('Position', [100, 100, 1000, 600]); %Widen figure
hold on; grid on; box on;

%1. Draw the original data (light gray, thin lines)
plot(K1_vec, abs_gk_mean, 'Color', [0.7,0.7,0.7], 'LineWidth', 1, 'DisplayName', 'Original data'); 
%2. Draw the fitting curve (dark blue, bold, core display)
plot(K1_vec, y_fit, 'Color', [0.1,0.4,0.7], 'LineWidth', 2.5, 'DisplayName', 'Fitted curve (x=K1)'); 

%% 7. Chart beautification (label core fitting object K1)
%Global font settings
set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');
set(0, 'DefaultUicontrolFontName', 'Arial');

%X axis settings (Core: K1 from min to max)
xlabel('Number of categories (N, core fitting object)', 'FontSize', 25, 'FontWeight', 'bold'); 
%Automatically generate K1 scale (adapted to 3-200 range)
num_ticks = 5;
xticks_auto = linspace(min_K1, max_K1, num_ticks);
xticks_auto = round(xticks_auto);
xticks(xticks_auto);
xticklabels(cellstr(num2str(xticks_auto')));

%Y axis settings (forced to start from 0)
y_min = 0;
y_max = max([abs_gk_mean; y_fit]) * 1.1;
ylim([y_min, y_max]);
ylabel('Absolute value of GKappa mean', 'FontSize', 20, 'FontWeight', 'bold'); 

%Title (highlighting K1 as the core fitting object)
title(sprintf('GKappa Convergence (N=%d-%d, M=N+10, n=K1,Rn=%d) \n (y=%.3f·e^{-%.5f·x}+%.3f)', ...
    min_K1, max_K1, fixed_iter, a_fit, b_fit, c_fit), 'FontSize', 15, 'FontWeight', 'bold'); 

%Legend settings
legend('Location', 'best', 'FontSize', 20); 
%Axis optimization
set(gca, 'FontSize', 20);
set(gca, 'GridAlpha', 0.2);
set(gca, 'Box', 'on');
set(gca, 'TickLabelInterpreter', 'none');

%% 8. Save high-resolution images
print(gcf, imgFilePath, '-dpng', '-r300'); %300dpi HD PNG
%Vector diagram (journal submission):
% print(gcf, fullfile(outputDir, sprintf('K1_%d-%d_K2_%d-%d_Iter%d_GKappa_Fit_Curve.eps', min_K1, max_K1, min_K2, max_K2, fixed_iter)), '-depsc', '-r300');

disp(['Fitted curve image saved to: ', imgFilePath]);
disp('All operations completed!');
