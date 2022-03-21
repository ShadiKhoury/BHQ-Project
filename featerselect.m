%% feater selection
load('final_label_Adir.mat')
load('feature_matrix_Adir.mat')
feature_matrix(isnan(feature_matrix))=0;
feature_matrix(isinf(feature_matrix)|isnan(feature_matrix)) = 0;
feature_matrix=feature_matrix(:,[1 2 3 4 6 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34]);
nfeature_matrix=feature_matrix(:,[1 4 5 7 8 9 11 12 14 15 16 17 21 22 23 24 29]);
[differ,cor_features,cor_feature_label ] = new_MMRcorrolation(nfeature_matrix, final_label);
feature_matrix=nfeature_matrix;