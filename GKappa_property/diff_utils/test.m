
x=[1,2,3,4,5,6,7,8,9,10];
y=[1,2,5,5,5,5,7,8,9,10];
mae_m = MS_MAEM(x,y,1,10)
mae_u = MS_MAEU(x,y)


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


function mae_u = MS_MAEU(X,Y)
    %Function: According to the definition of SemEval-2017 Task 4 subtask C, calculate the macro mean absolute error (MAE^U)
    %Input parameters:
    %X - vector, predicted label of the sample
    %Y - vector, true label of the sample
    %Output parameters:
    %mae_u - macro mean absolute error
    if(length( X)~=length(Y))
        error("X and Y must have same length");
    end
    N=length(X);
    mae_u=sum(abs(X-Y))/N;
    mae_u=1-mae_u;
end