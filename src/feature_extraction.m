
% Read in the sound data
[d,r] = auread('test2.au');

% Look at the spectrogram (spectrum as a function of time)
specgram(d,1024,r);
