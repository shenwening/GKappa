addpath("../utils/")
addpath("../metrics/")
metricNames=get_metricNames(1);
metricNames
bool_first=true;


outputFilePath = sprintf('data/gk_pro/same_class.xlsx');
a=[1 2 3 3 4 3 3 2 2]
b=[2 2 2 2 2 2 2 2 2]
value=get_test_value_data(a,b,4)

%% write result
if bool_first
    writecell(metricNames, outputFilePath, 'WriteMode', 'overwrite');
end

writematrix(value, outputFilePath, 'WriteMode', 'append');




