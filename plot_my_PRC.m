function [TPR,PPV]=plot_my_PRC(Y,score,val)
%Y - labels vector
%score - the threshold (how many numbers we want to say val?
%val - the class
sum_Y_val=sum(Y==val); %how many val class in Y?
sorted_score=unique(score); %score values without repetitions
len=length(sorted_score);
TPR=nan(len,1); %empty vector for sensitivity
PPV=TPR; %empty vector for PPV
for r=1:length(sorted_score)
TPR(r)=sum(Y==val & score>=sorted_score(r))/sum_Y_val;
%how many TP above threshold out of all positive?
PPV(r)=sum(Y==val & score>=sorted_score(r))/sum(score>=sorted_score(r));
%how many TP above threshold out of everyone who was result as
%positive?
end