function create_histograms_from_gtzan()

folders = {'blues'; 'classical'; 'country'; 'disco'; 'hiphop'; 'jazz'; 'metal'; 'pop'; 'reggae'; 'rock'};

savePath = './data/histograms/';
if (exist(savePath, 'dir') == 0)
    mkdir(savePath);
end
  
for i=1:10
    folderName = char(folders(i));
    path = strcat('data/sparserep/',folderName,'_data.mat');
    % Read in the dictionaries
    data = load(path);
    encoding = data.gamma;

    H = get_bag_of_histograms(encoding, 22050, 1024, 5);
    
    %write dictionary to file
    filename = strcat(savePath, char(folders(i)), '_data.mat');
    save(filename, 'H');
            
end