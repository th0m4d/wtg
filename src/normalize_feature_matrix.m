%% 
% Takes a m x n matrix whose columns are feature vectors. Every feature
% vector is normalized isolated a_norm = a/|a|
function A_norm = normalize_feature_matrix(A)

[rows,~]=size(A);

%take max absolute value to account for negative numbers
colMax = max(abs(A),[],1);
A_norm = A./repmat(colMax,rows,1);
