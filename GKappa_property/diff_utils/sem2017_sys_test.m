
%Calculate the consistency of b and C in the sem2017 data set
%If the results of sem2017 two-scale and five-scale are consistent, the results of B and C are considered to be consistent.
addpath('D:\matlibprojects\tmpOC_new')

addpath(strcat('..\utils\'));
bool_first = true;
metricNames = get_metricNames(1)
%Random sampling quantity
sample_size =200;
%Repeat times
num_iters = 100;
%Category start range
category_start = 1;
%category end range
category_end = 5;
%Select disturbance method 1 2 3 4 5
perturb_method = 1;
pertub_method_string=["most_frequent","random_category","circular_increment","circular_shift","random_average"];
  % 2     2     4     3     2     2     3     3     2     3
  %3     3     5     4     3     3     4     4     3     4
%Disturbance range array
perturb_range = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9,1];

for perturb_method = 1:5
    outputFilePath = sprintf('data\\sem_2017_C_A_Synthetic_%s_%d_num%d.xlsx',pertub_method_string(perturb_method) ,sample_size, num_iters);
    % folder_path = strcat('../data/sem_2017_C/raw/sem2017_english_A_C_merged.xlsx');
    folder_path = strcat('D:\matlibprojects\tmpOC_new\property_test\data\sem_2017_C\data\BB_twtr_c_output.xlsx');

    gold_data=read_excel_first_two_columns(folder_path);
    num_files=length(perturb_range)

    all_data = zeros(1, length(metricNames));
    %All test data sets
    k=0;

    for iter = 1:num_iters
        %Extract random test data
        rand_indices = randperm(length(gold_data(:, 2)), sample_size);
        gold_3_lable=gold_data(rand_indices, 1);
        gold_5_lable=gold_data(rand_indices, 2);
        all_test_data=zeros(sample_size, length(perturb_range));

        for i = 1:length(perturb_range)
            if perturb_method == 1
                perturbed_data = perturb_to_most_frequent(gold_5_lable, perturb_range(i));
            elseif perturb_method == 2
                perturbed_data = perturb_to_random_category(gold_5_lable, perturb_range(i), category_start,category_end);
            elseif perturb_method == 3
                perturbed_data = perturb_by_circular_increment(gold_5_lable, perturb_range(i), category_start,category_end);
            elseif perturb_method == 4
                perturbed_data = perturb_by_circular_shift(gold_5_lable, perturb_range(i), category_start,category_end,3);
            elseif perturb_method == 5
                perturbed_data = perturb_by_random_average(gold_3_lable, perturb_range(i),category_start,category_end);
            else
                error('无效的扰动方法');
            end
            all_test_data(:, i) = perturbed_data;
        end
        %Get file data

        disp(['迭代次数: ', num2str(iter)]);
        %Parallelize outer loop
        for  i = 1:num_files
            i;
            for j = i+1:num_files
                %Calculate test value
                value_a_3_3 =MAE_US(all_test_data(:, i), gold_5_lable, length(metricNames));
                value_a_5_3 = get_test_value_diff_m_data(all_test_data(:, i),gold_3_lable,  1, 5, 1, 3, 1);
                value_b_3_3 = MAE_US(all_test_data(:, j), gold_5_lable,length(metricNames) );
                value_b_5_3 = get_test_value_diff_m_data(all_test_data(:, j),gold_3_lable,  1, 5, 1, 3, 1);

                %update all_data
                local_all_data = zeros(1, length(metricNames));
                for m = 1:length(metricNames)
                    flag = 0;
                    if value_a_3_3(m) >= value_b_3_3(m)
                        if value_a_5_3(m) >= value_b_5_3(m)
                            local_all_data(m) = local_all_data(m) + 1;
                            flag =1;
                        end
                    elseif value_a_3_3(m) < value_b_3_3(m)
                        if value_a_5_3(m) < value_b_5_3(m)
                            local_all_data(m) = local_all_data(m) + 1;
                            flag =1;
                        end
                    end
                    % if m==15 && flag==0
                    %disp("Inconsistent data")
                    %     a_5_5=value_a_3_3(15)
                    %    a_5_3= value_a_5_3(15)
                    %     b_5_5=value_b_3_3(15)
                    %     b_5_3=value_b_5_3(15)
                    %     CMa_5 = CM_GK(all_test_data(:, i),  gold_5_lable, 1, 5, 1, 5)
                    %     CMa_3= CM_GK(all_test_data(:, i),gold_3_lable,  1, 5, 1, 3)
                    %     CMb_5 = CM_GK(all_test_data(:, j), gold_5_lable, 1, 5, 1, 5)
                    %     CMb_3 = CM_GK(all_test_data(:, j),gold_3_lable,  1, 5, 1, 3)
                    %     % fprintf("sampled_A = %s\n", mat2str(sampled_A'));
                    %     % fprintf("sampled_B = %s\n", mat2str(sampled_B'));
                    %     % fprintf("sampled_gold_2_frist = %s\n", mat2str(sampled_gold_2_frist'));
                    %     % fprintf("sampled_gold_5_frist = %s\n", mat2str(sampled_gold_5_frist'));
                    %     % fprintf("sampled_gold_2_second = %s\n", mat2str(sampled_gold_2_second'));
                    %     % fprintf("sampled_gold_5_second = %s\n", mat2str(sampled_gold_5_second'));
                    % end
                end
                %Accumulated results
                all_data = all_data + local_all_data;
                k = k + 1;
            end
        end
    end

    %Calculate all_data_num
    metricNames
    all_data_num = all_data / k

    %Write results
    if bool_first
        writecell(metricNames, outputFilePath, 'WriteMode', 'overwrite');
    end
    writematrix(all_data, outputFilePath, 'WriteMode', 'append');
    writematrix(all_data_num, outputFilePath, 'WriteMode', 'append');

end

function CM = CM_GK( x,y,b1,e1,b2,e2 )
CM = zeros(e1,e2);
s = length(x);
for i=1:s
    CM(x(i),y(i)) = CM(x(i),y(i)) + 1;
end

% CM = CM./sum(sum(CM(:)));
end


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
        data = readmatrix(filePath, 'Range', 'B:C');
    catch ME
        error('读取Excel文件失败: %s', ME.message);
    end
end

function values=MAE_US(x,y,N)
    values = zeros(N,1);
    MAE_U=MS_MAEU(x,y);
    for i=1:N
        values(i)=MAE_U;
    end
end

function values=MAE_MS(x,y,b,e,N)
    values = zeros(N,1);
    MAE_U=MS_MAEM(x,y,b,e);
    for i=1:N
        values(i)=MAE_U;
    end
end

function mae_u = MS_MAEU(X,Y)
    %Function: According to the definition of SemEval-2017 Task 4 subtask C, calculate the macro mean absolute error (MAE^U)
    %Input parameters:
    %X - vector, predicted label of the sample
    %Y - vector, true label of the sample
    %Output parameters:
    %mae_u - macro mean absolute error
    if(length( X)~=length(Y))
        error("X and Y must have same length");
    end
    N=length(X);
    mae_u=sum(abs(X-Y))/N;
    mae_u=1-mae_u;
end


function mae_m = MS_MAEM(h, y,range_begin,range_end)
    %Function: According to the definition of SemEval-2017 Task 4 subtask C, calculate the macro mean absolute error (MAE^M)
    %Input parameters:
    %h - vector, predicted labels for samples
    %y - vector, true label of the sample
    %begin - category start range
    %end - category end range
    %
    %Output parameters:
    %mae_m - Macro mean absolute error (MAE^M), the smaller the value, the better the model's prediction performance for ordinal classification
    
    %-------------------------- 1. Input validity check (refer to the sample function format) --------------------------
    if length(h) ~= length(y)
        error("h (预测标签) and y (真实标签) must have same length");
    end
   
    mae_m=0;
    for i=range_begin:range_end
        h_mask=(h==i);
        hx=h(h_mask);
        hy=y(h_mask);
        N=length(hx);
        if(N==0)
            continue;
        end
        sum(abs(hx-hy))/N;
        mae_m=mae_m+sum(abs(hx-hy))/N;
    end

    mae_m=1 - mae_m/(range_end-range_begin+1);
   
end