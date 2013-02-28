function gamma = encode_features_using_dictionaries(sparcity)

folders = {'blues'; 'classical'; 'country'; 'disco'; 'hiphop'; 'jazz'; 'metal'; 'pop'; 'reggae'; 'rock'};

savePath = './data/sparserep/';
if (exist(savePath, 'dir') == 0)
    mkdir(savePath);
end

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
for i=1:10
    folderName = char(folders(i));
    path = strcat('data/spectrograms/',folderName,'_data.mat');
    % Read in the spectrogram
    spectogram = load(path);
    spectogram = spectogram.dat;

    disp(strcat('Encoding genre:', folderName));
    
    % We enconde using OMP per genre
    gamma = omp(spectogram,joint_D, sparcity);
    
    %write dictionary to file
    filename = strcat(savePath, char(folders(i)), '_data.mat');
    save(filename, 'gamma');

            
end
