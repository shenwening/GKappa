
function [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat)
%Extract the simulated original sequence from the confusion matrix
%Note: Since the confusion matrix is ​​a statistical result, the original sequence cannot be completely restored.
%This function generates a sequence that conforms to the statistical properties of the confusion matrix
%
%enter:
%confMat - confusion matrix (n×n matrix)
%
%Output:
%trueLabels - simulated true label sequence
%predictedLabels - simulated sequence of predicted labels

    %Check input parameters
  
    
    if any(confMat < 0)  any(mod(confMat, 1) ~= 0)
        error('混淆矩阵元素必须是非负整数');
    end
    
    %Get the number of categories
    nClasses = size(confMat, 1);
    
    %Use default number labels
    labelNames = 1:nClasses;
    
    %Generate sequence
    trueLabels = [];
    predictedLabels = [];
    
    %Build a sequence based on a confusion matrix
    for i = 1:nClasses
        for j = 1:nClasses
            count = confMat(i, j);
            if count > 0
                trueLabels = [trueLabels; repmat(labelNames(i), count, 1)];
                predictedLabels = [predictedLabels; repmat(labelNames(j), count, 1)];
            end
        end
    end
end


function [trueLabels, predictedLabels] = extractSequencesFromGeneralConfusion(confMat)
%Extract the simulated original sequence from the general confusion matrix
%Supports NxM matrix, where N is the number of real categories and M is the number of predicted categories
%
%enter:
%confMat - confusion matrix (N×M matrix)
%Rows represent true labels, columns represent predicted labels
%
%Output:
%trueLabels - simulated true label sequence
%predictedLabels - simulated sequence of predicted labels

    %Check input parameters
    if any(confMat < 0, 'all') || any(mod(confMat, 1) ~= 0, 'all')
        error('混淆矩阵元素必须是非负整数');
    end
    
    %Get the number of rows and columns
    [nTrueClasses, nPredClasses] = size(confMat);
    
    %Use default number labels
    trueLabelNames = 1:nTrueClasses;
    predLabelNames = 1:nPredClasses;
    
    %Initialize output sequence
    trueLabels = [];
    predictedLabels = [];
    
    %Build a sequence based on a confusion matrix
    for i = 1:nTrueClasses
        for j = 1:nPredClasses
            count = confMat(i, j);
            if count > 0
                trueLabels = [trueLabels; repmat(trueLabelNames(i), count, 1)];
                predictedLabels = [predictedLabels; repmat(predLabelNames(j), count, 1)];
            end
        end
    end
end

%Verification results
% reconstructedConfMat = confusionmat(trueLabels, predictedLabels);
%disp('Original confusion matrix:');
% disp(confMat);
%disp('Reconstructed confusion matrix:');
% disp(reconstructedConfMat);



% confMat = [0 6 4 3 ;
%            3 0 4 0 ;
%            3 0 4 0 ;
%            0 6 4 3 ];
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromGeneralConfusion(confMat);
% 
% unique(trueLabels);
% unique(predictedLabels);
% 
% value1= get_test_value_data(trueLabels,predictedLabels,5)
% 
% 
% confMat = [0 6 4 3 ;
%            3 20 4 0 ;
%            3 20 4 0 ;
%            0 6 4 3 ];
% 
% % confMat = [0 0 0 0 ;
% %            0 2 0 0 ;
% %            0 2 0 0;
% %            0 0 0 0];
% 
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromGeneralConfusion(confMat);
% 
% unique(trueLabels);
% unique(predictedLabels);
% 
% value2= get_test_value_data(trueLabels,predictedLabels,5)
% outputFilePath = "data\ICC\test_value1.xlsx";
% 
% bool_first=true;
% metricNames=get_metricNames(1);
% if bool_first
%     writecell(metricNames, outputFilePath, 'WriteMode', 'overwrite');
% end
% 
% writematrix( value1, outputFilePath, 'WriteMode', 'append');
% writematrix( value2, outputFilePath, 'WriteMode', 'append');
% % writematrix( value3, outputFilePath, 'WriteMode', 'append');

%% Create a 3x3 confusion matrix
% confMat = [7  4   1;
%            4  0  1;
%            1   5   6];
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% 
% 
% value1= get_test_value_data(trueLabels,predictedLabels,3)
% 
% confMat = [7   4   1;
%            0   4  1;
%            1   5   6];
% 
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% 
% value2= get_test_value_data(trueLabels,predictedLabels,3)


%Create a 3x3 confusion matrix
confMat = [7  4   1;
           4  0  1;
           1   5   6];

%Call function reconstruction sequence
[trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);


value1= get_test_value_data(trueLabels,predictedLabels,3)

confMat = [7   4   1;
           4   21  1;
           1   5   6];


%Call function reconstruction sequence
[trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);

value2= get_test_value_data(trueLabels,predictedLabels,3)

confMat = [7   4   1;
           4   71  1;
           1   5   6];


%Call function reconstruction sequence
[trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);

value3= get_test_value_data(trueLabels,predictedLabels,3)
outputFilePath = "data\ICC\test_value1.xlsx";

bool_first=true;
metricNames=get_metricNames(1);
if bool_first
    writecell(metricNames, outputFilePath, 'WriteMode', 'overwrite');
end

writematrix( value1, outputFilePath, 'WriteMode', 'append');
writematrix( value2, outputFilePath, 'WriteMode', 'append');
writematrix( value3, outputFilePath, 'WriteMode', 'append');

% confMat = [700  400   100;
%            400   0     100;
%            100   500   600];
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% 
% 
% value1= get_test_value_data(trueLabels,predictedLabels,3)
% 
% confMat = [700 400 100;
%            400 2100 100;
%            100   500 600];
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% 
% 
% value2= get_test_value_data(trueLabels,predictedLabels,3)
% 
% confMat = [7000  4000   1000;
%            4000   0     1000;
%            1000   5000   6000];
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% 
% 
% value1= get_test_value_data(trueLabels,predictedLabels,3)
% 
% confMat = [7000 4000 1000;
%            4000 21000 1000;
%            1000   5000 6000];
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% 
% 
% value2= get_test_value_data(trueLabels,predictedLabels,3)


% confMat = [1 2 0 0 0;
%            1 4 1 0 0;
%            0 5 0 7 0;
%            0 0 0 5 1;
%            0 0 0 1 2];
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% value1= get_test_value_data(trueLabels,predictedLabels,5)
% true_mean=mean(trueLabels)
% predicted_mean=mean(predictedLabels)
% true_var=var(trueLabels)
% predicted_var=var(predictedLabels)
%% Covariance The covariance of xi and yi of the two sequences s12
% s12=cov(trueLabels,predictedLabels)
% confMat = [1 2 0 0 0;
%            1 4 1 0 0;
%            0 5 10 7 0;
%            0 0 0 5 1;
%            0 0 0 1 2;];
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% value2= get_test_value_data(trueLabels,predictedLabels,5)
% true_mean=mean(trueLabels)
% predicted_mean=mean(predictedLabels)
% true_var=var(trueLabels)
% predicted_var=var(predictedLabels)
%% Covariance The covariance of xi and yi of the two sequences s12
% s12=cov(trueLabels,predictedLabels)

% confMat = [1 2 0 0 0;
%            1 4 1 0 0;
%            0 5 10 7 0;
%            0 0 0 90 1;
%            0 0 0 1 2;];
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% value2= get_test_value_data(trueLabels,predictedLabels,5)
% true_mean=mean(trueLabels)
% predicted_mean=mean(predictedLabels)
% true_var=var(trueLabels)
% predicted_var=var(predictedLabels)
%% Covariance The covariance of xi and yi of the two sequences s12
% s12=cov(trueLabels,predictedLabels)

% 
% outputFilePath = "data\ICC\test_value2.xlsx";
% 
% bool_first=true;
% metricNames=get_metricNames(1);
% if bool_first
%     writecell(metricNames, outputFilePath, 'WriteMode', 'overwrite');
% end
% 
% writematrix( value1, outputFilePath, 'WriteMode', 'append');
% writematrix( value2, outputFilePath, 'WriteMode', 'append');
% writematrix( value3, outputFilePath, 'WriteMode', 'append');


%---------------------------------------------------------

% confMat = [1 2 0 0 ;
%            3 0 3 0 ;
%            0 3 0 3 ;
%            0 0 1 2
%            ];
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% value1= get_test_value_data(trueLabels,predictedLabels,4)
% 
% confMat = [1 2 0 0 ;
%            0 3 3 0 ;
%            0 0 3 3 ;
%            0 0 1 2
%            ];
% 
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% value2= get_test_value_data(trueLabels,predictedLabels,4)



% confMat = [1 2 0 0 ;
%            1 1 3 1 ;
%            0 3 1 2 ;
%            1 0 2 0
%            ];
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% value1= get_test_value_data(trueLabels,predictedLabels,4)
% 
% confMat = [1 2 0 0 ;
%            1 3 1 1 ;
%            0 1 3 2 ;
%            1 0 2 0
%            ];
% 
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% value2= get_test_value_data(trueLabels,predictedLabels,4)


% confMat = [1  2  0;
%            0  2  10;
%            2   1   0];
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% 
% 
% value1= get_test_value_data(trueLabels,predictedLabels,3)
% 
% confMat = [1  2  0;
%            0  10  2;
%            2   1 0];
% 
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% 
% value2= get_test_value_data(trueLabels,predictedLabels,3)











confMat = [1  15 1;
           3  0  3;
           2  3  2];

%Call function reconstruction sequence
[trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
data1=zeros(length(trueLabels),2)
data1(:,1)=trueLabels
data1(:,2)=predictedLabels


value1= get_test_value_data(trueLabels,predictedLabels,3)
true_mean=mean(trueLabels)
predicted_mean=mean(predictedLabels)
true_var=var(trueLabels)
predicted_var=var(predictedLabels)

confMat = [1 1  1;
           3 17 3;
           2 0  2];

%Call function reconstruction sequence
[trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
data2=zeros(length(trueLabels),2)
data2(:,1)=trueLabels
data2(:,2)=predictedLabels
value2= get_test_value_data(trueLabels,predictedLabels,3)
true_mean=mean(trueLabels)
predicted_mean=mean(predictedLabels)
true_var=var(trueLabels)
predicted_var=var(predictedLabels)
%Covariance Covariance of xi and yi of two sequences s12
s12=cov(trueLabels,predictedLabels)

outputFilePath = "data\ICC\test_value3.xlsx";

bool_first=true;
metricNames=get_metricNames(1);
if bool_first
    writecell(metricNames, outputFilePath, 'WriteMode', 'overwrite');
end

writematrix( value1, outputFilePath, 'WriteMode', 'append');
writematrix( value2, outputFilePath, 'WriteMode', 'append');
writematrix( value3, outputFilePath, 'WriteMode', 'append');


% confMat = [0 6 4 3 0;
%            3 0 4 0 1;
%            4 6 0 5 3 ;
%            3 0 4 0 1;
%            0 6 4 3 0];
% 
%Call function reconstruction sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% data1=zeros(length(trueLabels),2)
% data1(:,1)=trueLabels
% data1(:,2)=predictedLabels
% 
% 
% value1= get_test_value_data(trueLabels,predictedLabels,5)
% true_mean=mean(trueLabels)
% predicted_mean=mean(predictedLabels)
% true_var=var(trueLabels)
% predicted_var=var(predictedLabels)
% 
% confMat = [2 1 0 1 3;
%            0 3 5 4 0;
%            0 0 22 0 0;
%            0 3 5 4 0;
%            2 1 0 1 3];
% 
%Call function reconstruction sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% data2=zeros(length(trueLabels),2)
% data2(:,1)=trueLabels
% data2(:,2)=predictedLabels
% value2= get_test_value_data(trueLabels,predictedLabels,5)
% true_mean=mean(trueLabels)
% predicted_mean=mean(predictedLabels)
% true_var=var(trueLabels)
% predicted_var=var(predictedLabels)
%Covariance Covariance of xi and yi of two sequences s12
% s12=cov(trueLabels,predictedLabels)
% 
% outputFilePath = "data\ICC\test_value4.xlsx";
% 
% bool_first=true;
% metricNames=get_metricNames(1);
% if bool_first
%     writecell(metricNames, outputFilePath, 'WriteMode', 'overwrite');
% end
% 
% writematrix( value1, outputFilePath, 'WriteMode', 'append');
% writematrix( value2, outputFilePath, 'WriteMode', 'append');
% writematrix( value3, outputFilePath, 'WriteMode', 'append');



% confMat = [1  2  0;
%            0  2  3;
%            2  1  0];
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% data1=zeros(length(trueLabels),2);
% data1(:,1)=trueLabels;
% data1(:,2)=predictedLabels;
% 
% 
% value1= get_test_value_data(trueLabels,predictedLabels,3)
% % true_mean=mean(trueLabels);
% % predicted_mean=mean(predictedLabels);
% % true_var=var(trueLabels);
% % predicted_var=var(predictedLabels);
% 
% confMat = [1 2  0;
%            0 20 3;
%            2 1  0];
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% % data2=zeros(length(trueLabels),2);
% % data2(:,1)=trueLabels;
% % data2(:,2)=predictedLabels;
% value2= get_test_value_data(trueLabels,predictedLabels,3)
% 
% confMat = [1 2  0;
%            0 20 4;
%            1 1  0];
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% % data2=zeros(length(trueLabels),2);
% % data2(:,1)=trueLabels;
% % data2(:,2)=predictedLabels;
% value3= get_test_value_data(trueLabels,predictedLabels,3)
% 
% outputFilePath = "data\ICC\test_value5.xlsx";
% 
% bool_first=true;
% metricNames=get_metricNames(1);
% if bool_first
%     writecell(metricNames, outputFilePath, 'WriteMode', 'overwrite');
% end
% 
% writematrix( value1, outputFilePath, 'WriteMode', 'append');
% writematrix( value2, outputFilePath, 'WriteMode', 'append');



% confMat = [1  2  0;
%            0  2  1;
%            2  1  0];
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% data1=zeros(length(trueLabels),2);
% data1(:,1)=trueLabels;
% data1(:,2)=predictedLabels;
% 
% 
% value1= get_test_value_data(trueLabels,predictedLabels,3)
% % true_mean=mean(trueLabels);
% % predicted_mean=mean(predictedLabels);
% % true_var=var(trueLabels);
% % predicted_var=var(predictedLabels);
% 
% confMat = [1 2  0;
%            0 100 1;
%            2 1  0];
% 
%% Call the function to reconstruct the sequence
% [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat);
% % data2=zeros(length(trueLabels),2);
% % data2(:,1)=trueLabels;
% % data2(:,2)=predictedLabels;
% value2= get_test_value_data(trueLabels,predictedLabels,3)