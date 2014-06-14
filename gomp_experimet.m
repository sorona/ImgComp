function [ res ] = gomp_experimet( )
%% GOMP-experiment
% in this file we will experiment with omp
% to get the "fill" for the different parameters
Img = imread('barbara.gif');
Img = double(Img);

N = 4; % Dictionary for patches NxN
L = 256; % Num of atoms
D = odct2dict([N N],L);
% showdict(D,[N,N],sqrt(L),sqrt(L));


X = im2col(Img,[N N],'distinct');
X = X(:,1:20); % TODO remove
%Img_r = col2im(Y,[N N],size(Img),'distinct');
%imshow(Img_r,[])


%% omp2   min  |GAMMA|_0     s.t.  |X - D*GAMMA|_2 <= EPSILON

% G         = D'*D;
% Max_mse   =  norm(X,'fro'); % rough over estimation
PSNR_vec     = linspace(20,50,100);
% True_err  = zeros(size(E_vec));
Sparsity  = zeros(size(PSNR_vec));
True_psnr = zeros(size(PSNR_vec));
for i=1:length(PSNR_vec)
    GAMMA = gomp(D,X,'psnr',PSNR_vec(i),255);
    Sparsity(i) = nnz(GAMMA);
    MSE  = norm(X-D*GAMMA,'fro')/numel(X);
    PSNR = 10*log10(255^2/MSE);
    True_psnr(i) = PSNR;
end


figure()
subplot(1,2,1)
plot(PSNR_vec,Sparsity)
    xlabel('PSNR');
    ylabel('Sparsity');
    title('min |GAMMA|_0 s.t. |X - D*GAMMA|_2 <= EPSILON');
    set(gca, 'XDir', 'reverse')
subplot(1,2,2)
hold on
    plot(PSNR_vec,True_psnr)
    plot(PSNR_vec,PSNR_vec,'black')
    xlabel('PSNR req');
    ylabel('PSNR');
    title('min |GAMMA|_0 s.t. |X - D*GAMMA|_2 <= EPSILON');
    set(gca, 'XDir', 'reverse')
hold off
res =1;
end

