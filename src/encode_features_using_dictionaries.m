function gamma = encode_features_using_dictionaries(sparcity, folders, feature_extraction_method)

[~,savePathTraining,savePathTesting] =  util_create_directory_structure('./data/sparserep/');

joint_D = [];

num_genres = size(folders,2);

% we join the dictionaries
for i=1:num_genres
    folderName = char(folders(i));
    path = strcat('data/dictionaries/',folderName,'_data.mat');
    % Read in the dictionaries
    data = load(path);
    %encoding = data.A;
    joint_D = horzcat(joint_D,data.D);
end

fprintf('Enconding samples using a dictionary  of %d columns \n',size(joint_D,2));

%JD_norm = normc(joint_D);
%G = JD_norm'*JD_norm;

G = joint_D' * joint_D;

%create job
profileName = parallel.defaultClusterProfile();
cluster = parcluster(profileName);
job_training = createJob(cluster)

%Encode training (Necessary? - For the SVM I would say XD)
for i=1:num_genres
    createTask(job_training, @encode_training_data_per_genre, 0, {char(folders(i)), feature_extraction_method, sparcity, G, joint_D, savePathTraining});
end

fprintf('Starting job to encode training data.\n');
%job.Tasks
submit(job_training)
wait(job_training)
delete(job_training)
fprintf('Job finished.\n');

%create job
job_testing = createJob(cluster)

%Encodeing testing
%Remember that the dictionary has not been training using this files
for i=1:num_genres
    createTask(job_testing, @encode_testing_data_per_genre, 0, {char(folders(i)), feature_extraction_method, sparcity, G, joint_D, savePathTesting});
end

fprintf('Starting job to encode testing data.\n');
%job.Tasks
submit(job_testing)
wait(job_testing)
delete(job_testing)
fprintf('Job finished.\n');


