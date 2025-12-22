addpath('D:\matlibprojects\tmpOC_new')
addpath('..\utils\');
% outputFilePath = "data\sim\test_value_sim_rho_c_50.xlsx";
% outputFilePath = "data\sim\test_value_sim_rho_c_20.xlsx";
% outputFilePath = "data\sim\test_value_sim_rho_c_90.xlsx";

outputFilePath = "data\test\test_value_sim_rho_incre_90.xlsx";

% outputFilePath_2 = "D:\matlibprojects\tmpOC_new\property_test\data\test_value_x2.xlsx";

bool_first=true;
metricNames=get_metricNames(2)

% lable_3_file='D:\matlibprojects\tmpOC_new\property_test\data\sem_2016\sem2016_A_train.xlsx';
% lable_5_file='D:\matlibprojects\tmpOC_new\property_test\data\sem_2016\sem2016_C_train.xlsx';

% lable_3_data=get_xlsx_columdata(lable_3_file);
% lable_5_data=get_xlsx_columdata(lable_5_file);

num_length=1000
num_iters=100;

rhos=[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9];
rhos=[0.51, 0.52, 0.53, 0.54, 0.55, 0.56, 0.57, 0.58, 0.59];
 % rhos=[0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19];
rhos=[0.81, 0.82, 0.83, 0.84, 0.85, 0.86, 0.87, 0.88, 0.89];
data = zeros(length(rhos), length(metricNames));
lable_3_data = generate_sequence(num_length, 1, 3);
lable_5_data = data_3scals_5scals(lable_3_data);
% lable_10_data=generate_sequence(num_length, 1,10 );
% lable_5_data=data_10scals_5scals(lable_10_data);
for i = 1:length(rhos)
    mean_data= zeros(num_iters, length(metricNames));
    for j=1:num_iters
        %Generate random sequence

        rh0 = rhos(i);
           
        disturbed_lable_5_data =perturb_by_circular_increment(lable_5_data, rh0,1,5);
         % disturbed_lable_5_data =  disturb_sequence(lable_10_data , rh0);
        % disturbed_lable_5_data =  random_disturb(lable_5_data , rh0);
        mean_data(j, :)=get_test_value_diff_m_data(lable_3_data, disturbed_lable_5_data, 1, 3, 1, 5, 2);
        % mean_data(j, :) = get_test_value_diff_m_data(lable_5_data, disturbed_lable_5_data, 1, 5, 1, 10, 2);
    end
    i
    %Calculate test value
    data(i, :) = mean(mean_data, 1);
end


% lable_3_data=lable_3_data;
% lable_5_data=lable_5_data;
% data=get_test_value_diff_m_data(lable_3_data,lable_5_data,1,6,1,10,1);



if bool_first
    writecell(metricNames, outputFilePath, 'WriteMode', 'overwrite');
end

writematrix(data, outputFilePath, 'WriteMode', 'append');
function perturbedArray = perturb_by_circular_increment(inputArray, perturbRatio, categoryRangeStart, categoryRangeEnd)
    %Perturb some elements in the array by adding 1 in a loop
    %parameter:
    %inputArray - a one-dimensional array
    %perturbRatio - perturbation ratio (between 0 and 1)
    %categoryRangeStart - category starting range
    %categoryRangeEnd - Category end range
    %return:
    %perturbedArray - the perturbed array
    %
    %Perturbation rules: 1->2, 2->3, ..., maximum value->minimum value (cyclic)

    %Validate input parameters
    if perturbRatio < 0 || perturbRatio > 1
        error('扰动比率必须在0到1之间');
    end

    if categoryRangeStart >= categoryRangeEnd
        error('类别起始范围必须小于结束范围');
    end

    %Calculate the number of elements that need to be perturbed
    numElements = length(inputArray);
    numToPerturb = round(numElements * perturbRatio);

    %Randomly select the index to be perturbed
    perturbIndices = randperm(numElements, numToPerturb);

    %Create perturbed array
    perturbedArray = inputArray;

    %Perform a cyclic increment operation on the selected element.
    for i = 1:numToPerturb
        idx = perturbIndices(i);
        currentValue = inputArray(idx);

        %Only perturb values ​​within the specified range
        if currentValue >= categoryRangeStart && currentValue <= categoryRangeEnd
            if currentValue == categoryRangeEnd
                perturbedArray(idx) = categoryRangeEnd-1;  %Loop back to starting value
            else
                perturbedArray(idx) = currentValue + 1;    %Normal plus 1
            end
        end
    end
end

function data= data_3scals_5scals(lable_3_data)
    len= length(lable_3_data);
    data = zeros(1, len);
    for i = 1:len
        if lable_3_data(i) == 1
            data(i) = 1;
        elseif lable_3_data(i) == 2
            data(i) = 3;
        elseif lable_3_data(i) == 3
            data(i) = 5;
        end
    end
end

function data = data_10scals_5scals(lable_3_data)
    %DATA_3SCALS_5SCALS maps labels 1-10 to reduced values ​​1-5
    %Input parameters:
    %lable_3_data – a one-dimensional array containing integer labels from 1-10
    %Output parameters:
    %data - one-dimensional array, mapped result, rules:
    %          1/2 → 1, 3/4 → 2, 5/6 → 3, 7/8 → 4, 9/10 → 5
    %Exception handling: Values ​​other than 1-10 are mapped to NaN
    
    %Initialize the output array to keep the same dimensions as the input
    data = zeros(size(lable_3_data));
    
    %Iterate over each element to map
    for i = 1:length(lable_3_data)
        current_val = lable_3_data(i);
        
        %Judge mapping value according to rules
        if current_val == 1 || current_val == 2
            data(i) = 1;
        elseif current_val == 3 || current_val == 4
            data(i) = 2;
        elseif current_val == 5 || current_val == 6
            data(i) = 3;
        elseif current_val == 7 || current_val == 8
            data(i) = 4;
        elseif current_val == 9 || current_val == 10
            data(i) = 5;
        else
            %Outliers are marked as NaN to facilitate subsequent investigation.
            data(i) = NaN;
        end
    end
end



function disturbed_seq = disturb_sequence(seq, rh0)
    %Randomly perturb the sequence
    %enter:
    %seq: original sequence
    %rh0: Disturbance ratio (between 0-1)
    %Output:
    %disturbed_seq: disturbed sequence
    
    %copy original sequence
    disturbed_seq = seq;
    
    %Calculate the number of elements that need to be perturbed
    n = length(seq);
    num_disturb = round(n * rh0);
    
    %Get the maximum and minimum values ​​of a sequence
    max_val = max(seq);
    min_val = min(seq);
    
    %Randomly select locations for perturbation
    indices = randperm(n, num_disturb);
    
    %Disturb the selected position
    for i = indices
        current_val = seq(i);
        
        if current_val == min_val
            %If it is the minimum value, it can only be disturbed upward
            disturbed_seq(i) = current_val + 1;
        elseif current_val == max_val
            %If it is the maximum value, it can only be disturbed downward
            disturbed_seq(i) = current_val - 1;
        else
            %Randomly select up or down perturbations
            if rand < 0.5
                disturbed_seq(i) = current_val + 1;
            else
                disturbed_seq(i) = current_val - 1;
            end
        end
    end
end

function disturbed_seq = random_disturb(seq, rh0)
    %Randomly perturb the sequence
    %Input parameters:
    %seq: the original sequence to be perturbed
    %rh0: Disturbance ratio (between 0-1)
    %Output parameters:
    %disturbed_seq: disturbed sequence
    
    %Input check
    validateattributes(seq, {'numeric'}, {'vector'});
    validateattributes(rh0, {'numeric'}, {'scalar', '>=', 0, '<=', 1});
    
    %copy original sequence
    disturbed_seq = seq(:)';  %Make sure it is a row vector
    
    %Calculate the number of disturbances
    n = length(seq);
    num_disturb = round(n * rh0);
    
    %Get the range of possible values ​​for a sequence (integer)
    possible_values = min(seq):max(seq);
    
    %Randomly select perturbation locations
    disturb_idx = randperm(n, num_disturb);
    
    %Perturb the selected position
    for i = disturb_idx
        current_val = disturbed_seq(i);
        %Randomly select one of the possible values, excluding the current value
        possible_new_values = possible_values(possible_values ~= current_val);
        if ~isempty(possible_new_values)
            %Randomly choose a new value
            disturbed_seq(i) = possible_new_values(randi(length(possible_new_values)));
        end
    end
end


function seq = generate_sequence(num, begin_val, max_val)
    %Generate a sequence of specified length and range
    %Input parameters:
    %num: sequence length
    %begin_val: sequence minimum value
    %max_val: maximum value of sequence
    %Output parameters:
    %seq: generated sequence
    
    %Parameter validation
    validateattributes(num, {'numeric'}, {'positive', 'integer', 'scalar'});
    validateattributes(begin_val, {'numeric'}, {'scalar'});
    validateattributes(max_val, {'numeric'}, {'scalar', '>', begin_val});
    
    %Generate sequence
    seq = randi([begin_val, max_val], 1, num);
end