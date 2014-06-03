function quantization_test(Ap,Hd,Vd,Dd,Wpar,Qpar)
    fprintf('******Quantization Test begins******\n')
    Qpar.bins = 2^8;%TODO delete
    [Apq,Hdq,Vdq,Ddq] = QuantizeCells(Ap,Hd,Vd,Dd,Wpar,Qpar);
    [ApR,HdR,VdR,DdR] = QuantizeDecodeCells(Apq,Hdq,Vdq,Ddq,Wpar,Qpar);
    %TODO: make max err depends on bins
    thresh = 100;
    err = norm(Ap-ApR,'fro')/norm(Ap,'fro');
        if(err>thresh); error('ERR ksvd test failed');end
    for i = 1:Wpar.level
        figure();
        suptitle(sprintf('Quatization Test Results level %d',i))
        m = 2;n = 3;
        AA  = {'Hd{%d}.A' ,'Vd{%d}.A' ,'Dd{%d}.A'};
        AR  = {'HdR{%d}.A','VdR{%d}.A','DdR{%d}.A'};
        D   = {'H','V','D'};
        for j=1:3  
            A = sprintf(AA{j},i); eval(sprintf('A = %s;',A))
            R = sprintf(AR{j},i); eval(sprintf('R = %s;',R))
            err = norm(A-R,'fro')/numel(A);
            subplot(m,n,j);plot(A(:),'b');hold on;
                           plot(A(:)-R(:),'r'); title(sprintf('Quantization Err=%e %s level %d',err,D{j},i));
                           legend('Sigl','ERR');
            if(err>thresh); error('ERR ksvd test failed');end
        end
        
        
        AA  = {'Hd{%d}.GAMMA' ,'Vd{%d}.GAMMA' ,'Dd{%d}.GAMMA'};
        AR  = {'HdR{%d}.GAMMA','VdR{%d}.GAMMA','DdR{%d}.GAMMA'};
        D   = {'H','V','D'};
        for j=1:3  
            A = sprintf(AA{j},i); eval(sprintf('A = %s;',A))
            R = sprintf(AR{j},i); eval(sprintf('R = %s;',R))
            err = norm(A-R,'fro')/numel(A);
            subplot(m,n,j+3);plot(A(:),'b');hold on;
                           plot(A(:)-R(:),'r'); title(sprintf('Quantization Err=%e %s level %d',err,D{j},i));
                           legend('Sigl','ERR');
            if(err>thresh); error('ERR ksvd test failed');end
        end
        
%         err = norm(Vd{i}.A-VdR{i}.A,'fro')/numel(Vd{i}.A,'fro');
%             subplot(m,n,2);stem(Vd{i}.A(:));hold on;stem(Hd{i}.A(:)-HdR{i}.A(:),'r');
%                 title(sprintf('Quntization Err Hd{%s}.A',i));
%             if(err>thresh); error('ERR ksvd test failed');end
%         err = norm(Dd{i}.A-DdR{i}.A,'fro')/numel(Dd{i}.A,'fro');
%             if(err>thresh); error('ERR ksvd test failed');end
%         
        err = norm(Hd{i}.GAMMA-HdR{i}.GAMMA,'fro')/numel(Hd{i}.GAMMA,'fro');
            if(err>thresh); error('ERR ksvd test failed');end
        err = norm(Vd{i}.GAMMA-VdR{i}.GAMMA,'fro')/numel(Vd{i}.GAMMA,'fro'); 
            if(err>thresh); error('ERR ksvd test failed');end
        err = norm(Dd{i}.GAMMA-DdR{i}.GAMMA,'fro')/numel(Dd{i}.GAMMA,'fro');
            if(err>thresh); error('ERR ksvd test failed');end
    end
            %TODO add bins depended err estimations mean and max
        fprintf('max relative err TODO sperate GAMMA A, more informative ERR should be bounded %.3f\n');
    fprintf('******Quantization Test pass\n******')
end
    
    

