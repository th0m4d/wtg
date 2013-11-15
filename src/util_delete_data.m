function [] = util_delete_data()
%UTIL_DELETE_DATA Summary of this function goes here
%   Detailed explanation goes here
    spectrograms_dir = './data/spectrograms';

    directories = {'./data/cqts', './data/dictionaries', './data/histograms', './data/sparserep'};

    for i = 1:size(directories,2)
        dir = directories{1,i};
        if (exist(dir, 'dir') == 7)
            rmdir(dir, 's');
        end
    end

end

