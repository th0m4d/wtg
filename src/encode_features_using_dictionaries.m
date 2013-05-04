function gamma = encode_features_using_dictionaries(sparcity, folders)

addpath ./lib/ompbox10/

[savePathRoot,savePathTraining,savePathTesting] =  util_create_directory_structure('./data/sparserep/');

joint_D = [];

num_genres = size(folders,1);

% we join the dictionaries
parfor i=1:num_genres
    folderName = char(folders(i));
    path = strcat('data/dictionaries/',folderName,'dict_data.mat');
    % Read in the dictionaries
    dictionary = load(path);
    %encoding = data.A;
    
    joint_D = horzcat(joint_D,dictionary.data);
    
    %H = get_bag_of_histograms(encoding, 22050, 1024, 5);
    
    %write dictionary to file
    %filename = strcat(savePath, char(folders(i)), '_data.mat');
    %save(filename, 'H');
            
end

fprintf('Enconding samples using a dictionary  of %d columns \n',size(joint_D,2));

%JD_norm = normc(joint_D);
%G = JD_norm'*JD_norm;

G = joint_D' * joint_D;

%Encode training (Necessary? - For the SVM I would say XD)
parfor i=1:num_genres
    folderName = char(folders(i));
    path = strcat('data/spectrograms/training/',folderName,'_data.mat');
    % Read in the spectrogram
    spectogram = load(path);
    spectogram = spectogram.data;

    disp(strcat('Encoding genre:', folderName));
    % We enconde using OMP per genre
    training_gamma = omp(joint_D,spectogram,G, sparcity);
    
    %write representation to file
    filename = strcat(savePathTraining, char(folders(i)), '_data.mat');
    fprintf('Saving %s\n',filename);
    util_save_data(filename, training_gamma);
end

%Encodeing testing
%Remember that the dictionary has not been training using this files
parfor i=1:num_genres
    folderName = char(folders(i));
    path = strcat('data/spectrograms/testing/',folderName,'_data.mat');
    % Read in the spectrogram
    spectogram = load(path);
    spectogram = spectogram.data;

    disp(strcat('Encoding genre:', folderName));
    % We enconde using OMP per genre
    testing_gamma = omp(joint_D,spectogram,G, sparcity);
    
    %write representation to file
    filename = strcat(savePathTesting, char(folders(i)), '_data.mat');
    fprintf('Saving %',filename);
    util_save_data(filename, testing_gamma);
end

