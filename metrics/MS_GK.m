function [ gk ] = MS_GK( x,y,b1,e1,b2,e2 )
%MS_GK Gkappa is a weighted Kappa coefficient
%MS_GETGCM Generate confusion matrix, even if the range of x and y are different
%   x,y represent rating sequences, b and e respectively indicate the range minimum and maximum values
% GCM is the generated confusion matrix
% Initialize a e1 x e2 matrix M with all elements set to 0
% For each element i in x and each element j in y
% Count the occurrence of pair (i,j) from x and y sequences
% Record the count value in the corresponding position of matrix M: M(x(i), y(j))
% Normalize each element of M by dividing by the total sum so that the sum of all elements equals 1
CM = zeros(e1,e2);
s = length(x);
for i=1:s
    CM(x(i),y(i)) = CM(x(i),y(i)) + 1;
end

CM = CM./sum(sum(CM(:)));

[Kx,Ky] = size(CM);  % Kx-number of categories for rater 1, Ky-number of categories for rater 2
vetU = ([1:Kx]-b1)/(Kx - b1);  % Normalize the first dimension
vetV = ([1:Ky]-b2)/(Ky - b2);  % Normalize the second dimension

matW = abs( repmat(vetU', 1, Ky)-repmat(vetV, Kx, 1)); % Normalized weight matrix

P = sum(CM, 2); % Row probabilities of confusion matrix
Q = sum(CM, 1);% Column probabilities of confusion matrix

matP = zeros(Kx,Ky);
for i=1:Kx
    for j=1:Ky
        matP(i,j) = P(i)*Q(j);
    end
end

if sum(sum(matW.*CM)) == 0
    gk = 1;
    return
end

gk = 1- sum(sum(matW.*CM)) / sum(sum(matW.*matP)) ;

end

