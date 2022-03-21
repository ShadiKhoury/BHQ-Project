function [dates, count, norm_duration,std_duration,diff_duration_1,diff_duration_2] = calls_features(filename)

[num, txt, raw]=xlsread(filename);
dates = unique(raw(2:end,5));
%raw(2:end,6) = erase(raw(2:end,6),'0 days ');

idx_calls = cellfun(@(x) strcmp(x, 'calls'), raw(2:end,7));
raw = raw(2:end,:);
calls = raw(idx_calls,:);

count=zeros(1,length(dates));
duration=count;
incoming = calls(cellfun(@(x) strcmp(x, '1'), calls(:,11)),:);
outgoing = calls(cellfun(@(x) strcmp(x, '2'), calls(:,11)),:);
missed = calls(cellfun(@(x) strcmp(x, '3'), calls(:,11)),:);
voice_mail = calls(cellfun(@(x) strcmp(x, '4'), calls(:,11)),:);
reject_user = calls(cellfun(@(x) strcmp(x, '5'), calls(:,11)),:);
reject_auto = calls(cellfun(@(x) strcmp(x, '6'), calls(:,11)),:);
ans_app = calls(cellfun(@(x) strcmp(x, '7'), calls(:,11)),:);
for i = 1:length(dates)
    cur_date = dates{i};
    cur_calls=calls(cellfun(@(x) strcmp(x, cur_date), calls(:,5)),:);
    count(1,i) = size(cur_calls,1);
    duration(1,i) = sum(cellfun(@(x) str2double(x), cur_calls(:,9)));
    cur_calls_b=incoming(cellfun(@(x) strcmp(x, cur_date), incoming(:,5)),:);
    count(2,i) = size(cur_calls_b,1);
    duration(2,i) = sum(cellfun(@(x) str2double(x), cur_calls_b(:,9)));
    cur_values_c=outgoing(cellfun(@(x) strcmp(x, cur_date), outgoing(:,5)),:);
    count(3,i) = size(cur_values_c,1);
    cur_values_d=missed(cellfun(@(x) strcmp(x, cur_date), missed(:,5)),:);
    count(4,i) = size(cur_values_d,1);
    cur_calls_b=voice_mail(cellfun(@(x) strcmp(x, cur_date), voice_mail(:,5)),:);
    count(5,i) = size(cur_calls_b,1);
    cur_values_c=reject_user(cellfun(@(x) strcmp(x, cur_date), reject_user(:,5)),:);
    count(6,i) = size(cur_values_c,1);
    cur_values_d=reject_auto(cellfun(@(x) strcmp(x, cur_date), reject_auto(:,5)),:);
    count(7,i) = size(cur_values_d,1);
    cur_calls_b=ans_app(cellfun(@(x) strcmp(x, cur_date), ans_app(:,5)),:);
    count(8,i) = size(cur_calls_b,1);
   
end
for i=1:size(duration,1)
    
    norm_duration(i,:) = normalize_feature(duration(i,:));
end
norm_duration=norm_duration';
diff_duration_1=[];
diff_duration_2=[];
for i=1:size(norm_duration,1)
    if i==1
        diff_duration_1{i}=0;
        diff_duration_2{i}=0;
    else
        diff_duration_1{i}=norm_duration(i,1)-norm_duration(i-1,1);
        diff_duration_2{i}=norm_duration(i,2)-norm_duration(i-1,2);
    end
end

diff_duration_1=cell2mat(diff_duration_1)';
diff_duration_2=cell2mat(diff_duration_2)';
std_duration=std(norm_duration)';


for i=1:size(count,1)
    
    count(i,:)=normalize_feature(count(i,:));
end
 count=count';

% figure; 
% yyaxis left; plot(datetime(dates),count); xlabel('Date','FontSize',14); ylabel('Total # of calls','FontSize',14) 
% yyaxis right; plot(datetime(dates),duration); ylabel('Total calls time','FontSize',14)
% title(['User : ' filename])
% ax=gca;
% ax.FontSize = 14;

end

