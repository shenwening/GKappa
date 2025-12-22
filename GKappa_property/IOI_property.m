addpath("utils\")
addpath("D:\matlibprojects\tmpOC_new")
outputFilePath = "D:\matlibprojects\tmpOC_new\property_test\data\gk_pro\IOI_proprty.xlsx";
bool_first=true;

a = [1 3 5 7]';
b = [2 4 6 8]';
c = [1 3 5 8]';
d = [2 3 4 7]';

metricNames=get_metricNames(5);
metricNames
values1=get_test_value_data(a,a,8)
values2=get_test_value_data(a,b,8)
values3=get_test_value_data(a,c,8)
values4=get_test_value_data(a,c,8)




%% write result
if bool_first
    writecell(metricNames, outputFilePath, 'WriteMode', 'overwrite');
end

writematrix(values1, outputFilePath, 'WriteMode', 'append');
writematrix(values2, outputFilePath, 'WriteMode', 'append');
writematrix(values3, outputFilePath, 'WriteMode', 'append');
writematrix(values4, outputFilePath, 'WriteMode', 'append');
