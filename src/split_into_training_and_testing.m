
%% 
%Takes a GTZAN histogram matrix and splits it up into a matrix with 90% of
%the songs and another matrix with 10% randomly selected songs from each
%genre.
%
% k_fold = the percentage of the testset measurements
function [TR,TE,LTR,LTE] = split_into_training_and_testing(folders)

histograms_training = [];
histograms_testing = [];
labels_training = [];
labels_testing = [];

% Now this function is easier because the data is already splitted into two
% different directories

num_genres = size(folders,1);

parfor i=1:num_genres
    folderName = char(folders(i));
    path = strcat('data/histograms/training/',folderName,'_data.mat');
    % Read in the histogram
    data = load(path);
    %histogram = data.H;
    
    training = data.H_tr;
    histograms_training = horzcat(histograms_training, training);
    label_training = ones(1,size(training,2)) * i;
    
    
    labels_training = horzcat(labels_training, label_training);
end

parfor i=1:num_genres
    folderName = char(folders(i));
    path = strcat('data/histograms/testing/',folderName,'_data.mat');
    % Read in the histogram
    data = load(path);
    %histogram = data.H;
    
    testing = data.H_te;
    histograms_testing = horzcat(histograms_testing, testing);
    label_testing = ones(1,size(testing,2)) * i;
    
    
    labels_testing = horzcat(labels_testing, label_testing);
end


TR = histograms_training;
TE = histograms_testing;
LTR = labels_training;
LTE = labels_testing;






