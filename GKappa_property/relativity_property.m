addpath("../utils/")
addpath("../metrics/")
outputFilePath = "data\gk\rel_proprty_1.xlsx";
bool_first=true;

a = [1 1 1 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3];
b1 =[1 1 1 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3];
b2 =[2 2 1 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3];

% confMat=[3  0 0;
%         0 6 0;
%         0 2 8];
% [a,b1]=extractSequencesFromConfusion(confMat);
% a'
% b1'

metricNames=get_metricNames(1);
metricNames
values1=get_test_value_data(a,b1,3)
values2=get_test_value_data(a,b2,3)
% values3=get_test_value_data(a,c,8)
% values4=get_test_value_data(a,c,8)




%% write result
if bool_first
    writecell(metricNames, outputFilePath, 'WriteMode', 'overwrite');
end

writematrix(values1, outputFilePath, 'WriteMode', 'append');
writematrix(values2, outputFilePath, 'WriteMode', 'append');
writematrix(values3, outputFilePath, 'WriteMode', 'append');
writematrix(values4, outputFilePath, 'WriteMode', 'append');
