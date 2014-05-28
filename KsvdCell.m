function [ A,Gamma ] = KsvdCell( C ,Patch_size )
%% Get patches from cell
   X = im2col(C,[sqrt(Patch_size) sqrt(Patch_size)],'distinct');
%    Base_Dict_length = min(size(X,2),100); %% TOOD: BIG TIME REMOVE FAST
   Base_Dict_length = 64;

%% S-KSVD
% initialize params
params2d.data = X;                          % samples
params2d.initA = speye(Base_Dict_length);                % initial A matrix (identity)
%TODO:review why can't we get a long base dict to sksvd
params2d.basedict{1} = odctdict(sqrt(Patch_size),ceil(sqrt(Base_Dict_length)));      %make sqrt...patch size      % the separable base dictionary -
params2d.basedict{2} = odctdict(sqrt(Patch_size),ceil(sqrt(Base_Dict_length)));      % basedict{i} is the base dictionary


% for the i-th dimension
params2d.Edata = 130;                       % 'Tdata'/'Edata' sparse-coding target                                                                                    
params2d.Tdict = 10;                        % sparsity of each trained atom
params2d.iternum = 15;                       % number of training iterations

 close all;
[A,Gamma,~,~] = ksvds(params2d);
if(max(isnan(full(A(:))))) 
    error('KSVD A output NaN for some indicies');
end
if(max(isnan(full(Gamma(:)))))
    error('KSVD Gamma output NaN for some indicies');
end
% TODO: check then remove
% figure();
%  imhist(full(A)) %for sphit comression we need source transform
% figure();
%  imhist(full(Gamma)) 

end
