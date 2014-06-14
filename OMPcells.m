function [GAMMA] = OMPcells(H,V,D,Dict,Wpar,Kpar)
    fprintf('**********GOMP RUN**********\n');
    level   = Wpar.level;
    GAMMA = cell(3,level);
    band = {'H','V','D'};
    % for each level each dirction train dictionary
    for i = 1:level
        for j=1:length(band)
            name    =  sprintf('%s{%d}',band{j},i);
            Im      =  eval(name);
            [X,m]   =  Im2colgomp(Im);
            R       =  Kpar.R; % dictionary reduandancy
            dictLen =  R*m;
            phi = kron(odctdict(sqrt(m),sqrt(dictLen)),odctdict(sqrt(m),sqrt(dictLen)));
            DD  = phi*Dict{j,i};
      %     Xr = phi*A*Gamma;
            MAXI = max(X(:));
            GAMMA{i,j} = gomp(DD,X,'psnr',50,MAXI);% TODO: parameter
            if(Kpar.gomp_test)
               Xr   = DD*GAMMA{i,j};
               MSE  = norm(Xr-X)/numel(X);
               PSNR = 10*log10(MAXI/MSE); % TODO review
               fprintf('GOMP for %s PSNR:%.2f MSE:%.2f nnz(GAMMA):%d::%d\n',name,PSNR,MSE,nnz(GAMMA{i,j}),numel(GAMMA{i,j}));
               ImRe  = col2im(Xr,[sqrt(m) sqrt(m)],size(Im),'distinct');
               figure;subplot(1,2,1);imshow(Im,[]);title('Original');
                      subplot(1,2,2);imshow(ImRe,[]);title('Reconstruction');
                      suptitle(sprintf('%s GOMP',name));
            end
        end
    end
end

function [X,m] = Im2colgomp(Im)
imLen  = size(Im,1); 
if(imLen>=64)
    pSize = 8;
else
    pSize = 4;
end
    X = im2col(Im,[pSize pSize],'distinct');
    m = pSize^2;
end