function create_dict_from_gtzan()

folders = {'blues'; 'classical'; 'country'; 'disco'; 'hiphop'; 'jazz'; 'metal'; 'pop'; 'reggae'; 'rock'};

savePath = './data/dictionaries/';
if (exist(savePath, 'dir') == 0)
    mkdir(savePath);
end
  
for i=1:10
    folderName = char(folders(i));
    path = strcat('data/spectrograms/',folderName,'_data.mat');
    % Read in the spectrogram
    spectrogram = load(path);
    spectrogram = spectrogram.dat;

    disp(strcat('Training dictionary for genre: ', folderName));
    % there was an error here when dividing by then. A inner loop is
    % missing.
    [ D, A ] = train_dictionary_ksvd(spectrogram, size(spectrogram,2)/10, 3, 10);

    %write dictionary to file
    filename = strcat(savePath, char(folders(i)), '_data.mat');
    save(filename, 'D');
    save(filename, 'A','-append');
            
end