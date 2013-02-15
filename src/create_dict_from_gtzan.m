function create_dict_from_gtzan()

folders = {'blues'; 'classical'; 'country'; 'disco'; 'hiphop'; 'jazz'; 'metal'; 'pop'; 'reggae'; 'rock'};

savePath = './data/dictionaries/';
if (exist(savePath, 'dir') == 0)
    mkdir(savePath);
end

%%train blues dictionary
spectrogram = load('data/spectrograms/blues_data.mat');
spectrogram = spectrogram.dat;
[ D, A ] = train_dictionary_ksvd(spectrogram);

 %write dictionary to file
 filename = strcat(savePath, char(folders(1)), '_data');
 save(filename, 'D');
 save(filename, 'A','-append');