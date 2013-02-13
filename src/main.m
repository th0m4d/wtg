clear all

%Add library paths
addpath ./lib/cqt_toolbox

% Read in the sound data
[Y,Fs,BITS] = auread('test.au');

%% init values for CQT 
%We want to use 96 filters spanning four octaves from c2 to c6
%C2 has frequency 65.4064 Hertz
%C6 has frequency 1046.5 Hertz

fs = Fs;
bins_per_octave = 24;
fmax = 1046.5;     %center frequency of the highest frequency bin 
fmin = 65.4064; %lower boundary for CQT (lowest frequency bin will be immediately above this): fmax/<power of two> 

%% CQT
Xcqt = cqt(Y,fmin,fmax,bins_per_octave,fs);
intCQT = getCQT(Xcqt,'all','all');

plotCQT(Xcqt,fs,0.6,'surf');


