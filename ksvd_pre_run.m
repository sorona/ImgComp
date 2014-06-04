function [ A,Gamma,parRe ] = ksvd_pre_run(C,par)
    
    par.Img =C;
    R = par.R;
%     R = 2; % dictionary redundancy
    % choose patch size
    maxPatchSize = floor(sqrt(numel(C)/R));%for non overlapping patches        
    patchOption = (2:1:8).^2;
    ind = find(patchOption<maxPatchSize,1,'last');
    par.patchSize = patchOption(ind);
    % if can't choose lower the redudancy
    while(isempty(par.patchSize))
        if(R==1)
            error('ERR could not chooes patch size')
        end
        R=max(0.9*R,1);
        maxPatchSize = floor(sqrt(numel(C)/R));%for non overlapping patches        
        patchOption = (2:1:8).^2;
        ind = find(patchOption<maxPatchSize,1,'last');
        par.patchSize = patchOption(ind);
    end
    dictOption    =(2:1:15).^2;
    maxDictLen    = par.patchSize*R;
    ind = find(dictOption<maxDictLen,1,'last');  
    par.dictLen   = dictOption(ind);

%     par.perTdict = 0.8; % TODO review we should somehow balance or find optimum
%     par.perTdata = 0.2;
%       par.perEdata = 0.1;
%     par.Tdata    = 3;
%     par.Edata =4;
    [ A,Gamma ] = run_ksvd(par);
    parRe.dictLen   = par.dictLen;
    parRe.patchSize = par.patchSize;
    
end

function [ A,Gamma ] = run_ksvd(par)
    fprintf('**********KSVD RUN**********\n');
    C  = par.Img;
    Ps = par.patchSize;
    perTdict  = par.perTdict;
    dictLen   = par.dictLen;% dictionary length (power of 2)
    iternum   = par.iternum;
    m    = sqrt(Ps);
    n    = sqrt(Ps);
    bins = 256; % for histogram
    X = im2col(C,[m n],'distinct');
    imSize = size(C);
    err_info = 0;
    
    params2d.data = X;                                
    params2d.initA = speye(dictLen);              
    params2d.basedict{1} = odctdict(m,sqrt(dictLen));   
    params2d.basedict{2} = odctdict(n,sqrt(dictLen));   

    % TODO: add verifiers on Tdata Tdict Edata choices sainty checks
    if(isfield(par,'Tdata'))  
        params2d.Tdata   =  par.Tdata;
    elseif(isfield(par,'Edata'))
        params2d.Edata   =  par.Edata ;
    elseif(isfield(par,'perTdata'))
        params2d.Tdata   = ceil(par.perTdata*(m*n));
    elseif(isfield(par,'perEdata'))
        meanNrom = 0;
        for j=1:size(X,2)
            meanNrom = meanNrom + norm(X(:,j));
        end
        meanNrom = meanNrom/size(X,2);
        params2d.Edata   =  par.perEdata*meanNrom;
        err_info=sprintf('mean norm of patch=%.3f req per=%.3f req ERR=%.e\n',meanNrom,par.perEdata,params2d.Edata);
    else
        error('no fields sepsify constrain')
    end
    
    params2d.Tdict   = ceil(perTdict*dictLen);                
    params2d.iternum = iternum;              
    
    [A,Gamma,err] = ksvds(params2d);
    % print info
    fprintf('info:\n %s ImgSize=%dx%d ,PatchSize=%d ,Patches=%d,Redudancy=%.3f\n'...
                       ,par.name...
                       ,size(C)...
                       ,Ps...
                       ,numel(C)/Ps...
                       ,dictLen/Ps);
    if(err_info)
        fprintf(err_info);
    end
    if(max(isnan(full(A(:))))) 
        error('KSVD A output NaN for some indicies'); %TODO:reviewed with jere fix bug
    %     ind = isnan(A);
    %     A(ind)=0;
    end
    if(max(isnan(full(Gamma(:)))))
        error('KSVD Gamma output NaN for some indicies'); %TODO:reviewed with jere fix bug
    %     ind = isnan(Gamma);
    %     Gamma(ind)=0;
    end

    B = kron(odctdict(m,sqrt(dictLen)),odctdict(n,sqrt(dictLen)));
    Xr = B*A*Gamma;
    ImRe = col2im(Xr,[m n],imSize,'distinct');

    if(isfield(params2d,'Tdata'))
        RMSE = sqrt( (norm(X-Xr,'fro'))^2 / numel(X) );
        fprintf('Tdata=%d of %d patch of %d GAMMA len\nreq spar=%.3f RMSE=%e per pixel\n',params2d.Tdata,m*n,size(Gamma,1),params2d.Tdata/m*n,RMSE);
    else
        ERR = 0;
        for j=1:size(X,2)
            ERR = ERR + (norm(X(:,j)-Xr(:,j)));
        end
        ERR = ERR/size(X,2);
        fprintf('mean patch ERR=%e\n',ERR);
    end
    fprintf('Coeff To send=%d nnz=%d\n',numel(A)+numel(Gamma),nnz(A)+nnz(Gamma));
    
    % pixel mean err
    PRMSE = norm(X-Xr,'fro')/numel(X);
    
     if(par.plots)
         mm = 4; nn=3;
         figure('units','normalized','outerposition',[0 0 1 1])
         subplot(mm,nn,1);imshow(X,[]);title(sprintf('in2col of Img (size:%d:%d)',size(X)));
         subplot(mm,nn,2);imshow(C,[]);title(sprintf('Original Img (size:%d:%d)',size(C)));
         subplot(mm,nn,3);imshow(ImRe,[]);title(sprintf('Reconstructed Img PRMSE=%.4f',PRMSE))

         subplot(mm,nn,4);imshow(B); title(sprintf('Base Dictionary (size:%dx%d)',size(B))); 
         subplot(mm,nn,5);spy((A));title(sprintf('spy for A (size:%dx%d) spar=%.3f',size(A),nnz(A)/numel(A)))
         subplot(mm,nn,6);spy(Gamma);title(sprintf('spy for GAMMA (size:%dx%d) spar=%.3f',size(Gamma),nnz(Gamma)/numel(Gamma)));
         subplot(mm,nn,7);showdict(B,[m,n],ceil(size(B,1)/m),ceil(size(B,2)/n),'highcontrast','whitelines');
            title('showdict for B')
         subplot(mm,nn,8);hist(full(A),bins);title('hist for A')

         subplot(mm,nn,9);hist(full(Gamma),bins);title('hist for GAMMA');
         subplot(mm,nn,11);plot(err); title('S-KSVD error convergence');xlabel('Iteration');
             if(isfield(params2d,'Tdata'))  
                    ylabel('RMSE');
             else
                    ylabel('mean Atoms');
             end
         suptitle(sprintf('KSVD run results %s',par.name));
     end
end