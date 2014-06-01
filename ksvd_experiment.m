function ksvd_experiment()
close all;clear all;clc;
% load('KsvdExpVar.mat')
% load('BugVarForKsvd')
C  = imread('lenna.gif'); C = double(imresize(C,[256 256]));
% pSize = 64;
bins      =256;
pSizeSqrt = 8;
X = im2col(C,[pSizeSqrt pSizeSqrt],'distinct');
OrSize = size(C);

baseDictLen = 64;
baseDictLenSqrt = 8;

params2d.data = X;                                
params2d.initA = speye(baseDictLen);              
params2d.basedict{1} = odctdict(pSizeSqrt,baseDictLenSqrt);   
params2d.basedict{2} = odctdict(pSizeSqrt,baseDictLenSqrt);   

params2d.Edata   = 150 ;      
% params2d.Tdata   = 20;
params2d.Tdict   = 10;                
params2d.iternum = 40;              

 close all;
[A,Gamma,err,gerr] = ksvds(params2d);

if(max(isnan(full(A(:))))) 
%     error('KSVD A output NaN for some indicies'); TODO:review with jere
    ind = isnan(A);
    A(ind)=0;
end
if(max(isnan(full(Gamma(:)))))
%     error('KSVD Gamma output NaN for some indicies');TODO:review with
%     jere
    ind = isnan(Gamma);
    Gamma(ind)=0;
end

 B = kron(odctdict(8,8),odctdict(8,8));
 %R = B*A*Gamma;
 Xr = B*A*Gamma;
 ImRe = col2im(Xr,[pSizeSqrt pSizeSqrt],OrSize,'distinct');
 
 RMSE = sqrt( (norm(X-Xr,'fro'))^2 / numel(X) );
 fprintf('**********KSVD EXPERIMENT**********\n');
 fprintf('RMSE=%e\n',RMSE);
 
 figure();
 subplot(4,2,1);imshow(C,[]);title('Original Img');
 subplot(4,2,2);imshow(ImRe,[]);title('Reconstructed Img')
 subplot(4,2,3);hist(full(A),bins);title('hist for A')
 subplot(4,2,4);imshow(full(A),[]);title('imshow for A')
 subplot(4,2,5);hist(full(Gamma),bins);title('hist for GAMMA');
 subplot(4,2,6);imshow(full(Gamma),[]);title('imhow for GAMMA');
 subplot(4,2,7);plot(err); title('S-KSVD error convergence');
    xlabel('Iteration'); ylabel('RMSE');
 subplot(4,2,8);plot(gerr); title('S-KSVD Generalize error convergence'); 
    xlabel('Iteration'); ylabel('RMSE?');
 suptitle('KSVD experiment results');
end