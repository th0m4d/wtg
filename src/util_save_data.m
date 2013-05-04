function util_save_data(filepath, data, append)

%This utility function is necessary for the parfor loops, because direct
%saving is not supportet there.

if(append) 
    save(filepath, 'data', '-append');
else
    save(filepath, 'data');
end
