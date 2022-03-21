function [dates, count_loc,var_loc] = GPS_features(filename)

[num, txt, raw]=xlsread(filename);
dates = unique(raw(2:end,5));
%raw(2:end,6) = erase(raw(2:end,6),'0 days ');

idx_location    = cellfun(@(x) strcmp(x, 'location'), raw(2:end,7));
raw             = raw(2:end,:);
location        = raw(idx_location,:);

count_loc=zeros(1,length(dates));
% incoming = calls(cellfun(@(x) strcmp(x, '1'), calls(:,11)),:);
% outgoing = calls(cellfun(@(x) strcmp(x, '2'), calls(:,11)),:);

for i = 1:length(dates)
    cur_date          = dates{i};
    location_all_data = location(cellfun(@(x) strcmp(x, cur_date), location(:,5)),:);
%   location_all_data_new(1,i) = location(cellfun(@(x) strcmp(x, 'on'),location(:,5)),:);
    %location_sum     = sum(location_values(:,9));
    value{i}=abs(cellfun(@(x) str2double(x), location_all_data(:,9)));
    var_loc{i}=var(value{i});
    count_loc(1,i)        = size(location_all_data,1);
    %normalize_location = (normalize_feature(count_loc(1,i)))';
end
for i=1:size(count_loc,1)
    
    count_loc(i,:)=normalize_feature(count_loc(i,:));
end
    count_loc=count_loc';
    var_loc=cell2mat(var_loc);
    var_loc=normalize_feature(var_loc);
    var_loc=var_loc';
end
