function [ Dksvd,A,err ] = train_dictionary_ksvdbox(dictsize, signals, cols_per_song, target_sparcity, num_iter,random,varargin)
%TRAIN_DICTIONARY Using Rubinstein KSVD implementation
%   Train a dictioonary using ksvdbox - K-SVD Dictionary training
%   implementation by Ruybstein
%   dict_size: the size of the spectogram
%   random = true a random dictionary is used, otherway is taken from the 
%   training data.

addpath ./lib/ksvdbox13

number_of_samples = size(signals,2);
sample_dimension = size(signals,1);

if  size(varargin{1}) > 0
    if isa(varargin{1}{1},'double')
        num_training_samples = varargin{1}{1};
        idxs = randperm(number_of_samples,num_training_samples)-1;
        signals = signals(:,idxs);
        number_of_samples = size(signals,2);
    end
end


if(random) 
%Use random dictionary for training
    fprintf('Using a random dictionary');
    D = normc(randn(sample_dimension,number_of_samples));
else
%Generate dictioanry of random dict_size column selected from Y (Signals)
    fprintf('Extracting random dictionary randomly from data');
    range = ceil(1 + (number_of_samples-1).*rand(dictsize,1));
    D = signals(:,range);
end

% how many songs to process?
data_num_cols =  size(signals,2);
num_song = data_num_cols/cols_per_song;
fprintf('Number of columnns in data %i\n',data_num_cols);
%fprintf('Training a dictionary with %i songs\n',num_song);
%fprintf('Dictionary size of %i atoms\n',dictsize);
fprintf('Dictionary size of %i atoms\n',size(D,2));

params.data = signals;
params.Tdata = target_sparcity;
params.dictsize = dictsize;
params.initdict = D;
%params.exact = 1;
params.iternum = num_iter;
params.memusage = 'high';
%params.muthresh = 0.9;
[Dksvd,A,err] = ksvd(params,'irt');

%% show results %%
figure; plot(err); title('K-SVD error convergence');
xlabel('Iteration'); ylabel('RMSE');

fprintf('  Dictionary size: %d x %d\n', dictsize, sample_dimension);
fprintf('  Number of examples: %d\n', number_of_samples);

[~,ratio] = dictdist(Dksvd,D);
fprintf('  Ratio of recovered atoms: %.2f%%\n', ratio*100);


end

