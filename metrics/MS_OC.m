function [ Oc ] = MS_OC(x,y,K,a,b)
% Calculate OC_a,b value between sequences x and y, IJ11
% K is the number of categories
% Input:
% Generate confusion matrix CM between sequences x and y
CM = GetCM(x,y,K);
N = 0; % Total count
M = 0; % Off-diagonal weighted sum, where weights are powers of absolute differences
M_matrix = zeros(K,K);  % Off-diagonal matrix
for i = 1:K
    for j = 1:K
        if CM(i,j) ~= 0
            N = N + CM(i,j);
            M = M + CM(i,j)*(abs(i-j)^a);
            M_matrix(i,j) = CM(i,j)*(abs(i-j)^a);
        end
    end
end
b = b/(N*(K-1));

dp = zeros(K,K);  % Path weight cumulative sum
dp(1,1) = CM(1,1);

error = zeros(K,K);
error(1,1) = M_matrix(1,1);

Oc = zeros(K,K);
Oc(1,1) = 1 - dp(1,1) / (N+M^(1/a)) + b * error(1,1);


% Initialize first row and first column
for i = 2:K
    dp(i,1) = dp(i-1,1) + CM(i,1);
    error(i,1) = error(i-1,1)+M_matrix(i,1);
    Oc(i,1) = 1 - dp(i,1) / (N + M^(1/a)) + b * error(i,1);
    dp(1,i) = dp(1,i-1) + CM(1,i);
    error(1,i) = error(1,i-1)+M_matrix(1,i);
    Oc(1,i) = 1 - dp(1,i) / (N + M^(1/a)) + b * error(1,i);
end
% Calculate remaining dynamic programming table to obtain Oc values
for i = 2:K
    for j = 2:K
        % Calculate path weights for three possible transitions
         path1 = Oc(i-1,j);
         path2 = Oc(i,j-1);
         path3 = Oc(i-1,j-1);
            
        % Update dynamic programming table to calculate Oc value
         [~, index] = min([path1, path2, path3]);
         if index == 1
             dp(i,j) = dp(i-1,j) + CM(i,j);
             error(i,j) = error(i-1,j) +M_matrix(i,j);
             Oc(i,j) = 1 - dp(i,j) / (N + M^(1/a)) + b * error(i,j);
         elseif index == 2
             dp(i,j) = dp(i,j-1) + CM(i,j);
             error(i,j) = error(i,j-1) +M_matrix(i,j);
             Oc(i,j) = 1 - dp(i,j) / (N + M^(1/a)) + b * error(i,j);
         else
             dp(i,j) = dp(i-1,j-1) + CM(i,j);
             error(i,j) = error(i-1,j-1) +M_matrix(i,j);
             Oc(i,j) = 1 - dp(i,j) / (N + M^(1/a)) + b * error(i,j);
         end
     end
end

Oc = Oc(K,K);

end