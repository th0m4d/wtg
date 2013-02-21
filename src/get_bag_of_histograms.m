%%
% Aggregates the codeword encoding over the texture window given as a
% parameter and returns a matrix containin a so called bag of histograms.
%
% bitrate = sampling resolution of the audiofile in bits/s
% windowSize = size of the window used for stft. in bits
% textureWindow = aggregation size in seconds
function B = get_bag_of_histograms(A, bitrate, windowSize, textureWindow)

% number of measurements in texture window = textureWindow (stftWindowSize / bitrate)
cols_single = floor(textureWindow / (windowSize / bitrate));

cols = (cols_single * 2) - 1;

nx = size(A,2);

ncol = fix(nx/cols);

X = [];

for i = 0:(ncol - 1)
    startCols = (cols * i)+1;
    endCols = (cols*(i+1))+1;
    aCol = A(:,(startCols:endCols));
    %sum over the columns of aCol
    colSum = sum(aCol, 2);
    X = horzcat(X,colSum); 
end

B = X;
