function normalized_feature = normalize_feature(feature)

feature_notnan = feature(~isnan(feature));
if size(feature_notnan,2)==0
    baseline=1;
elseif size(feature_notnan,2)==1
    baseline = mean(feature_notnan(:,1),2);
elseif size(feature_notnan,2)<14
    baseline = mean(feature_notnan(:,1:2),2);
else
    baseline = mean(feature_notnan(:,1:14),2);
end
normalized_feature = feature./baseline;

end