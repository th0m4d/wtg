clear all

%Add library paths
addpath ./lib/cqt_toolbox
addpath ./lib/k-svd
addpath ./lib/fast-additive-svms
addpath ./lib/fast-additive-svms/libsvm-mat-3.0-1
% K-SVD implementation from Ron Rubinstein
addpath ./lib/ompbox10/
addpath ./lib/ksvdbox13/

folders = {'blues'; 'classical'; 'country'; 'disco'; 'hiphop'; 'jazz'; 'metal'; 'pop'; 'reggae'; 'rock'};

%% Short time audio representation

%create_spec_from_gtzan();
%read_spectrograms_from_filesystem();

%% Codebook generation and encoding

%create_dict_from_gtzan();

% TODO Refactor and move to the right using and specified 
encode_features_using_dictionaries(1);


%% Code word encoding aggregation
create_histograms_from_gtzan();


%% SVM training
histograms = [];
labels = [];

testing_percentage = 90;

[TR,TE,LTR,LTE] = split_into_training_and_testing(testing_percentage);


% 
% for i=1:size(folders,1)
%     folderName = char(folders(i));
%     path = strcat('data/histograms/',folderName,'_data.mat');
%     % Read in the histogram
%     data = load(path);
%     histogram = data.H;
%     histograms = horzcat(histograms, histogram);
%     label = ones(1,size(histogram,2)) * i;
%     labels = horzcat(labels, label);
% end

svmmodel = boh_svm_train(TR' ,LTR');

%Make a prediction to test the model
[svml,svmap,svmd] = boh_svm_predict(svmmodel, TE',LTE');

