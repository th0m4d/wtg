function [svml,svmap,svmd] = boh_svm_predict(model, histograms,labels )
% boh_svm_train Train a SVM using a bog kernel
% This implements binary classification so it is a class vs another

% First add to the path the modified version of libsvm with the
% intersection kernel
libsvmpath = 'lib/fast-additivie-svms/libsvm-mat-3.0-1';
fastsvmpath = 'lib/fast-additivie-svms;'

addpath(libsvmpath);
addpath(fastsvmpath);

[svml,svmap,svmd] = svmpredict(l,x,model,'-b 1');

end

