function [dates,max_light_after_t1,max_light_after_t2,avg_ligt] = light_features(filename,t1,t2)

[num, txt, raw]=xlsread(filename);
dates = unique(raw(2:end,5));
%raw(2:end,6) = erase(raw(2:end,6),'0 days ');

idx_light = cellfun(@(x) strcmp(x, 'light'), raw(2:end,7));
raw = raw(2:end,:);
light = raw(idx_light,:);

t_init1 = datenum(t1);
t_init2 = datenum(t2);

max_light_after_t1 = nan*zeros(1,length(dates));
max_light_after_t2 = nan*zeros(1,length(dates));

avg_ligt={};
for i = 1:length(dates)
    cur_date = dates{i};
    cur_light=light(cellfun(@(x) strcmp(x, cur_date), light(:,5)),:);
    if size(cur_light,1)==0
        avg_ligt=[avg_ligt,0];
        continue
    else
        
    value{i}=abs(cellfun(@(x) str2double(x), cur_light(:,9)));
    avg_ligt=[avg_ligt,mean(value{i})];
    %diff_light{i}=var(value{i});
    
    
    idx_after_20 = cellfun(@(x) datenum(x) > t_init1, cur_light(:,6));
    idx_after_23 = cellfun(@(x) datenum(x) > t_init2, cur_light(:,6));
    
    if sum(idx_after_20)>0
        max_light_after_t1(1,i) = max(cellfun(@(x) str2double(x), cur_light(idx_after_20,9)));
        %avg_light_after_t1(1,i) = mean(cellfun(@(x) str2double(x), cur_light(idx_after_20,9)));
        
    end
    
    if sum(idx_after_23)>0
        max_light_after_t2(1,i) = max(cellfun(@(x) str2double(x), cur_light(idx_after_23,9)));
        %avg_light_after_t2(1,i) = mean(cellfun(@(x) str2double(x), cur_light(idx_after_23,9)));
    end
    end
end
    avg_ligt=cell2mat(avg_ligt);
    avg_ligt=normalize_feature(avg_ligt);
    avg_ligt=avg_ligt';
    for i=1:size(max_light_after_t1,1)
        max_light_after_t1(i,:)=normalize_feature(max_light_after_t1(i,:));
        %avg_light_after_t1(i,:)=normalize_feature(avg_light_after_t1(i,:));
    end
   
    
    for i=1:size(max_light_after_t2,1)
        max_light_after_t2(i,:)=normalize_feature(max_light_after_t2(i,:));
        %avg_light_after_t2(i,:)=normalize_feature(avg_light_after_t2(i,:));
    end
    
    %%
    max_light_after_t1=max_light_after_t1';
    %avg_light_after_t1=avg_light_after_t1';
    max_light_after_t2=max_light_after_t2';
    %avg_light_after_t2=avg_light_after_t2';
    
%     diff_light=cell2mat(diff_light);
%     diff_light=normalize_feature(diff_light);
%     diff_light=diff_light';
    
% figure; 
% plot(datetime(dates),max_light_after_t); xlabel('Date','FontSize',14); ylabel(['Max light level from ' t],'FontSize',14) 
% title(['User : ' filename])
% ax=gca;
% ax.FontSize = 14;
end