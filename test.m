%% s-KSVD test
% chdir('/home/oron/Dropbox/semster_EE/semester_8_EE/project_B/Matlab_files/Img2Sparse/');
% Im= imread('lenna.gif');
% m = 8; n = 8;
% X = im2col(Im,[m n],'distinct');
% 
% % initialize params
% params2d.data = X;                          % samples
% params2d.initA = speye(100);                % initial A matrix (identity)
% 
% %TODO:review why can't we get a long base dict to sksvd
% params2d.basedict{1} = odctdict(8,10);      %make sqrt...patch size      % the separable base dictionary -
% params2d.basedict{2} = odctdict(8,10);      % basedict{i} is the base dictionary
%                                             % for the i-th dimension
% params2d.Edata = 100;                       % 'Tdata'/'Edata' sparse-coding target                                                                                    
% params2d.Tdict = 8;                        % sparsity of each trained atom
% params2d.iternum = 5;                       % number of training iterations
% 
% [A,Gamma,~,~] = ksvds(params2d);
   
% %% Quantization test
% 
% N = 3;
% ind = randperm(N^2);
% A = randn(N);
% A(ind(1:N^2-2*N))=0;
% A = sparse(A);
% % A = full(A)
% 
% Gamma = randn(1,N^2)*100;
% Gamma(ind(1:N^2-2*N))=0;
% Gamma = sparse(Gamma);
% Gamma = full(Gamma)
% Gamma = A
% 
% Gamma_DC  = mean(Gamma);
% Gamma_no_DC = Gamma-Gamma_DC;
% Gamma_no_DC_max =  max(abs(Gamma_no_DC));
% 
% bins = 640000;
% partition = ((-bins/2:1:bins/2-2)+0.5)/(bins/2)*Gamma_no_DC_max;
% codebook =  (-bins/2:1:bins/2-1);
% [index,quantized] = quantiz(Gamma_no_DC,partition,codebook);
% 
% % reconstruction
% quantized/(bins/2)*Gamma_no_DC_max+Gamma_DC

