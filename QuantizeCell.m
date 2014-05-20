function [ A, GAMMA ] = QuantizeCell( C,bins )
    
    % Quantize encode GAMMA
    OrignalSize = size(C.GAMMA); 
    GAMMAv = Gamma2vec(C.GAMMA);
    GAMMAv = GAMMAv';
    DC     = mean(GAMMAv);
    GAMMAv = GAMMAv-DC;
    Max    = max(abs(GAMMAv));
    % encode
    partition = ((-bins/2:1:bins/2-2)+0.5)/(bins/2)*Max;
    codebook =  (-bins/2:1:bins/2-1);
    [index,~] = quantiz(GAMMAv,partition,codebook);
    % save parameters
    Qpar.OrignalSize = OrignalSize;
    Qpar.DC          = DC;
    Qpar.Max         = Max;
    GAMMA.Qindex     = index;
    GAMMA.Qpar       = Qpar;

    % Quantize encode A
    OrignalSize = size(C.A);
    Av          = Gamma2vec(C.A); % TODO: replace with A2vec
    AV          = Av';
    DC          = mean(Av);
    Av          = Av-DC;
    Max         = max(abs(Av));
    % encode
    partition = ((-bins/2:1:bins/2-2)+0.5)/(bins/2)*Max;
    codebook =  (-bins/2:1:bins/2-1);
    [index,~] = quantiz(Av,partition,codebook);
    % save parameters
    Qpar.OrignalSize = OrignalSize;
    Qpar.DC          = DC;
    Qpar.Max         = Max;
    A.Qindex         = index;
    A.Qpar           = Qpar;
    
end

