function [ Rs ] = MS_Rs( X,Y )
% This function implements the calculation of Spearman rank correlation coefficient
% Column vectors
% Inputs:
%   X: input numerical sequence
%   Y: input numerical sequence
%
% Output:
%   Rs: correlation coefficient between two input numerical sequences X and Y


if length(X) ~= length(Y)
    error('Dimensions of two numerical sequences are not equal');
end

N = length(X); % Get the length of sequences
Xrank = zeros(1 , N); % Store rankings of elements in X
Yrank = zeros(1 , N); % Store rankings of elements in Y

% Calculate ranks for each element in Xrank
for i = 1 : N
    cont1 = 1; % Count of elements greater than the specific element
    cont2 = -1; % Count of elements equal to the specific element
    for j = 1 : N
        if X(i) < X(j)
            cont1 = cont1 + 1;
        elseif X(i) == X(j)
            cont2 = cont2 + 1;
        end
    end
    Xrank(i) = cont1 + mean(0 : cont2);
end

% Calculate ranks for each element in Yrank
for i = 1 : N
    cont1 = 1; % Count of elements greater than the specific element
    cont2 = -1; % Count of elements equal to the specific element
    for j = 1 : N
        if Y(i) < Y(j)
            cont1 = cont1 + 1;
        elseif Y(i) == Y(j)
            cont2 = cont2 + 1;
        end
    end
    Yrank(i) = cont1 + mean([0 : cont2]);
end

% Calculate Spearman rank correlation coefficient using rank difference sequences
Rs = corr(Xrank' , Yrank'); % Pearson correlation coefficient

end % End of mySpearman function