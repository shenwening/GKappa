function [trueLabels, predictedLabels] = extractSequencesFromConfusion(confMat)
% Extract simulated original sequences from confusion matrix
% Note: Since confusion matrix is a statistical result, it is impossible to completely restore the original sequence,
% This function generates sequences that conform to the statistical characteristics of the confusion matrix
%
% Inputs:
%   confMat - Confusion matrix (n×n matrix)
%
% Outputs:
%   trueLabels - Simulated true label sequence
%   predictedLabels - Simulated predicted label sequence

    % Check input parameters
  
    
    if any(confMat < 0) | any(mod(confMat, 1) ~= 0)
        error('Confusion matrix elements must be non-negative integers');
    end
    
    % Get number of classes
    nClasses = size(confMat, 1);
    
    % Use default numeric labels
    labelNames = 1:nClasses;
    
    % Generate sequences
    trueLabels = [];
    predictedLabels = [];
    
    % Build sequences according to confusion matrix
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