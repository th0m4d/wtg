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
k = 20;
%range for the exponential c value
%x = 
cval = power(2,-5:0.7:2); % power(2,-5:1:15); % exp(x);

sprintf('Training model using 10-fold cross validation from C= %d to %d...',cval(1),cval(9));

 for i = 1:1:5
     fprintf('Training with %0.5f   -  ',cval(i));
     newacc =   svmtrain(labels,histograms,sprintf('-t 5 -b 1 -v 10 -c %0.5f',cval(i)));
     if ( newacc > acc && newacc < 99) 
         acc = newacc;
         C = cval(i);
     end
 end
%C = 0.12500;

fprintf('Best parameter C=%i with an accuract of %f\n',C,acc);
fprintf('Retraining...');
    svmmodel = svmtrain(labels,histograms,sprintf('-t 5 -b 1 -c %0.5f ', C));
fprintf('DONE\n');

end

