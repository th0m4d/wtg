% tesing the spectogram

clear all

%Add library paths
addpath ./lib/cqt_toolbox

% Read in the sound data
[Y,Fs,BITS] = auread('test.au');
Fs
BITS

% Y = Data -1 to +1 amplitude
% Frequency of the sample rate
% BITS how many bits were used per sample 

windowSize = 1024; 
nooverlap = windowSize/2;

% Window size of 1024 measurements (Herz) (each windo takes 1 nsecond and overlap 512 Hz (measurment))
% so for a 30 seconds sample we have 
% Nx measurement = 22050 * 30 second 
% nfft is the length of the window = windowSize and for Hann window is 1024

% Number of columns  S
% k = fix((Nx-noverlap)/(windowSize-noverlap))
% In this case fix((661794-512)/(1024-512))
% k = 1291

% For real x, the output S has 
% (nfft/2+1) rows if nfft is even, and (nfft+1)/2 rows if nfft is odd.



[S,F,T,P] = spectrogram(Y,hann(windowSize), nooverlap, windowSize, Fs)


