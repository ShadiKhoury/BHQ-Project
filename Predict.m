%% PREDICTION
set(0,'DefaultFigureWindowStyle','docked')
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
confusionmat(labelTest_window,Yfit_bag)
stats_trigger=confusionmatStats(Yfit_bag,labelTest_window);
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