function [ svmmodel ] = boh_svm_train( histograms,labels )
% boh_svm_train Train a SVM using a bog kernel
% This implements binary classification so it is a class vs another

% First add to the path the modified version of libsvm with the
% intersection kernel
libsvmpath = 'lib/fast-additivie-svms/libsvm-mat-3.0-1';
fastsvmpath = 'lib/fast-additivie-svms;'

addpath(libsvmpath);
addpath(fastsvmpath);

% type of the interception kernel

% model = svmtrain(histograms,labels);
% default C-SVM model with C = 10
svmmodel = svmtrain(labels,histograms,'-t 5 -b 1');

end

