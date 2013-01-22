clear all

%Add library paths
addpath ./lib/cqt_toolbox

% Read in the sound data
[Y,Fs,BITS] = auread('test2.au');

%% Divide sound data into small chunks of ~32ms
%TODO

%% init values for CQT
fs = Fs;
bins_per_octave = 24;
fmax = fs/3;     %center frequency of the highest frequency bin 
fmin = fmax/512; %lower boundary for CQT (lowest frequency bin will be immediately above this): fmax/<power of two> 

%% CQT
Xcqt = cqt(Y,fmin,fmax,bins_per_octave,fs);

plotCQT(Xcqt,fs,0.6,'surf');


