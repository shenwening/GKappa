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