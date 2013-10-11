function create_histograms_from_gtzan(folders,use_testing)

%Creating the histograms runs pretty quick. For now there is no need to
%wrap them into a job (the overhead takes longer than the actual
%computation).

if ~exist('use_testing','var') || isempty(use_testing)
  use_testing=1;
end


savePath = './data/histograms/';
util_create_directory_structure(savePath);

num_genres = size(folders,2);
  
for i=1:num_genres
    create_training_histogram_for_genre(char(folders(i)));
end

if use_testing
    for i=1:num_genres
       create_testing_histogram_for_genre(char(folders(i)));         
    end
end