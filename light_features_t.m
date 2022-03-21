function [dates,max_light_after_t,avg_ligt] = light_features_t(filename,t)

[num, txt, raw]=xlsread(filename);
dates = unique(raw(2:end,5));
raw(2:end,6) = erase(raw(2:end,6),'0 days ');

idx_light = cellfun(@(x) strcmp(x, 'light'), raw(2:end,7));
raw = raw(2:end,:);
light = raw(idx_light,:);

t_init = datenum(t);
max_light_after_t = nan*zeros(1,length(dates));

for i = 1:length(dates)
    cur_date = dates{i};
    cur_light=light(cellfun(@(x) strcmp(x, cur_date), light(:,5)),:);
    avg_ligt{i}=mean(cur_light{i});
    idx_after_20 = cellfun(@(x) datenum(x) > t_init, cur_light(:,6));
    if sum(idx_after_20)>0
        max_light_after_t(1,i) = max(cellfun(@(x) str2double(x), cur_light(idx_after_20,9)));
    end
end
    avg_ligt=cell2mat(avg_ligt);
    avg_ligt=normalize_feature(avg_ligt);
    avg_ligt=avg_ligt';
    for i=1:size(max_light_after_t,1)
        max_light_after_t(i,:)=normalize_feature(max_light_after_t(i,:));
    end
    max_light_after_t=max_light_after_t';
    
    
% figure; 
% plot(datetime(dates),max_light_after_t); xlabel('Date','FontSize',14); ylabel(['Max light level from ' t],'FontSize',14) 
% title(['User : ' filename])
% ax=gca;
% ax.FontSize = 14;
end