function create_histograms_from_gtzan(folders)

savePath = './data/histograms/';
util_create_directory_structure(savePath);

num_genres = size(folders,1);
  
parfor i=1:num_genres
    folderName = char(folders(i));
    path = strcat('data/sparserep/training/',folderName,'_data.mat');
    % Read in the dictionaries
    gamma = load(path);
    encoding = gamma.data;

    H_tr = get_bag_of_histograms(encoding, 22050, 1024, 5);
    
    %write dictionary to file
    filename = strcat(savePath,'training/', char(folders(i)), '_data.mat');
    util_save_data(filename, H_tr);
            
end

parfor i=1:num_genres
    folderName = char(folders(i));
    path = strcat('data/sparserep/testing/',folderName,'_data.mat');
    % Read in the dictionaries
    gamma = load(path);
    encoding = gamma.data;

    H_te = get_bag_of_histograms(encoding, 22050, 1024, 5);
    
    %write dictionary to file
    filename = strcat(savePath,'testing/', char(folders(i)), '_data.mat');
    util_save_data(filename, H_te);
            
end