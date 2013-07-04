function create_cqts_from_gtzan(training_percentage, folders)
% This function create the spectograms for the songs in the dataset
% at the same time it splits those spectograms into training and testing
% (storing in in different subdirectories) the amount of songs used for
% training is controlled by the paramter training_percentage

num_genres = size(folders,2);

%create job
profileName = parallel.defaultClusterProfile();
cluster = parcluster(profileName);
job = createJob(cluster)


for i=1:num_genres;
    createTask(job, @create_cqt_for_genre, 0, {char(folders(i)), training_percentage});
end

fprintf('Starting job to create specs from gtzan');
%job.Tasks
submit(job)
wait(job)
delete(job)
fprintf('Job finished.');