addpath("../utils/")
addpath("../metrics/")
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Simulated data set stability experiment-GK


sss = 100; %Repeat times
n = 5; %Level range

%% Define correlation coefficient matrix and counter
MER_mat = zeros(sss,6);
MAE_mat = zeros(sss,6);
Pearson_mat = zeros(sss,6);
Rs_mat = zeros(sss,6);
tb_mat = zeros(sss,6);
rint_mat = zeros(sss,6);
a_mat = zeros(sss,6);
OC_mat = zeros(sss,6);
Mcc_mat = zeros(sss,6);
IA_mat = zeros(sss,6);
CEM_mat = zeros(sss,6);
ICC_mat = zeros(sss,6);
pi_mat = zeros(sss,6);
kappa_mat = zeros(sss,6);
Gkappa_mat = zeros(sss,6);
AC_mat = zeros(sss,6);
NDCG_mat=zeros(sss,6);

total_iter = sss * 6;
pbar = waitbar(0, 'Progress', 'Name', 'Calculating Correlation Coefficients...');
% 
for i=1:sss
    vectorLength = 1000;
    %Generate sequence
    %Define base sequence
    a = round(1 + (n-1) * rand(1, vectorLength));  %Generate a random sequence of integers between 1 and 4
    a;
    %Define the similarity level (expressed as a percentage)
    similarityLevels = [100, 80, 60, 40, 20, 0];

    %Generate sequences with different degrees of similarity
    b = zeros(length(similarityLevels), vectorLength);  %Store the generated sequence

    for k = 1:length(similarityLevels)
        similarity = similarityLevels(k);
        sequence = a;  %The initial sequence is the same as the base sequence

        %Modify sequences based on similarity levels
        if similarity < 100
            numChanges = round((100 - similarity) * vectorLength / 100);
            indices = randperm(vectorLength, numChanges);  %Randomly select the index of the element to modify
            for j = 1:numChanges
                %Randomly generate new elements to replace the modified elements, making sure they are not the same as the previous number
                newElement = sequence(indices(j));
                while newElement == sequence(indices(j))
                    newElement = round(1 + 3 * rand());
                end
                sequence(indices(j)) = newElement;
            end
        end

        b(k,:) = sequence;  %Store the generated sequence
    end


    %% Display the generated sequence
    % for i = 1:length(similarityLevels)
    %     similarity = similarityLevels(i);
    %     disp(['Similarity: ', num2str(similarity), '%']);
    %     disp(b(i,:));
    %     disp('------------------');
    % end

    for j=1:6
        CM = GetCM(a,b(j,:),n);
       % [MAE_mat(i, j), MER_mat(i, j)] = MS_MER(a', b(j,:)',n);
       % Pearson_mat(i, j) = MS_P(a,b(j,:));
       % Rs_mat(i, j) = MS_Rs(a',b(j,:)');
       % tb_mat(i, j) = MS_tb(a',b(j,:)');
       % rint_mat(i, j) = MS_Rint(CM);
       % a_mat(i, j) = MS_ORD(a',b(j,:)',n);
       % OC_mat(i, j) = MS_OC(a',b(j,:)',n,1,0.75);
       % Mcc_mat(i, j) = MS_MCC(a,b(j,:),n);
       IA_mat(i, j) = MS_IA(CM,n);
       % CEM_mat(i, j) = MS_CEM(CM);
       % ICC_mat(i, j) = ICC([a', b(j,:)'], 'C-1');
       % pi_mat(i, j) = MS_WAC(CM,'Quadratic','Scotts_pi');
       % kappa_mat(i, j) = MS_WAC(CM,'Quadratic','Weighted_kappa');
       % Gkappa_mat(i, j) = MS_GK( a,b(j,:),1,n,1,n );
       %  AC_mat(i, j) = MS_WAC(CM,'Quadratic','Gwet');
        NDCG_mat(i,j)=MS_NDCG(a,b(j,:));
    end

    % Update the progress bar after each complete iteration
    iter_num = (i - 1) * 6 + j;
    progress_pct = iter_num / total_iter;
    waitbar(progress_pct, pbar, sprintf('Progress: %d/%d', iter_num, total_iter));
end

close(pbar);

%Write data to Excel file using xlswrite function
% xlswrite('result/MER_mat.xlsx', 1-MER_mat);
% xlswrite('result/MAE_mat.xlsx', MAE_mat);
% xlswrite('result/Pearson_mat.xlsx', Pearson_mat);
% xlswrite('result/Rs_mat.xlsx', Rs_mat);
% xlswrite('result/tb_mat.xlsx', tb_mat);
% xlswrite('result/rint_mat.xlsx', rint_mat);
% xlswrite('result/a_mat.xlsx', a_mat);
% xlswrite('result/OC_mat.xlsx', OC_mat);
% xlswrite('result/Mcc_mat.xlsx', Mcc_mat);
xlswrite('result/IA_mat_5.xlsx', mean(IA_mat,1));
% xlswrite('result/CEM_mat.xlsx', CEM_mat);
% xlswrite('result/ICC_mat.xlsx', ICC_mat);
% xlswrite('result/pi_mat.xlsx', pi_mat);
% xlswrite('result/kappa_mat.xlsx', kappa_mat);
% xlswrite('result/Gkappa_mat.xlsx', Gkappa_mat);
% xlswrite('result/AC_mat.xlsx', AC_mat);
xlswrite('result/NDCG_mat_4.xlsx', mean(NDCG_mat,1));


%4/5/8 Modify folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% % Draw line chart_1
%%Read the data of the first table
% [data1, ~, ~] = xlsread('result/MER_mat.xlsx', 'A1:F100');
%% Read the data of the second table
% [data2, ~, ~] = xlsread('result/MAE_mat.xlsx', 'A1:F100');
%% Read the data of the third table
% [data3, ~, ~] = xlsread('result/Pearson_mat.xlsx', 'A1:F100');
%% Read the data of the fourth table
% [data4, ~, ~] = xlsread('result/Rs_mat.xlsx', 'A1:F100');
% 
% % 创建一个新的图形窗口
% figure
% 
%% Define the x-axis coordinate
% 
% x_labels = {'100%', '80%', '60%', '40%', '20%', '0%'};
% x = 1:6;
% 
%% Draw the first chart
% subplot(2, 2, 1)
% hold on
% for i = 1:100
%     plot(x, data1(i, :), '-o')
% end
% xticks(x)
% xticklabels(x_labels)
% title('(1) MER')
% xlim([1, max(x)]);
%% Draw the second chart
% subplot(2, 2, 2)
% hold on
% for i = 1:100
%     plot(x, data2(i, :), '-o')
% end
% xticks(x)
% xticklabels(x_labels)
% title('(2) MAE')
% xlim([1, max(x)]);
%% Draw the third chart
% subplot(2, 2, 3)
% hold on
% for i = 1:100
%     plot(x, data3(i, :), '-o')
% end
% xticks(x)
% xticklabels(x_labels)
% title('(3) Pearson')
% xlim([1, max(x)]);
%% Draw the fourth chart
% subplot(2, 2, 4)
% hold on
% for i = 1:100
%     plot(x, data4(i, :), '-o')
% end
% xticks(x)
% xticklabels(x_labels)
% title('(4) Rs')
% xlim([1, max(x)]);
% 
% print('result/chart1.png', '-dpng', '-r300');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Draw a line chart_2
%% Read the data of the first table
% [data1, ~, ~] = xlsread('result/tb_mat.xlsx', 'A1:F100');
%% Read the data of the second table
% [data2, ~, ~] = xlsread('result/rint_mat.xlsx', 'A1:F100');
%% Read the data of the third table
% [data3, ~, ~] = xlsread('result/a_mat.xlsx', 'A1:F100');
%% Read the data of the fourth table
% [data4, ~, ~] = xlsread('result/OC_mat.xlsx', 'A1:F100');
% 
%% Create a new graphics window
% figure
% 
%% Define the x-axis coordinate
% 
% x_labels = {'100%', '80%', '60%', '40%', '20%', '0%'};
% x = 1:6;
% 
%% Draw the first chart
% subplot(2, 2, 1)
% hold on
% for i = 1:100
%     plot(x, data1(i, :), '-o')
% end
% xticks(x)
% xticklabels(x_labels)
% title('(5) tb')
% xlim([1, max(x)]);
%% Draw the second chart
% subplot(2, 2, 2)
% hold on
% for i = 1:100
%     plot(x, data2(i, :), '-o')
% end
% xticks(x)
% xticklabels(x_labels)
% title('(6) rint')
% xlim([1, max(x)]);
%% Draw the third chart
% subplot(2, 2, 3)
% hold on
% for i = 1:100
%     plot(x, data3(i, :), '-o')
% end
% xticks(x)
% xticklabels(x_labels)
% title('(7) α-ord')
% xlim([1, max(x)]);
%% Draw the fourth chart
% subplot(2, 2, 4)
% hold on
% for i = 1:100
%     plot(x, data4(i, :), '-o')
% end
% xticks(x)
% xticklabels(x_labels)
% title('(8) OCI')
% xlim([1, max(x)]);
% 
% print('result/chart2.png', '-dpng', '-r300');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% draw line chart_3
%% Read the data of the first table
% [data1, ~, ~] = xlsread('result/Mcc_mat.xlsx', 'A1:F100');
%% Read the data of the second table
% [data2, ~, ~] = xlsread('result/IA_mat.xlsx', 'A1:F100');
%% Read the data of the third table
% [data3, ~, ~] = xlsread('result/CEM_mat.xlsx', 'A1:F100');
%% Read the data of the fourth table
% [data4, ~, ~] = xlsread('result/ICC_mat.xlsx', 'A1:F100');
% 
%% Create a new graphics window
% figure
% 
%% Define the x-axis coordinate
% 
% x_labels = {'100%', '80%', '60%', '40%', '20%', '0%'};
% x = 1:6;
% 
%% Draw the first chart
% subplot(2, 2, 1)
% hold on
% for i = 1:100
%     plot(x, data1(i, :), '-o')
% end
% xticks(x)
% xticklabels(x_labels)
% title('(9) MCC')
% xlim([1, max(x)]);
%% Draw the second chart
% subplot(2, 2, 2)
% hold on
% for i = 1:100
%     plot(x, data2(i, :), '-o')
% end
% xticks(x)
% xticklabels(x_labels)
% title('(10) IA')
% xlim([1, max(x)]);
%% Draw the third chart
% subplot(2, 2, 3)
% hold on
% for i = 1:100
%     plot(x, data3(i, :), '-o')
% end
% xticks(x)
% xticklabels(x_labels)
% title('(11) CEM-ord')
% xlim([1, max(x)]);
%% Draw the fourth chart
% subplot(2, 2, 4)
% hold on
% for i = 1:100
%     plot(x, data4(i, :), '-o')
% end
% xticks(x)
% xticklabels(x_labels)
% title('(12) ICC(3,1)')
% xlim([1, max(x)]);
% 
% print('result/chart3.png', '-dpng', '-r300');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% draw line chart_4
%%Read the data of the first table
% [data1, ~, ~] = xlsread('result/pi_mat.xlsx', 'A1:F100');
%% Read the data of the second table
% [data2, ~, ~] = xlsread('result/kappa_mat.xlsx', 'A1:F100');
%% Read the data of the third table
% [data3, ~, ~] = xlsread('result/AC_mat.xlsx', 'A1:F100');
%% Read the data of the fourth table
% [data4, ~, ~] = xlsread('result/Gkappa_mat.xlsx', 'A1:F100');
% 
%% Create a new graphics window
% figure
%% Define the x-axis coordinate
% x_labels = {'100%', '80%', '60%', '40%', '20%', '0%'};
% x = 1:6;
%% Draw the first chart
% subplot(2, 2, 1)
% hold on
% for i = 1:100
%     plot(x, data1(i, :), '-o')
% end
% xticks(x)
% xticklabels(x_labels)
% title('(13) π')
% xlim([1, max(x)]);
%% Draw the second chart
% subplot(2, 2, 2)
% hold on
% for i = 1:100
%     plot(x, data2(i, :), '-o')
% end
% xticks(x)
% xticklabels(x_labels)
% title('(14) Weighted kappa')
% xlim([1, max(x)]);
%% Draw the third chart
% subplot(2, 2, 3)
% hold on
% for i = 1:100
%     plot(x, data3(i, :), '-o')
% end
% xticks(x)
% xticklabels(x_labels)
% title('(15) AC2')
% xlim([1, max(x)]);
%% Draw the fourth chart
% subplot(2, 2, 4)
% hold on
% for i = 1:100
%     plot(x, data4(i, :), '-o')
% end
% xticks(x)
% xticklabels(x_labels)
% title('(16) Gkappa')
% xlim([1, max(x)]);
% 
% print('result/chart4.png', '-dpng', '-r300');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculate average
% data = cell(16,1)
% 
% [data{1}, ~, ~] = xlsread('result/MER_mat.xlsx', 'A1:F100');
% [data{2}, ~, ~] = xlsread('result/MAE_mat.xlsx', 'A1:F100');
% [data{3}, ~, ~] = xlsread('result/Pearson_mat.xlsx', 'A1:F100');
% [data{4}, ~, ~] = xlsread('result/Rs_mat.xlsx', 'A1:F100');
% [data{5}, ~, ~] = xlsread('result/tb_mat.xlsx', 'A1:F100');
% [data{6}, ~, ~] = xlsread('result/rint_mat.xlsx', 'A1:F100');
% [data{7}, ~, ~] = xlsread('result/a_mat.xlsx', 'A1:F100');
% [data{8}, ~, ~] = xlsread('result/OC_mat.xlsx', 'A1:F100');
% [data{9}, ~, ~] = xlsread('result/Mcc_mat.xlsx', 'A1:F100');
% [data{10}, ~, ~] = xlsread('result/IA_mat.xlsx', 'A1:F100');
% [data{11}, ~, ~] = xlsread('result/CEM_mat.xlsx', 'A1:F100');
% [data{12}, ~, ~] = xlsread('result/ICC_mat.xlsx', 'A1:F100');
% [data{13}, ~, ~] = xlsread('result/pi_mat.xlsx', 'A1:F100');
% [data{14}, ~, ~] = xlsread('result/kappa_mat.xlsx', 'A1:F100');
% [data{15}, ~, ~] = xlsread('result/Gkappa_mat.xlsx', 'A1:F100');
% [data{16}, ~, ~] = xlsread('result/AC_mat.xlsx', 'A1:F100');
% 
%% Calculate the average of each column of each array
% averages = zeros(16, 6);
% for i = 1:16
%% Calculate the average of each column of the current array
%     averages(i, :) = mean(data{i}, 1);
% end
% 
%% show results
% disp(averages);
%% to four decimal places
% averages = round(averages, 4);
% addpath("utils\")
% metcinames=get_metricNames(1)'
%averages = [metcinames, num2cell(averages)]; % horizontal splicing
% 
%% Export to Excel
% xlswrite('result/averages.xlsx', averages);