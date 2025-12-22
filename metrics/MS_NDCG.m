function ndcg = MS_NDCG(y_true, y_score, k)
    % NDCG_SCORE Calculate Normalized Discounted Cumulative Gain (compatible with 1D/2D input)
    % Inputs:
    %   y_true - 1D/2D matrix, 1D=single sample, 2D=(n_samples, n_items), true relevance scores
    %   y_score - 1D/2D matrix, same shape as y_true, model predicted ranking scores
    %   k - Optional, Top-k position, default [] means evaluate all items
    % Outputs:
    %   ndcg - NDCG score (scalar for single sample, array for batch samples)
    
    % Step 1: Convert 1D input to 2D (1×N) uniformly, compatible with 1D/2D input
    if ndims(y_true) == 1
        y_true = reshape(y_true, 1, []);
    end
    if ndims(y_score) == 1
        y_score = reshape(y_score, 1, []);
    end
    
     % Handle default k value (evaluate all items)
    if nargin < 3 || isempty(k)
        k = size(y_true, 2);
    else
        k = min(k, size(y_true, 2)); 
    end
    k;
    % 校验输入形状
    if ~isequal(size(y_true), size(y_score))
        error('y_true和y_score形状必须一致');
    end
    if ndims(y_true) ~= 2
        error('仅支持一维/二维输入（一维=单样本，二维=批量样本）');
    end
    
    n_samples = size(y_true, 1);
    ndcg = zeros(n_samples, 1); 
    
    for i = 1:n_samples

        true_rel = y_true(i, :);
        pred_rel = y_score(i, :);
        
       
        [~, sorted_indices] = sort(pred_rel, 'descend'); 
        sorted_true_rel = true_rel(sorted_indices);
        sorted_true_rel_k = sorted_true_rel(1:k); 
        
        
        dcg = dcg_at_k(sorted_true_rel_k);
        
       
        [ideal_sorted_true, ~] = sort(true_rel, 'descend');
        ideal_sorted_true_k = ideal_sorted_true(1:k);
        idcg = dcg_at_k(ideal_sorted_true_k);
        
        % 步骤5：计算NDCG（避免除零）
        if idcg ~= 0
            ndcg(i) = dcg / idcg;
        else
            ndcg(i) = 0;
        end
    end
    
    % 单样本返回标量，批量返回数组
    if n_samples == 1
        ndcg = ndcg(1);
    end
end


% Internal helper function: calculate DCG@k
function dcg = dcg_at_k(relevance_scores)
    if isempty(relevance_scores)
        dcg = 0;
        return;
    end
    % 位置从1开始，折损因子为log2(i+1)
    discounts = log2(2:(length(relevance_scores)+1));
    dcg = sum(relevance_scores ./ discounts);
end