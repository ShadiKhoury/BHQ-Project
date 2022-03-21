%% Importing the data
d = uigetdir();
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

%     idx_accelerometer = cellfun(@(x) strcmp(x, 'acelerometer'), raw(2:end,7));
%     idx_activity_recognition = cellfun(@(x) strcmp(x, 'activity_recognition'), raw(2:end,7));
%     idx_battery = cellfun(@(x) strcmp(x, 'battery'), raw(2:end,7));
%     idx_bluetooth = cellfun(@(x) strcmp(x, 'bluetooth'), raw(2:end,7));
%     idx_calls = cellfun(@(x) strcmp(x, 'calls'), raw(2:end,7));
%     idx_gyroscope = cellfun(@(x) strcmp(x, 'gyroscope'), raw(2:end,7));
%     idx_light = cellfun(@(x) strcmp(x, 'light'), raw(2:end,7));
%     idx_location = cellfun(@(x) strcmp(x, 'location'), raw(2:end,7));
%     idx_magnetic = cellfun(@(x) strcmp(x, 'magnetic'), raw(2:end,7));
%     idx_screen_state = cellfun(@(x) strcmp(x, 'screenstate'), raw(2:end,7));
%     idx_wireless = cellfun(@(x) strcmp(x, 'wireless'), raw(2:end,7));
%     raw = raw(2:end,:);
%     accelerometer = raw(idx_accelerometer,:);
%     %accelerometer=accelerometer(:,[12 13 14]);
%     activity_recognition = raw(idx_activity_recognition,:);
%     %activity_recognition=activity_recognition(:,[10 11]);
%     battery = raw(idx_battery,:);
%     %battery=battery(:,[9 10 11]);
%     bluetooth = raw(idx_bluetooth,:);
%     %bluetooth=bluetooth(:,[8 9 10]);
%     calls = raw(idx_calls,:);
% %     calls=calls(:,[ 5 8 9 11]);
%     gyroscope = raw(idx_gyroscope,:);
%     gyroscope=gyroscope(:,[12 13 14]);
%     light = raw(idx_light,:);
%     
%     location = raw(idx_location,:);
%     
%     magnetic = raw(idx_magnetic,:);
%     screen_state = raw(idx_screen_state,:);
%     wireless = raw(idx_wireless,:);
%     
    %% Extract label
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
    feature_matrix_k=feature_matrix_k(:,[1 6 11 13 16 18 19 20 21 22 25 26 28 31 32 33 34 35]);
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
[idx,weights]=Feature_selction(feature_matrix,final_label,10)
%%
top_10_idx      = [idx(1:10)];
new_filterd_window_data         = feature_matrix(:,top_10_idx);
%[differ,cor_features,cor_feature_label ]        = MMRcorrolation(new_filterd_window_data, labels_Window)
%figure
%gplotmatrix(new_filterd_window_data,[],labels_Window)
all_data=[new_filterd_window_data,final_label];
    
%% croos
% Cross varidation (train: 70%, test: 30%)
cv = cvpartition(size(final_label,1),'HoldOut',0.3);
disp(cv)
idxx = cv.test;
istrain = training(cv); % Data for fitting
istest = test(cv);   
% Separate to training and test data
dataTrain_window       = new_filterd_window_data(~idxx,:); % Data for fitting
labelTrain_window      =final_label(~idxx,:);  % labels for fitting
dataTest_window       = new_filterd_window_data(idxx,:); % Data for quality assessment
labelTest_window       =final_label(idxx,:);  % labels for quality assessment


%% Create the RandomForest ensemble
rng('default')
t = templateTree('Reproducible',true,'MaxNumSplits',1000,'Prune','on'); % For reproducibility of random predictor selections);
%t = templateTree('MaxNumSplits',3,'NumVariablesToSample',1);
num_trees=35;
tic
bagTree = fitcensemble(dataTrain_window,labelTrain_window,'Method','RUSBoost','NPrint',300,'NumBins',250,'NumLearningCycles',1000,'LearnRate',0.05,'Prior','empirical','Learners',t);
disp('Training time for RandomForest:')
toc

% for r=1:5
%     view(bagTree.Trained{r},'Mode','graph')
% end
%% Calculate confusion matrix
tab=tabulate(final_label(istest));
tic;
[Yfit_bag,score] = predict(bagTree,dataTest_window);
disp('Prediction time for RandomForest prediction:');
toc
disp('Confusion matrix (percentage) with Random Forest:');
stt=confusionmat(labelTest_window,Yfit_bag)
stats_trigger=confusionmatStats(Yfit_bag,labelTest_window)
figure;
confusionchart(final_label(istest),Yfit_bag,'RowSummary','absolute','ColumnSummary','absolute');






%%  select a working point max senestivity
%plot(score)
[x_PRC,y_PRC]=perfcurve(final_label(istest),score(:,2),tab(2),"XCrit","tpr","YCrit",'ppv');
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
confusionmatrix_recall=confusionmat(final_label(istest),Yfit_bag1)
stats_1=confusionmatStats(final_label(istest),Yfit_bag1);
confusionchart(final_label(istest),Yfit_bag1,'RowSummary','absolute','ColumnSummary','absolute');
%% selecting maximum PPV= Precscion
idx90_PPV=find(y_PRC>=0.9);
if size(idx90_PPV,1)==0
    idx90_PPV=find(max(y_PRC));
end
threshold_90_PPV=score(idx90_PPV,2);
ind2=find(score(:,2)>=threshold_90_PPV);
ind22=find(score(:,2)<threshold_90_PPV);
Yfit_bag2=Yfit_bag;
Yfit_bag2(ind2)=1;
Yfit_bag2(ind22)=0;
figure
confusionmatrix_PPV=confusionmat(final_label(istest),Yfit_bag2)
stats_2=confusionmatStats(final_label(istest),Yfit_bag2);
confusionchart(final_label(istest),Yfit_bag2,'RowSummary','absolute','ColumnSummary','absolute');



%% The Model you want to release to the world
tic
bagTree_Submit= fitcensemble(new_filterd_window_data,final_label,'Method','RUSBoost','NPrint',300,'NumBins',500,'NumLearningCycles',1000,'LearnRate',0.05,'Prior','empirical','Learners',t);
disp('Training time for RandomForest:')
toc