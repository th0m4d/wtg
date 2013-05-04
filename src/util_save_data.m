function util_save_data(filepath, data)

%This utility function is necessary for the parfor loops, because direct
%saving is not supportet there.

save(filepath, 'data');

