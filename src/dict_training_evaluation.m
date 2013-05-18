addpath lib/cqt_toolbox

%list of folders to be included into training
%folders = {'blues'; 'classical'; 'country'; 'disco'; 'hiphop'; 'jazz'; 'metal'; 'pop'; 'reggae'; 'rock'};
folders = {'blues'};

%feature extraction method: spectrogram or cqt
ex_method = 'spectrogram';

%numbers of iterations for the generation of the dictionary
num_iterations = 100;

%target sparcity for the encoding of the dictionary
target_sparcity = 5;

%size of the dictionary per genre
dict_size = 100;

num_of_training_samples = 1000;

util_delete_data()

create_spec_from_gtzan(90, folders);

create_dict_from_gtzan(dict_size, num_iterations,target_sparcity, folders, ex_method, 1000);
