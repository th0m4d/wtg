function createDictionariesFromGTZAN()

savePath = './data/dictionaries/';
if (exist(savePath, 'dir') == 0)
    mkdir(savePath);
end

%%train blues dictionary
spectrogram = load('data/spectrograms/blues_data.mat');
spectrogram = spectrogram.dat;
[ D, A ] = train_dictionary_ksvd(spectrogram);

 %write dictionary to file
 filename = strcat(savePath, folderName, '_data');
 save(filename, 'D');