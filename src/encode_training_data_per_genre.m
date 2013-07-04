function encode_training_data_per_genre( folderName, feature_extraction_method, sparcity, G, joint_D, savePathTraining)
%ENCODE_TRAINING_DATA_PER_GENRE Summary of this function goes here
%   Detailed explanation goes here

    path = strcat('data/', feature_extraction_method, 's', '/training/',folderName,'_data.mat');
    % Read in the spectrogram
    feature = load(path);
    feature = feature.dat_training;

    disp(strcat('Encoding genre:', folderName));
    % We enconde using OMP per genre
    gamma = omp(joint_D,feature,G, sparcity);
    
    %write representation to file
    filename = strcat(savePathTraining, folderName, '_data.mat');
    fprintf('Saving %s\n',filename);
    save(filename, 'gamma');

end

