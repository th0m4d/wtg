function [ CQT ] = get_cqt_from_audio( file_path )
%GET_CQT_FROM_AUDIO Summary of this function goes here
%   Detailed explanation goes here

fprintf('Processing file %s \n',file_path);

% Read in the sound data
    Y = []
    FS = []
    [~, ~, ext] = fileparts(file_path) 
    if strcmp(ext,'.au') == 1
        [Y,Fs,~] = auread(file_path);
    elseif strcmp(ext,'.mp3') == 1
        [Y,Fs] = audioread(file_path)
    else
        error('Audio extension not supported: ' + ext)
    end
 

%% init values for CQT 
%We want to use 96 filters spanning four octaves from c2 to c6
%C2 has frequency 65.4064 Hertz
%C6 has frequency 1046.5 Hertz

bins_per_octave = 24;
fmax = 1046.5;     %center frequency of the highest frequency bin 
fmin = 65.4064; %lower boundary for CQT (lowest frequency bin will be immediately above this): fmax/<power of two> 

%% CQT
Xcqt = cqt(Y,fmin,fmax,bins_per_octave,Fs);
CQT = getCQT(Xcqt,'all','all');

%normalize columns to l2-norm <= 1
CQT = normr(CQT);

%plotCQT(Xcqt,fs,0.6,'surf');

end

