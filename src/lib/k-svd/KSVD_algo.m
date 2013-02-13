%% KSVD implementation
clear all

% define image
I = [144  126  117  119  128  139  151  139  120  123;
   97   95   97   99  100  104  106   99   83   75;
  116  103   97   91   88   88   86   78   71   62;
  185  179  172  165  153  142  125   77   51   50;
  194  194  194  194  193  191  179  112   53   39;
  196  194  194  196  195  196  185  127   68   43;
  193  194  194  195  194  196  188  139   98   69;
  192  193  194  195  195  197  193  159  123  110;
  192  192  193  194  194  194  194  180  140  129;
  190  193  190  192  191  193  195  191  180  159];

% I = double(imread('house.png'));
% I = imresize(I,[64 64]);
% I = imresize(I,[128 128]);


% number of iterations
num_iter = 10;

% define block size
blk_sz = 8; % 7;

% define target sparsity
tg_sp = 3; % 15;

% decompose image into overlapping patches
Y = im2col(I,[blk_sz blk_sz],'sliding');


% initialize dictionary
D = odctdict(size(Y,1),2*size(Y,1));
D_orig = D;
%showdict(D,[blk_sz blk_sz],8,16,'lines');

% D = rand(2*size(X,1),size(X,1));
% D = bsxfun(@times,D,1./sqrt(sum(D.^2,1)));
A_orig = OMP(D,Y,tg_sp);


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
       

% reconstruct image from original dictionary
% Code from M. Aharon, M. Elad and A. Bruckstein, K-SVD: An Algorithm
% for Designing Overcomplete Dictionaries for Sparse
% Representation, IEEE Transactions on Signal Processing, vol. 54, no. 11, 2006
[NN1,NN2] = size(I);
bb = blk_sz;
blocks = D_orig*A_orig;
idx = [1:size(blocks,2)];
Weight = zeros(NN1,NN2);
IMout_orig = zeros(NN1,NN2);
count = 1;
[rows,cols] = ind2sub(size(I)-bb+1,idx);
for i  = 1:length(cols)
    col = cols(i); row = rows(i);        
    block =reshape(blocks(:,count),[bb,bb]);
    IMout_orig(row:row+bb-1,col:col+bb-1)=IMout_orig(row:row+bb-1,col:col+bb-1)+block;
    Weight(row:row+bb-1,col:col+bb-1)=Weight(row:row+bb-1,col:col+bb-1)+ones(bb);
    count = count+1;
end
IMout_orig = IMout_orig./Weight;

% reconstruct image from learned dictionary
[NN1,NN2] = size(I);
bb = blk_sz;
blocks = D*A;
idx = [1:size(blocks,2)];
Weight = zeros(NN1,NN2);
IMout_learned = zeros(NN1,NN2);
count = 1;
[rows,cols] = ind2sub(size(I)-bb+1,idx);
for i  = 1:length(cols)
    col = cols(i); row = rows(i);        
    block =reshape(blocks(:,count),[bb,bb]);
    IMout_learned(row:row+bb-1,col:col+bb-1)=IMout_learned(row:row+bb-1,col:col+bb-1)+block;
    Weight(row:row+bb-1,col:col+bb-1)=Weight(row:row+bb-1,col:col+bb-1)+ones(bb);
    count = count+1;
end
IMout_learned = IMout_learned./Weight;

% errors between fixed sparse representation recovery and learned
% Dictionary
errors = [norm(I-IMout_orig,'fro') norm(I-IMout_learned,'fro')]

% show images
% figure, imshow([uint8(I), uint8(IMout_orig) uint8(IMout_learned)]);




