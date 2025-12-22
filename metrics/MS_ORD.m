function [ ord ] = MS_ORD( X,Y,C )
%MS_ORD1 krippendorff's ¦Á-ord
N = numel(X);
NM = zeros(C,N);
for i=1:N
    if X(i) == Y(i)
        NM(X(i),i) = 2;
    end
    if X(i) ~= Y(i)
        NM(X(i),i) = 1;
        NM(Y(i),i) = 1;
    end
end
O = zeros(C,C);
E = zeros(C,C);
e = zeros(C,C);
for i=1:C
    for j=1:C
        if i~=j
            for u=1:N
                O(i,j) = O(i,j) + NM(i,u)*NM(j,u);
                E(i,j) = sum(NM(i,:))*sum(NM(j,:)) / (2*N-1);
                if i<j
                    K = 0;
                    for k=i:j
                        K = K + sum(NM(k,:));
                    e(i,j) = (K-(sum(NM(i,:))+sum(NM(j,:)))/2)^2;
                    end
                end
            end
        end
    end
end
D1 = 0;
D2 = 0;
for i=1:C
    for j=1:C
        if i<j
            D1 = D1 + O(i,j)*e(i,j);
            D2 = D2 + E(i,j)*e(i,j);
        end
    end
end
ord = 1-D1/D2;
return

