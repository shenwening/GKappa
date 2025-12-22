function [ r ] = MS_P( x,y )
%MS_P Pearson
r = corr(x', y', 'type', 'Pearson');

end

