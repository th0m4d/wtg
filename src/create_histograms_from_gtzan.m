function create_histograms_from_gtzan()

folders = {'blues'; 'classical'; 'country'; 'disco'; 'hiphop'; 'jazz'; 'metal'; 'pop'; 'reggae'; 'rock'};

savePath = './data/histograms/';
util_create_directory_structure(savePath);

  
for i=1:10
    folderName = char(folders(i));
    path = strcat('data/sparserep/training/',folderName,'_data.mat');
    % Read in the dictionaries
    data = load(path);
    encoding = data.gamma;

    H = get_bag_of_histograms(encoding, 22050, 1024, 5);
    
    %write dictionary to file
    filename = strcat(savePath,'training/', char(folders(i)), '_data.mat');
    save(filename, 'H');
            
end

for i=1:10
    folderName = char(folders(i));
    path = strcat('data/sparserep/testing/',folderName,'_data.mat');
    % Read in the dictionaries
    data = load(path);
    encoding = data.gamma;

    H = get_bag_of_histograms(encoding, 22050, 1024, 5);
    
    %write dictionary to file
    filename = strcat(savePath,'testing/', char(folders(i)), '_data.mat');
    save(filename, 'H');
            
end