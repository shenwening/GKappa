% function [ rint ] = MS_Rint( CM )
% % 返回指标rint
% % 行向量
% % CM是RXR的矩阵，R表示类别个数
% R = size(CM,1);
% S12 = 0;
% S1 = 0;
% S2 = 0;
% NI = sum(CM,2);
% NJ = sum(CM,1);
% N = sum(CM(:));
% 
% for i=1:R
%     for j=i:R
%         S1 = S1 + NI(i)*NI(j);
%         S2 = S2 + NJ(i)*NJ(j);
%         for x=i:R
%             for y=j:R
%                 S12 = S12 + CM(i,j)*CM(x,y);
%             end
%         end
%     end
% end
% S1 = S1 - N;
% S2 = S2 - N;
% S12 = S12 - N;
% rint = -1 + 2 * ( S12 / sqrt(S1*S2));
% 
% end
% 


function rint = MS_Rint(CM)
    % MS_Rint Calculate rank correlation coefficient (rint)
    % Inputs:
    %   CM - R x R classification count matrix, where R represents the number of categories
    % Outputs:
    %   rint - Rank correlation coefficient, value range [-1, 1]
    
    % Get number of categories R and total sample count N
    R = size(CM, 1);          % Number of categories
    N = sum(CM(:));           % Total sample count
    
    % Initialize S1, S2 and S12
    S1 = 0;
    S2 = 0;
    S12 = 0;
    
    % Pre-calculate row sums and column sums
    NI = sum(CM, 2);          % Sum of each row (distribution of rater 1)
    NJ = sum(CM, 1);          % Sum of each column (distribution of rater 2)
    
    % Calculate S1, S2 and S12
    for i = 1:R
        for j = i:R
            % Update S1 and S2
            S1 = S1 + NI(i) * NI(j);
            S2 = S2 + NJ(i) * NJ(j);
            
            % Update S12
            for x = i:R
                for y = j:R
                    S12 = S12 + CM(i, j) * CM(x, y);
                end
            end
        end
    end
    
    % Adjust S1, S2 and S12
    S1 = S1 - N;
    S2 = S2 - N;
    S12 = S12 - N;
    
    % Calculate rint
    if S1 > 0 && S2 > 0
        rint = -1 + 2 * (S12 / sqrt(S1 * S2));
    else
        error('Invalid input matrix: S1 or S2 is zero or negative');
    end
end