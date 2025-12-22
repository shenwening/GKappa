function [ mae,mer ] = MS_MER( x,y,N )
% MAE and MER
x ;
y;
mae = mean(abs(x-y));
CM = GetCM(x,y,N);
mer = 1-sum(diag(CM))/ sum(CM(:));
% mer = sum(diag(CM))/ sum(CM(:));

end

