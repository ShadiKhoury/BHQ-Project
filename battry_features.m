function [dates, value, avg_batt_all,count,change_batt,std_batt] = battry_features(filename)

[num, txt, raw]=xlsread(filename);
dates = unique(raw(2:end,5));
%raw(2:end,6) = erase(raw(2:end,6),'0 days ');

idx_battery = cellfun(@(x) strcmp(x, 'battery'), raw(2:end,7));
raw = raw(2:end,:);
battery = raw(idx_battery,:);
%%
battery_tag = battery(cellfun(@(x) strcmp(x, 'battery'), battery(:,11)),:);
usbcharge = battery(cellfun(@(x) strcmp(x,'usbCharge'), battery(:,11)),:);
accharge =battery(cellfun(@(x) strcmp(x, 'acCharge'), battery(:,11)),:);
count=zeros(1,length(dates));
duration=count;
%%
for i = 1:length(dates)
    cur_date = dates{i};
    cur_values_all=battery(cellfun(@(x) strcmp(x, cur_date), battery(:,5)),:);
    value{i}=abs(cellfun(@(x) str2double(x), cur_values_all(:,9)));
    avg_batt_all{i}=mean(value{i});
    
    if i ==1
        change_batt{i}=0;
    else
        change_batt{i}=(mean(value{i})-mean(value{i-1}));
    end
    std_batt{i}=std(value{i});
    cur_values_b=battery_tag(cellfun(@(x) strcmp(x, cur_date), battery_tag(:,5)),:);
    count(1,i) = size(cur_values_b,1);
    cur_values_c=usbcharge(cellfun(@(x) strcmp(x, cur_date), usbcharge(:,5)),:);
    count(2,i) = size(cur_values_c,1);
    cur_values_d=accharge(cellfun(@(x) strcmp(x, cur_date), accharge(:,5)),:);
    count(3,i) = size(cur_values_d,1);
    
    
    
    
end
    avg_batt_all=cell2mat(avg_batt_all);
    avg_batt_all=normalize_feature(avg_batt_all);
    avg_batt_all=avg_batt_all';
    count(1,:)=normalize_feature(count(1,:));
    count(2,:)=normalize_feature(count(2,:));
    count(3,:)=normalize_feature(count(3,:));
    count=count';
    
    change_batt=cell2mat(change_batt);
    change_batt=normalize_feature(change_batt);
    change_batt=change_batt';
    
    std_batt=cell2mat(std_batt);
    std_batt=normalize_feature(std_batt);
    std_batt=std_batt';
end