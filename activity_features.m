function [dates,avg_act,count_activity] = activity_features(filename)

[num, txt, raw]=xlsread(filename);
dates = unique(raw(2:end,5));
%raw(2:end,6) = erase(raw(2:end,6),'0 days ');

idx_active = cellfun(@(x) strcmp(x, 'activity_recognition'), raw(2:end,7));
raw = raw(2:end,:);
activityrecognition = raw(idx_active,:);
%%
act_still = activityrecognition(cellfun(@(x) strcmp(x, 'STILL'), activityrecognition(:,11)),:);
act_tilt = activityrecognition(cellfun(@(x) strcmp(x,'TILTING'), activityrecognition(:,11)),:);
act_foot = activityrecognition(cellfun(@(x) strcmp(x,'ON_FOOT'), activityrecognition(:,11)),:);
act_unkonw = activityrecognition(cellfun(@(x) strcmp(x,'UNKNOWN'), activityrecognition(:,11)),:);
act_veh = activityrecognition(cellfun(@(x) strcmp(x,'IN_VEHICLE'), activityrecognition(:,11)),:);

count_actibity=zeros(1,length(dates));
duration=count_actibity;
%%
for i = 1:length(dates)
    cur_date = dates{i};
    cur_values_all=activityrecognition(cellfun(@(x) strcmp(x, cur_date), activityrecognition(:,5)),:);
    value=abs(cellfun(@(x) str2double(x), cur_values_all(:,10)));
    avg_act(1,i)=mean(value);
    %
    cur_calls=act_still(cellfun(@(x) strcmp(x, cur_date), act_still(:,5)),:);
    count_activity(1,i) = size(cur_calls,1);
    value=abs(cellfun(@(x) str2double(x), cur_calls(:,10)));
    avg_act(2,i)=mean(value);
    %
    
    cur_calls_b=act_tilt(cellfun(@(x) strcmp(x, cur_date), act_tilt(:,5)),:);
    count_activity(2,i) = size(cur_calls_b,1);
    value=abs(cellfun(@(x) str2double(x), cur_calls(:,10)));
    avg_act(3,i)=mean(value);
    %
    
    cur_values_c=act_foot(cellfun(@(x) strcmp(x, cur_date), act_foot(:,5)),:);
    count_activity(3,i) = size(cur_values_c,1);
    value=abs(cellfun(@(x) str2double(x), cur_values_c(:,10)));
    avg_act(4,i)=mean(value);
    %
    cur_values_d=act_unkonw(cellfun(@(x) strcmp(x, cur_date), act_unkonw(:,5)),:);
    count_activity(4,i) = size(cur_values_d,1);
    value=abs(cellfun(@(x) str2double(x), cur_values_d(:,10)));
    avg_act(5,i)=mean(value);
    %
    cur_calls_b=act_veh(cellfun(@(x) strcmp(x, cur_date), act_veh(:,5)),:);
    count_activity(5,i) = size(cur_calls_b,1);
    value=abs(cellfun(@(x) str2double(x), cur_calls_b(:,10)));
    avg_act(6,i)=mean(value);
   
end
for i=1:size(avg_act)
    avg_act(i,:)=normalize_feature(avg_act(i,:));
    
end
avg_act=avg_act';
for i=1:size(count_activity,1)
    
    count_activity(i,:)=normalize_feature(count_activity(i,:));
end
 count_activity=count_activity';
end