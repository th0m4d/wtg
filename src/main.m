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
%folders = {'blues'; 'classical'; 'country'; 'disco'; 'hiphop'; 'jazz'; 'metal'; 'pop'; 'reggae'; 'rock'};
folders = {'blues';'classical'};

%feature extraction method: spectrogram or cqt
ex_method = 'spectrogram'

%numbers of iterations for the generation of the dictionary
num_iterations = 10;

%target sparcity for the encoding of the dictionary
target_sparcity = 1;

%print date and time
fprintf('Starting script at: %s\n', datestr(now));

%% Old data cleanup
util_delete_data();

%% Short time audio representation
fprintf('\n_________________________________________\n');
fprintf('== Short time audio feature generation ==\n');
if(strcmp(ex_method, 'spectrogram') == 1)
    create_spec_from_gtzan(90, folders);
elseif(strcmp(ex_method, 'cqt') == 1)
    create_cqts_from_gtzan(90, folders);
end

%% Codebook generation and encoding
fprintf('\n_________________________________________\n');
fprintf('== dictionary learning ==\n');

create_dict_from_gtzan(50, num_iterations, folders, ex_method);

encode_features_using_dictionaries(target_sparcity, folders, ex_method);

%% Code word encoding aggregation
fprintf('\n_________________________________________\n');
fprintf('== Bag of histograms creation ==\n');
create_histograms_from_gtzan(folders);

%% SVM training
fprintf('\n_________________________________________\n');
fprintf('== SVM training ==\n');

histograms = [];
labels = [];


[TR,TE,LTR,LTE] = split_into_training_and_testing(folders);

% call like this to perform cross validation
xvalidation_range = power(1.5,5:0.7:12);
svmmodel = boh_svm_train(TR' ,LTR',xvalidation_range);

%call like this to train with an specific value
%C = 55;
%svmmodel = boh_svm_train(TR' ,LTR',0,C);

fprintf('\n_________________________________________\n');
fprintf('== SVM model testingc==\n');

%Make a prediction to test the model
[svml,svmap,svmd] = boh_svm_predict(svmmodel, TE',LTE');

%print date and time
fprintf('Starting script at: %s\n', datestr(now));

