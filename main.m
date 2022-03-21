function [confusionmatrix1,confusionmatrix_sen,confusionmatrix_PPV]= main(filepath,model_name)
f=sprintf('%s.mat',model_name);
load(f);
%% Importing the data
d = uigetdir(filepath);
filePattern = fullfile(d, '*.xlsx');
file = dir(filePattern);
addpath(genpath(d));
v = cell(1, numel(file));
% raw={};
% accelerometer = {};
%     activity_recognition = {};
%     battery = {};
%     bluetooth = {};
%     calls = {};
%     gyroscope = {};
%     light = {};
%     location = {};
%     magnetic = {};
%     screen_state = {};
%     wireless={};
feature_matrix=[];
final_label=[];
foucse_group={file.name};
bug_list=[];
skip=0;
filed_list=[];
done=[];
%%
tic
for k=1:length(foucse_group)
    if ismember(foucse_group{k},foucse_group)
    try
    m=foucse_group{k};
    name         = m;
    feature_matrix_k=[];
    label=[];
    [num, txt, raw]=xlsread(name);    
    dates = unique(raw(2:end,5));
    %raw(2:end,6) = erase(raw(2:end,6),'0 days ');
    time = datetime(dates,'Format','eee dd-MMM-yy');
    label = isweekend(time);
    t1=20;
    t2=23;
    k
    name

  
    %% Extract Feature
    [dates, count_calls, norm_duration,std_duration,diff_duration_1,diff_duration_2] = calls_features(name);
    [dates, value_w, avg_wireless,std_wireless,diff_wireless] = wireless_features(name);
    [dates, value_b, avg_batt_all,count_battrry,change_batt,std_batt] = battry_features(name);
    [dates,max_light_after_t1,max_light_after_t2,avg_ligt] = light_features(name,t1,t2);
    [dates, avg_bluetooth_all,count_bluetoth] = bluetooth_features(name);
    [dates,avg_act,count_activity] = activity_features(name);
    [dates,count_screen,screen_after_24] = screen_features(name,t2);
    [dates, count_loc,var_loc] = GPS_features(name)
    feature_matrix_k=[feature_matrix_k,count_calls,norm_duration,diff_duration_1,diff_duration_2,avg_wireless,std_wireless,diff_wireless,...
        avg_batt_all,count_battrry,change_batt,std_batt,max_light_after_t1,max_light_after_t2,avg_ligt,avg_bluetooth_all,count_bluetoth,avg_act,count_activity...
        ,count_screen,var_loc];
    %%
    feature_matrix_k=feature_matrix_k(:,[19 18 33 1 6 25 31 11 13 28]);
    feature_matrix=[feature_matrix;feature_matrix_k];
    final_label=[final_label;label];
    feature_matrix(isnan(feature_matrix))=0;
    feature_matrix(isinf(feature_matrix)|isnan(feature_matrix)) = 0;
   
    catch
        fprintf('loop number %d  %d failed\n',k)
        filed_list=[filed_list;name];
        skip=skip+1;
    end
    
    
    
    end
    done=[done;name];
    
    
end
toc

%% PREDICTION
%% Calculate confusion matrix
tab=tabulate(final_label);
tic;
[Yfit_bag,score] = predict(bagTree_Submit,feature_matrix);
disp('Prediction time for RandomForest prediction:');
toc
disp('Confusion matrix (percentage) with Random Forest:');
stt=confusionmat(final_label,Yfit_bag)
confusionmatrix1=confusionmatStats(Yfit_bag,final_label);
figure;
confusionchart(final_label,Yfit_bag,'RowSummary','absolute','ColumnSummary','absolute');
%%  select a working point max senestivity
%plot(score)
[x_PRC,y_PRC]=perfcurve(final_label,score(:,2),tab(2),"XCrit","tpr","YCrit",'ppv');
%plot(x_PRC,y_PRC);
%xlabel('TPR');ylabel('PPV');title('PRC curve')
%Recall = Senstivity
% Precision = PPV
figure;
idx90_Senstivity=find(x_PRC>=0.9);
threshold_90_sestivity=score(idx90_Senstivity(1),2);
ind1=find(score(:,2)>=threshold_90_sestivity);
ind11=find(score(:,2)<threshold_90_sestivity);
Yfit_bag1=Yfit_bag;
Yfit_bag1(ind1)=1;
Yfit_bag1(ind11)=0;
confusionmatrix_sen=confusionmat(final_label,Yfit_bag1)
stats_1=confusionmatStats(final_label,Yfit_bag1);
confusionchart(final_label,Yfit_bag1,'RowSummary','absolute','ColumnSummary','absolute');
%% selecting maximum PPV= Precscion
idx90_PPV=find(y_PRC>=0.9);
if size(idx90_PPV,1)==0
    idx90_PPV=find(max(y_PRC));
end
threshold_90_PPV=score(idx90_PPV(1),2);
ind2=find(score(:,2)>=threshold_90_PPV);
ind22=find(score(:,2)<threshold_90_PPV);
Yfit_bag2=Yfit_bag;
Yfit_bag2(ind2)=1;
Yfit_bag2(ind22)=0;
figure
confusionmatrix_PPV=confusionmat(final_label,Yfit_bag2)
stats_2=confusionmatStats(final_label,Yfit_bag2);
confusionchart(final_label,Yfit_bag2,'RowSummary','absolute','ColumnSummary','absolute');





end