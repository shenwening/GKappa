addpath("../utils/")
addpath("../metrics/")
outputFilePath = "D:\matlibprojects\tmpOC_new\property_test\data\gk_pro\input_bias_sample1.xlsx";
addpath('utils\');
bool_first=true;
metricNames=get_metricNames(5);


%----------------------------------------Example experiment--------------------------------
 

a  =[1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4]
b1 =[1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2]
b2 =[2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3]
b3 =[1 1 1 1 1 1 1 1 4 4 4 4 4 4 4 4]

% a  =[1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8]
% b1 =[1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2]
% b2 =[4 4 4 4 4 4 4 4 8 8 8 8 8 8 8 8]
% b3 =[1 1 1 1 3 3 3 3 5 5 5 5 7 7 7 7 ]
% b4 =[2 2 3 3 4 4 5 5 6 6 7 7 8 8 8 8]


values=[];
% values(end+1)=metricNames;
values1=get_test_value_data(a,b1,4)
values(end+1,:)=values1;
values2=get_test_value_data(a,b2,4)
values(end+1,:)=values2;
values3=get_test_value_data(a,b3,4)
values(end+1,:)=values3;
values4=get_test_value_data(a,b4,8)
values(end+1,:)=values4;


%% write result
if bool_first
    writecell(metricNames, outputFilePath, 'WriteMode', 'overwrite');
end

writematrix(values1, outputFilePath, 'WriteMode', 'append');
writematrix(values2, outputFilePath, 'WriteMode', 'append');
writematrix(values3, outputFilePath, 'WriteMode', 'append');

