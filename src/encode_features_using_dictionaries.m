function gamma = encode_features_using_dictionaries(sparcity, folders, feature_extraction_method,use_testing)

[~,savePathTraining,savePathTesting] =  util_create_directory_structure('./data/sparserep/');

joint_D = [];

num_genres = size(folders,2);

if ~exist('use_testing','var') || isempty(use_testing)
  use_testing=1;
end


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
job = createJob(cluster)

%Encode training (Necessary? - For the SVM I would say XD)
for i=1:num_genres
    createTask(job, @encode_training_data_per_genre, 0, {char(folders(i)), feature_extraction_method, sparcity, G, joint_D, savePathTraining});
end

%Encodeing testing
%Remember that the dictionary has not been training using this files
if use_testing
    for i=1:num_genres
        createTask(job, @encode_testing_data_per_genre, 0, {char(folders(i)), feature_extraction_method, sparcity, G, joint_D, savePathTesting});
    end
end

fprintf('Starting job to encode data.\n');
%job.Tasks
submit(job)
wait(job)
delete(job)
fprintf('Job finished.\n');


