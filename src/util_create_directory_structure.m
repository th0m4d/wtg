function [rootdir,training,testing] = util_create_directory_structure( rootdir )
%UTIL_CREATE_DIRECTORY_STRUCTURE If the directory does not exists it
%create it and testing and training subdirs


if (exist(rootdir, 'dir') == 0)
    mkdir(rootdir);
end


training = strcat(rootdir,'training/');
testing = strcat(rootdir,'testing/');

if (exist(training, 'dir') == 0)
    mkdir(training);
end

if (exist(testing, 'dir') == 0)
    mkdir(testing);
end

end

