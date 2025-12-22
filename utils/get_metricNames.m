function metricNames=get_metricNames(type)
%The type type represents the selected type
    if(type==1)
        metricNames = {'MAE', 'MER', 'Pearson', 'Rs', 'tb', 'Rint', 'ord', 'OC', ...
    'MCC', 'IA', 'CEM', 'ICC', 'Lwpi', 'Lwkappa', 'GKappa', 'LwAC2'};
    elseif (type==2)
         metricNames = { 'Pearson', 'Rs', 'tb', ...
     'ICC','NDCG' 'GKappa'};
    elseif (type==3)
        metricNames = { 'Pearson', 'Rs', 'tb', ...
     'ICC', 'n_kappa', 'n_kappa_scott'};
    elseif (type==4)
        metricNames = { 'Pearson', 'Rs', 'tb', ...
     'ICC', 'CCC','Ar','n_kappa', 'n_kappa_scott'};
    elseif type==5
      metricNames = {'MAE', 'MER', 'Pearson', 'Rs', 'tb', 'Rint', 'ord', 'OC', ...
    'MCC', 'IA', 'CEM', 'ICC', 'Lwpi', 'Lwkappa', 'GKappa', 'GDkappa','LwAC2'};
     elseif type==6
      metricNames = {'MAE', 'MER', 'Pearson', 'Rs', 'tb', 'Rint', 'ord', 'OC', ...
    'MCC', 'IA', 'CEM', 'ICC', 'Lwpi', 'Lwkappa', 'GKappa','LwAC2', 'NDCG'};
    end
    
   
 end