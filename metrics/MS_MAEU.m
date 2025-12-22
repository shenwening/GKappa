% MS_MAEM
function [ maeu, ret ] = MS_MAEU( v1, v2 );
%% [create] function for the ordinal measure MAE_U, by zim 2022/5/10 
%% [modify] Note that it is symmetric,  i.e., MS_MAEM(A, B) == MS_MAEM(B, A)
%% [usage ] MS_weightedKappa( B ); % see [input example]
%% [ REF. ] [ACL21] Evaluating Evaluation Measures for Ordinal Classification and Ordinal Quantification.pdf
%% [input ] v1 :  label vector 1
%% [input ] v2 :  label vector 2  (golden truth)
%% [input ] B :
%% [output] A : 
%% [output] ret: return 1 when success, 0 when fail.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% [input example]
bExample = 0; % whether to run the input example for debug
if (bExample == 1)
    clear all;
    v1 = [1 1 1 2 2 2 3 3 3];
    v2 = [2 2 1 3 3 3 4 4 5];

    v1 = [1 1 1 2 2 3 3 3 3 4 4];
    v2 = [3 3 3 2 2 2 1 1 1 4 4];
    v2 = v1;
    % v2 = [2 2 1 1 1 1];
    
end %% if
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% [initialize output parameters]
ret = 0;

N = length(v1); 

% compute the contingency matrix mat, mat(i, j) is the number of points in class i in v1  and in class j in v2.
vU1 = unique(v1);
vU2 = unique(v2);
K1 = length(vU1);
K2 = length(vU2);
[ mat, ret ] = MS_GenConMatFromTwoLabel( v1, v2 );

W = abs(repmat((1:K1)',  1, K2) - repmat((1:K2),  K1, 1)); % linear weighted, i.e.,  wij = |i-j|

vClassLength2 = sum(mat, 1); % the class size of  classification 2 ,  label vector 2  (golden truth)
maeu = sum(sum(W.*mat))/N


ret = 1;




























































