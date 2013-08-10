function create_training_histogram_for_genre( folderName )
%CREATE_HISTOGRAM_FOR_GENRE Summary of this function goes here
%   Detailed explanation goes here
    
    savePath = './data/histograms/';

    path = strcat('data/sparserep/training/',folderName,'_data.mat');
    % Read in the dictionaries
    data = load(path);
    encoding = data.gamma;

    H_tr = get_bag_of_histograms(encoding, 22050, 1024, 5);
    
    %write dictionary to file
    filename = strcat(savePath,'training/', folderName, '_data.mat');
    save(filename, 'H_tr');

end

