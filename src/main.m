clear all

%Add library paths
addpath lib/cqt_toolbox
addpath lib/k-svd
addpath lib/fast-additive-svms
addpath lib/fast-additive-svms/libsvm-mat-3.0-1
% K-SVD implementation from Ron Rubinstein
addpath lib/ompbox10
addpath lib/ksvdbox13

%% Configuration parameters

%list of folders to be included into training
%folders = {'blues', 'classical', 'country', 'disco', 'hiphop', 'jazz', 'metal', 'pop', 'reggae', 'rock'};
folders = {'blues', 'classical', 'country'} % 'disco', 'hiphop', 'jazz', 'metal', 'pop', 'reggae', 'rock'};


%feature extraction method: spectrogram or cqt
ex_method = 'spectrogram'
%ex_method = 'cqt'

%numbers of iterations for the generation of the dictionary
num_iterations = 50;

%target sparcity for the encoding of the dictionary
target_sparsity = 2;

%size of the dictionary per genre
dict_size = 50;

%print date and time
fprintf('Starting script at: %s\n', datestr(now));
%what preprocessing:
prep='norm'

%If we use random vector to initialize the Dictionary
random = false;

%Percentage of the data which is used for training. The rest is used for
%testing
training_precentage = 100;

%if we want to use only the whole data  as training and evaluation (10-fold 
% cross validation) if this true this will use the data from the testing 
% directory and encode it separatly.
% if you are using 100% data for training then this should be set to false
use_testing = false;


%% Old data cleanup
util_delete_data();
 
%% Short time audio representation
 fprintf('\n_________________________________________\n');
 fprintf('== Short time audio feature generation ==\n');
 if(strcmp(ex_method, 'spectrogram') == 1)
     create_spec_from_gtzan(training_precentage, folders,prep);
 elseif(strcmp(ex_method, 'cqt') == 1)
     create_cqts_from_gtzan(training_precentage, folders);
 end

%% Codebook generation and encoding
fprintf('\n_________________________________________\n');
fprintf('== dictionary learning ==\n');

create_dict_from_gtzan(dict_size, num_iterations,target_sparsity, folders, ex_method,random);

encode_features_using_dictionaries(target_sparsity, folders, ex_method,use_testing);

%% Code word encoding aggregation
fprintf('\n_________________________________________\n');
fprintf('== Bag of histograms creation ==\n');
create_histograms_from_gtzan(folders,use_testing);

%% SVM training

fprintf('\n_________________________________________\n');
fprintf('== Loading data for SVM ==\n');


[TR,TE,LTR,LTE] = split_into_training_and_testing(folders,use_testing);

% one value
xvalidation_range = [0.3553];

%small
%xvalidation_range = power(2,-1.5:0.5:1.0)

%big
%xvalidation_range = power(2,1.5:0.3:3.0)

%bigger
%xvalidation_range = power(2,3.0:0.3:5.0)


%%SVM Classification usage:

%% SVM with a training-testing set - histogram level
%use boh_svm_train when training with a split data set (90%-10%)
%In this case the cross-validation is done internally by LibSVM
%at histogram leval

fprintf('\n_________________________________________\n');
fprintf('== SVM training ==\n');


svmmodel = boh_svm_train(TR' ,LTR',xvalidation_range,true,true);

fprintf('\n_________________________________________\n');
fprintf('== SVM model testingc==\n');

%Make a prediction to test the model
[svml,svmap,svmd] = boh_svm_predict(svmmodel,TE',LTE');


%% SVM training with full set. Us this function when training with full data
% In this case we only have just one Testing (10-fold cross validation is
% used to predict model accuraccy).

c_value = 0.3553; % with which value of c test?
histograms_per_song = 6; % this is feature dependent for song level acc.
n_fold = 10 ; % how many folds?

% use cross-validation at histogram level to pick the best c
svmmodel = boh_svm_train(TR' ,LTR',xvalidation_range,true,true);

% now do Xvalidation at clip-leval and store the confusion matrix
% as the model is chose using the clip-level accuracy then the x-validation
% had to be reimplemented in matlab directly.

boh_stratified_xvalidation(TR', LTR',c_value,histograms_per_song,n_fold);

svmmodel = boh_svm_train(TR' ,LTR',c_value,true,false);


%get the accuracy per clip
fprintf('Calculating per clip\n');
[a,b] = calc_predict_clip(LTR',svml,histograms_per_song);

acc_clip = (1 - nnz(a - b)/size(a,2))*100;
fprintf('Accuracy  per clip %.2f%% \n',acc_clip);


%print date and time
fprintf('Finishing script at: %s\n', datestr(now));
