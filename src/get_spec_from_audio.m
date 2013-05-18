function [ spec ] = get_spec_from_audio( file_path,prep)
%GET_SPEC_FROM_AUDIO Returns a spectrogram with normalized columns from an
%audio file at the location given as parameter.
%   Detailed explanation goes here
% @paran: prep = one of 'log' or 'norm', default norm

    %% Read in the sound data
    fprintf('Processing file %s \n',file_path);
    [Y,Fs,BITS] = auread(file_path);
    %%Compute spectrum
    windowSize = 1024;
    overlap = windowSize/2;
    %(x,window,noverlap,nfft,fs)
    [S,F,T,P] = spectrogram(Y,hann(windowSize), overlap, windowSize, Fs);
    
    
    if(strcmp('log',prep))
    %create the log spectrogram.
        fprintf('Spectrogram is brought to a logarithmic scale\n');
        P = log(P);
    elseif(strcmp('norm',prep))
    %normalize columns to l2-norm <= 1
        fprintf('Spectrogram is normalized between [0,1]\n');
        P = normr(P);
    end
    
    
   
    spec = P;

end

