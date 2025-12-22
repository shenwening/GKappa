function values = get_test_value_num_data(a,b,sequenceRangebegin,sequenceRangeend,type)
    % Initialize empty array for values

    if ~iscolumn(a)
        a = a(:);
    end
    if ~iscolumn(b)
        b = b(:);
    end
    
    values = [];
    if type==2
        values(end+1) = MS_P(a', b');
        values(end+1) = MS_Rs(a, b);
        values(end+1) = MS_tb(a, b);
        values(end+1) = ICC([a, b], 'C-1');
        values(end+1) =MS_CCC(a,b);
        values(end+1)=MS_Ar(a,b);
        values(end+1)=MS_nkappa(a,b,sequenceRangebegin,sequenceRangeend,'cohen');
        values(end+1)=MS_nkappa(a,b,sequenceRangebegin,sequenceRangeend,'scott');
    else 
        values(end+1) = MS_P(a', b');
        values(end+1) = MS_Rs(a, b);
        values(end+1) = MS_tb(a, b);
        values(end+1) = ICC([a, b], 'C-1');
        values(end+1)=MS_nkappa(a,b,sequenceRangebegin,sequenceRangeend,'cohen');
        values(end+1)=MS_nkappa(a,b,sequenceRangebegin,sequenceRangeend,'scott');
    end
    

end