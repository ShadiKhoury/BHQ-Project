function [dates, value, avg_wireless,std_wireless,diff_wireless] = wireless_features(filename)

[num, txt, raw]=xlsread(filename);
dates = unique(raw(2:end,5));
%raw(2:end,6) = erase(raw(2:end,6),'0 days ');

idx_wireless = cellfun(@(x) strcmp(x, 'wireless'), raw(2:end,7));
raw = raw(2:end,:);
wireless = raw(idx_wireless,:);

count=zeros(1,length(dates));
duration=count;
for i = 1:length(dates)
    cur_date = dates{i};
    cur_values=wireless(cellfun(@(x) strcmp(x, cur_date), wireless(:,5)),:);
    value{i}=abs(cellfun(@(x) str2double(x), cur_values(:,9)));
    avg_wireless{i}=mean(value{i});
    std_wireless{i}=std(value{i});
    diff_wireless{i}=var(diff(value{i}));
%     if i ==1
%         change_wireless{i}=0;
%     else
%         change_wierless{i}=(mean(value{i})-mean(value{i-1}));
%     end
end
    avg_wireless=cell2mat(avg_wireless);
    avg_wireless=normalize_feature(avg_wireless);
    avg_wireless=avg_wireless';
    
    std_wireless=cell2mat(std_wireless);
    std_wireless=normalize_feature(std_wireless);
    std_wireless=std_wireless';
    
    diff_wireless=cell2mat(diff_wireless);
    diff_wireless=normalize_feature(diff_wireless);
    diff_wireless=diff_wireless';
    
    
%     change_wierless=cell2mat(change_wierless);
%     change_wierless=normalize_feature(change_wierless);
%     change_wierless=change_wierless';
end
