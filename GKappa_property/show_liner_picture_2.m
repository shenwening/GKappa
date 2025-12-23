addpath("../utils/")
addpath("../metrics/")
clear; clc; close all;
%Read Excel file
 % [~, ~, raw] = xlsread('data\sim\test_value_sim_rho_c_10_90.xlsx');
   % [~, ~, raw] = xlsread('data\sim\test_value_sim_rho_c_90.xlsx');
 % [~, ~, raw] = xlsread('data\sim\test_value_sim_rho_c_50.xlsx');
 [~, ~, raw] = xlsread('data\sim\test_value_sim_rho_c_20.xlsx')

%Extract header and data
metrics_names = raw(1,:);
data = cell2mat(raw(2:end,:))

%Create graphics
figure('Name', '多指标评估图', 'Position', [100 100 800 500]);

%16 high-definition colors
custom_colors = [
    0.894, 0.102, 0.110;  %red
    0.216, 0.494, 0.722;  %blue
    0.302, 0.686, 0.290;  %green
    0.600, 0.600, 0.600;  %Ash
    0.596, 0.306, 0.639;  %purple
    0.870, 0.560, 0.056;  %golden
    1.000, 0.498, 0.000;  %orange
    1.000, 1.000, 0.200;  %yellow
    0.651, 0.337, 0.157;  %Brown
    0.969, 0.506, 0.749;  %pink
    0.600, 0.600, 0.600;  %Ash
    0.121, 0.471, 0.705;  %dark blue
    0.682, 0.780, 0.909;  %light blue
    0.870, 0.560, 0.056;  %golden
    0.498, 0.498, 0.000;  %olives
    0.737, 0.741, 0.133;  %light green
    0.090, 0.745, 0.811;  %green
    0.839, 0.153, 0.157;  %deep red
];

%An array of values ​​defining the x-axis
% x_values = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9];
% x_values = [0.81,0.82,0.83,0.84,0.85,0.86,0.87,0.88,0.89]

 x_values =[0.11,0.12,0.13,0.14,0.15,0.16,0.17,0.18,0.19];
%  x_values=[0.51,0.52,0.53,0.54,0.55,0.56,0.57,0.58,0.59];


%Create graphics
figure('Name', '16指标评估图', 'Position', [50 50 1200 800]);

%Draw lines for each indicator (only use different colors and uniformly use round markers)
hold on
for i = 1:min(16, size(data, 2))
    if i <= size(custom_colors, 1)
        plot(x_values, data(:,i), '-o', ...  %Uniform use of circular markers
             'LineWidth', 1.5, ...
             'MarkerSize', 8, ...
             'Color', custom_colors(i,:), ...
             'DisplayName', metrics_names{i}, ...
             'MarkerFaceColor', custom_colors(i,:));
        
       
    end
end
hold off

%Set graphic properties
grid on;
% xlabel('Perturbation range of Confusion Percentage', 'FontSize', 12);
% ylabel('Metric Value', 'FontSize', 12);
% title('Comparison of 4 Metrics', 'FontSize',14)

%Set x-axis ticks and labels
xticks(x_values);
xticklabels(x_values);

%Optimize legend display
% legend('Location', 'eastoutside', ...
%        'FontSize', 10, ...
%        'NumColumns', 2, ...
%        'Box', 'on', ...
%        'EdgeColor', [0.7 0.7 0.7]);
%Optimize legend display
legend('Location', 'eastoutside', ...
       'FontSize', 30, ...  %Increase legend font size
       'NumColumns', 2, ...
       'Box', 'on', ...
       'EdgeColor', [0.7 0.7 0.7]);

%Optimize axes
%Optimize axes
ax = gca;
ax.FontSize = 20;  %Increase axis font size
ax.Box = 'on';
ax.GridAlpha = 0.3;
ax.GridLineStyle = ':';

%Set the font size of the x-axis and y-axis coordinate values ​​(controlled separately)
ax.XAxis.FontSize = 30;  %Increase the x-axis coordinate value font
ax.YAxis.FontSize = 30;  %Increase the font of the y-axis coordinate value

%You can also increase the axis label font size
xlabel('Perturbation range of Confusion Percentage', 'FontSize', 30);
ylabel('Metric Value', 'FontSize', 30);
title('Comparison of 6 Metrics', 'FontSize', 30);

%Adjust y-axis range
ylim_data = [min(data(:))*0.95, max(data(:))*1.05];
ylim(ylim_data);

%Resize graph to fit legend
set(gcf, 'Units', 'normalized');
pos = get(gcf, 'Position');
pos(3) = pos(3) * 1.2;
set(gcf, 'Position', pos);

%Export graphics
% saveas(gcf, 'data/picture/metrics_plot_10_90.png', 'png');
  % saveas(gcf, 'data/picture/metrics_plot_90.png', 'png');
  saveas(gcf, 'data/picture/metrics_plot_10.png', 'png');
% saveas(gcf, 'data/picture/metrics_plot_50.png', 'png');