function create_histograms_from_gtzan(folders)

%Creating the histograms runs pretty quick. For now there is no need to
%wrap them into a job (the overhead takes longer than the actual
%computation).

savePath = './data/histograms/';
util_create_directory_structure(savePath);

num_genres = size(folders,2);
  
for i=1:num_genres
    create_training_histogram_for_genre(char(folders(i)));
end

for i=1:num_genres
    create_testing_histogram_for_genre(char(folders(i)));         
end