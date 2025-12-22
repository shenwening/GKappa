addpath('D:\matlibprojects\tmpOC_new')
outputFilePath = "D:\matlibprojects\tmpOC_new\property_test\data\diff\test_value_01.xlsx";
addpath('utils\');
bool_first=true
metricNames=get_metricNames(5);

%--------------------------------------------------Sample data test--------------------------------

a=[8 8 9 8 9 8];
b=[8 7 9 8 9 8];
c=[3 4 9 6 8 5];
d=[2 1 8 1 7 3];

value1=get_test_value_data(a,b,9)
value2=get_test_value_data(c,d,9)


if bool_first
    writecell(metricNames, outputFilePath, 'WriteMode', 'overwrite');
end

writematrix(value1, outputFilePath, 'WriteMode', 'append');
writematrix(value2, outputFilePath, 'WriteMode', 'append');

% function perturbedSeq = perturbSequence(sequence, n)
%% perturbSequence randomly adds or subtracts 1 to each element in the input sequence (keep within the range [1, n])
%      %
%% input:
%% sequence - original sequence (row or column vector, elements must be in [1, n])
%% n - element upper limit value
%      %
%% output:
%% perturbedSeq - perturbed sequence
 
%      if ~isvector(sequence)
%error('Input sequence must be a vector');
%      end
 
%      if any(sequence < 1 | sequence > n)
%error('All elements in the sequence must be in the range [1, n]');
%      end
 
%      perturbedSeq = zeros(size(sequence));
 
%      for i = 1:length(sequence)
%          x = sequence(i);
 
%% Randomly select +1 or -1
%          if rand > 0.5
%% try to add 1
%              if x + 1 <= n
%                  perturbedSeq(i) = x + 1;
%              else
%perturbedSeq(i) = x; % If 1 cannot be added, keep the original value
%              end
%          else
%% try to subtract 1
%              if x - 1 >= 1
%                  perturbedSeq(i) = x - 1;
%              else
%perturbedSeq(i) = x; % If it cannot be reduced by 1, keep the original value
%              end
%          end
%      end
%  end


% outputArray=generateSpecialArray(startVal, endVal)
% sequence_1a = generateSequence_proportions(scale, outputArray, numSamples)
% 
% sequence_1b = generateCorrelatedSequence(startVal, endVal, sequence_1a, rho_a)
% 
% sequence_2a = generateSequence(startVal, endVal, numSamples)'
% sequence_2b = generateCorrelatedSequence(startVal, endVal, sequence_2a, rho_b)
% 
% 
% value1=get_test_value_data(sequence_1a,sequence_1b,endVal)
% value2=get_test_value_data(sequence_2a,sequence_2b,endVal)
% 
% if bool_first
%     writecell(metricNames, outputFilePath, 'WriteMode', 'overwrite');
% end
% 
% writematrix(value1, outputFilePath, 'WriteMode', 'append');
% writematrix(value2, outputFilePath, 'WriteMode', 'append');



%% --------------------------------------------------Simulated data experiment----------------------------------------------------------------

num_iters = 10000; %Number of experiments
metricNames = get_metricNames(5);
num_metrics = length(metricNames);
result = zeros(1, num_metrics);
startVal = 1;
endVal = 10;
numSamples = 200;
scale = startVal:endVal;
rho_a=0.9;
rho_b=0.2;

%% Create a progress bar window
%hWaitBar = waitbar(0, 'Start experiment...', 'Name', 'Experiment progress bar');

for iter = 1:num_iters
    %Update progress bar
    % if mod(iter, 100) == 0
    %% Update the progress bar every 10 times
    %waitbar(iter / num_iters, hWaitBar, sprintf('Processing: %d / %d', iter, num_iters));
    %     % result
    % end
    if mod(iter, 1000) == 0
        %Update the progress bar every 10 times
        %waitbar(iter / num_iters, hWaitBar, sprintf('Processing: %d / %d', iter, num_iters));
        result
    end

    outputArray=generateSpecialArray_num(startVal, endVal, 4);
    sequence_1a = generateSequence_proportions(scale, outputArray, numSamples);

    sequence_1b = generateCorrelatedSequence(startVal, endVal, sequence_1a, rho_a);

    sequence_2a = generateSequence(startVal, endVal, numSamples)';
    sequence_2b = generateCorrelatedSequencerand(startVal, endVal, sequence_2a, rho_b);


    values1=get_test_value_data(sequence_1a,sequence_1b,endVal);
    values2=get_test_value_data(sequence_2a,sequence_2b,endVal);

    % values1 = get_test_value_data(sequence, newSeq2, 100);
    % values2 = get_test_value_data(sequence, newSeq1, 100);

    for i = 1:length(values1)
        if values1(i) > values2(i)
            result(i) = result(i) + 1;
        end
        if i==15 &&  values1(i) < values2(i)
            outputArray
            sequence_1a
            sequence_1b
            sequence_2a
            sequence_2b
            values1
            values2
        end

    end

end

%% Close the progress bar
% close(hWaitBar);
result
%Write results to Excel
if bool_first
    writecell(metricNames, outputFilePath, 'WriteMode', 'overwrite');
end

writematrix(result, outputFilePath, 'WriteMode', 'append');