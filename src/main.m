clear all

%Add library paths
addpath ./lib/cqt_toolbox
addpath ./lib/k-svd
folders = {'blues'; 'classical'; 'country'; 'disco'; 'hiphop'; 'jazz'; 'metal'; 'pop'; 'reggae'; 'rock'};

%% Short time audio representation

%create_spec_from_gtzan();
%read_spectrograms_from_filesystem();

%% Codebook generation and encoding

%create_dict_from_gtzan();
%read_dictionaries_from_filesystem();

%% Code word encoding aggregation

%% SVM training
histograms = [];
labels = [];

for i=1:size(folders,1)
    folderName = char(folders(i));
    path = strcat('data/histograms/',folderName,'_data.mat');
    % Read in the histogram
    data = load(path);
    histogram = data.H;
    
    histograms = horzcat(histograms, histogram);
    label = double(ones(1,size(histogram,2)) * i);
    labels = horzcat(labels, label);
end


[svmmodel] = boh_svm_train( histograms',labels');
