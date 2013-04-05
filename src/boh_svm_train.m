function  svmmodel  = boh_svm_train( histograms,labels,range,C)
% boh_svm_train Train a SVM using a bog kernel
% This implements binary classification so it is a class vs another
% First add to the path the modified version of libsvm with the
% intersection kernel
% type of the interception kernel
% noxvalidation: if this parameter is present then no x validation is done
% cdefault: when not executing crossvalidation then a value of C is
% necessay is this parameter is not set then C=1 is used.

addpath ./lib/fast-additive-svms/libsvm-mat-3.0-1/
addpath ./lib/fast-additive-svms/

  
doxvalidation = 1;

if nargin < 4
   C = 1;
end

if nargin > 3
    if range == 0
    doxvalidation = 0;
    end
end


% model = svmtrain(histograms,labels);
% default C-SVM model with C = 1 and 10-fold cross validation
%svmmodel = svmtrain(labels,histograms,'-t 5 -b 1 -v 10');

acc = 0;
%start x value for the exponential c parameter
j = -15;
%end x value for the exponential c parameter
k = 20;
%range for the exponential c value
%x = 
cval =  range; %power(2,3.8:0.2:6); % power(2,-5:1:15); % exp(x);

if doxvalidation == 1 % crosvalidation

fprintf('Training model using 10-fold cross validation from C= %d to %d...\n',cval(1),cval(size(cval,2)));
fprintf('Training with %d training samples \n',size(labels,1));

for i = 1:size(cval,2)
      fprintf('Training with %0.5f \n',cval(i));
      newacc =   svmtrain(labels,histograms,sprintf('-t 5 -b 1 -v 10 -c %0.5f',cval(i)));
      if ( newacc > acc) 
          acc = newacc;
          C = cval(i);
      end
      
     if(acc >= 99)
          break;
      end
end


%C = cval(i);

fprintf('Best parameter C=%i with an accuracy of %f\n',C,acc);
fprintf('Retraining...'); %Cross validation END
else
    
fprintf('Training model directly with C=%i..',C);    
end 

svmmodel = svmtrain(labels,histograms,sprintf('-t 5 -b 1 -c %0.5f ', C));
fprintf('DONE\n');

end

