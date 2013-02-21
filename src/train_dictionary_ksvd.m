function [ D,A ] = train_dictionary_ksvd( spectograms,  cols_per_song, target_sparcity, num_iter  )
%TRAIN_DICTIONARY Summary of this function goes here
%   Train a dictioonary using K-SVD method

addpath ./lib/k-svd

% number of column per song 
% so size(spectograms,2) mod cols_per_song = 0
% cols_per_song = 1291;

% number of iterations
%num_iter = 80;

% define target sparsity
tg_sp = target_sparcity;

% decompose image into overlapping patches
% Y = im2col(I,[blk_sz blk_sz],'sliding');
% We don't need to to this given that the spectogram is already 
% well formed with the column


% initialize dictionary
%D = odctdict(size(Y,1),2*size(Y,1));
%D_orig = D;

% we use instead of a DCT or something like that, we use random atoms from
% the original dataset as stated in [Mairal et al 09] 

% codebook size equals to 500 initialy
a = 1;
b = size(spectograms,2);
range = ceil(1 + (b-a).*rand(500,1));
D = spectograms(:,range);
D_orig = D;

Y = spectograms(:,1:cols_per_song);



%showdict(D,[blk_sz blk_sz],8,16,'lines');

% D = rand(2*size(X,1),size(X,1));
% D = bsxfun(@times,D,1./sqrt(sum(D.^2,1)));
A_orig = OMP(D,Y,target_sparcity);

for iter = 1:num_iter

    A = OMP(D,Y,tg_sp);
    
    % upodate each column
    for k = 1:size(D,2)
        
        %get kth row of x
        xTk = A(k,:);
        
        %find non zero elements of xTk
        omega = find(xTk);
        
        if(isempty(omega))
            continue;
        end
        
        %Compute error for N examples, where
        %the kth atom is removed
        red_D = D;
        red_D(:,k) = [];
        red_A = A;
        red_A(k,:) = [];
        dx = red_D*red_A;
        Ek = Y-dx;
        
        %Compute Omega_k to strip the zero
        %elements. This is required to use
        % SVD.
        Omega_k = zeros(size(Y,2),length(find(omega)));
        for i = 1:size(omega,2)
            Omega_k(omega(1,i),i) = 1;
        end
        
        xRk = xTk*Omega_k;
        YRk = Y*Omega_k;
        ERk = Ek*Omega_k;
        
        [U,S,V] = svd(ERk);
        
        D(:,k) = U(:,1);
        A(k,:) = (S(1,1)*V(:,1))'*Omega_k';

    end
end

end

