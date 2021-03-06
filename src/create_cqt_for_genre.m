function create_cqt_for_genre( folderName, training_percentage)
%CREATE_CQT_FOR_GENRE Summary of this function goes here
%   Detailed explanation goes here

% if prep is not set use normalization by default
if nargin < 3
    prep = 'none';
end

% create directories if they don't exists
savePathTraining = './data/cqts/training/';
savePathTesting = './data/cqts/testing/';

num_songs = 100; % number of songs to process per each genre

dat_training = [];
dat_testing = [];

% get the testing and and training indexings
training_idxs = randperm(num_songs,training_percentage)-1;
testing_idxs = setdiff(0:num_songs-1,training_idxs);

fprintf('Creating constant q transforms of genre %s for training set\n',folderName);
for j=training_idxs
    path = strcat('data/genres/',folderName ,'/',folderName ,'.',sprintf('%05d',j), '.au');
    P = get_cqt_from_audio(path);
    dat_training = horzcat(dat_training, P);
end

fprintf('Creating constant q transforms of genre %s for testing set\n',folderName);
for j=testing_idxs
    path = strcat('data/genres/',folderName ,'/',folderName ,'.',sprintf('%05d',j), '.au');
    P = get_cqt_from_audio(path);
    dat_testing = horzcat(dat_testing, P);
end

fprintf('saving constant q transforms to file...\n');
%write genre data to file
filename_tr = strcat(savePathTraining,folderName ,'_data');
filename_te = strcat(savePathTesting,folderName ,'_data');

save(filename_tr, 'dat_training');
save(filename_te, 'dat_testing');


end

