function mae_m = MS_MAEM(h, y,range_begin,range_end)
    %Function: According to the definition of SemEval-2017 Task 4 subtask C, calculate the macro mean absolute error (MAE^M)
    %Input parameters:
    %h - vector, predicted labels for samples
    %y - vector, true label of the sample
    %begin - category start range
    %end - category end range
    %
    %Output parameters:
    %mae_m - Macro mean absolute error (MAE^M), the smaller the value, the better the model's prediction performance for ordinal classification
    
    %-------------------------- 1. Input validity check (refer to the sample function format) --------------------------
    if length(h) ~= length(y)
        error("h (预测标签) and y (真实标签) must have same length");
    end
   
    mae_m=0;
    for i=range_begin:range_end
        h_mask=(h==i);
        hx=h(h_mask);
        hy=y(h_mask);
        N=length(hx);
        if(N==0)
            continue;
        end
        sum(abs(hx-hy))/N;
        mae_m=mae_m+sum(abs(hx-hy))/N;
    end

    mae_m=1 - mae_m/(range_end-range_begin+1);
   
end