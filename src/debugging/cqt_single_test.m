clear all

%Add library paths
addpath ./lib/cqt_toolbox

% Read in the sound data
 [y,Fs,BITS] = auread('data/genres/blues/blues.00088.au');

%t = 0:0.001:1;            % 1 secs @ 1kHz sample rate
%y = chirp(t,0,1,440);

%spectrogram(y,256,250,256,1E3,'yaxis') 

%% init values for CQT 
%We want to use 96 filters spanning four octaves from c2 to c6
%C2 has frequency 65.4064 Hertz
%C6 has frequency 1046.5 Hertz

fs = Fs;
bins_per_octave = 24;
fmax = 1046.5;     %center frequency of the highest frequency bin 
fmin = 65.4064; %lower boundary for CQT (lowest frequency bin will be immediately above this): fmax/<power of two> 

%% CQT
Xcqt = cqt(y,fmin,fmax,bins_per_octave,fs);
PerfectXcqt = cqtPerfectRast(y,fmin,fmax,bins_per_octave,fs,'q',1,'atomHopFactor',0.25,'thresh',0.0005,'win','sqrt_blackmanharris');
intCQT = getCQT(Xcqt,'all','all');

plotCQT(Xcqt,fs,0.6,'surf');
figure;
plotCQT(PerfectXcqt,fs,0.6,'surf');


