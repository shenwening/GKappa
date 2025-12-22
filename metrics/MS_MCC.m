function [ mcc ] = MS_MCC( x,y,R )
%MS_MCC MCC
CM = GetCM(x,y,R);
I = sum(CM,2);
J = sum(CM,1);
diagsum = sum(diag(CM));
N = sum(CM(:));
NIJ = 0;
E1 = 0;
E2 = 0;
for i = 1:R
    NIJ = NIJ + I(i)*J(i);
    E1 = E1 + I(i)^2;
    E2 = E2 + J(i)^2;
end
mcc = (N*diagsum - NIJ) / sqrt((N^2-E1)*(N^2-E2));
end

