function [] = util_delete_data()
%UTIL_DELETE_DATA Summary of this function goes here
%   Detailed explanation goes here

    dict = './data/dictionaries';
    if (exist(dict, 'dir') == 7)
        rmdir(dict, 's');
    end
    
    hist = './data/histograms';
    if (exist(hist, 'dir') == 7)
        rmdir(hist, 's');
    end
    
    sparserep = './data/sparserep';
    if (exist(sparserep, 'dir') == 7)
        rmdir(sparserep, 's');
    end
    
    spectrograms = './data/spectrograms';
    if (exist(spectrograms, 'dir') == 7)
        rmdir(spectrograms, 's');
    end

end

