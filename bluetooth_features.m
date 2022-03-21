function [dates, avg_bluetooth_all,count_bluetoth] = bluetooth_features(filename)

[num, txt, raw]=xlsread(filename);
dates = unique(raw(2:end,5));
%raw(2:end,6) = erase(raw(2:end,6),'0 days ');

idx_bluetooth = cellfun(@(x) strcmp(x, 'bluetooth'), raw(2:end,7));
raw = raw(2:end,:);
bluetooth = raw(idx_bluetooth,:);
%%
bluetooth_on = bluetooth(cellfun(@(x) strcmp(x, 'on'), bluetooth(:,10)),:);
bluetooth_off = bluetooth(cellfun(@(x) strcmp(x,'off'), bluetooth(:,10)),:);
count_bluetoth=zeros(1,length(dates));
duration=count_bluetoth;
%%
for i = 1:length(dates)
    cur_date = dates{i};
    cur_values_all=bluetooth(cellfun(@(x) strcmp(x, cur_date), bluetooth(:,5)),:);
    value{i}=abs(cellfun(@(x) str2double(x), cur_values_all(:,9)));
    avg_bluetooth_all{i}=mean(value{i});
    cur_values_b=bluetooth_on(cellfun(@(x) strcmp(x, cur_date), bluetooth_on(:,5)),:);
    count_bluetoth(1,i) = size(cur_values_b,1);
    cur_values_c=bluetooth_off(cellfun(@(x) strcmp(x, cur_date), bluetooth_off(:,5)),:);
    count_bluetoth(2,i) = size(cur_values_c,1);
    
    
    
    
end
    avg_bluetooth_all=cell2mat(avg_bluetooth_all);
    avg_bluetooth_all=normalize_feature(avg_bluetooth_all);
    avg_bluetooth_all=avg_bluetooth_all';
    count_bluetoth(1,:)=normalize_feature(count_bluetoth(1,:));
    count_bluetoth(2,:)=normalize_feature(count_bluetoth(2,:));
    count_bluetoth=count_bluetoth';
end