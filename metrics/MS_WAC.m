function [ A ] = MS_WAC(CM,w_type,type)
%MS_WAC Implements weighted coefficients: Weighted kappa/Scott's pi/Gwet AC2
% CM is an NXN matrix, R is the number of categories
% w_type specifies the weight selection: including 6 types
% Unweighted/Linear/Quadratic/Ordinal/Radical/Bipolar
% type specifies the weighted coefficient: including 3 types Weighted_kappa/Scotts_pi/Gwet
P = CM ./ sum(CM(:));
R = size(CM, 1);
PI = sum(P,2);
PJ = sum(P,1);
W = zeros(R);
Mmax = eps; % Ordinal
M = eps; % Bipolar

for i=1:R
    for j=1:R
        a = max(i,j) - min(i,j) + 1;
        if a>Mmax
            Mmax = a;
        end
        b = ((i-j)^2) / ((i+j-2)*(2*R-i-j)); 
        if b>M
            M = b;
        end
    end
end

% Weighted matrix W
if strcmp(w_type, 'Unweighted')
    for i=1:R
        W(i,i) = 1;
    end
elseif strcmp(w_type, 'Linear')
    W = ones(R, R);
    for i = 1:R
        for j = 1:R
            W(i, j) = 1 - abs(i-j) / (R-1);
        end
    end
elseif strcmp(w_type, 'Quadratic')
    W = ones(R, R);
    for i = 1:R
        for j = 1:R
            W(i, j) = 1 - ((i-j) / (R-1))^2;
        end
    end
elseif strcmp(w_type, 'Ordinal')
    W = ones(R, R);
    for i = 1:R
        for j = 1:R
            Mij = max(i,j)-min(i,j)+1;
            W(i, j) = 1 - Mij / Mmax;
        end
    end
elseif strcmp(w_type, 'Radical')
    W = ones(R, R);
    for i = 1:R
        for j = 1:R
            W(i, j) = 1 - sqrt(abs(i-j)) / sqrt(abs(R-1));
        end
    end

elseif strcmp(w_type, 'Bipolar')
    W = ones(R, R);
    for i = 1:R
        for j = 1:R
            
            W(i, j) = 1 - ((i-j)^2) / (M * (i+j-2) * (2*R-i-j) + eps);
        end
    end
end

P0 = W.*P;
P0 = sum(P0(:));
Pe = 0;

if strcmp(type, 'Weighted_kappa')
    for i=1:R
        for j=1:R
            Pe = Pe + W(i,j)*PI(i)*PJ(j);
        end
    end
elseif strcmp(type, 'Scotts_pi')
    for i = 1:R
        for j = 1:R
            a = (PI(i) + PJ(i)) / 2;
            b = (PI(j) + PJ(j)) / 2;
            Pe = Pe + W(i, j) * a * b;
        end
    end
elseif strcmp(type, 'Gwet')
    b = 0;
    for i = 1:R
         a = (PI(i) + PJ(i)) / 2;
         b = b + a*(1-a);
    end
    Pe = sum(W(:)) * b / (R*(R-1));
end

if P0 == 1
    A = 1;
    return
end
A = (P0 - Pe) / (1 - Pe);
end

