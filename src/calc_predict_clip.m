function [ expected_clip, predicted_clip ] = calc_predict_clip(expected,predicted,group_size)
% expected: predicted label - one row per resul (Nx1)
% predicted label: one row per result
% group size: how texture windows is the clip split into

%make sure they have the same dimension
num_clips = size(predicted,1)/group_size;
predicted = reshape(predicted,group_size,num_clips);
expected = reshape(expected,group_size,num_clips);


% we have a matrix now with each columns representing a clip
% and each row is a texture windows (with their own classification)
% we then find the mode of both (the most common element

predicted_clip = mode(predicted);
expected_clip  = mode(expected);


end

