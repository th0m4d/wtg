function create_spec_from_gtzan(training_percentage, folders,prep)
% This function create the spectograms for the songs in the dataset
% at the same time it splits those spectograms into training and testing
% (storing in in different subdirectories) the amount of songs used for
% training is controlled by the paramter training_percentage
% @param prep = one of 'norm' or 'log'. Apply either normalization or log
% applied to the spectrogram prior to returning. By default use = 'norm'

num_genres = size(folders,2);

% create directories if they don't exists
savePathroot = './data/spectrograms/';

util_create_directory_structure(savePathroot);

%create job
profileName = parallel.defaultClusterProfile();
cluster = parcluster(profileName);
job = createJob(cluster)

for i=1:num_genres; 
    createTask(job, @create_spec_for_genre, 0, {char(folders(i)), training_percentage,prep});
end

fprintf('Starting job to create specs from gtzan\n');
%job.Tasks
submit(job)
wait(job)
delete(job)
fprintf('Job finished.\n');
