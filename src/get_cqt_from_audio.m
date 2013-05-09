function [ CQT ] = get_cqt_from_audio( file_path )
%GET_CQT_FROM_AUDIO Summary of this function goes here
%   Detailed explanation goes here

fprintf('Processing file %s \n',file_path);

% Read in the sound data
 [y,Fs,BITS] = auread(file_path);

%% init values for CQT 
%We want to use 96 filters spanning four octaves from c2 to c6
%C2 has frequency 65.4064 Hertz
%C6 has frequency 1046.5 Hertz

bins_per_octave = 24;
fmax = 1046.5;     %center frequency of the highest frequency bin 
fmin = 65.4064; %lower boundary for CQT (lowest frequency bin will be immediately above this): fmax/<power of two> 

%% CQT
Xcqt = cqt(y,fmin,fmax,bins_per_octave,Fs);
CQT = getCQT(Xcqt,'all','all');

%plotCQT(Xcqt,fs,0.6,'surf');





end

