clear all

%Add library paths
addpath ./lib/cqt_toolbox
addpath ./lib/k-svd

%% Short time audio representation

%create_spec_from_gtzan();
%read_spectrograms_from_filesystem();

%% Codebook generation and encoding

create_dict_from_gtzan();
%read_dictionaries_from_filesystem();

%% Code word encoding aggregation

%

%% SVM training
