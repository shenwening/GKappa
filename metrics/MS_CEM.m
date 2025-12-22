function cem = MS_CEM(CM)
% CEM-ORD ACL20
% Calculate according to ACL21 format
% CM: Confusion matrix, size [K, K], where row i and column j 
% represents the number of samples with true label i and predicted label j

R = size(CM, 1); 
N = sum(CM(:)); 
NI = sum(CM,2);
NJ = sum(CM,1);


K = zeros(R, R);
for i = 1:R
    for j = 1:R
        if i >= j
            a = 0;
            for l =j+1:i
                a = a + NI(l);
            K(i, j) = NI(j) / 2 + a;
            end
        else
            b = 0;
            for l = i:j-1
                b = b + NI(l);
            end
            K(i, j) = NI(j) / 2 + b;
        end
    end
end

%  proxij
prox = zeros(R, R);
for i = 1:R
    for j = 1:R
        prox(i,j) = -log2( max(0.5, K(i,j)) / N );
    end
end

%  CEM-ord
P1 = 0;
P2 = 0;
for i = 1:R
     P2 = P2 + prox(i,i) * NI(i);
    for j = 1:R
        P1 = P1 + prox(i,j) * CM(i,j);
    end
end
cem = P1 / P2;
end