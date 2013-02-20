function B = get_bag_of_histograms(A, bitrate, textureWindow)

% number of measurements = time * bitrate
bins = textureWindow * bitrate;

%create histograms for textureWindow with 50% overlapping.
n = hist(A, bins);