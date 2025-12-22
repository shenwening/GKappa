
function values = get_test_value_data(a,b,sequenceRange)
    % Initialize empty array for values

    if ~iscolumn(a)
        a = a(:);
    end
    if ~iscolumn(b)
        b = b(:);
    end
    
    values = [];
    
    % Get sequence range
    sequenceRange1 = sequenceRange;
    
    % Calculate confusion matrix
    CM = GetCM(a, b, sequenceRange1);
    
    % Calculate all metrics and add to values array
    [mae, mer] = MS_MER(a, b, sequenceRange1);
    values(end+1) = mae;
    values(end+1) = 1-mer;
    
    values(end+1) = MS_P(a', b');
    values(end+1) = MS_Rs(a, b);
    values(end+1) = MS_tb(a, b);
    values(end+1) = MS_Rint(CM);
    values(end+1) = MS_ORD(a, b, sequenceRange1);
    values(end+1) = 1-MS_OC(a, b, sequenceRange1, 1, 0.75);
    values(end+1) = MS_MCC(a, b, sequenceRange1);
    values(end+1) = MS_IA(CM, sequenceRange1);
    values(end+1) = MS_CEM(CM);
    values(end+1) = ICC([a, b], 'C-1');
    values(end+1) = MS_WAC(CM, 'Linear', 'Scotts_pi');
    % values(end+1) = MS_WAC(CM, 'Quadratic', 'Weighted_kappa');
    values(end+1) = MS_WAC(CM, 'Linear', 'Weighted_kappa');
    values(end+1) = MS_GK(a, b, 1, sequenceRange1, 1, sequenceRange1);
    values(end+1) = MS_WAC(CM, 'Linear', 'Gwet');
    values(end+1) =MS_NDCG(a',b');
end