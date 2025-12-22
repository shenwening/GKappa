function [trueLabels, predictedLabels] = extractSequencesFromGeneralConfusion(confMat)
% Extract simulated original sequences from general confusion matrix
% Supports NxM matrices, where N is the number of true classes and M is the number of predicted classes
%
% Inputs:
%   confMat - Confusion matrix (N×M matrix)
%             Rows represent true labels, columns represent predicted labels
%
% Outputs:
%   trueLabels - Simulated true label sequence
%   predictedLabels - Simulated predicted label sequence

    % Check input parameters
    if any(confMat < 0, 'all') || any(mod(confMat, 1) ~= 0, 'all')
        error('Confusion matrix elements must be non-negative integers');
    end
    
    % Get row and column counts
    [nTrueClasses, nPredClasses] = size(confMat);
    
    % Use default numeric labels
    trueLabelNames = 1:nTrueClasses;
    predLabelNames = 1:nPredClasses;
    
    % Initialize output sequences
    trueLabels = [];
    predictedLabels = [];
    
    % Build sequences according to confusion matrix
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