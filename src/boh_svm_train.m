function  svmmodel  = boh_svm_train( histograms,labels )
% boh_svm_train Train a SVM using a bog kernel
% This implements binary classification so it is a class vs another

% First add to the path the modified version of libsvm with the
% intersection kernel
% type of the interception kernel
addpath ./lib/fast-additive-svms/libsvm-mat-3.0-1/
addpath ./lib/fast-additive-svms/



% model = svmtrain(histograms,labels);
% default C-SVM model with C = 1 and 10-fold cross validation
%svmmodel = svmtrain(labels,histograms,'-t 5 -b 1 -v 10');

C = 1;
acc = 0;
%start x value for the exponential c parameter
j = -15;
%end x value for the exponential c parameter
k = 10;
%range for the exponential c value
x = j:k;
cval = exp(x);

sprintf('Training model using 10-fold cross validation from C= %d to %d...',j,k);

for i = 1:1:size(cval,2)
    newacc =   svmtrain(labels,histograms,sprintf('-t 5 -b 1 -v 10 -c %0.5f',cval(i)));
    if newacc > acc
        acc = newacc;
        C = cval(i);
    end
end

fprintf('Best parameter C=%i with an accuract of %f\n',C,acc);
fprintf('Retraining...');
    svmmodel = svmtrain(labels,histograms,sprintf('-t 5 -b 1 -c %i ',C));
fprintf('DONE\n');

end

