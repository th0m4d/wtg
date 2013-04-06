function gamma = encode_features_using_dictionaries(sparcity)

addpath ./lib/ompbox10/


folders = {'blues'; 'classical'; 'country'; 'disco'; 'hiphop'; 'jazz'; 'metal'; 'pop'; 'reggae'; 'rock'};

[savePathRoot,savePathTraining,savePathTesting] =  util_create_directory_structure('./data/sparserep/');

joint_D = [];

% we join the dictionaries
for i=1:10
    folderName = char(folders(i));
    path = strcat('data/dictionaries/',folderName,'_data.mat');
    % Read in the dictionaries
    data = load(path);
    %encoding = data.A;
    
    joint_D = horzcat(joint_D,data.D);
    
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
for i=1:10
    folderName = char(folders(i));
    path = strcat('data/spectrograms/training/',folderName,'_data.mat');
    % Read in the spectrogram
    spectogram = load(path);
    spectogram = spectogram.dat_training;

    disp(strcat('Encoding genre:', folderName));
    % We enconde using OMP per genre
    gamma = omp(joint_D,spectogram,G, sparcity);
    
    %write representation to file
    filename = strcat(savePathTraining, char(folders(i)), '_data.mat');
    fprintf('Saving %s\n',filename);
    save(filename, 'gamma');

            
end

%Encodeing testing
%Remember that the dictionary has not been training using this files
for i=1:10
    folderName = char(folders(i));
    path = strcat('data/spectrograms/testing/',folderName,'_data.mat');
    % Read in the spectrogram
    spectogram = load(path);
    spectogram = spectogram.dat_testing;

    disp(strcat('Encoding genre:', folderName));
    % We enconde using OMP per genre
    gamma = omp(joint_D,spectogram,G, sparcity);
    
    %write representation to file
    filename = strcat(savePathTesting, char(folders(i)), '_data.mat');
    fprintf('Saving %',filename);
    save(filename, 'gamma');

            
end

