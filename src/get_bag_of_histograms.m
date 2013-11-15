%%
% Aggregates the codeword encoding over the texture window given as a
% parameter and returns a matrix containin a so called bag of histograms.
%
% bitrate = sampling resolution of the audiofile in bits/s
% windowSize = size of the window used for stft. in bits
% textureWindow = aggregation size in seconds
function B = get_bag_of_histograms(A, bitrate, windowSize, textureWindow)

%transform the textureWindow from seconds to bits
text_window_in_bits = textureWindow * bitrate;

%check if the textureWindow divides without a remainder
remainder = mod((textureWindow * bitrate), windowSize);

%cut off the remainder
if(remainder > 0) 
    text_window_in_bits = text_window_in_bits - remainder;
end

% number of measurements in texture window = textureWindow (stftWindowSize / bitrate)
cols_single = floor(text_window_in_bits/windowSize);

%take into account the overlapping of 1/2
cols = (cols_single * 2) - 1;

%get the number of window shifts
nx = size(A,2);
nshifts = fix(nx/cols);

X = [];

for i = 0:(nshifts - 1)
    startCols = (cols * i)+1;
    endCols = (cols*(i+1))+1;
    aCol = A(:,(startCols:endCols));
    %sum over the columns of aCol
    colSum = sum(aCol, 2);
   X  = horzcat(X,colSum); 
end

B = X(:,1:600);
