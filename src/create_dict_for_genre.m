function create_dict_for_genre(folderName, genre_dict_size, num_iterations, target_sparcity, feature_extraction_method, varargin)
%CREATE_DICT_FOR_GENRE Summary of this function goes here
%   Detailed explanation goes here

    savePath = './data/dictionaries/';
    if (exist(savePath, 'dir') == 0)
        mkdir(savePath);
    end

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
    filename = strcat(savePath, folderName, '_data.mat');
    save(filename, 'D');
    save(filename, 'A','-append');

end

