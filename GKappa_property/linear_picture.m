clear; clc; close all;
%% 1. Data preparation (organize data according to disturbance type)
%Disturbance amplitude
mag_majority = 0.1:0.1:0.9;
mag_random = 0.1:0.1:0.9;
mag_label = 0.1:0.1:0.9;
mag_ordinal = 0.1:0.1:0.9;
mag_proximity = 0.1:0.1:0.9;

%Majority Class Assignment indicator data
pearson_majority = [0.7557, 0.7122, 0.6647, 0.6158, 0.5624, 0.5013, 0.4312, 0.3537, 0.2471];
rs_majority = [0.7602, 0.7164, 0.6684, 0.6193, 0.5656, 0.5042, 0.4331, 0.3555, 0.2481];
tb_majority = [0.7282, 0.6839, 0.6364, 0.5886, 0.5369, 0.4783, 0.4108, 0.3373, 0.2355];
icc_majority = [0.7556, 0.7113, 0.6603, 0.6046, 0.5411, 0.4657, 0.3761, 0.276, 0.1491];
ndcg_majority = [0.9839, 0.9826, 0.9818, 0.9813, 0.9811, 0.9815, 0.982, 0.9843, 0.9881];
gkappa_majority = [0.4325, 0.3924, 0.3498, 0.3063, 0.2613, 0.2133, 0.1619, 0.1112, 0.0556];

%Random Assignment indicator data
pearson_random = [0.6794, 0.5771, 0.5051, 0.4488, 0.401, 0.324, 0.2838, 0.209, 0.1484];
rs_random = [0.6975, 0.5817, 0.4968, 0.4223, 0.3627, 0.2712, 0.2302, 0.1502, 0.1017];
tb_random = [0.6645, 0.5518, 0.4702, 0.4007, 0.3444, 0.2584, 0.2192, 0.1432, 0.0969];
icc_random = [0.6717, 0.5646, 0.4889, 0.4351, 0.3875, 0.31, 0.265, 0.1913, 0.12];
ndcg_random = [0.9786, 0.972, 0.9684, 0.9679, 0.9664, 0.9593, 0.962, 0.959, 0.9639];
gkappa_random = [0.4158, 0.3609, 0.3089, 0.2594, 0.2163, 0.1664, 0.1257, 0.0787, 0.0401];

%Label Shift indicator data
pearson_label = [0.7438, 0.7055, 0.6814, 0.6676, 0.6607, 0.6618, 0.6748, 0.6938, 0.7309];
rs_label = [0.7509, 0.7091, 0.6798, 0.6622, 0.6545, 0.6576, 0.6742, 0.6996, 0.74];
tb_label = [0.7121, 0.6644, 0.6312, 0.6116, 0.6032, 0.607, 0.626, 0.6552, 0.7014];
icc_label = [0.7376, 0.6949, 0.6675, 0.652, 0.645, 0.6472, 0.6626, 0.6855, 0.7272];
ndcg_label = [0.9813, 0.9802, 0.98, 0.9808, 0.9823, 0.9841, 0.9861, 0.9885, 0.9911];
gkappa_label = [0.4439, 0.4149, 0.3879, 0.3624, 0.3371, 0.3126, 0.2933, 0.27, 0.2504];

%Ordinal Shift indicator data
pearson_ordinal = [0.4898, 0.2852, 0.1236, -0.0035, -0.1171, -0.2183, -0.3059, -0.3856, -0.4603];
rs_ordinal = [0.5582, 0.3545, 0.1755, 0.0305, -0.0936, -0.1958, -0.2711, -0.3264, -0.36];
tb_ordinal = [0.5276, 0.3325, 0.1676, 0.038, -0.0699, -0.1562, -0.2173, -0.2591, -0.2809];
icc_ordinal = [0.4746, 0.2651, 0.11, -0.0029, -0.0962, -0.1729, -0.2345, -0.2865, -0.3322];
ndcg_ordinal = [0.9659, 0.9502, 0.9354, 0.9212, 0.9082, 0.8935, 0.881, 0.8682, 0.8556];
gkappa_ordinal = [0.3526, 0.2444, 0.1416, 0.0484, -0.04, -0.1222, -0.1992, -0.2706, -0.3368];

%Proximity-based Assignment indicator data
pearson_proximity = [0.8843, 0.7963, 0.7241, 0.6662, 0.615, 0.5661, 0.5281, 0.4939, 0.4686];
rs_proximity = [0.9074, 0.8225, 0.7469, 0.6808, 0.618, 0.5601, 0.5128, 0.4734, 0.446];
tb_proximity = [0.8925, 0.797, 0.713, 0.641, 0.574, 0.5139, 0.466, 0.4268, 0.4];
icc_proximity = [0.8817, 0.7901, 0.7143, 0.6542, 0.6014, 0.5527, 0.516, 0.4833, 0.4596];
ndcg_proximity = [0.9812, 0.9748, 0.9702, 0.9679, 0.9665, 0.9652, 0.9658, 0.9655, 0.9666];
gkappa_proximity = [0.3796, 0.3625, 0.3453, 0.329, 0.3134, 0.2912, 0.2725, 0.2572, 0.2419];

%% 2. Drawing settings (create 5 subgraphs)
figure('Position', [100, 100, 1400, 850]); %Make the canvas taller to leave space at the top for the title
set(groot, 'DefaultAxesFontName', 'Times New Roman'); %global font
set(groot, 'DefaultAxesFontSize', 15); %global font size

%Define colors and line types (6 indicators correspond to different colors/line types, simplifying marking)
colors = [0.894, 0.102, 0.110;  %red
    0.216, 0.494, 0.722;  %blue
    0.302, 0.686, 0.290;  %green
    0.600, 0.600, 0.600;  %Ash
    0.596, 0.306, 0.639;  %purple
    0.870, 0.560, 0.056;  %golden
    ]
linestyles = {'-', '--', '-.', ':', '--', '-'};
labels = {'Pearson', 'Rs', '\tau b', 'ICC', 'NDCG', 'GKappa'};

%% Subfigure 1: Majority Class Assignment
ax1 = subplot(2,3,1); hold on;
plot(mag_majority, pearson_majority, 'Color', colors(1,:), 'LineStyle', linestyles{1}, 'LineWidth', 1.5);
plot(mag_majority, rs_majority, 'Color', colors(2,:), 'LineStyle', linestyles{2}, 'LineWidth', 1.5);
plot(mag_majority, tb_majority, 'Color', colors(3,:), 'LineStyle', linestyles{3}, 'LineWidth', 1.5);
plot(mag_majority, icc_majority, 'Color', colors(4,:), 'LineStyle', linestyles{4}, 'LineWidth', 1.5);
plot(mag_majority, ndcg_majority, 'Color', colors(5,:), 'LineStyle', linestyles{5}, 'LineWidth', 1.5);
plot(mag_majority, gkappa_majority, 'Color', colors(6,:), 'LineStyle', linestyles{6}, 'LineWidth', 1.5); hold off;
title('Majority Class Assignment', 'FontWeight', 'bold');
xlabel('Disturbance Magnitude');
ylabel('Metric Value');
grid on; grid minor;
ylim([0, 1.05]);
box on;

%% Subpicture 2: Random Assignment
ax2 = subplot(2,3,2); hold on;
plot(mag_random, pearson_random, 'Color', colors(1,:), 'LineStyle', linestyles{1}, 'LineWidth', 1.5);
plot(mag_random, rs_random, 'Color', colors(2,:), 'LineStyle', linestyles{2}, 'LineWidth', 1.5);
plot(mag_random, tb_random, 'Color', colors(3,:), 'LineStyle', linestyles{3}, 'LineWidth', 1.5);
plot(mag_random, icc_random, 'Color', colors(4,:), 'LineStyle', linestyles{4}, 'LineWidth', 1.5);
plot(mag_random, ndcg_random, 'Color', colors(5,:), 'LineStyle', linestyles{5}, 'LineWidth', 1.5);
plot(mag_random, gkappa_random, 'Color', colors(6,:), 'LineStyle', linestyles{6}, 'LineWidth', 1.5); hold off;
title('Random Assignment', 'FontWeight', 'bold');
xlabel('Disturbance Magnitude');
ylabel('Metric Value');
grid on; grid minor;
ylim([0, 1.05]);
box on;

%% Subpicture 3: Label Shift
ax3 = subplot(2,3,3); hold on;
plot(mag_label, pearson_label, 'Color', colors(1,:), 'LineStyle', linestyles{1}, 'LineWidth', 1.5);
plot(mag_label, rs_label, 'Color', colors(2,:), 'LineStyle', linestyles{2}, 'LineWidth', 1.5);
plot(mag_label, tb_label, 'Color', colors(3,:), 'LineStyle', linestyles{3}, 'LineWidth', 1.5);
plot(mag_label, icc_label, 'Color', colors(4,:), 'LineStyle', linestyles{4}, 'LineWidth', 1.5);
plot(mag_label, ndcg_label, 'Color', colors(5,:), 'LineStyle', linestyles{5}, 'LineWidth', 1.5);
plot(mag_label, gkappa_label, 'Color', colors(6,:), 'LineStyle', linestyles{6}, 'LineWidth', 1.5); hold off;
title('Label Shift', 'FontWeight', 'bold');
xlabel('Disturbance Magnitude');
ylabel('Metric Value');
grid on; grid minor;
ylim([0, 1.05]);
box on;

%% Subpicture 4: Ordinal Shift
ax4 = subplot(2,3,4); hold on;
plot(mag_ordinal, pearson_ordinal, 'Color', colors(1,:), 'LineStyle', linestyles{1}, 'LineWidth', 1.5);
plot(mag_ordinal, rs_ordinal, 'Color', colors(2,:), 'LineStyle', linestyles{2}, 'LineWidth', 1.5);
plot(mag_ordinal, tb_ordinal, 'Color', colors(3,:), 'LineStyle', linestyles{3}, 'LineWidth', 1.5);
plot(mag_ordinal, icc_ordinal, 'Color', colors(4,:), 'LineStyle', linestyles{4}, 'LineWidth', 1.5);
plot(mag_ordinal, ndcg_ordinal, 'Color', colors(5,:), 'LineStyle', linestyles{5}, 'LineWidth', 1.5);
plot(mag_ordinal, gkappa_ordinal, 'Color', colors(6,:), 'LineStyle', linestyles{6}, 'LineWidth', 1.5); hold off;
title('Ordinal Shift', 'FontWeight', 'bold');
xlabel('Disturbance Magnitude');
ylabel('Metric Value');
grid on; grid minor;
ylim([-0.5, 1.05]);
box on;

%% Subfigure 5: Proximity-based Assignment
ax5 = subplot(2,3,5); hold on;
plot(mag_proximity, pearson_proximity, 'Color', colors(1,:), 'LineStyle', linestyles{1}, 'LineWidth', 1.5);
plot(mag_proximity, rs_proximity, 'Color', colors(2,:), 'LineStyle', linestyles{2}, 'LineWidth', 1.5);
plot(mag_proximity, tb_proximity, 'Color', colors(3,:), 'LineStyle', linestyles{3}, 'LineWidth', 1.5);
plot(mag_proximity, icc_proximity, 'Color', colors(4,:), 'LineStyle', linestyles{4}, 'LineWidth', 1.5);
plot(mag_proximity, ndcg_proximity, 'Color', colors(5,:), 'LineStyle', linestyles{5}, 'LineWidth', 1.5);
plot(mag_proximity, gkappa_proximity, 'Color', colors(6,:), 'LineStyle', linestyles{6}, 'LineWidth', 1.5); hold off;
title('Proximity-based Assignment', 'FontWeight', 'bold');
xlabel('Disturbance Magnitude');
ylabel('Metric Value');
grid on; grid minor;
ylim([0, 1.05]);
box on;

%% 3. Overall beautification + title adjustment compatible with all versions
set(gcf, 'Color', 'white'); %Canvas background is white

%===== Core fix: replace the Position setting of sgtitle, compatible with all MATLAB versions =====
%Solution 1: High version MATLAB (R2020b+) - Use tight_layout to automatically avoid titles
try
    %First adjust the spacing between sub-pictures to reserve space for the title.
    tight_layout(gcf, 'padding', 0.12); 
    %Add a general title (MATLAB automatically adjusts the position without blocking)
    sgtitle('Evaluation Metrics Under Different Disturbance Types', 'FontSize', 20, 'FontWeight', 'bold');
catch
    %Option 2: Low version of MATLAB - manually adjust the position of the subfigure, and the title will naturally not be blocked
    %1. Manually move the sub-picture down and leave enough space at the top for the title
    set(ax1, 'Position', [0.06, 0.52, 0.22, 0.35]); %The upper row of sub-pictures has been significantly moved downwards
    set(ax2, 'Position', [0.35, 0.52, 0.22, 0.35]);
    set(ax3, 'Position', [0.64, 0.52, 0.22, 0.35]);
    set(ax4, 'Position', [0.06, 0.06, 0.22, 0.35]); %Move the lower row of sub-pictures down
    set(ax5, 'Position', [0.35, 0.06, 0.22, 0.35]);
    
    %2. Add a general title (there is enough space at the top, no need to adjust the Position)
    sgtitle('Evaluation Metrics Under Different Disturbance Types', 'FontSize', 20, 'FontWeight', 'bold');
end

%Create a global legend (place it on the right side outside the figure and only show it once)
h_legend = legend(ax1, labels, 'Location', 'eastoutside', 'FontSize', 20);
%Fixed legend position (adapts to the layout after moving the subgraph down)
set(h_legend, 'Position', [0.88, 0.09, 0.10, 0.75]); 

%% Optional: Save HD pictures
print(gcf, 'disturbance_metrics_plot', '-dpng', '-r300'); %Save as PNG at 300dpi

saveas(gcf, 'disturbance_metrics_plot.svg'); %Save fig file
