function  svmmodel  = boh_svm_train( histograms,labels )
% boh_svm_train Train a SVM using a bog kernel
% This implements binary classification so it is a class vs another

% First add to the path the modified version of libsvm with the
% intersection kernel
% type of the interception kernel
addpath ./lib/fast-additive-svms/libsvm-mat-3.0-1/
addpath  ./lib/fast-additive-svms/



% model = svmtrain(histograms,labels);
% default C-SVM model with C = 1 and 10-fold cross validation
svmmodel = svmtrain(labels,histograms,'-t 5 -b 1 -v 10');

end

