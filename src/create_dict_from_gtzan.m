function create_dict_from_gtzan(genre_dict_size)

folders = {'blues'; 'classical'; 'country'; 'disco'; 'hiphop'; 'jazz'; 'metal'; 'pop'; 'reggae'; 'rock'};

savePath = './data/dictionaries/';
if (exist(savePath, 'dir') == 0)
    mkdir(savePath);
end
  
for i=1:10
    folderName = char(folders(i));
    path = strcat('data/spectrograms/training/',folderName,'_data.mat');
    % Read in the spectrogram
    spectrogram = load(path);
    spectrogram = spectrogram.dat_training;

    disp(strcat('Training dictionary for genre: ', folderName));
    % there was an error here when dividing by then. A inner loop is
    % missing.
    [ D, A ] = train_dictionary_ksvdbox(genre_dict_size,spectrogram, size(spectrogram,2)/100, 1, 10);

    %write dictionary to file
    filename = strcat(savePath, char(folders(i)), '_data.mat');
    save(filename, 'D');
    save(filename, 'A','-append');
            
end