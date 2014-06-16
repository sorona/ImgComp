function quantization_experiment(file_name)
    bins  = (2:1:15);
    bins  = 2.^bins;

    err = zeros(size(bins));
    for i=1:length(bins)
        dbstop in quantize_test2
     err(i) = quantize_test2(bins(i),file_name);
    end
    figure(); semilogx(bins,err)
    title('Quantization err vs bins')
    xlabel('bins')
    ylabel('err normalized')
end


function err = quantize_test1(bins,file_name)
    % Quantization test
%     load('HdSamp.mat')
    load(file_name);
    Hd2 = Hd{2};
    GAMMA = Hd2.GAMMA;

%     figure;imshow(full(A))
%      figure;imshow(full(GAMMA))

    Size   = size(GAMMA); 
    GAMMAv = Gamma2vec(GAMMA);
    DC     = mean(full(GAMMAv));
    GAMMAv = GAMMAv-DC;
    Max    = max(abs(GAMMAv));

    % encode
    partition = ((-bins/2:1:bins/2-2)+0.5)/(bins/2)*Max;
    codebook =  (-bins/2:1:bins/2-1);
    [index,~] = quantiz(GAMMAv,partition,codebook);
    index = index';
    
    % decode
    codebook = (-bins/2:1:bins/2-1);
    quant    = (codebook(index+1));
    Gr       = quant/(bins/2)*Max+DC;
    GAMMAr   = vec2GAMMA(Gr,Size);
    
    err = norm(GAMMAr-GAMMA,'fro')/norm(GAMMA,'fro');
end

function err = quantize_test2(bins,file_name)
    % Quantization test
%     load('HdSamp.mat')
    load(file_name);
    Hd2 = Hd{2};
    A = Hd2.GAMMA;
%     figure;imshow(full(A))
%     figure;imshow(full(GAMMA))
    Size   = size(A); 
    Av = Gamma2vec(A);
    NegSigns  = Av<0;
    Av     = abs(Av);
    DC     = mean(full(GAMMAv));
    Av     =     Av-DC;
    Max    = max(abs(Av));

    % encode
    partition = ((-bins/2:1:bins/2-2)+0.5)/(bins/2)*Max;
    codebook =  (-bins/2:1:bins/2-1);
    [index,~] = quantiz(GAMMAv,partition,codebook);
    index = index';
    
    % decode
    codebook = (-bins/2:1:bins/2-1);
    quant    = (codebook(index+1));
    Gr       = quant/(bins/2)*Max+DC;
    GAMMAr   = vec2GAMMA(Gr,Size);
    
    err = norm(GAMMAr-GAMMA,'fro')/norm(GAMMA,'fro');
    

    
end

