function [ D,A,err ] = train_dictionary_ksvdbox(dictsize, signals,  cols_per_song, target_sparcity, num_iter  )
%TRAIN_DICTIONARY Using Rubinstein KSVD implementation
%   Train a dictioonary using ksvdbox - K-SVD Dictionary training
%   implementation by Ruybstein
%   dict_size: the size of the spectogram
%   
addpath ./lib/ksvdbox13


% number of column per song 
% so size(spectograms,2) mod cols_per_song = 0
% cols_per_song = 1291;

% number of iterations
%num_iter = 80;

% define target sparsity



a = 1;
b = size(signals,2);

%Generate dictioanry of random dict_size column selected from Y (Signals) 
range = ceil(1 + (b-a).*rand(dictsize,1));
D = signals(:,range);

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
params.iternum = num_iter;
params.memusage = 'high';
params.initdict = D;
[D,A,err] = ksvd(params,'irt');



% main loop
 

%Y = signals(:,s:cols_per_song); 
%A_orig = OMP(D,Y,target_sparcity);

%for iter = 1:num_iter

%     A = OMP(D,Y,tg_sp);
%     
%     % upodate each column
%     for k = 1:size(D,2)
%         
%         %get kth row of x
%         xTk = A(k,:);
%         
%         %find non zero elements of xTk
%         omega = find(xTk);
%         
%         if(isempty(omega))
%             continue;
%         end
%         
%         %Compute error for N examples, where
%         %the kth atom is removed
%         red_D = D;
%         red_D(:,k) = [];
%         red_A = A;
%         red_A(k,:) = [];
%         dx = red_D*red_A;
%         Ek = Y-dx;
%         
%         %Compute Omega_k to strip the zero
%         %elements. This is required to use
%         % SVD.
%         Omega_k = zeros(size(Y,2),length(find(omega)));
%         for i = 1:size(omega,2)
%             Omega_k(omega(1,i),i) = 1;
%         end
%         
%         xRk = xTk*Omega_k;
%         YRk = Y*Omega_k;
%         ERk = Ek*Omega_k;
%         
%         [U,S,V] = svd(ERk);
%         
%         D(:,k) = U(:,1);
%         A(k,:) = (S(1,1)*V(:,1))'*Omega_k';
% 
%     end
% end

end

