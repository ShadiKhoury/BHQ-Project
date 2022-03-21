function [FPR,TPR]=plot_my_ROC(Y,score,val)
%Y - labels vector
%score - the threshold (how many numbers we want to say val?
%val - the class
sum_Y_val=sum(Y==val); %how many val class in Y?
sum_Y_not_val=sum(Y~=val); %how many not val class in Y?
sorted_score=unique(score); %score values without repetitions
len=length(sorted_score);
TPR=nan(len,1); %empty vector for sensitivity
FPR=TPR; %empty vector for specificity
for r=1:len
TPR(r)=sum(Y==val & score>=sorted_score(r))/sum_Y_val;
%how many TP above threshold out of all positive?
FPR(r)=sum(Y~=val & score>=sorted_score(r))/sum_Y_not_val;
%how many TN above threshold out of all negative?
end
% plot(FPR,TPR)
% line([0 1],[0 1],'color','r')
% xlim([0 1]);ylim([0 1])