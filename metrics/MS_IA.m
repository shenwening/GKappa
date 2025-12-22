function [ IA ] = MS_IA( CM,R )
% MS_IA implements the IA coefficient
% Input confusion matrix CM of size RXR where R represents the number of categories
CM = CM / sum(CM(:));
I = sum(CM,2);
J = sum(CM,1);
MI = 0;
HX = 0;
HY = 0;
for i=1:R
    HX = HX - I(i) .* (log(I(i) + eps) / log(R)); % +eps avid Nan
    HY = HY - J(i) .* (log(J(i) + eps) / log(R));
    for j=1:R
        if CM(i,j) ~= 0 % 0 entry does not contribute
            MI = MI + CM(i,j) * (log(CM(i,j) / (I(i)*J(j))) / log(R));
        end
    end
end
IA = MI / min(HX,HY);
end
 
