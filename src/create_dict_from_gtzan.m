function create_dict_from_gtzan(genre_dict_size, num_iterations, target_sparcity, folders, feature_extraction_method, random, varargin)
% This function create the dictionaries from the spectogram of gtzans
% genre_dict_size is the size of the dictionary for each genre.
% the dictionaries are written in data/dictionaries

num_genres = size(folders,2);

%create job
profileName = parallel.defaultClusterProfile();
cluster = parcluster(profileName);
job = createJob(cluster)

for i=1:num_genres
    createTask(job, @create_dict_for_genre, 0, {char(folders(i)),genre_dict_size, num_iterations, target_sparcity, feature_extraction_method, random, varargin});
end

fprintf('Starting job to create dictionaries\n');
%job.Tasks
submit(job)
wait(job)
delete(job)
fprintf('Job finished.\n');
