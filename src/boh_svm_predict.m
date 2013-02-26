function [svml,svmap,svmd] = boh_svm_predict(model, histograms,labels )
% boh_svm_train Train a SVM using a bog kernel
% This implements binary classification so it is a class vs another
% model:  model obtained from boh_svm_train
% histograms: The agregated histograms of the songs
% labels for each group of histogram (a number)

% First add to the path the modified version of libsvm with the
% intersection kernel
addpath ./lib/fast-additive-svms/libsvm-mat-3.0-1/
addpath  ./lib/fast-additive-svms/


[svml,svmap,svmd] = svmpredict(labels, histograms, model, '-b 1');

end

