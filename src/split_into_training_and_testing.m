
%% 
%Takes a GTZAN histogram matrix and splits it up into a matrix with 90% of
%the songs and another matrix with 10% randomly selected songs from each
%genre.
%
% k_fold = the percentage of the testset measurements
function [TR,TE,LTR,LTE] = split_into_training_and_testing(k_fold)

folders = {'blues'; 'classical'; 'country'; 'disco'; 'hiphop'; 'jazz'; 'metal'; 'pop'; 'reggae'; 'rock'};

histograms_training = [];
histograms_testing = [];
labels_training = [];
labels_testing = [];

for i=1:size(folders,1)
    folderName = char(folders(i));
    path = strcat('data/histograms/',folderName,'_data.mat');
    % Read in the histogram
    data = load(path);
    histogram = data.H;
    
    %number of songs in the histogram matrix
    number_of_songs = floor(size(histogram,2) / 6);
    
    %number of songs for the testing subset
    num_of_test = floor(number_of_songs * k_fold/100);
   
    %create random indices
    randoms = randi(number_of_songs,[1,num_of_test]);
    randoms = (randoms-1)*6+1;
    
    indices = [];
    for j=1:(size(randoms,2))
        indices = horzcat(indices,(randoms(j):randoms(j)+5));
    end
    
    %compile training songs
    testing = histogram(:,indices);
    
    %compile testing songs
    training = histogram;
    training(:,randoms) = [];
    
    histograms_training = horzcat(histograms_training, training);
    histograms_testing = horzcat(histograms_testing, testing);
    
    label_training = ones(1,size(training,2)) * i;
    labels_training = horzcat(labels_training, label_training);
    
    label_testing = ones(1,size(testing,2)) * i;
    labels_testing = horzcat(labels_testing, label_testing);
end

TR = histograms_training;
TE = histograms_testing;
LTR = labels_training;
LTE = labels_testing;






