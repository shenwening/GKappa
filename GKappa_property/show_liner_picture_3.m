% clear; clc; close all;
% 
%% ================== Data file ==================
% files = {
%     'data\sim\test_value_sim_rho_c_10_90.xlsx', ...
%     'data\sim\test_value_sim_rho_c_10.xlsx', ...
%     'data\sim\test_value_sim_rho_c_50.xlsx', ...
%     'data\sim\test_value_sim_rho_c_90.xlsx'
% };
% 
%% corresponds to the x-axis
% x_values_all = {
%     0.1:0.1:0.9, ...
%     0.11:0.01:0.19, ...
%     0.51:0.01:0.59, ...
%     0.81:0.01:0.89
% };
% 
%% ================== 16 high-resolution colors ==================
% custom_colors = [
%     0.894, 0.102, 0.110;
%     0.216, 0.494, 0.722;
%     0.302, 0.686, 0.290;
%     0.600, 0.600, 0.600;
%     0.596, 0.306, 0.639;
%     0.870, 0.560, 0.056;
%     1.000, 0.498, 0.000;
%     1.000, 1.000, 0.200;
%     0.651, 0.337, 0.157;
%     0.969, 0.506, 0.749;
%     0.121, 0.471, 0.705;
%     0.682, 0.780, 0.909;
%     0.498, 0.498, 0.000;
%     0.737, 0.741, 0.133;
%     0.090, 0.745, 0.811;
%     0.839, 0.153, 0.157;
% ];
% 
%% ================== Create graphics ==================
% figure('Position',[50 50 1600 1200]);
% tiledlayout(2,2,'TileSpacing','compact','Padding','compact');
% 
% for k = 1:4
%     nexttile;
% 
%% Read data
%     [~,~,raw] = xlsread(files{k});
%     metrics_names = raw(1,:);
%     data = cell2mat(raw(2:end,:));
%     x_values = x_values_all{k};
% 
%     hold on
%     for i = 1:min(size(data,2), size(custom_colors,1))
%         plot(x_values, data(:,i), '-o', ...
%             'LineWidth', 1.8, ...
%             'MarkerSize', 6, ...
%             'Color', custom_colors(i,:), ...
%             'MarkerFaceColor', custom_colors(i,:), ...
%             'DisplayName', metrics_names{i});
%     end
%     hold off
% 
%% ================== Coordinate axis forced setting ==================
%     grid on;
%     title(['Experiment ', num2str(k)], 'FontSize', 30);
%     xlabel('Perturbation Level', 'FontSize', 30);
%     ylabel('Metric Value', 'FontSize', 30);
% 
%     ax = gca;
% 
%% - core three lines (to prevent ticks from being omitted) -
%xticks(x_values); % force ticks
%xlim([min(x_values), max(x_values)]); % fixed range
%ax.XTickLabelRotation = 0; % No rotation, anti-cropping
% 
%% Font and line width
%     ax.FontSize = 16;
%     ax.XAxis.FontSize = 16;
%     ax.YAxis.FontSize = 16;
%     ax.LineWidth = 1.2;
%     ax.TickDir = 'out';
% end
% 
%% ================== Unified legend ==================
% lgd = legend(metrics_names, ...
%     'Location','eastoutside', ...
%     'FontSize',16);
% lgd.Box = 'on';
% 
%% ================== Export ==================
% set(gcf, 'PaperPositionMode', 'auto');
% 
%% ================== Export ==================
% set(gcf, 'PaperPositionMode', 'auto');
% 
%% PNG (bitmap, for review/Word)
% print(gcf, 'data/metrics_comparison_sim_mon_1', '-dpng', '-r300');
% 
%% SVG (vector, fallback)
% print(gcf, 'data/metrics_comparison_sim_mon_1_sim_mon_1', '-dsvg');


clear; clc; close all;

%================== Data files ==================
% files = {
%     'data\sim\test_value_sim_rho_c_10_90.xlsx', ...
%     'data\sim\test_value_sim_rho_c_10.xlsx', ...
%     'data\sim\test_value_sim_rho_c_50.xlsx', ...
%     'data\sim\test_value_sim_rho_c_90.xlsx'
% };
files = {
    'data\test\test_value_sim_rho_incre_10_90.xlsx', ...
    'data\test\test_value_sim_rho_incre_10.xlsx', ...
    'data\test\test_value_sim_rho_incre_50.xlsx', ...
    'data\test\test_value_sim_rho_incre_90.xlsx'
};

x_values_all = {
    0.1:0.1:0.9, ...
    0.11:0.01:0.19, ...
    0.51:0.01:0.59, ...
    0.81:0.01:0.89
};

%================== 16 high-definition colors ==================
custom_colors = [
    0.894, 0.102, 0.110;
    0.216, 0.494, 0.722;
    0.302, 0.686, 0.290;
    0.600, 0.600, 0.600;
    0.596, 0.306, 0.639;
    0.870, 0.560, 0.056;
    1.000, 0.498, 0.000;
    1.000, 1.000, 0.200;
    0.651, 0.337, 0.157;
    0.969, 0.506, 0.749;
    0.121, 0.471, 0.705;
    0.682, 0.780, 0.909;
    0.498, 0.498, 0.000;
    0.737, 0.741, 0.133;
    0.090, 0.745, 0.811;
    0.839, 0.153, 0.157;
];

%================== Create graphics ==================
fig = figure('Units','centimeters','Position',[2 2 35 25]);  %Specify physical dimensions (cm)

tiledlayout(2,2,'TileSpacing','compact','Padding','compact');

for k = 1:4
    nexttile;
    
    [~,~,raw] = xlsread(files{k});
    metrics_names = raw(1,:);
    data = cell2mat(raw(2:end,:));
    x_values = x_values_all{k};
    
    hold on
    for i = 1:min(size(data,2), size(custom_colors,1))
        plot(x_values, data(:,i), '-o', ...
            'LineWidth', 1.8, ...
            'MarkerSize', 6, ...
            'Color', custom_colors(i,:), ...
            'MarkerFaceColor', custom_colors(i,:), ...
            'DisplayName', metrics_names{i});
    end
    hold off
    
    grid on;
    title(['Experiment ', num2str(k)], 'FontSize', 30);
    xlabel('Perturbation Level', 'FontSize', 30);
    ylabel('Metric Value', 'FontSize', 30);
    
    ax = gca;
    xticks(x_values);
    xlim([min(x_values), max(x_values)]);
    ax.XTickLabelRotation = 0;
    ax.FontSize = 16;
    ax.XAxis.FontSize = 16;
    ax.YAxis.FontSize = 20;
    ax.LineWidth = 1.2;
    ax.TickDir = 'out';
end

%unified legend
lgd = legend(metrics_names, 'Location','eastoutside', 'FontSize',20);
lgd.Box = 'on';

%================== Setting PaperSize and exporting ==================
set(fig, 'PaperUnits', 'centimeters');
set(fig, 'PaperSize', [35 25]);          %Same size as figure
set(fig, 'PaperPositionMode', 'manual');
set(fig, 'PaperPosition', [0 0 35 25]);

% PNG
print(fig, 'data/metrics_comparison_sim_mon_2.png', '-dpng', '-r300');

%PDF (complete without cropping)
print(fig, 'data/metrics_comparison_sim_mon_2.pdf', '-dpdf', '-bestfit');

% SVG
print(fig, 'data/metrics_comparison_sim_mon_2.svg', '-dsvg');
