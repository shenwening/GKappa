function [ oc ] = OCI( cMatrix,K )
% Original implementation code given in IJ11 paper, but the value on (a,a) is not 0
N = sum(cMatrix(:));
ggamma = 1;
bbeta = 0.75/(N*(K-1)^ggamma);

helperM2 = zeros(K,K);
for r=1:K
    for c=1:K
        helperM2(r,c) = cMatrix(r,c) * ((abs(r-c))^ggamma);
    end
end
TotalDispersion = (sum(helperM2(:))^(1/ggamma));
helperM1 = cMatrix/(TotalDispersion+N);

errMatrix(1,1) = 1-helperM1(1,1) + bbeta * helperM2(1,1);
for r=2:K
    c = 1;
    errMatrix(r,c) = errMatrix(r-1,c) - helperM1(r,c) + bbeta*helperM2(r,c);
end
for c=2:K
    r = 1;
    errMatrix(r,c) = errMatrix(r,c-1) - helperM1(r,c) + bbeta*helperM2(r,c);
end

for c=2:K
    for r=2:K
        costup = errMatrix(r-1,c);
        costleft = errMatrix(r,c-1);
        lefttopcost = errMatrix(r-1,c-1);
        [aux,~] = min([costup costleft lefttopcost]);
        errMatrix(r,c) = aux - helperM1(r,c) + bbeta*helperM2(r,c);
    end
end
oc = errMatrix(end,end);
return


