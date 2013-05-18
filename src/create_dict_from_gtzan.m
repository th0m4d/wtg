function create_dict_from_gtzan(genre_dict_size, num_iterations, target_sparcity, folders, feature_extraction_method, varargin)
% This function create the dictionaries from the spectogram of gtzans
% genre_dict_size is the size of the dictionary for each genre.
% the dictionaries are written in data/dictionaries

% K-SVD implementation from Ron Rubinstein
addpath ./lib/ompbox10/
addpath ./lib/ksvdbox13/

savePath = './data/dictionaries/';
if (exist(savePath, 'dir') == 0)
    mkdir(savePath);
end

num_genres = size(folders,1);

for i=1:num_genres
    folderName = char(folders(i));
    path = strcat('data/', feature_extraction_method,'s', '/training/',folderName,'_data.mat');
    % Read in the spectrogram
    feature = load(path);
    feature = feature.dat_training;

    disp(strcat('Training dictionary for genre: ', folderName));
    disp(strcat('Processing file: ', path));
    
    % there was an error here when dividing by then. A inner loop is
    % missing.
    [ D, A ] = train_dictionary_ksvdbox(genre_dict_size,feature, size(feature,2)/100, target_sparcity, num_iterations, varargin);

    %write dictionary to file
    filename = strcat(savePath, char(folders(i)), '_data.mat');
    save(filename, 'D');
    save(filename, 'A','-append');
            
end