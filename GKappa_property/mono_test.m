addpath("../utils/")
addpath("../metrics/")

%---------------------------------------Monotonicity test written by senior sister---------------------------
%% define sequence
% a = [1 1 1 1 2 2 2 2 2 2 4 4 4]';
% b = [2 2 2 2 3 3 3 3 3 3 4 4 4]';
% c = [3 3 3 3 3 3 3 3 3 3 4 4 4]';
% d = [2 2 2 2 1 1 1 1 1 1 4 4 4]';
% 
%% define sequence range
% sequenceRange1 = max(a);
% sequenceRange2 = max(b);
% sequenceRange3 = max(c);
% sequenceRange4 = max(d);
% 
%% initialize matrix
% MAE_mat = zeros(4, 1);
% MER_mat = zeros(4, 1);
% Pearson_mat = zeros(4, 1);
% Rs_mat = zeros(4, 1);
% tb_mat = zeros(4, 1);
% rint_mat = zeros(4, 1);
% a_mat = zeros(4, 1);
% OC_mat = zeros(4, 1);
% Mcc_mat = zeros(4, 1);
% IA_mat = zeros(4, 1);
% CEM_mat = zeros(4, 1);
% ICC_mat = zeros(4, 1);
% pi_mat = zeros(4, 1);
% kappa_mat = zeros(4, 1);
% Gkappa_mat = zeros(4, 1);
% AC_mat = zeros(4, 1);
% 
%% calculated indicator
% % a, a
% CM = GetCM(a, a, sequenceRange1)
% [MAE_mat(1), MER_mat(1)] = MS_MER(a, a, sequenceRange1);
%  Pearson_mat(1)= MS_P(a', a');
% % Pearson_mat(1) = MS_P(a, a)
% Rs_mat(1) = MS_Rs(a, a);
% tb_mat(1) = MS_tb(a, a);
% rint_mat(1) = MS_Rint(CM);
% a_mat(1) = MS_ORD(a, a, sequenceRange1);
% OC_mat(1) = MS_OC(a, a, sequenceRange1, 1, 0.75);
% Mcc_mat(1) = MS_MCC(a, a, sequenceRange1);
% IA_mat(1) = MS_IA(CM, sequenceRange1);
% CEM_mat(1) = MS_CEM(CM);
% ICC_mat(1) = ICC([a, a], 'C-1');
% pi_mat(1) = MS_WAC(CM, 'Quadratic', 'Scotts_pi');
% kappa_mat(1) = MS_WAC(CM, 'Quadratic', 'Weighted_kappa');
% Gkappa_mat(1) = MS_GK(a, a, 1, sequenceRange1, 1, sequenceRange1);
% AC_mat(1) = MS_WAC(CM, 'Quadratic', 'Gwet');
% 
% % a, b
% CM = GetCM(a, b, sequenceRange1)
% [MAE_mat(2), MER_mat(2)] = MS_MER(a, b, sequenceRange1);
% Pearson_mat(2) = MS_P(a', b');
% Rs_mat(2) = MS_Rs(a, b);
% tb_mat(2) = MS_tb(a, b);
% rint_mat(2) = MS_Rint(CM);
% a_mat(2) = MS_ORD(a, b, sequenceRange1);
% OC_mat(2) = MS_OC(a, b, sequenceRange1, 1, 0.75);
% Mcc_mat(2) = MS_MCC(a, b, sequenceRange1);
% IA_mat(2) = MS_IA(CM, sequenceRange1);
% CEM_mat(2) = MS_CEM(CM);
% 
% ICC_mat(2) = ICC([a, b], 'C-1');
% pi_mat(2) = MS_WAC(CM, 'Quadratic', 'Scotts_pi');
% kappa_mat(2) = MS_WAC(CM, 'Quadratic', 'Weighted_kappa');
% Gkappa_mat(2) = MS_GK(a, b, 1, sequenceRange1, 1, sequenceRange2);
% AC_mat(2) = MS_WAC(CM, 'Quadratic', 'Gwet');
% 
% % a, c
% CM = GetCM(a, c, sequenceRange1)
% [MAE_mat(3), MER_mat(3)] = MS_MER(a, c, sequenceRange1);
% Pearson_mat(3) = MS_P(a', c');
% Rs_mat(3) = MS_Rs(a, c);
% tb_mat(3) = MS_tb(a, c);
% rint_mat(3) = MS_Rint(CM);
% a_mat(3) = MS_ORD(a, c, sequenceRange1);
% OC_mat(3) = MS_OC(a, c, sequenceRange1, 1, 0.75);
% Mcc_mat(3) = MS_MCC(a, c, sequenceRange1);
% IA_mat(3) = MS_IA(CM, sequenceRange1);
% CEM_mat(3) = MS_CEM(CM);
% ICC_mat(3) = ICC([a, c], 'C-1');
% pi_mat(3) = MS_WAC(CM, 'Quadratic', 'Scotts_pi');
% kappa_mat(3) = MS_WAC(CM, 'Quadratic', 'Weighted_kappa');
% Gkappa_mat(3) = MS_GK(a, c, 1, sequenceRange1, 1, sequenceRange3);
% AC_mat(3) = MS_WAC(CM, 'Quadratic', 'Gwet');
% 
% % a, d
% CM = GetCM(a, d, sequenceRange1)
% [MAE_mat(4), MER_mat(4)] = MS_MER(a, d, sequenceRange1);
% Pearson_mat(4) = MS_P(a', d');
% Rs_mat(4) = MS_Rs(a, d);
% tb_mat(4) = MS_tb(a, d);
% rint_mat(4) = MS_Rint(CM);
% a_mat(4) = MS_ORD(a, d, sequenceRange1);
% OC_mat(4) = MS_OC(a, d, sequenceRange1, 1, 0.75);
% Mcc_mat(4) = MS_MCC(a, d, sequenceRange1);
% IA_mat(4) = MS_IA(CM, sequenceRange1);
% CEM_mat(4) = MS_CEM(CM);
% ICC_mat(4) = ICC([a, b], 'C-1');
% pi_mat(4) = MS_WAC(CM, 'Quadratic', 'Scotts_pi');
% kappa_mat(4) = MS_WAC(CM, 'Quadratic', 'Weighted_kappa');
% Gkappa_mat(4) = MS_GK(a, d, 1, sequenceRange1, 1, sequenceRange4);
% AC_mat(4) = MS_WAC(CM, 'Quadratic', 'Gwet');
% 
%% Print results for monotonicity testing
% disp('MAE:');
% disp(MAE_mat);
% disp('MER:');
% disp(MER_mat);
% disp('Pearson Correlation:');
% disp(Pearson_mat);
% disp('Spearman Correlation:');
% disp(Rs_mat);
% disp('kendal Coefficient:');
% disp(tb_mat);
% disp('Rint:');
% disp(rint_mat);
% disp('α-ord:');
% disp(a_mat);
% disp('OCI:');
% disp(OC_mat);
% disp('MCC:');
% disp(Mcc_mat);
% disp('IA:');
% disp(IA_mat);
% disp('CEM-ord:');
% disp(CEM_mat);
% disp('ICC(3,1):');
% disp(ICC_mat);
% disp('π:');
% disp(pi_mat);
% disp('Weighted kappa:');
% disp(kappa_mat);
% disp('Gkappa:');
% disp(Gkappa_mat);
% disp('AC2:');
% disp(AC_mat);


%--------------------------Monotonicity test of packaged version---------------------------------------
addpath("utils\")
addpath("D:\matlibprojects\tmpOC_new")
outputFilePath = "D:\matlibprojects\tmpOC_new\property_test\data\gk_pro\mono_proprty_ndcg.xlsx";
bool_first=true;

a = [1 1 1 1 2 2 2 2 2 2 4 4 4]';
b = [2 2 2 2 3 3 3 3 3 3 4 4 4]';
c = [3 3 3 3 3 3 3 3 3 3 4 4 4]';
d = [2 2 2 2 1 1 1 1 1 1 4 4 4]';

metricNames=get_metricNames(6);
metricNames
values1=get_test_value_data(a,a,4)
values2=get_test_value_data(a,b,4)
values3=get_test_value_data(a,c,4)
values4=get_test_value_data(a,d,4)




%% write result
if bool_first
    writecell(metricNames, outputFilePath, 'WriteMode', 'overwrite');
end

writematrix(values1, outputFilePath, 'WriteMode', 'append');
writematrix(values2, outputFilePath, 'WriteMode', 'append');
writematrix(values3, outputFilePath, 'WriteMode', 'append');
writematrix(values4, outputFilePath, 'WriteMode', 'append');






%-------------------------
% addpath("utils\")
% addpath("D:\matlibprojects\tmpOC_new")
% outputFilePath = "D:\matlibprojects\tmpOC_new\property_test\data\gk_pro\mono_proprty_01.xlsx";
% bool_first=true;
% metricNames=get_metricNames(1);
% 
% cm1=[
%     4	0	0	0;
%     0	6	0	0;
%     0	0	3	0;
%     0	0	0	0;
% ];
% 
% cm2=[
%     0	4	0	0;
%     0	6	0	0;
%     0	0	3	0;
%     0	0	0	0;
% ];
% 
% cm3=[
%     0	0	4	0;
%     0	6	0	0;
%     0	0	3	0;
%     0	0	0	0;
% ];
% 
% 
% cm4=[
%     0	0	0	4;
%     0	6	0	0;
%     0	0	3	0;
%     0	0	0	0;
% ];
% [s1,s2]=extractSequencesFromConfusion(cm1);
% values1=get_test_value_data(s1,s2,4)
% 
% [s1,s2]=extractSequencesFromConfusion(cm2);
% values2=get_test_value_data(s1,s2,4)
% 
% [s1,s2]=extractSequencesFromConfusion(cm3);
% values3=get_test_value_data(s1,s2,4)
% 
% [s1,s2]=extractSequencesFromConfusion(cm4);
% values4=get_test_value_data(s1,s2,4)
% 
% 
% if bool_first
%     writecell(metricNames, outputFilePath, 'WriteMode', 'overwrite');
% end
% 
% writematrix(values1, outputFilePath, 'WriteMode', 'append');
% writematrix(values2, outputFilePath, 'WriteMode', 'append');
% writematrix(values3, outputFilePath, 'WriteMode', 'append');
% writematrix(values4, outputFilePath, 'WriteMode', 'append');
