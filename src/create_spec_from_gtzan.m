function create_spec_from_gtzan(training_percentage)
% This function create the spectograms for the songs in the dataset
% at the same time it splits those spectograms into training and testing
% (storing in in different subdirectories) the amount of songs used for
% training is controlled by the paramter training_percentage


%Add library paths
addpath ./lib/cqt_toolbox
folders = {'blues'; 'classical'; 'country'; 'disco'; 'hiphop'; 'jazz'; 'metal'; 'pop'; 'reggae'; 'rock'};

num_songs = 100; % number of songs to process per each genre

% create directories if they don't exists


savePathroot = './data/spectrograms/';
savePathTraining = './data/spectrograms/training';
savePathTesting = './data/spectrograms/testing';

util_create_directory_structure(savePathroot);


training_idxs = [];
testing_idxs = [];


for i=1:10
    dat_training = [];
    dat_testing = [];
    folderName = char(folders(i));
    
    % get the testing and and training indexings
    training_idxs = randperm(num_songs,training_percentage);
    testing_idxs = setdiff(1:num_songs,training_idxs);
    
    
    for j=training_idxs
        path = strcat('data/genres/',folderName ,'/',folderName ,'.',sprintf('%05d',i), '.au');
        %% Read in the sound data
        [Y,Fs,BITS] = auread(path);
        %%Compute spectrum
        windowSize = 1024;
        overlap = windowSize/2;
        %(x,window,noverlap,nfft,fs)
        [S,F,T,P] = spectrogram(Y,hann(windowSize), overlap, windowSize, Fs);
        dat_training = horzcat(dat_training, P);
    end
    
    for j=testing_idxs
        path = strcat('data/genres/',folderName ,'/',folderName ,'.',sprintf('%05d',i), '.au');
        %% Read in the sound data
        [Y,Fs,BITS] = auread(path);
        %%Compute spectrum
        windowSize = 1024;
        overlap = windowSize/2;
        %(x,window,noverlap,nfft,fs)
        [S,F,T,P] = spectrogram(Y,hann(windowSize), overlap, windowSize, Fs);
        dat_testing = horzcat(dat_testing, P);
    end
    
    
    
    %write genre data to file
    filename_tr = strcat(savePathTraining,folderName ,'_data');
    filename_te = strcat(savePathTesting,folderName ,'_data');

    save(filename_tr, 'dat_training');
    save(filename_te, 'dat_testing');

    
end