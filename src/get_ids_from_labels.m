%% 
% Returns integer ids for every element in the array given as parameter.
%
%
function T = get_ids_from_labels(labels)

s = size(labels,1);

T = double(colon(1,s));