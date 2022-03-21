function [differ,cor_features,cor_feature_label ] = new_MMRcorrolation(data_matrix, final_label)
%%
close all;
data_matrix=normalize(data_matrix);
meas=data_matrix;
species=final_label;

cor_features        =   corr(data_matrix)
heatmap(cor_features)
differ=abs(cor_features)>0.7;
%gplotmatrix(meas,[],species);

%% feature-feature correlation
rff_Pearson=corr(meas,'type','Pearson'); figure; heatmap(abs(rff_Pearson));title('Pearson correlation - Heatmap')
rff_Spearman=corr(meas,'type','Spearman');figure; heatmap(abs(rff_Spearman));title('Spearman correlation - Heatmap')
%% selecting featture selection function
%We also tried using MI and pearson but separman was better:
corr_func=@spearman_correlation;
corr_func_name='Spearman Correlation';

%% feature-label correlation
len=size(meas,2);
W=zeros(len,1);
for j=1:len
    [~,W(j)] = relieff(meas(:,j),species,10);
end
disp(['relieff weights are: ',num2str(W')])
cor_feature_label=W;
feature_class_correlation=cor_feature_label;
%% Use mutual information to test correlation and
y=final_label;
len=size(meas,2);
d_meas=zeros(size(meas));
for r=1:len
    [d_meas(:,r),~]=discretize(meas(:,r),tsprctile(meas(:,r),[0,30,50,70,100]));
end
MI=zeros(len,1);
for r=1:len
    MI(r)=spearman_correlation(d_meas(:,r),y);
    disp(['Spearman correlation of feature #',num2str(r),' = ',num2str(MI(r))])
end
[~,max_ind]=max(MI);
disp(['Maximum mutual information between feature #',num2str(max_ind),' with label'])
columns_indices=1:len;
columns_indices=setdiff(columns_indices,max_ind);
MI2=zeros(len-1,1);
for r=columns_indices
    MI2(r)=corr_func(d_meas(:,[max_ind,r]),y);
    disp(['Spearman correlation of feature #',num2str(max_ind),' with feature #',num2str(r),' = ',num2str(MI2(r))])
end
end