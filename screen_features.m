function [dates,count_screen,screen_after_24] = screen_features(filename,t)

[num, txt, raw]=xlsread(filename);
dates = unique(raw(2:end,5));
%raw(2:end,6) = erase(raw(2:end,6),'0 days ');

idx_screen_state = cellfun(@(x) strcmp(x, 'screenstate'), raw(2:end,7));
raw = raw(2:end,:);
screen_state = raw(idx_screen_state,:);
%%
t_init = datenum(t);
screen_on = screen_state(cellfun(@(x) strcmp(x, 'on'), screen_state(:,9)),:);
screen_of = screen_state(cellfun(@(x) strcmp(x,'off'), screen_state(:,9)),:);
screen_after_24=zeros(1,length(dates));
count_screen=zeros(1,length(dates));
duration=count_screen;
%%
for i = 1:length(dates)
    cur_date = dates{i};
    cur_screen_state=screen_state(cellfun(@(x) strcmp(x, cur_date), screen_state(:,5)),:);
    idx_after_24 = cellfun(@(x) datenum(x) > t_init, cur_screen_state(:,6));
    if sum(idx_after_24)>0
        for i=1:size(idx_after_24,1)
            if cellfun(@(x) strcmp(x, 'on'), screen_state(i,9))==1
            screen_after_24(1,i) = 1;
        else
            screen_after_24(1,i) = 0;
            end
        end
end
    
for i = 1:length(dates)
    cur_date = dates{i};
    cur_values_b=screen_on(cellfun(@(x) strcmp(x, cur_date), screen_on(:,5)),:);
    count_screen(1,i) = size(cur_values_b,1);
    cur_values_c=screen_of(cellfun(@(x) strcmp(x, cur_date), screen_of(:,5)),:);
    count_screen(2,i) = size(cur_values_c,1);
end
    
    
    
    
end
    screen_after_24=normalize_feature(screen_after_24(1,:));
    count_screen(1,:)=normalize_feature(count_screen(1,:));
    count_screen(2,:)=normalize_feature(count_screen(2,:));
    count_screen=count_screen';
    screen_after_24=screen_after_24';
end