addpath("../utils/")
addpath("../metrics/")
metricNames=get_metricNames(6);
metricNames
bool_first=true;



K = 5; %Indicates category size
N = 100; %sample size
iters = 10000; %Repeat times
outputFilePath = sprintf('data/kn/K%d_N%d_iters%d_ndcg.xlsx',K,N,iters);
n =0;
values=zeros(1,length(metricNames));
for i = 1:iters
    if mod(i,100)==0
        disp(i)
    end
    a=generateSequence(1,K,N);
    % unique(a)
    b=generateSequence(1,K,N);
    value=get_test_value_data(a,b,K);
    %If value exists NAN value, display ab
    % if any(isnan(value))
    %     % a'
    %     % b'
    %     n=n+1
    %     continue;
    % end
    values=values+value;
end

values=values/(iters-n)

%% write result
if bool_first
    writecell(metricNames, outputFilePath, 'WriteMode', 'overwrite');
end

writematrix(values, outputFilePath, 'WriteMode', 'append');



%------------------------------------

%K1 = 5; % represents the category length
% K2 = 8;
%N = 50; % sample size
%iters = 100000; % number of repetitions
% outputFilePath = sprintf('data/kn/diff_K%d_N%d_iters%d.xlsx',K,N,iters);
% n =0;
% values=zeros(1,length(metricNames));
% for i = 1:iters
%     a=generateSequence(1,K1,N);
%     b=generateSequence(1,K2,N);
%     value=get_test_value_diff_m_data(a,b,1,K1,1,K2,1);
%% If value exists NAN value, display ab
%     % if any(isnan(value))
%     %     % a'
%     %     % b'
%     %     n=n+1
%     %     continue;
%     % end
%     values=values+value;
% end
% 
% values=values/(iters-n)
% 
%% % Write results
% if bool_first
%     writecell(metricNames, outputFilePath, 'WriteMode', 'overwrite');
% end
% 
% writematrix(values, outputFilePath, 'WriteMode', 'append');