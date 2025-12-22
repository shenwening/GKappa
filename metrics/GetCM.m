function [ CM ] = GetCM( x,y,N)
% Generate confusion matrix function
% x: First sequence
% y: Second sequence  
% N: Range of values from 1 to N (positive integers)

CM = zeros(N, N);

for i = 1:length(x)
    % Increment the count at position (x(i), y(i)) in the confusion matrix
    CM(x(i), y(i)) = CM(x(i), y(i)) + 1;
end
end